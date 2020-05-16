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
if [[ -n "${HDFS_DFS_NAMENODE_SECONDARY_HTTPS_ADDRESS}" ]]; then
    sed -i "/<name>dfs.namenode.secondary.https-address<\/name>/{n;s/<value>.*<\/value>/<value>${HDFS_DFS_NAMENODE_SECONDARY_HTTPS_ADDRESS}<\/value>/g}" "${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"
fi
sed -i "s/<\/configuration>/    <property>\n        <name>dfs.datanode.max.transfer.threads<\/name>\n        <value>4096<\/value>\n    <\/property>\n<\/configuration>/g" "${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"

if [[ -n "$HBASE_ROOTDIR" ]]; then
    sed -i "/<name>hbase.rootdir<\/name>/{n;s/<value>.*<\/value>/<value>${HBASE_ROOTDIR////\\/}<\/value>/g}" "$HBASE_HOME/conf/hbase-site.xml"
fi
if [[ -n "$HBASE_REGION_SERVERS" ]]; then
    echo -e "${HBASE_REGION_SERVERS//,/\\n}" > "$HBASE_HOME/conf/regionservers"
fi
if [[ -n "$HBASE_BACKUP_MASTER" ]]; then
    echo -e "${HBASE_BACKUP_MASTER//,/\\n}" > "$HBASE_HOME/conf/backup-masters"
fi
sed -i "/<name>hbase.cluster.distributed<\/name>/{n;s/<value>.*<\/value>/<value>${HBASE_CLUSTER_DISTRIBUTED:-false}<\/value>/g}" "$HBASE_HOME/conf/hbase-site.xml"
sed -i "/<name>hbase.zookeeper.quorum<\/name>/{n;s/<value>.*<\/value>/<value>${HBASE_ZOOKEEPER_QUORUM:-localhost}<\/value>/g}" "$HBASE_HOME/conf/hbase-site.xml"
echo "export HBASE_MANAGES_ZK=false" >> "$HBASE_HOME/conf/hbase-env.sh"

if [ "$1" = 'start-hbase.sh' ]; then
    /etc/init.d/ssh start
    gosu hadoop hdfs namenode -format
    if [[ -z "$HBASE_CLUSTER_DISTRIBUTED" || -n "$HDFS_CLUSTER_MASTER" ]]; then
        gosu hadoop /usr/local/hadoop/sbin/start-dfs.sh
    fi
    if [[ -z "$HBASE_CLUSTER_DISTRIBUTED" || -n "$HBASE_CLUSTER_MASTER" ]]; then
        gosu hbase /usr/local/hbase/bin/start-hbase.sh
    fi
    gosu hbase tail -f /dev/null
fi

exec "$@"