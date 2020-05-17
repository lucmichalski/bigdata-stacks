package com.znk.solr.custom.module;

import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.CloudSolrClient;
import org.apache.solr.common.SolrInputDocument;
import org.apache.solr.core.PluginInfo;
import org.apache.solr.handler.component.SearchHandler;
import org.apache.solr.request.SolrQueryRequest;
import org.apache.solr.response.BasicResultContext;
import org.apache.solr.response.SolrQueryResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A dummy search handler that indexes query stats in a collection
 *
 * @author lboutros
 */
public class QueryStatSearchHandler extends SearchHandler {

  private static final Logger log = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

  private final static Random R = new Random();
  // TODO should be configurable
  private String collectionName = "query-stats";
  private String zkConnectionString = "zookeeper:2181";

  private CloudSolrClient solrClient;

  @Override
  public void init(PluginInfo info) {
    super.init(info);
    // TODO should split zkConnectionString
    solrClient = new CloudSolrClient.Builder(Collections.singletonList(zkConnectionString), Optional.empty()).build();
  }

  @Override
  public void handleRequestBody(SolrQueryRequest req, SolrQueryResponse rsp) throws Exception {
    super.handleRequestBody(req, rsp);

    List<String> collectionsList = req.getHttpSolrCall().getCollectionsList();
    String usedCollectionName;

    if (collectionsList != null) {
      usedCollectionName = req.getHttpSolrCall().getCollectionsList().iterator().next();

      // Do not index stats queries
      if (!collectionName.equals(usedCollectionName)) {
        BasicResultContext response = (BasicResultContext) rsp.getValues().get("response");
        if (response != null) {
          long numCount = response.getDocList().matches();
          String query = response.getQuery().toString();

          SolrInputDocument solrInputDocument = new SolrInputDocument();
          solrInputDocument.setField("id", UUID.randomUUID().toString());
          solrInputDocument.setField("collection", usedCollectionName);
          solrInputDocument.setField("query", query);
          solrInputDocument.setField("numCount", numCount);
          try {
            solrClient.add(collectionName, solrInputDocument, 15000);
          } catch (IOException | SolrServerException ex) {
            log.warn("Cannot write query stats:", ex);
          }
        }
      }
    }
  }
}
