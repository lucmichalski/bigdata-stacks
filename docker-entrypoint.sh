#!/bin/bash
set -e

export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HADOOP_USER_NAME="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"
export HADOOP_HOME="/opt/hadoop"
export HIVE_HOME="/opt/apache-hive"
export HADOOP_OPTS="-Xmx1024m -Xms1024m"

echo "listing data directories of $(hostname)"
/bin/ls /opt/hadoop/data
if [ "$1" == 'hadoop' ]; then
    echo "Starting sshd service..."
    /etc/init.d/ssh start

    if [ "$(hostname)" == 'node-master' ]; then
        HDFS_ALREADY_FORMATTED=$(find "$HADOOP_HOME/data/nameNode" -mindepth 1 -print -quit 2>/dev/null)

        # Checking if HDFS needs to be formated.
        if [ !  $HDFS_ALREADY_FORMATTED ]; then
            echo "FORMATTING NAMENODE"
            $HADOOP_HOME/bin/hdfs namenode -format || { echo 'FORMATTING FAILED' ; exit 1; }

            # tells hive to use mysql database as its metastore database.
            $HIVE_HOME/bin/schematool -dbType mysql -initSchema  
        fi


        echo "Starting HDFS.."
        /bin/bash /opt/hadoop/sbin/start-dfs.sh

        # Create non-existing folders
        $HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive/warehouse

        # Create hue directories
        $HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hue
        $HADOOP_HOME/bin/hadoop fs -chown hue:hadoop /user/hue
        $HADOOP_HOME/bin/hadoop fs -chmod 755 /user/hue

        echo "Initializing hive..."
        /bin/bash  /opt/apache-hive/bin/init-hive-dfs.sh

        echo "Starting HIVESERVER.."
        $HIVE_HOME/bin/hive --service hiveserver2 &

        echo "Creating user tables.."
        for file in `/bin/ls /opt/hive/scripts/*.sql`; do 
           echo "Running script file named: $file"
           $HIVE_HOME/bin/hive -f "$file"
	    done

        echo "Starting YARN."
        /bin/bash /opt/hadoop/sbin/start-yarn.sh

        echo "Starting webhttp hadoop service..."
        /bin/bash /opt/hadoop/bin/hdfs httpfs &
    fi

fi
# To prevent containers exit
tail -F /opt/hadoop/logs/*.log
