#!/bin/bash

if (($#==0))
then
    exit 1;
fi
for i in hadoop102 hadoop103 hadoop104
do
    echo Starting zk in $i
    ssh $i "source /etc/profile && /home/alanding/software/bigdata/zookeeper/bin/zkServer.sh $1" > /dev/null
done
