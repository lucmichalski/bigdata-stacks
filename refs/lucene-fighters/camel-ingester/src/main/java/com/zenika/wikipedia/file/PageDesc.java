package com.zenika.wikipedia.file;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * @author lboutros
 */
public class PageDesc {

    public static class InnerDesc {

        @JsonProperty("_id")
        private String id;
        @JsonProperty("_type")
        private String type;


        @JsonProperty("_id")
        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getType() {
            return type;
        }

        public void setType(String _type) {
            this.type = type;
        }

        @Override
        public String toString() {
            return "InnerDesc{" + "id=" + id + ", type=" + type + '}';
        }

    }

    private InnerDesc index;

    public InnerDesc getIndex() {
        return index;
    }

    public void setIndex(InnerDesc index) {
        this.index = index;
    }

    @Override
    public String toString() {
        return "PageDesc{" + "index=" + index + '}';
    }


}
