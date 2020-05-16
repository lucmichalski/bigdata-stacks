package producer;

import org.apache.kafka.clients.producer.Callback;
import org.apache.kafka.clients.producer.RecordMetadata;

public class ProducerCallback implements Callback {
    public void onCompletion(RecordMetadata recordMetadata, Exception e) {
        if(e == null)
            System.out.printf("message with offset %d acknowledged by partition %d \n", recordMetadata.offset(), recordMetadata.partition());
        else
            System.out.println(e.getMessage());
    }
}
