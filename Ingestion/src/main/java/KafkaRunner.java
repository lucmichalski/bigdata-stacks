import producer.TwitterProducer;

public class KafkaRunner {
    public static void main(String[] args) {
        TwitterProducer twitterProducer = new TwitterProducer();
        twitterProducer.run();
    }
}
