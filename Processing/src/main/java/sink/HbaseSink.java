package sink;

import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.spark.JavaHBaseContext;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.streaming.api.java.JavaDStream;

public class HbaseSink {

    public static class PutFunction implements Function<String, Put> {

        private static final long serialVersionUID = 1L;

        public Put call(String v) throws Exception {
            String[] cells = v.split(":");
            Put put = new Put(Bytes.toBytes(cells[0]));
            put.addColumn(Bytes.toBytes("content"), Bytes.toBytes(cells[1]),
                    Bytes.toBytes(cells[2]));
            put.addColumn(Bytes.toBytes("rating"), Bytes.toBytes(cells[3]),
                    Bytes.toBytes(cells[4]));
            return put;
        }
    }

    public static void saveToHbase(JavaHBaseContext javaHBaseContext, JavaDStream<String> resultSA) {
        javaHBaseContext.streamBulkPut(resultSA,
                TableName.valueOf("tweets"),
                new PutFunction());
    }


}
