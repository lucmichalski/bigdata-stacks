#!/bin/bash

set -e

if [[ -z "$KAFKA_CLUSTER" || -z "$ZOOKEEPER_CONNECT" ]]; then
    su-exec "$ZOO_USER" cp /conf/zoo_sample.cfg /conf/zoo.cfg
    zkServer.sh start
fi

if [[ -n "$KAFKA_CLUSTER" ]]; then
    sed -i "s/broker.id=.*/broker.id=${BROKER_ID:-0}/g" "/etc/kafka/server.properties"
    if [[ -n "$LISTENERS" ]]; then
        sed -i "s/listeners=.*/listeners=${LISTENERS////\\/}/g" "/etc/kafka/server.properties"
    fi
    if [[ -n "$ADVERTISED_LISTENERS" ]]; then
        sed -i "s/advertised.listeners=.*/listeners=${ADVERTISED_LISTENERS////\\/}/g" "/etc/kafka/server.properties"
    fi
    if [[ -n "$ZOOKEEPER_CONNECT" ]]; then
        sed -i "s/zookeeper.connect=.*/zookeeper.connect=$ZOOKEEPER_CONNECT/g" "/etc/kafka/server.properties"
    fi
fi

if [ "$1" = 'kafka-server-start.sh' ]; then
    su-exec kafka kafka-server-start.sh /etc/kafka/server.properties
fi

exec "$@"
