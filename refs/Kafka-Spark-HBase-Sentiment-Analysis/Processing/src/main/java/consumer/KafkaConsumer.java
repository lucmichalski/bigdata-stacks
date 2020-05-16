package consumer;

import config.KafkaConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.spark.streaming.StreamingContext;
import org.apache.spark.streaming.api.java.*;
import org.apache.spark.streaming.dstream.InputDStream;
import org.apache.spark.streaming.kafka010.ConsumerStrategies;
import org.apache.spark.streaming.kafka010.KafkaUtils;
import org.apache.spark.streaming.kafka010.LocationStrategies;
import scala.Tuple2;

import java.util.*;

public class KafkaConsumer {
    Map<String, Object> kafkaParams;
    Collection<String> topics;


    public KafkaConsumer() {
        kafkaParams = new HashMap<>();
        kafkaParams.put("bootstrap.servers", KafkaConfig.boostrapservers);
        kafkaParams.put("key.deserializer", KafkaConfig.keyDeserializer);
        kafkaParams.put("value.deserializer", KafkaConfig.valueDeserializer);
        kafkaParams.put("group.id", "1");
        kafkaParams.put("auto.offset.reset", "latest");
        kafkaParams.put("enable.auto.commit", false);

        topics = Arrays.asList(KafkaConfig.topic);

    }

    public JavaPairDStream<String, List<String>> consumeStream(JavaStreamingContext javaStreamingContext){
        JavaInputDStream<ConsumerRecord<Long, String>> stream =
                KafkaUtils.createDirectStream(
                        javaStreamingContext,
                        LocationStrategies.PreferConsistent(),
                        ConsumerStrategies.<Long, String>Subscribe(topics, kafkaParams)
                );


        JavaPairDStream<String, List<String>> pairedStream= stream.mapToPair(record -> new Tuple2<>(record.value(), Arrays.asList(record.value().split(" "))));
        return pairedStream;
    }
}
