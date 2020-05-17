package com.sbartnik.config

import com.typesafe.config.ConfigFactory

object AppConfig {

  private val appConfig = ConfigFactory.load()

  object Postgres {
    private val postgresConfig = appConfig.getConfig("postgres")

    val connectionString: String = postgresConfig.getString("connectionString")

    val siteTable : String = postgresConfig.getStringList("tables").get(0)
    val actionTypeTable : String = postgresConfig.getStringList("tables").get(1)
    val visitorTable : String = postgresConfig.getStringList("tables").get(2)
    val actionTable : String = postgresConfig.getStringList("tables").get(3)
  }

  object Kafka {
    private val kafkaConfig = appConfig.getConfig("kafka")

    val topic: String = kafkaConfig.getString("topic")
    val numOfPartitions: Int = kafkaConfig.getInt("numOfPartitions")

    object StreamConsumer {
      private val streamConsumerConf = kafkaConfig.getConfig("streamConsumer")

      val groupId: String = streamConsumerConf.getString("groupId")
      val clientId: String = streamConsumerConf.getString("clientId")
      val bootstrapServers: String = streamConsumerConf.getString("bootstrapServers")
      val autoOffsetReset: String = streamConsumerConf.getString("autoOffsetReset")
      val keyDeserializerClass: String = streamConsumerConf.getString("keyDeserializerClass")
      val valueDeserializerClass: String = streamConsumerConf.getString("valueDeserializerClass")
    }
  }
}
