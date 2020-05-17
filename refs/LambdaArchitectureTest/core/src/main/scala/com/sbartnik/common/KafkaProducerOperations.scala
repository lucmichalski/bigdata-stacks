package com.sbartnik.common

import java.util.Properties
import org.apache.kafka.clients.producer.{KafkaProducer, ProducerRecord}
import com.sbartnik.common.Helpers._
import com.typesafe.scalalogging.LazyLogging
import scala.language.reflectiveCalls
import scala.util.Random

class KafkaProducerOperations(configProps: Properties, topic: String, numOfPartitions: Int) extends LazyLogging {

  private val kafkaProducer = new KafkaProducer[String, String](configProps)
  logger.info(s"Initialized KafkaProducerOperations with topic '$topic' and properties: ${configProps.format}")
  logger.info(s"Topic $topic has ${kafkaProducer.partitionsFor(topic)} partitions")

  private val rnd = new Random()

  def send(message: String): Boolean = {
    try {
      logger.info(s"Sending message to topic $topic...")
      val partition = rnd.nextInt(numOfPartitions)
      val recordToSend = new ProducerRecord[String, String](topic, partition, 0.toString, message)
      kafkaProducer.send(recordToSend)
      true
    } catch {
      case ex: Exception =>
        logger.error(s"Got exception sending message to topic $topic", ex)
        false
    }
  }
}
