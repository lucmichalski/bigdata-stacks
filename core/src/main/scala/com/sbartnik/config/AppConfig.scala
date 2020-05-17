package com.sbartnik.config

import com.typesafe.config.ConfigFactory

object AppConfig {

  private val appConfig = ConfigFactory.load()

  val sparkMaster: String = appConfig.getString("sparkMaster")
  val hdfsDataPath: String = appConfig.getString("hdfsDataPath")
  val streamingBatchDurationSeconds: Int = appConfig.getInt("streamingBatchDurationSeconds")
  val streamingWindowDurationSeconds: Int = appConfig.getInt("streamingWindowDurationSeconds")
  val checkpointDir: String = appConfig.getString("checkpointDir")
  val hllBitsCount: Int = appConfig.getInt("hllBitsCount")
  val batchBucketMinutes: Int = appConfig.getInt("batchBucketMinutes")

  object Cassandra {
    private val cassandraConfig = appConfig.getConfig("cassandra")

    val port: Int = cassandraConfig.getInt("port")
    val host: String = cassandraConfig.getString("host")
    val keepAliveMs: Int = cassandraConfig.getInt("keepAliveMs")
    val userName: String = cassandraConfig.getString("userName")
    val keyspaceName: String = cassandraConfig.getString("keyspaceName")

    val batchUniqueVisitorsBySiteTable : String = cassandraConfig.getStringList("tables").get(0)
    val batchActionsBySiteTable : String = cassandraConfig.getStringList("tables").get(1)
    val speedUniqueVisitorsBySiteTable : String = cassandraConfig.getStringList("tables").get(2)
    val speedActionsBySiteTable : String = cassandraConfig.getStringList("tables").get(3)
  }

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

    object Producer {
      private val kafkaProducerConfig = kafkaConfig.getConfig("producer")

      val clientId: String = kafkaProducerConfig.getString("clientId")
      val bootstrapServers: String = kafkaProducerConfig.getString("bootstrapServers")
      val acks: String = kafkaProducerConfig.getString("acks")
      val maxRetries: Int = kafkaProducerConfig.getInt("maxRetries")
      val batchSizeBytes: Int = kafkaProducerConfig.getInt("batchSizeBytes")
      val lingerTimeMs: Int = kafkaProducerConfig.getInt("lingerTimeMs")
      val bufferSizeBytes: Int = kafkaProducerConfig.getInt("bufferSizeBytes")
      val keySerializerClass: String = kafkaProducerConfig.getString("keySerializerClass")
      val valueSerializerClass: String = kafkaProducerConfig.getString("valueSerializerClass")
    }

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

  object TrafficGen {
    private val trafficGenConfig = appConfig.getConfig("trafficGen")

    val recordsPerBatch: Int = trafficGenConfig.getInt("recordsPerBatch")
    val numOfBatches: Int = trafficGenConfig.getInt("numOfBatches")
    val numOfVisitors: Int = trafficGenConfig.getInt("numOfVisitors")
    val timeMultiplier: Int = trafficGenConfig.getInt("timeMultiplier")
    val numOfSubpages: Int = trafficGenConfig.getInt("numOfSubpages")
    val sleepAfterEachFileMs: Int = trafficGenConfig.getInt("sleepAfterEachFileMs")
  }
}
