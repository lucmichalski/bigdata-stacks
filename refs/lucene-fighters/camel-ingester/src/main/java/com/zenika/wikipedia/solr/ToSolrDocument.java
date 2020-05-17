package com.zenika.wikipedia.solr;

import com.zenika.wikipedia.file.Page;
import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.apache.solr.common.SolrInputDocument;

/**
 * @author lboutros
 */
public class ToSolrDocument implements Processor {

    public ToSolrDocument() {
    }

    @Override
    public void process(Exchange exchange) throws Exception {
        Page page = exchange.getIn().getBody(Page.class);

        SolrInputDocument document = new SolrInputDocument();
        document.setField("id", page.getId());
        document.setField("title", page.getTitle());
        document.setField("text", page.getText());
        document.setField("wikibase_item", page.getWikibase_item());
        document.setField("timestamp", page.getTimestamp());
        document.setField("create_timestamp", page.getCreate_timestamp());
        document.setField("popularity_score", page.getPopularity_score());
        document.setField("template", page.getTemplate());
        document.setField("category", page.getCategory());
        document.setField("heading", page.getHeading());
        document.setField("incoming_links", page.getIncoming_links());
        document.setField("external_link", page.getExternal_link());
        document.setField("outgoing_link", page.getOutgoing_link());
        document.setField("version", page.getVersion());
        document.setField("text_bytes", page.getText_bytes());

        exchange.getIn().setBody(document);
    }

}
