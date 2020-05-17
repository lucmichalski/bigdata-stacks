package com.sbartnik.common

import java.util.Properties
import com.sbartnik.common.Helpers._
import com.typesafe.scalalogging.LazyLogging
import org.apache.kafka.clients.consumer.KafkaConsumer
import scala.language.reflectiveCalls
import scala.collection.JavaConverters._
import java.util.Collections.singletonList

class KafkaConsumerOperations(configProps: Properties, topic: String) extends LazyLogging {

  private val kafkaConsumer = new KafkaConsumer[String, String](configProps)
  logger.info(s"Initialized KafkaConsumerOperations with topic '$topic' and properties: ${configProps.format}")

  kafkaConsumer.subscribe(topic)

  def receive(): List[String] = {
    try {
      logger.info(s"Getting messages from topic $topic...")
      val kafkaRecords = kafkaConsumer.poll(1000)
      val records = kafkaRecords.asScala
        .values
        .flatMap(_.records().asScala)
        .map(_.value())
      records.toList
    } catch {
      case ex: Exception =>
        logger.error(s"Got exception receiving messages from topic $topic", ex)
        List.empty
    }
  }
}
