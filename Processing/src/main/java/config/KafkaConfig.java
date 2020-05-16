package config;

import org.apache.kafka.common.serialization.LongDeserializer;
import org.apache.kafka.common.serialization.LongSerializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;

public class KafkaConfig {
    public static final String boostrapservers = "kafka:9092";
    public static final String acks = "1";
    public static final String topic = "MyTopic";
    public static final String keyDeserializer= LongDeserializer.class.getName();
    public static final String valueDeserializer = StringDeserializer.class.getName();

}
