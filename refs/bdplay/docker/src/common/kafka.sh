#!/usr/bin/env bash

export HOSTNAME_MASTER=${HOSTNAME_MASTER:-$(hostname -f)}
export KAFKA_ENABLED=${KAFKA_ENABLED:-true}
export KAFKA_ADV_HOSTNAME=${KAFKA_ADV_HOSTNAME:-$(hostname -f)}

function config_broker {
    [ ! -z ${KAFKA_CONF_BY_FILE} ] && ${KAFKA_CONF_BY_FILE} && return 0
    if [ -z ${KAFKA_ZOOKEEPER_CONNECT} ] && ${KAFKA_ENABLED}; then
        echo "KAFKA_ZOOKEEPER_CONNECT required"
        exit 1
    fi
    echo "configuring kafka"
    CONF_FILE=$KAFKA_HOME/config/server.properties
    envsubst < /opt/conf/kafka/server.properties > ${CONF_FILE}
    echo "config file: $CONF_FILE" && grep '^[^\n#]' "${CONF_FILE}"
}

function start_broker {
    if $KAFKA_ENABLED; then
        $KAFKA_HOME/bin/kafka-server-start.sh -daemon "$KAFKA_HOME/config/server.properties"
    fi
}