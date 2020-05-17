package com.sbartnik.common

import java.util.{Collections, Properties}
import com.sbartnik.common.Helpers._
import com.typesafe.scalalogging.LazyLogging
import org.apache.kafka.clients.consumer.KafkaConsumer
import scala.language.reflectiveCalls
import scala.collection.JavaConverters._

class KafkaConsumerOperations(configProps: Properties, topic: String) extends LazyLogging {

  private val kafkaConsumer = new KafkaConsumer[String, String](configProps)
  logger.info(s"Initialized KafkaConsumerOperations with topic '$topic' and properties: ${configProps.format}")

  kafkaConsumer.subscribe(Collections.singletonList(topic))

  def receive(): List[String] = {
    try {
      logger.info(s"Getting messages from topic $topic...")
      val kafkaRecords = kafkaConsumer.poll(1000)
      val records = kafkaRecords.asScala.map(_.value())
      records.toList
    } catch {
      case ex: Exception =>
        logger.error(s"Got exception receiving messages from topic $topic", ex)
        List.empty
    }
  }
}
