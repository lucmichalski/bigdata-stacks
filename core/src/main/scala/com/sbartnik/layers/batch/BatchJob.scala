package com.sbartnik.layers.batch

import com.sbartnik.config.AppConfig
import org.apache.spark.sql.{SaveMode, SparkSession}
import org.apache.spark.streaming.Minutes

class BatchJob extends App {

  val conf = AppConfig

  val ss = SparkSession
    .builder()
    .appName("Spark Batch Processing")
    .master(AppConfig.sparkMaster)
    .config("spark.sql.warehouse.dir", "file:///${system:user.dir}/spark-warehouse")
    .config("spark.casandra.connection.host", conf.Cassandra.host)
    .config("spark.casandra.connection.port", conf.Cassandra.port)
    .config("spark.cassandra.auth.username", conf.Cassandra.userName)
    .getOrCreate()

  val sc = ss.sparkContext
  val sqlc = ss.sqlContext

  val dfToProcess = sqlc.read.parquet(conf.hdfsDataPath)
    .where(s"unix_timestamp() - timestampBucket / 1000 <= ${conf.batchBucketMinutes * 60}")

  dfToProcess.createOrReplaceTempView("records")

  //////////////////////////
  // Compute unique visitors
  //////////////////////////

  val uniqueVisitorsBySite = sqlc.sql("""
      |SELECT site, timestampBucket AS timestamp_bucket,
      |  COUNT(DISTINCT visitor) AS unique_visitors
      |FROM records
      |GROUP BY site, timestampBucket
    """.stripMargin)

  //uniqueVisitorsBySite.show(500)

  uniqueVisitorsBySite
    .write
    .mode(SaveMode.Append)
    .format("org.apache.spark.sql.cassandra")
    .options(Map("keyspace" -> conf.Cassandra.keyspaceName, "table" -> conf.Cassandra.batchUniqueVisitorsBySiteTable))
    .save()

  //////////////////////////
  // Compute action by site
  //////////////////////////

  val actionsBySite = sqlc.sql("""
      |SELECT site, timestampBucket AS timestamp_bucket,
      |  SUM(CASE WHEN action = 'add_to_favorites' THEN 1 ELSE 0 END) AS fav_count,
      |  SUM(CASE WHEN action = 'comment' THEN 1 ELSE 0 END) AS comm_count,
      |  SUM(CASE WHEN action = 'page_view' THEN 1 ELSE 0 END) AS view_count
      |FROM records
      |GROUP BY site, timestampBucket
    """.stripMargin
  ).cache()

  //actionsBySite.show(500)

  actionsBySite
    .write
    .mode(SaveMode.Append)
    .format("org.apache.spark.sql.cassandra")
    .options(Map("keyspace" -> conf.Cassandra.keyspaceName, "table" -> conf.Cassandra.batchActionsBySiteTable))
    .save()
}
