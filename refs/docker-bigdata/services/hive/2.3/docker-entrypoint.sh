#!/bin/bash

if [[ -n "$HIVE_CLUSTER" ]]; then

    HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
    if [[ -n "$HDFS_FS_DEFAULTFS" ]]; then
        sed -i "/<name>fs.defaultFS<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_FS_DEFAULTFS////\\/}<\/value>/g}" "$HADOOP_CONF_DIR/core-site.xml"
    fi
    if [[ -n "$HDFS_SLAVES" ]]; then
        echo -e "${HDFS_SLAVES/,/\\n}" > "$HADOOP_CONF_DIR/slaves"
    fi
    sed -i "/<name>dfs.replication<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_DFS_REPLICATION:-1}<\/value>/g}" "$HADOOP_CONF_DIR/hdfs-site.xml"
    sed -i "/<name>yarn.resourcemanager.hostname<\/name>/{n;s/<value>.*<\/value>/<value>${YARN_RESOURCEMANAGER_HOSTNAME:-0.0.0.0}<\/value>/g}" "$HADOOP_CONF_DIR/yarn-site.xml"
fi

if [ "$1" = 'hiveserver2' ]; then
    /etc/init.d/ssh start
    gosu hadoop hdfs namenode -format
    if [[ -z "$HIVE_CLUSTER" || -n "$HDFS_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/start-dfs.sh
        gosu hive /usr/local/hadoop/bin/hadoop fs -mkdir /tmp
        gosu hive /usr/local/hadoop/bin/hadoop fs -mkdir -p /user/hive/warehouse
        gosu hive /usr/local/hadoop/bin/hadoop fs -chmod g+w /tmp
        gosu hive /usr/local/hadoop/bin/hadoop fs -chmod g+w /user/hive/warehouse
    fi
    if [[ -z "$HIVE_CLUSTER" || -n "$YARN_MASTER" ]]; then
        gosu hive /usr/local/hadoop/sbin/start-yarn.sh
    fi
    if [[ -z "$HIVE_CLUSTER" || -n "$HISTORY_MASTER" ]]; then
        gosu hive /usr/local/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
    fi
    gosu hive /usr/local/hive/bin/schematool -dbType ${HIVE_DB_TYPE:-derby} -initSchema
    gosu hive /usr/local/hive/bin/hiveserver2
    gosu hive tail -f /dev/null
fi

exec "$@"