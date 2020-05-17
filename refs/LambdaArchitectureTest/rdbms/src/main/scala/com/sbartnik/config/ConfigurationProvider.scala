package com.sbartnik.config

import java.util.Properties
import org.apache.kafka.clients.consumer.ConsumerConfig
import org.apache.kafka.clients.producer.ProducerConfig

object ConfigurationProvider {
  def kafkaStreamConsumer: Properties = {
    val kafkaStreamConsumerConf = AppConfig.Kafka.StreamConsumer
    val props = new Properties()
    props.put(ConsumerConfig.CLIENT_ID_CONFIG, kafkaStreamConsumerConf.clientId)
    props.put(ConsumerConfig.GROUP_ID_CONFIG, kafkaStreamConsumerConf.groupId)
    props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaStreamConsumerConf.bootstrapServers)
    props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, kafkaStreamConsumerConf.autoOffsetReset)
    props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, kafkaStreamConsumerConf.keyDeserializerClass)
    props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, kafkaStreamConsumerConf.valueDeserializerClass)
    props
  }
}
