package producer;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.twitter.hbc.ClientBuilder;
import com.twitter.hbc.core.Client;
import com.twitter.hbc.core.Constants;
import com.twitter.hbc.core.endpoint.StatusesFilterEndpoint;
import com.twitter.hbc.core.processor.StringDelimitedProcessor;
import com.twitter.hbc.httpclient.auth.Authentication;
import com.twitter.hbc.httpclient.auth.OAuth1;
import config.KafkaConfig;
import config.TwitterConfig;
import models.Tweet;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.List;
import java.util.Properties;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

public class TwitterProducer {
    private ProducerCallback producerCallback;
    private Client client;
    private BlockingQueue<String> queue;
    private Gson gson;

    public TwitterProducer() {

        Authentication authentication = new OAuth1(
                TwitterConfig.apiKey,
                TwitterConfig.apiSecrertKey,
                TwitterConfig.accessToken,
                TwitterConfig.accessTokenSecret
        );

        StatusesFilterEndpoint endpoint = new StatusesFilterEndpoint();
        List<Long> followings = Lists.newArrayList(1234L, 566788L);
        List<String> terms = Lists.newArrayList("twitter", "api");
        endpoint.followings(followings);
        endpoint.trackTerms(terms);

        queue = new LinkedBlockingQueue<String>(100000);

        client = new ClientBuilder()
                .hosts(Constants.STREAM_HOST)
                .authentication(authentication)
                .endpoint(endpoint)
                .processor(new StringDelimitedProcessor(queue))
                .build();

        gson = new Gson();
        producerCallback = new ProducerCallback();
    }

    private Producer<Long, String> getProducer(){
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, KafkaConfig.boostrapservers);
        props.put(ProducerConfig.ACKS_CONFIG, KafkaConfig.acks);
        props.put(ProducerConfig.LINGER_MS_CONFIG, 500);
        props.put(ProducerConfig.RETRIES_CONFIG, 0);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, KafkaConfig.keySerializer);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaConfig.valueSerializer);

        return new KafkaProducer<Long, String>(props);
    }
    public void run(){
        client.connect();
        try(Producer<Long, String> producer = getProducer()) {
            while (true){
                Tweet tweet = gson.fromJson(queue.take(), Tweet.class);
                if(tweet.getId() != 0 && tweet.getLang().equals("en")){
                    System.out.printf("Fetched tweet id %d \n ", tweet.getId());
                    ProducerRecord<Long, String> producerRecord = new ProducerRecord<>(KafkaConfig.topic, tweet.getId(), tweet.getText());
                    producer.send(producerRecord);
                }
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            client.stop();
        }


    }
}
