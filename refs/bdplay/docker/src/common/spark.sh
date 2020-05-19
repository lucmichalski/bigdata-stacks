#!/usr/bin/env bash

export HOSTNAME_MASTER=${HOSTNAME_MASTER:-$(hostname -f)}
export SPARK_MASTER_HOST=${SPARK_MASTER_HOST:-$HOSTNAME_MASTER}
export SPARK_DIST_CLASSPATH=$(hadoop classpath):${SPARK_DIST_CLASSPATH}
export SPARK_PUBLIC_DNS=${SPARK_PUBLIC_DNS:-${HOSTNAME_MASTER}}

function start_master {
    $SPARK_HOME/sbin/start-master.sh
}

function start_worker {
    $SPARK_HOME/sbin/start-slave.sh spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
}