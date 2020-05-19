#!/usr/bin/env bash

export HOSTNAME_MASTER=${HOSTNAME_MASTER:-$(hostname -f)}
export HDFS_NAME_DIR=${HDFS_NAME_DIR:-/data/hadoop/hdfs/name/}
export HDFS_DATA_DIR=${HDFS_DATA_DIR:-/data/hadoop/hdfs/data/}
export HDFS_REPLICATION=${HDFS_REPLICATION:-1}
export YARN_NODE_RES_MEM_MB=${YARN_NODE_RES_MEM_MB:-8192}
export HADOOP_MAP_MEM_MB=${HADOOP_MAP_MEM_MB:-1536}
export HADOOP_REDUCE_MEM_MB=${HADOOP_REDUCE_MEM_MB:-3072}


THIS_DIR=`dirname $0`
export HADOOP_CONF_PATH=${HADOOP_HOME}/etc/hadoop

function configure_one {
    target_file=${HADOOP_CONF_PATH}/`basename $1`
    envsubst < $1 > ${target_file}
    echo "config file: $target_file" && grep '^[^\n#]' "${target_file}"
}
export -f configure_one

function configure_hadoop {
    [ ! -z ${HADOOP_CONF_BY_FILE} ] && ${HADOOP_CONF_BY_FILE} && return 0
    ls ${THIS_DIR}/../conf/hadoop/*.xml | xargs -I % bash -c "configure_one %"
}

function format_namenode {
    if [ "`ls -A $HDFS_NAME_DIR`" == "" ]; then
      echo "Formatting namenode name directory: $HDFS_NAME_DIR"
      $HADOOP_HOME/bin/hdfs namenode -format $HOSTNAME_MASTER
    fi
}

function start_master {
    format_namenode
    $HADOOP_HOME/bin/hdfs --daemon start namenode
    $HADOOP_HOME/bin/yarn --daemon start resourcemanager
    $HADOOP_HOME/bin/mapred --daemon start historyserver
}

function start_worker {
    $HADOOP_HOME/bin/hdfs --daemon start datanode
    $HADOOP_HOME/bin/yarn --daemon start nodemanager
}