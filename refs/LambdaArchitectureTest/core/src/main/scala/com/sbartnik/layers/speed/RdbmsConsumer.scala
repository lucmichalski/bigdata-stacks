package com.sbartnik.layers.speed

import com.sbartnik.common.KafkaConsumerOperations
import com.sbartnik.config.{AppConfig, ConfigurationProvider}
import com.sbartnik.domain.SiteActionRecord

object RdbmsConsumer extends App {

  val conf = AppConfig
  val kafkaConf = conf.Kafka
  val kafkaProps = ConfigurationProvider.kafkaStreamConsumer

  val kafkaConsumerOps = new KafkaConsumerOperations(kafkaProps, kafkaConf.topic)

  while(true) {
    val records = kafkaConsumerOps.receive
    val mappedRecords = records.map(SiteActionRecord.deserialize)
    println(mappedRecords.length)
    Thread.sleep(5000)
  }
}
