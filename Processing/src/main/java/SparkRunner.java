import config.HBaseConfig;
import consumer.KafkaConsumer;
import jobs.SentimentAnalysis;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.spark.HBaseContext;
import org.apache.hadoop.hbase.spark.JavaHBaseContext;
import org.apache.spark.SparkConf;
import org.apache.spark.SparkContext;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.streaming.Durations;
import org.apache.spark.streaming.api.java.JavaDStream;
import org.apache.spark.streaming.api.java.JavaPairDStream;
import org.apache.spark.streaming.api.java.JavaStreamingContext;
import sink.HbaseSink;

import java.util.ArrayList;
import java.util.List;

public class SparkRunner {
    public static void main(String[] args) {
        SparkConf conf = new SparkConf().setMaster("local[2]").setAppName("Spark Sentiment Analysis");
        SparkSession sparkSession = SparkSession
                .builder()
                .config(conf)
                .getOrCreate();

        JavaSparkContext jsc = JavaSparkContext.fromSparkContext(sparkSession.sparkContext());
        JavaStreamingContext jssc = new JavaStreamingContext(jsc, Durations.seconds(1));

        KafkaConsumer kafkaConsumer = new KafkaConsumer();

        JavaPairDStream<String, List<String>> stream = kafkaConsumer.consumeStream(jssc);
        SentimentAnalysis sentimentAnalysis = new SentimentAnalysis(jssc);
        JavaDStream<String> resultSA = sentimentAnalysis.applySentimentAnalysis(stream);
        Configuration hbaseConfiguration = HBaseConfiguration.create();
        hbaseConfiguration.set("hbase.zookeeper.quorum", HBaseConfig.zookeeperQuorum);
        hbaseConfiguration.set("hbase.zookeeper.property.clientPort", HBaseConfig.zookeeperClientPort);
        JavaHBaseContext javaHBaseContext = new JavaHBaseContext(jsc, hbaseConfiguration);
        HbaseSink.saveToHbase(javaHBaseContext, resultSA);

        jssc.start();
        try {
            jssc.awaitTermination();
        jsc.stop();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

