package com.sbartnik.layers.producer

import com.sbartnik.config.{AppConfig, ConfigurationProvider}
import com.sbartnik.common.{Helpers, KafkaProducerOperations}
import com.sbartnik.domain.SiteActionRecord
import com.typesafe.scalalogging.LazyLogging
import scala.util.Random

object KafkaDataProducer extends App with LazyLogging with Helpers {

  // Configurations
  val kafkaProducerConfigProps = ConfigurationProvider.kafkaProducer
  val kafkaTopic = AppConfig.Kafka.topic
  val kafkaNumOfPartitions = AppConfig.Kafka.numOfPartitions
  val generatorConfig = AppConfig.TrafficGen

  // Files with test inputs
  val sites = getLinesFromResourceFile("sites.txt")
  val referrers = getLinesFromResourceFile("referrers.txt")
  val countries = getLinesFromResourceFile("countries.txt")

  // Dummy test inputs
  val visitorsIds = (0 to generatorConfig.numOfVisitors).map(x => s"Visitor-$x")
  val subpagesIds= (0 to generatorConfig.numOfSubpages).map(x => s"Subpage-$x")

  val rnd = new Random()

  val kafkaOps = new KafkaProducerOperations(
    kafkaProducerConfigProps,
    kafkaTopic,
    kafkaNumOfPartitions)

  for (_ <- 1 to generatorConfig.numOfBatches) {

    val randomSleepEvery = rnd.nextInt(80000) + 20000
    var timestamp = System.currentTimeMillis()
    var adjustedTimestamp = timestamp

    for (currRecordIndex <- 1 to generatorConfig.recordsPerBatch) {
      adjustedTimestamp = adjustedTimestamp + ((System.currentTimeMillis - timestamp) * generatorConfig.timeMultiplier)
      timestamp = System.currentTimeMillis

      val record = getRandomSiteActionRecord(timestamp, currRecordIndex)
      val recordAsLine = record.serialized
      kafkaOps.send(recordAsLine)

      if(currRecordIndex % randomSleepEvery == 0) {
        logger.info(s"Sent $currRecordIndex messages")
        val sleepTime = rnd.nextInt(2000)
        logger.info(s"Sleeping for $sleepTime ms (random sleep)")
        Thread.sleep(sleepTime)
      }
    }

    val sleepAfterEachBatch = generatorConfig.sleepAfterEachFileMs
    logger.info(s"Sleeping for $sleepAfterEachBatch ms (after batch)")
    Thread.sleep(sleepAfterEachBatch)
  }

  def getRandomSiteActionRecord(timestamp: Long, currRecordIndex: Int): SiteActionRecord = {
    val action = currRecordIndex % (rnd.nextInt(generatorConfig.recordsPerBatch) + 1) match {
      case 0 => "add_to_favorites"
      case 1 => "comment"
      case _ => "page_view"
    }

    val geo = rnd.nextInt(3) match {
      case 0 => countries(rnd.nextInt(countries.length - 1))
      case _ => ""
    }

    val referrer = referrers(rnd.nextInt(referrers.length - 1))

    val previousPage = referrer match {
      case "Internal" => subpagesIds(rnd.nextInt(subpagesIds.length - 1))
      case "Other" => sites(rnd.nextInt(sites.length - 1))
      case _ => ""
    }

    val timeSpentSeconds = rnd.nextInt(5 * 60) + 1

    val visitor = visitorsIds(rnd.nextInt(visitorsIds.length - 1))
    val subPage = subpagesIds(rnd.nextInt(subpagesIds.length - 1))
    val site = sites(rnd.nextInt(sites.length - 1))

    val siteActionRecord = SiteActionRecord(
      timestamp, -1, referrer, action, previousPage, visitor, geo, timeSpentSeconds, subPage, site
    )
    siteActionRecord
  }
}
