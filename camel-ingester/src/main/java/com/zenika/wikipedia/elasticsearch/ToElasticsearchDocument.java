package com.zenika.wikipedia.elasticsearch;

import com.zenika.wikipedia.file.Page;
import org.apache.camel.Exchange;
import org.apache.camel.Processor;

import java.util.HashMap;
import java.util.Map;

/**
 * Parse an {@link Exchange} into an Elasticsearch document.
 * Implements camel {@link Processor}
 *
 * @author modye
 */
public class ToElasticsearchDocument implements Processor {

    @Override
    public void process(Exchange exchange) {
        Page page = exchange.getIn().getBody(Page.class);

        Map<String, Object> map = new HashMap<>();
        map.put("id", page.getId());
        map.put("title", page.getTitle());
        map.put("text", page.getText());
        map.put("wikibase_item", page.getWikibase_item());
        map.put("timestamp", page.getTimestamp());
        map.put("create_timestamp", page.getCreate_timestamp());
        map.put("popularity_score", page.getPopularity_score());
        map.put("template", page.getTemplate());
        map.put("category", page.getCategory());
        map.put("heading", page.getHeading());
        map.put("incoming_links", page.getIncoming_links());
        map.put("external_link", page.getExternal_link());
        map.put("outgoing_link", page.getOutgoing_link());
        map.put("version", page.getVersion());
        map.put("text_bytes", page.getText_bytes());

        exchange.getIn().setBody(map);
    }
}
