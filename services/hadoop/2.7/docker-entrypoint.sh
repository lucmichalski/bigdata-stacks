#!/bin/bash

set -e

if [[ -n "${HDFS_FS_DEFAULTFS}" ]]; then
    sed -i "/<name>fs.defaultFS<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_FS_DEFAULTFS////\\/}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/core-site.xml"
fi
if [[ -n "${HADOOP_CLUSTER_SLAVES}" ]]; then
    echo -e "${HADOOP_CLUSTER_SLAVES//,/\\n}" > "${HADOOP_HOME}/etc/hadoop/slaves"
    sed -i "/<name>dfs.replication<\/name>/{n;s/<value>.*<\/value>/<value>$(awk 'END{print NR}' ${HADOOP_HOME}/etc/hadoop/slaves)<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"
fi
if [[ -n "${HDFS_DFS_REPLICATION}" ]]; then
    sed -i "/<name>dfs.replication<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_DFS_REPLICATION}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"
fi
if [[ -n "${HDFS_DFS_NAMENODE_SECONDARY_HTTP_ADDRESS}" ]]; then
    sed -i "/<name>dfs.namenode.secondary.http-address<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_DFS_NAMENODE_SECONDARY_HTTP_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"
fi
if [[ -n "${HDFS_DFS_DATANODE_ADDRESS}" ]]; then
    sed -i "/<name>dfs.datanode.address<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_DFS_DATANODE_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"
fi
if [[ -n "${HDFS_DFS_DATANODE_IPC_ADDRESS}" ]]; then
    sed -i "/<name>dfs.datanode.ipc.address<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_DFS_DATANODE_IPC_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"
fi
if [[ -n "${YARN_RESOURCEMANAGER_HOSTNAME}" ]]; then
    sed -i "/<name>yarn.resourcemanager.hostname<\/name>/{n;s/<value>.*<\/value>/<value>${YARN_RESOURCEMANAGER_HOSTNAME}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/yarn-site.xml"
fi
if [[ -n "${YARN_RESOURCEMANAGER_SCHEDULER_ADDRESS}" ]]; then
    sed -i "/<name>yarn.resourcemanager.scheduler.address<\/name>/{n;s/<value>.*<\/value>/<value>${YARN_RESOURCEMANAGER_SCHEDULER_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/yarn-site.xml"
fi
if [[ -n "${YARN_RESOURCEMANAGER_RESOURCE_TRACKER_ADDRESS}" ]]; then
    sed -i "/<name>yarn.resourcemanager.resource-tracker.address<\/name>/{n;s/<value>.*<\/value>/<value>${YARN_RESOURCEMANAGER_RESOURCE_TRACKER_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/yarn-site.xml"
fi
if [[ -n "${YARN_RESOURCEMANAGER_ADDRESS}" ]]; then
    sed -i "/<name>yarn.resourcemanager.address<\/name>/{n;s/<value>.*<\/value>/<value>${YARN_RESOURCEMANAGER_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/yarn-site.xml"
fi
if [[ -n "${YARN_RESOURCEMANAGER_ADMIN_ADDRESS}" ]]; then
    sed -i "/<name>yarn.resourcemanager.admin.address<\/name>/{n;s/<value>.*<\/value>/<value>${YARN_RESOURCEMANAGER_ADMIN_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/yarn-site.xml"
fi
if [[ -n "${YARN_NODEMANAGER_LOCALIZER_ADDRESS}" ]]; then
    sed -i "/<name>yarn.nodemanager.localizer.address<\/name>/{n;s/<value>.*<\/value>/<value>${YARN_NODEMANAGER_LOCALIZER_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/yarn-site.xml"
fi

if [ "$1" = 'start-all.sh' ]; then
    /etc/init.d/ssh start
    gosu hadoop /usr/local/hadoop/bin/hdfs namenode -format
    if [[ ! -n "$HADOOP_CLUSTER_SLAVES" || -n "$HADOOP_CLUSTER_MASTER" || -n "$HDFS_CLUSTER_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/start-dfs.sh
    fi
    if [[ ! -n "$HADOOP_CLUSTER_SLAVES" || -n "$HADOOP_CLUSTER_MASTER" || -n "$YARN_CLUSTER_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/start-yarn.sh
    fi
    if [[ ! -n "$HADOOP_CLUSTER_SLAVES" || -n "$HADOOP_CLUSTER_MASTER" || -n "$HISTORY_CLUSTER_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
    fi
    gosu hadoop sleep 8640h
fi

exec "$@"