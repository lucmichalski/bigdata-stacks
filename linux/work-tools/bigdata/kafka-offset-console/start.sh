#! /usr/bin/env bash


# File Name    : kafka-offset-console/start.sh
# Author       : AlanDing
# Created Time : Sat 07 Dec 2019 10:16:09 AM CST
# Description  :


# offset 存储在kafka里面，如果是老版本可以改成zookeeper

path=$(dirname $0)

java -cp $path/KafkaOffsetMonitor-assembly-0.4.6-SNAPSHOT.jar com.quantifind.kafka.offsetapp.OffsetGetterWeb \
--offsetStorage kafka \
--kafkaBrokers hadoop100:9092,hadoop101:9092,hadoop102:9092 \
--kafkaSecurityProtocol PLAINTEXT \
--zk hadoop100:2181,hadoop101:2181,hadoop102:2181 \
--port 8086 \
--refresh 10.seconds \
--retain 2.days \
--dbName offsetapp_kafka &

# & 以非阻塞方式执行该命令，后台
