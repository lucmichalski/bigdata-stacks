# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export HADOOP_HOME=/opt/hadoop

#Hadoop variables
# export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_40/
# export HADOOP_INSTALL=/opt/hadoop
# export PATH=$PATH:$HADOOP_INSTALL/bin
# export PATH=$PATH:$HADOOP_INSTALL/sbin
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_LIBEXEC_DIR=${HADOOP_HOME}/libexec
export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"

# SET HIVE HOME
export HIVE_HOME=/opt/apache-hive
export HIVE_CONF_DIR=$HIVE_HOME/conf
export CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:.
export CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.

PATH=$PATH:$HIVE_HOME/bin

export PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${JAVA_HOME}:${HADOOP_MAPRED_HOME}:${HADOOP_COMMON_HOME}:${HADOOP_HDFS_HOME}:${YARN_HOME}:${HADOOP_LIBEXEC_DIR}

