#! /usr/bin/env bash


# File Name    : linux/work-tools/docker/rabbitmq/rabbitmq-docker.sh
# Author       : AlanDing
# Created Time : Mon 18 Nov 2019 03:55:40 PM CST
# Description  : 

# 提供交互-it 
# -e 限制es启动堆内存，它默认为2G...，自己电脑运行太大，抗不住


if [ $1 == 'kibana' ]; then
    docker run -it -d -e ELASTICSEARCH_URL=http://localhost:9200 --name kibana7 --network=container:ES7-01 kibana:7.4.2
    # docker exec -it kibana7 /bin/bash
    # cd config && vi kibana.yml
    # 修改url

    # kibana浏览器访问地址
    # http://localhost:5601

elif [ $1 == '' ]; then
    docker run -d --name ES7-01 -p 5601:5601 -p 9200:9200 -p 9300:9300 -e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
        -e "discovery.type=single-node" --restart=always elasticsearch:7.4.2
elif [ $1 == '6' ]; then
    docker run -d --name ES6-01 -p 5601:5601 -p 9200:9200 -p 9300:9300 -e ES_JAVA_OPTS="-Xms256m -Xmx256m" \
        -e "discovery.type=single-node" --restart=always elasticsearch:6.8.5
else
  echo 'invalid version args'
fi

