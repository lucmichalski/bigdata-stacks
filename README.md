# Docker apache

This is a project created to build a apache large data cluster.

The services provided include but not limited to **hadoop** **hbase** **kafka** and **zookeeper**.

You can run this software on linux or windows or mac, recommending use of x86_64 linux platforms.

## Dependencies

git version 1.8.3.1 or higher

docker version 17.09.0-ce or higher

docker-compose version 1.16.1 or higher

## Get installed
    
    $ git clone https://github.com/yinfuyuan/docker-bigdata.git

## Services

You can start all services like this:

    #docker-compose up -d

You can start some of the services you need like this:

    #docker-compose up -d SERVICE1 SERVICE2
    
example:

    #docker-compose up -d zookeeper1 zookeeper2 zookeeper3 hbase1 hbase2 hbase3
    
You can also start them using yam files like this:

    #docker-compose [-f docker-compose-SERVICE.yml] up -d
    
example:

    #docker-compose -f docker-compose-zookeeper.yml up -d
    #docker-compose -f docker-compose-hbase.yml up -d
    
The command above started the zookeeper and hbase service cluster,you can use
a browser to enter the host machine ip and 16010 port to view hbase status.
    
All images have been built and in the dockerhub, you can directly download to use, 
but if you use yml file start for the first time and you don't have local image, 
docker will try to build them not to download, It may waste your time.
If this is not what you want, try starting after manually removing the build option from yml file.

### zookeeper
    
    The service from the zookeeper official image
    version 3.4.12
    image：https://hub.docker.com/_/zookeeper/
    Dockerfile：https://github.com/31z4/zookeeper-docker/blob/0e558d7a6df4031a6be7c1df4ba1e2367666d004/3.4.12/Dockerfile
    
### hadoop
    
    The service from the hadoop image, if you use docker-compose-hadoop.yml for the first time,it automatically builds the image.
    You can comment out the build option to direct to use image.
    version 2.7.6
    image：https://hub.docker.com/r/yinfuyuan/hadoop/
    Dockerfile：https://github.com/yinfuyuan/docker-bigdata/blob/master/services/hadoop/2.7/Dockerfile
    
    After you up the service you can use the host machine ip:50070 view the
    hdfs and use the host machine ip:8088 view yarn
    
    Environment Variables
    HADOOP_MASTER
    HDFS_MASTER
    YARN_MASTER
    HISTORY_MASTER
    HDFS_FS_DEFAULTFS
    HDFS_SLAVES
    HDFS_DFS_REPLICATION
    HDFS_DFS_NAMENODE_SECONDARY_HTTP_ADDRESS
    YARN_RESOURCEMANAGER_HOSTNAME
    
### hbase
    
**The service depends on zookeeper service, Start the zookeeper service before starting.**

    The service from the hbase image, if you use docker-compose-hbase.yml for the first time,it automatically builds the image.
    You can comment out the build option to direct to use image.
    version 2.0.0
    image：https://hub.docker.com/r/yinfuyuan/hbase/
    Dockerfile：https://github.com/yinfuyuan/docker-bigdata/blob/master/services/hbase/2.0/Dockerfile
    
    After you up the service you can use the host machine ip:16010 view the hbase.
    
### kafka
    
**The service depends on zookeeper service, Start the zookeeper service before starting.**
    
    The service from the kafak image, if you use docker-compose-kafka.yml for the first time,it automatically builds the image.
    You can comment out the build option to direct to use image.
    version 1.1.0
    image：https://hub.docker.com/r/yinfuyuan/kafka/
    Dockerfile：https://github.com/yinfuyuan/docker-bigdata/blob/master/services/kafka/Dockerfile