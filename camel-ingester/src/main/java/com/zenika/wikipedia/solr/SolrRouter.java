package com.zenika.wikipedia.solr;

import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.solr.SolrConstants;
import org.apache.camel.util.toolbox.FlexibleAggregationStrategy;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.CloudSolrClient;
import org.apache.solr.client.solrj.impl.HttpSolrClient.RemoteSolrException;
import org.apache.solr.client.solrj.request.CollectionAdminRequest;
import org.apache.solr.client.solrj.request.schema.SchemaRequest.*;
import org.apache.solr.common.SolrException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.*;

/**
 * @author lboutros
 */
@Component
@Profile("solr")
@Order(Ordered.HIGHEST_PRECEDENCE)
public class SolrRouter extends RouteBuilder {

    public SolrRouter(CamelContext context) {
        super(context);
    }

    @Value("${solr.zk.host}")
    private String zkHost;

    @Value("${solr.collection.name}")
    private String collectionName;

    @Override
    public void configure() throws SolrServerException, IOException {
        initCollection();

        from("seda:solr?size=10000&concurrentConsumers=4")
                .process(new ToSolrDocument())
                .aggregate(new FlexibleAggregationStrategy().accumulateInCollection(ArrayList.class))
                .constant(true)
                .completionSize(1000)
                .completionInterval(5000)
                .setHeader(SolrConstants.OPERATION, constant(SolrConstants.OPERATION_INSERT))
                .setHeader(SolrConstants.PARAM + "commitWithin", constant(30000))
                .log(simple("Sending ${body.size()} documents to Solr (~${exchangeProperty.CamelSplitIndex} lines processed)").getText())
                .to("solrCloud:{{solr.connection.string}}?zkHost={{solr.zk.host}}&collection={{solr.collection.name}}")
                .end()
        ;
    }

    private void initCollection() throws SolrServerException, IOException {
        try (CloudSolrClient client = new CloudSolrClient.Builder()
                .withZkHost(zkHost)
                .build()) {

            client.setDefaultCollection(collectionName);

            CollectionAdminRequest.Delete deleteCollection = CollectionAdminRequest.deleteCollection(collectionName);
            CollectionAdminRequest.Create createCollection = CollectionAdminRequest.createCollection(collectionName, 1, 1);

            try {
                client.request(deleteCollection);
            } catch (SolrServerException | IOException | RemoteSolrException ex) {
                // we suppose here that the collection does not exist
                // TODO add a better check
                // TODO add a log
            }

            try {
                client.request(createCollection);
            } catch (SolrServerException | IOException ex) {
                throw ex;
            }

            try {
                cleanFields(client);
            } catch (SolrServerException | IOException | SolrException ex) {
                // we suppose here that the collection fiels do not exist
                // TODO add a better check
                // TODO add a log
            }

            addPageFields(client);
        }
    }

    private Map<String, Object> getMapFrom(String name,
                                           String type,
                                           boolean isMultiValued,
                                           boolean isIndexed,
                                           boolean isRequired,
                                           boolean isStored
    ) {
        Map<String, Object> retValue = new HashMap<>();

        retValue.put("name", name);
        retValue.put("type", type);
        retValue.put("multiValued", isMultiValued);
        retValue.put("indexed", isIndexed);
        retValue.put("required", isRequired);
        retValue.put("stored", isStored);

        return retValue;
    }

    /**
     * Add schema fields Something like this:
     * <field name="create_timestamp" type="pdates"/>
     * <field name="id" type="string" multiValued="false" indexed="true" required="true" stored="true"/>
     * <field name="incoming_links" type="plongs"/>
     * <field name="popularity_score" type="pdoubles"/>
     * <field name="text_bytes" type="plongs"/>
     * <field name="timestamp" type="pdates"/>
     * <field name="version" type="plongs"/>
     * <p>
     * TODO add a nice builder
     */
    private void addPageFields(SolrClient client) throws SolrServerException, IOException {
        List<Update> updates = new ArrayList<>();

        updates.add(new AddField(getMapFrom("wikibase_item.keyword", "string", true, true, false, false)));
        updates.add(new AddField(getMapFrom("wikibase_item", "text_fr", true, true, false, true)));
        updates.add(new AddCopyField("wikibase_item", Collections.singletonList("wikibase_item.keyword")));

        updates.add(new AddField(getMapFrom("template.keyword", "string", true, true, false, false)));
        updates.add(new AddField(getMapFrom("template", "text_fr", true, true, false, true)));
        updates.add(new AddCopyField("template", Collections.singletonList("template.keyword")));

        updates.add(new AddField(getMapFrom("category.keyword", "string", true, true, false, false)));
        updates.add(new AddField(getMapFrom("category", "text_fr", true, true, false, true)));
        updates.add(new AddCopyField("category", Collections.singletonList("category.keyword")));

        updates.add(new AddField(getMapFrom("heading.keyword", "string", true, true, false, false)));
        updates.add(new AddField(getMapFrom("heading", "text_fr", true, true, false, true)));
        updates.add(new AddCopyField("heading", Collections.singletonList("heading.keyword")));

        updates.add(new AddField(getMapFrom("external_link", "string", true, true, false, false)));
        updates.add(new AddField(getMapFrom("outgoing_link", "string", true, true, false, false)));

        updates.add(new AddField(getMapFrom("title", "text_fr", false, true, false, true)));
        updates.add(new AddField(getMapFrom("text", "text_fr", false, true, false, true)));

        updates.add(new AddField(getMapFrom("timestamp", "pdate", false, true, false, true)));
        updates.add(new AddField(getMapFrom("create_timestamp", "pdate", false, true, false, true)));
        updates.add(new AddField(getMapFrom("popularity_score", "pdoubles", false, true, false, true)));
        updates.add(new AddField(getMapFrom("incoming_links", "plongs", false, true, false, true)));
        updates.add(new AddField(getMapFrom("text_bytes", "plongs", false, true, false, true)));
        updates.add(new AddField(getMapFrom("version", "plongs", false, true, false, true)));

        MultiUpdate multiUpdate = new MultiUpdate(updates);

        client.request(multiUpdate);
    }

    private void cleanFields(CloudSolrClient client) throws SolrServerException, IOException {
        List<Update> updates = new ArrayList<>();

        updates.add(new DeleteCopyField("wikibase_item", Collections.singletonList("wikibase_item.keyword")));
        updates.add(new DeleteField("wikibase_item.keyword"));
        updates.add(new DeleteField("wikibase_item"));

        updates.add(new DeleteCopyField("template", Collections.singletonList("template.keyword")));
        updates.add(new DeleteField("template.keyword"));
        updates.add(new DeleteField("template"));

        updates.add(new DeleteCopyField("category", Collections.singletonList("category.keyword")));
        updates.add(new DeleteField("category.keyword"));
        updates.add(new DeleteField("category"));

        updates.add(new DeleteCopyField("heading", Collections.singletonList("heading.keyword")));
        updates.add(new DeleteField("heading.keyword"));
        updates.add(new DeleteField("heading"));

        updates.add(new DeleteField("external_link"));
        updates.add(new DeleteField("outgoing_link"));

        updates.add(new DeleteField("title"));
        updates.add(new DeleteField("text"));

        updates.add(new DeleteField("timestamp"));
        updates.add(new DeleteField("create_timestamp"));
        updates.add(new DeleteField("popularity_score"));
        updates.add(new DeleteField("incoming_links"));
        updates.add(new DeleteField("text_bytes"));
        updates.add(new DeleteField("version"));

        MultiUpdate multiUpdate = new MultiUpdate(updates);

        client.request(multiUpdate);
    }
}
