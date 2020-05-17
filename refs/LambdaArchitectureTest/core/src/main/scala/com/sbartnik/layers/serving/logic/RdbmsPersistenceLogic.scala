package com.sbartnik.layers.serving.logic

import java.sql.ResultSet
import com.sbartnik.common.db.PostgresOperations
import com.sbartnik.domain.{ActionBySite, UniqueVisitorsBySite}
import com.sbartnik.common.db.DbRowMapper._
import com.sbartnik.config.AppConfig
import com.typesafe.scalalogging.LazyLogging

object RdbmsPersistenceLogic extends PersistenceLogic with PostgresOperations with LazyLogging {

  private val conf = AppConfig

  private def timestampBucketBoundary(index: Int) = {
    System.currentTimeMillis - (conf.batchBucketMinutes * 60L * 1000 * index)
  }

  override def getSiteActions(siteName: String, bucketsNumber: Int): List[ActionBySite] = {

    val filters = List(
      if(!siteName.isEmpty) Some(s"s.name = '$siteName'") else None,
      if(bucketsNumber > 0) Some(s"a.timestamp > ${timestampBucketBoundary(bucketsNumber)}") else None
    ).filter(_.isDefined).map(_.get)

    val filterExpression = filters.mkString(if(filters.isEmpty) "" else "WHERE ", " AND ", "")

    val dbQuery = s"""
         |SELECT s.name AS site,
         |  MIN(a.timestamp) AS timestamp_bucket,
         |  SUM(CASE WHEN t.name = 'add_to_favorites' THEN 1 ELSE 0 END) AS fav_count,
         |  SUM(CASE WHEN t.name = 'comment' THEN 1 ELSE 0 END) AS comm_count,
         |  SUM(CASE WHEN t.name = 'page_view' THEN 1 ELSE 0 END) AS view_count
         |FROM ${conf.Postgres.actionTable} a
         |JOIN ${conf.Postgres.siteTable} s
         |  ON a.site_id = s.id
         |JOIN ${conf.Postgres.actionTypeTable} t
         |  ON a.action_type_id = t.id
         |$filterExpression
         |GROUP BY s.name
      """.stripMargin

    var dbResultSet: ResultSet = null
    withConnection(conn => {
      logger.info(dbQuery)
      val ps = conn.prepareStatement(dbQuery)
      dbResultSet = ps.executeQuery()
    })

    val dbResultMapped = dbResultSet.map(ActionBySite)
    dbResultMapped
  }

  override def getUniqueVisitors(siteName: String, bucketIndex: Int): List[UniqueVisitorsBySite] = {

    val bucketBoundary = timestampBucketBoundary(if(bucketIndex > 0) bucketIndex else 1)

    val filters = List(
      if(!siteName.isEmpty) Some(s"s.name = '$siteName'") else None,
      Some(s"a.timestamp > $bucketBoundary AND a.timestamp <= ${bucketBoundary + conf.batchBucketMinutes * 60 * 1000}")
    ).filter(_.isDefined).map(_.get)

    val filterExpression = filters.mkString(if(filters.isEmpty) "" else "WHERE ", " AND ", "")

    val dbQuery = s"""
         |SELECT s.name AS site,
         |  MIN(a.timestamp) AS timestamp_bucket,
         |  COUNT(DISTINCT(a.visitor_id)) AS unique_visitors
         |FROM ${conf.Postgres.actionTable} a
         |JOIN ${conf.Postgres.siteTable} s
         |  ON a.site_id = s.id
         |JOIN ${conf.Postgres.visitorTable} v
         |  ON a.visitor_id = v.id
         |$filterExpression
         |GROUP BY s.name
      """.stripMargin

    var dbResultSet: ResultSet = null
    withConnection(conn => {
      logger.info(dbQuery)
      val ps = conn.prepareStatement(dbQuery)
      dbResultSet = ps.executeQuery()
    })

    val dbResultMapped = dbResultSet.map(UniqueVisitorsBySite)
    dbResultMapped
  }
}
