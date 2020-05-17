package com.zenika.wikipedia.elasticsearch;

import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.util.toolbox.FlexibleAggregationStrategy;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

/**
 * Router used to ingest document in Elasticsearch.
 *
 * @author modye
 */
@Component
@Profile("elasticsearch")
@Order(Ordered.HIGHEST_PRECEDENCE)
public class ElasticsearchRouter extends RouteBuilder {

  @Override
  public void configure() {
    from("seda:es?size=10000&concurrentConsumers=4")
            .process(new ToElasticsearchDocument())
            .aggregate(new FlexibleAggregationStrategy().accumulateInCollection(ArrayList.class))
            .constant(true)
            .completionSize(1000)
            .completionInterval(5000)
            .log(simple("Sending ${body.size()} documents to ES (~${exchangeProperty.CamelSplitIndex} lines processed)").getText())
            .to("elasticsearch-rest://elasticsearch?operation=BULK&indexName={{ingest.index.name}}&indexType={{ingest.document.type}}&hostAddresses={{elasticsearch.host.addresses}}")
            .end();
  }
}
