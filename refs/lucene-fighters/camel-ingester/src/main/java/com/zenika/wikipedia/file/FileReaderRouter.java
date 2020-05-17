package com.zenika.wikipedia.file;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.util.toolbox.FlexibleAggregationStrategy;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

/**
 * Read a file and process it to an ingest endpoint.
 */
@Component
@Order(Ordered.LOWEST_PRECEDENCE)
public class FileReaderRouter extends RouteBuilder {

    @Override
    public void configure() {
        from("file:{{data.input.directory}}?noop=true")
                .split(body().tokenize("\n"))
                .streaming()
                .aggregate(new FlexibleAggregationStrategy().accumulateInCollection(ArrayList.class))
                .constant(true)
                .completionSize(2)
                .process(new ToPage())
                .to("{{ingest.endpoint.name}}");
    }
}
