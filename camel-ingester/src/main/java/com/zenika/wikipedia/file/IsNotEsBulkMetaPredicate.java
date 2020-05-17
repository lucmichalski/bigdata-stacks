package com.zenika.wikipedia.file;

import org.apache.camel.Exchange;
import org.apache.camel.Predicate;

/**
 * @author lboutros
 */
public class IsNotEsBulkMetaPredicate implements Predicate {

    private static final String ES_INDEX_META_PREFIX = "{\"index\"";

    public IsNotEsBulkMetaPredicate() {
    }

    public boolean matches(Exchange exchange) {
        return !exchange.getIn().getBody(String.class).startsWith(ES_INDEX_META_PREFIX);
    }

}
