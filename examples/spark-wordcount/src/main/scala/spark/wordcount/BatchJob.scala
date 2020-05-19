/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package spark.wordcount
import org.apache.spark.sql.{SparkSession}
import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
import org.apache.spark.sql.types.{StructField, StructType, StringType, LongType}

/**
  * Skeleton for a Flink Batch Job.
  *
  * For a tutorial how to write a Flink batch application, check the
  * tutorials and examples on the <a href="http://flink.apache.org/docs/stable/">Flink Website</a>.
  *
  * To package your application into a JAR file for execution,
  * change the main class in the POM.xml file to this class (simply search for 'mainClass')
  * and run 'mvn clean package' on the command line.
  */
object BatchJob {

    def main(args: Array[String]) {
        val logFile = args(0) // Should be some file on your system
        val conf = new SparkConf().setAppName("word count")
        val sc = new SparkContext(conf)

        val logData = sc.textFile(args(0))
        val numAs = logData.filter(line => line.contains("a")).count()
        val numBs = logData.filter(line => line.contains("b")).count()
        println(s"Lines with a: $numAs, Lines with b: $numBs")
        val res = logData.flatMap(line => line.split("\\s")).map((_, 1)).reduceByKey(_ + _)
        val df = SparkSession.builder.config(sc.getConf).getOrCreate().createDataFrame(res).toDF("key", "value").toJSON
        df.show()
        df.write.format("kafka")
            .option("kafka.bootstrap.servers", "localhost:9092").option("topic", "worldcount").save()
        sc.stop()
    }
}
