package com.sbartnik.common.db

import com.datastax.driver.core.{Cluster, ConsistencyLevel, QueryOptions, Session}
import com.sbartnik.config.AppConfig

trait CassandraOperations {

  private val conf = AppConfig.Cassandra

  def withSession(func: Session => Unit): Unit = {
    val cluster = new Cluster.Builder()
      .withClusterName("Lambda Architecture Test Cluster")
      .addContactPoint(conf.host)
      .withPort(conf.port)
      .withQueryOptions(new QueryOptions().setConsistencyLevel(ConsistencyLevel.ONE)).build

    val session = cluster.connect
    try {
      session.execute(s"USE ${conf.keyspaceName}")
      func(session)
    } finally {
      session.close()
    }
  }

  def initDb(): Unit = withSession(session => {

    session.execute(s"CREATE KEYSPACE IF NOT EXISTS ${conf.keyspaceName} WITH REPLICATION = " +
      s"{ 'class' : 'SimpleStrategy', 'replication_factor' : 1 }")

    session.execute(s"USE ${conf.keyspaceName}")

    session.execute(s"CREATE TABLE IF NOT EXISTS ${conf.batchUniqueVisitorsBySiteTable} (" +
      s"timestamp_bucket bigint, " +
      s"site ascii, " +
      s"unique_visitors bigint, " +
      s"PRIMARY KEY (site, timestamp_bucket)" +
      s") WITH CLUSTERING ORDER BY (timestamp_bucket DESC)")

    session.execute(s"CREATE TABLE IF NOT EXISTS ${conf.batchActionsBySiteTable} (" +
      s"timestamp_bucket bigint, " +
      s"site ascii," +
      s"fav_count bigint, " +
      s"comm_count bigint, " +
      s"view_count bigint, " +
      s"PRIMARY KEY (site, timestamp_bucket)" +
      s") WITH CLUSTERING ORDER BY (timestamp_bucket DESC)")

    session.execute(s"CREATE TABLE IF NOT EXISTS ${conf.speedUniqueVisitorsBySiteTable} (" +
      s"timestamp_bucket bigint, " +
      s"site ascii, " +
      s"unique_visitors bigint, " +
      s"PRIMARY KEY (site, timestamp_bucket)" +
      s") WITH CLUSTERING ORDER BY (timestamp_bucket DESC)")

    session.execute(s"CREATE TABLE IF NOT EXISTS ${conf.speedActionsBySiteTable} (" +
      s"timestamp_bucket bigint, " +
      s"site ascii," +
      s"fav_count bigint, " +
      s"comm_count bigint, " +
      s"view_count bigint, " +
      s"PRIMARY KEY (site, timestamp_bucket)" +
      s") WITH CLUSTERING ORDER BY (timestamp_bucket DESC)")
  })
}
object CassandraOperations extends CassandraOperations
