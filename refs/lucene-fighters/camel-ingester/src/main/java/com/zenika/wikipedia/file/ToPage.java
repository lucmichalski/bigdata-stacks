package com.zenika.wikipedia.file;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.camel.Exchange;
import org.apache.camel.Processor;

import java.util.Collection;
import java.util.Iterator;

/**
 * @author lboutros
 */
public class ToPage implements Processor {
    private final static ObjectMapper MAPPER = new ObjectMapper();

    static {
        MAPPER.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    public ToPage() {
    }

    @Override
    public void process(Exchange exchange) throws Exception {
        Collection<String> json = exchange.getIn().getBody(Collection.class);

        if (json.size() != 2) {
            throw new IllegalStateException("Json input documents should contain a descriptor and the document itself.");
        }

        Iterator<String> iterator = json.iterator();
        PageDesc descriptor = MAPPER.readValue(iterator.next(), PageDesc.class);
        Page page = MAPPER.readValue(iterator.next(), Page.class);

        PageDesc.InnerDesc index = descriptor.getIndex();
        if (index == null) {
            throw new IllegalStateException("Cannot find document id.");
        }

        String id = descriptor.getIndex().getId();
        if (id == null) {
            throw new IllegalStateException("Cannot find document id.");
        }

        page.setId(id);

        exchange.getIn().setBody(page);
    }

}
