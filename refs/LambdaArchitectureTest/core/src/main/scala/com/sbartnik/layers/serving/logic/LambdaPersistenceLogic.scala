package com.sbartnik.layers.serving.logic

import com.datastax.driver.core.ResultSet
import com.sbartnik.config.AppConfig
import com.sbartnik.domain.{ActionBySite, UniqueVisitorsBySite}
import com.sbartnik.common.db.DbRowMapper._
import com.sbartnik.common.db.CassandraOperations
import com.typesafe.scalalogging.LazyLogging
import scala.language.postfixOps

object LambdaPersistenceLogic extends PersistenceLogic with CassandraOperations with LazyLogging {

  private val conf = AppConfig

  private def timestampBucketBoundary(index: Int) = {
    System.currentTimeMillis - (conf.batchBucketMinutes * 60 * 1000 * index)
  }

  override def getSiteActions(siteName: String, bucketsNumber: Int): List[ActionBySite] = {

    val batchFilters = List(
      if(!siteName.isEmpty) Some(s"site = '$siteName'") else None,
      if(bucketsNumber > 0) Some(s"timestamp_bucket > ${timestampBucketBoundary(bucketsNumber)}") else None
    ).filter(_.isDefined).map(_.get)

    val batchFilterExpression = batchFilters.mkString(if(batchFilters.isEmpty) "" else "WHERE ", " AND ", "")
    val speedFilterExpression = if(!siteName.isEmpty) s"WHERE site = '$siteName'" else ""

    val batchDbQuery = s"""
         |SELECT site,
         |  MIN(timestamp_bucket) AS timestamp_bucket,
         |  SUM(comm_count) AS comm_count,
         |  SUM(fav_count) AS fav_count,
         |  SUM(view_count) AS view_count
         |FROM ${conf.Cassandra.batchActionsBySiteTable}
         |$batchFilterExpression
         |GROUP BY site
         |ALLOW FILTERING;
      """.stripMargin

    val speedDbQuery = s"""
         |SELECT *
         |FROM ${conf.Cassandra.speedActionsBySiteTable}
         |$speedFilterExpression
         |PER PARTITION LIMIT 1;
      """.stripMargin

    var batchDbResultSet, speedDbResultSet: ResultSet = null
    withSession(cs => {
      logger.info(batchDbQuery)
      batchDbResultSet = cs.execute(batchDbQuery)
      logger.info(speedDbQuery)
      speedDbResultSet = cs.execute(speedDbQuery)
    })

    val batchResultMapped = batchDbResultSet.map(ActionBySite)
    val speedResultMapped = speedDbResultSet.map(ActionBySite)

    val mergedResult = (batchResultMapped ++ speedResultMapped)
      .groupBy(_.site).map(x => ActionBySite(
        x._1,
        x._2.head.timestamp_bucket,
        x._2.map(_.comm_count).sum,
        x._2.map(_.fav_count).sum,
        x._2.map(_.view_count).sum)
      )

    mergedResult.toList
  }

  override def getUniqueVisitors(siteName: String, bucketIndex: Int): List[UniqueVisitorsBySite] = {

    val batchFilters = List(
      if(!siteName.isEmpty) Some(s"site = '$siteName'") else None,
      if(bucketIndex > 0) Some(s"timestamp_bucket < ${timestampBucketBoundary(bucketIndex)}") else None
    ).filter(_.isDefined).map(_.get)

    val batchFilterExpression = batchFilters.mkString(if(batchFilters.isEmpty) "" else "WHERE ", " AND ", "")
    val speedFilterExpression = if(!siteName.isEmpty) s"WHERE site = '$siteName'" else ""

    val batchDbQuery = s"""
         |SELECT *
         |FROM ${conf.Cassandra.batchUniqueVisitorsBySiteTable}
         |$batchFilterExpression
         |PER PARTITION LIMIT 1
         |ALLOW FILTERING;
      """.stripMargin

    val speedDbQuery = s"""
         |SELECT *
         |FROM ${conf.Cassandra.speedUniqueVisitorsBySiteTable}
         |$speedFilterExpression
         |PER PARTITION LIMIT 1;
      """.stripMargin

    var dbResultSet: ResultSet = null
    withSession(cs => {
      val dbQuery = if(bucketIndex > 0) batchDbQuery else speedDbQuery
      logger.info(dbQuery)
      dbResultSet = cs.execute(dbQuery)
    })

    val dbResultMapped = dbResultSet.map(UniqueVisitorsBySite)
    dbResultMapped
  }
}
