package com.sbartnik.layers.speed

import java.sql.Connection

import com.sbartnik.common.{KafkaConsumerOperations, PostgresOperations}
import com.sbartnik.config.{AppConfig, ConfigurationProvider}
import com.sbartnik.domain.SiteActionRecord
import com.typesafe.scalalogging.LazyLogging

import scala.collection.mutable

object RdbmsConsumer extends App with PostgresOperations with LazyLogging {

  val conf = AppConfig
  val kafkaConf = conf.Kafka
  val kafkaProps = ConfigurationProvider.kafkaStreamConsumer

  val kafkaConsumerOps = new KafkaConsumerOperations(kafkaProps, kafkaConf.topic)

  val siteCache = mutable.Map.empty[String, Long]
  val actionTypeCache = mutable.Map.empty[String, Long]
  val visitorCache = mutable.Map.empty[String, Long]

  private def updateTableCache(connection: Connection,
                               tableName: String,
                               cache: mutable.Map[String, Long],
                               missingRowsNames: List[String]): Unit = {

    if(missingRowsNames.isEmpty)
      return

    val namesToInsert = missingRowsNames.mkString("'),('")

    val insertQuery = s"""
         |WITH input_rows (name) AS ( VALUES
         |  (text '$namesToInsert')
         |), ins AS (
         |  INSERT INTO $tableName (name)
         |  SELECT * FROM input_rows
         |  ON CONFLICT (name) DO NOTHING
         |  RETURNING id
         |)
         |SELECT id FROM ins
         |UNION ALL
         |SELECT t.id FROM input_rows
         |JOIN $tableName t USING (name)
      """.stripMargin

    logger.info(insertQuery)
    val stmt = connection.prepareStatement(insertQuery)
    val resultSet = stmt.executeQuery()

    for (siteName <- missingRowsNames) {
      resultSet.next()
      cache += (siteName -> resultSet.getLong(1))
    }
  }

  private def recordInsertSqlPart(record: SiteActionRecord): String = {
    val siteId = siteCache(record.site)
    val actionTypeId = actionTypeCache(record.action)
    val visitorId = visitorCache(record.visitor)

    s"""${record.timestamp}, $siteId, $actionTypeId, $visitorId, '${record.referrer}',
       |'${record.previousPage}', '${record.geo}', ${record.timeSpentSeconds}, '${record.subPage}'
     """.stripMargin
  }

  while(true) {
    val records = kafkaConsumerOps.receive()
    val mappedRecords = records
      .map(SiteActionRecord.deserialize)
      .filter(_.isDefined)
      .map(_.get)

    val missingSiteCache = mappedRecords.map(_.site).distinct.filter(x => !siteCache.contains(x))
    val missingActionTypeCache = mappedRecords.map(_.action).distinct.filter(x => !actionTypeCache.contains(x))
    val missingVisitorCache = mappedRecords.map(_.visitor).distinct.filter(x => !visitorCache.contains(x))

    withConnection(conn => {
      conn.setAutoCommit(false)

      updateTableCache(conn, conf.Postgres.siteTable, siteCache, missingSiteCache)
      updateTableCache(conn, conf.Postgres.actionTypeTable, actionTypeCache, missingActionTypeCache)
      updateTableCache(conn, conf.Postgres.visitorTable, visitorCache, missingVisitorCache)

      val recordsToInsert = mappedRecords
        .map(recordInsertSqlPart)
        .mkString("),(")

      if(recordsToInsert.length > 0) {
        val insertQuery = s"""
             |INSERT INTO ${conf.Postgres.actionTable} (
             |  timestamp,
             |  site_id,
             |  action_type_id,
             |  visitor_id,
             |  referrer,
             |  previous_page,
             |  geo,
             |  time_spent_seconds,
             |  sub_page
             |) VALUES (
             |  $recordsToInsert
             |)
        """.stripMargin

        logger.info(insertQuery)
        val mainInsertStmt = conn.prepareStatement(insertQuery)
        mainInsertStmt.executeUpdate()
      }

      conn.commit()
    })

    // Thread.sleep(2000)
  }
}
