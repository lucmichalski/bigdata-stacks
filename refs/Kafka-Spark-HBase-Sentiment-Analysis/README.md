# Kafka-Spark-HBase-Sentiment-Analysis
## Description
This project is an implementation of a Big data workflow.
It aims to manipulate different big data technologies such as Apache Kafka, Apache Zookeeper, Apache Spark and Apache Hbase. <br/> 
This application consists of a (dumb) sentiment analysis of a twitter stream that is based on computing a score for each tweet.
The score is calculated as follows: for each tweet text eliminate the (stop words) , add 1 for positive words and retrieve 1 for négative words.


## Architecture

![Big data workflow](Architecture.jpg)

The architecture consists of an ingestion and processing of a stream of Tweets consumed from the twitter developer Account. The result is stored in a database for querying and visualization.

## Prerequisites

* Install Java 8+
* Install docker: you can use this script https://get.docker.com/
```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sh get-docker.sh
```

## Steps
1. [Clone the repo](#1-clone-the-repo)
2. [Set up the infrastructure](#2-set-up-the-infrastructure)
3. [Launch the Ingestion Module](#3-launch-the-ingestion-module)
4. [Launch the Processing Module](#4-launch-the-processing-module)
5. [Visualize the results](#5-visualize-the-results)

### 1. Clone the repo

Clone this repository. In a terminal, run:

```bash
$ git clone https://github.com/ziedYazidi/Kafka-Spark-HBase-Sentiment-Analysis.git
```

### 2. Set up the infrastructure
In this project, i have used an infrastructure based on docker containers to simplify and accelerate the set up. Each service is a container (see the  architecture section)

The docker-compose.yml file launches Apache Kafka (a Kafka Broker and Apache Zookeeper), Apache Spark (a Driver container and 2 worker containers) and Apache HBase.

I used Hbase in standalone mode. In this case, HBase does not use HDFS — it uses the local filesystem instead — and it runs all HBase daemons and a local ZooKeeper all up in the same JVM.

The docker-compose.yml is based on 
 [wurstmeister/kafka](https://github.com/wurstmeister/kafka-docker), [singularities/spark](https://hub.docker.com/r/singularities/spark/) and [dajobe/hbase](https://github.com/dajobe/hbase-docker).

 I needed to rebuild the [dajobe/hbase](https://github.com/dajobe/hbase-docker) image because it uses the Apache Zookeeper default port 2181 (changed it to 2182). In this case there will be no conflict with the Apache Zookeeper port 2181 used with kafka.

You can find the new image in [my docker hub account](https://hub.docker.com/repository/docker/ziedyazidi/hbase).

All you need to do in this section is launch the docker compose file as follows:
```bash
$ docker-compose up
```
Then you need to configure the __/etc/hosts__ throught the __updateHosts__ script. This script allows to use hostnames in our program rather than IP Addresses and to enable client connexion to the Hbase container.
To launch the script:
```bash
$ ./updateHosts.sh
```

 
#### Notes
You can use these other methods to set up the infrastructure:
- [Hortonworks Data Plateform Sandbox](https://hub.docker.com/r/hortonworks/sandbox-hdp-standalone/)
- Install the services locally (needs much more time)


### 3. Launch the Ingestion Module
This module aims to consume the twitter stream and send it to a Kafka Topic. 
It contains a producer that authetificates to the Twitter API, constructs models based on the stream schema and connects to the kafka broker to save the stream.

#### Notes
* For this section, you need to create a Twitter developer account to get an **apiKey**, **apiSecret**, **accessToken** and **accessTokenSecret**. Set this values in the **TwitterConfig** file.

* Otherwise, you can skip the kafka section and use the [PubNub tweets stream](https://www.pubnub.com/developers/realtime-data-streams/twitter-stream/) alonside with apache Bahir. This will allow you to consume the stream directly in Apache Spark. (See [documentation](https://bahir.apache.org/docs/spark/2.3.2/spark-streaming-pubnub/))   

### 4. Launch the Processing Module
This module is composed of 3 parts: kafka stream consumption, stream processing and hbase sink.

The kafka consumer consumes the tweets from the Kafka topic.

A score is computed for each tweet using Spark Streaming (See SentimenetAnalysis.java)

The result is saved to hbase using the **hbase-spark** connector. 

You need to create the **tweets** table and the column families **content** and **rating** in Apache Hbase before launchning the module:
```bash
$ create 'tweets', 'content', 'rating'
```

### 5. Visualize and query the results
You can add tools like Apache Zeppelin, Tableau, Qlink, ... to be able to query and visualize the data stored in Apache HBase. 


### References
* [wurstmeister/kafka](https://github.com/wurstmeister/kafka-docker)
* [singularities/spark](https://hub.docker.com/r/singularities/spark/)
* [dajobe/hbase](https://github.com/dajobe/hbase-docker).


