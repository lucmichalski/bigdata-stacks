#!/bin/bash

set -eo pipefail

if [ "$1" == "-server" ]; then
    shift
    
    myid=$1
    size=${2:-1}
    vnet=${3:-"vnet"}
    
    echo $myid > /zookeeper/myid

    for i in $(seq $size); do
        echo "server.${i}=zookeeper-${i}.${vnet}:2888:3888" >> ${ZOOKEEPER_CONF_DIR}/zoo.cfg
    done
    exec su-exec zookeeper ${ZOOKEEPER_HOME}/bin/zkServer.sh start-foreground
fi

exec "$@"
