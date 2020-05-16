#!/bin/bash

#$1= MASTER or SLAVE
#$2= cluster master hostname

#start os service
/opt/start-service.sh

#Edit config: hadoop and hbase
/opt/ready-config.sh $2

if [[ $1 == "MASTER" ]]; then
  : ${HADOOP_PREFIX:=/opt/hadoop}

  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
  rm -rf /tmp/*.pid

  #FROMATE namenode, only formatting at first time.
  if [ ! -e /tmp/.namenode_formated.format ]
  then
    echo "Namenode Formatted" > /tmp/.namenode_formated.format
    $HADOOP_PREFIX/bin/hadoop namenode -format
  fi

  #START HDFS
  $HADOOP_PREFIX/sbin/start-dfs.sh
  $HADOOP_PREFIX/sbin/start-yarn.sh
  $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver
  #START HBASE
  /opt/hbase/bin/start-hbase.sh

fi

#Persist container instance
supervisord -n
