# Hadoop cluster 精简版(hadoop & kafka & storm & hbase & phoenix & pig & zookeeper & flume)
使用下面提到的hadoop服务构建一个轻量级的hadoop集群。 这些版本与Hortonworks HDP 2.3.4发行版的版本相匹配。

## Versions
- Alpine Linux: latest
- Debian: 8.3
- Java: Open JDK 7
- hadoop : 2.7.1
- pig: 0.15.0
- Zookeeper: 3.4.6
- Hbase: 1.1.2
- Kafka: 0.9.0.1
- Kafka manager: latest
- Storm: 0.10.0
- Phoenix: 4.7.0
- Flume: 1.6.0

Note: Hadoop和storm建立在Debian Linux和Alpine Linux上的版本上

>Dockerhub: https://hub.docker.com/r/pkeropen3/

## Prerequsities
- Install [Docker](https://docs.docker.com/engine/installation/)
- Install [Docker compose](https://docs.docker.com/compose/install/)

> The Docker project is tested on Ubuntu host. There is no guarantee that this will work on Windows.
> Docker项目在Window和macOS主机上进行了测试. 其中Window的使用docker-machine.

## Building all images
- 从docker hub  Pull镜像 
- OR
- 单独构建每个镜像

>这将单独构建每个镜像。 然后花费一些时间，并且只需要完成一次。

- Get zookeeper IP address using 

``docker inspect --format='{{.NetworkSettings.IPAddress}}' zookeeper``

- Get hbase IP address using 

``docker inspect --format='{{.NetworkSettings.IPAddress}}' hbase``
- Add zookeeper and hbase entries in the host /etc/hosts file

## Verification
- ``docker images`` 查看使用正确的标签版本创建的所有镜像
- ``docker logs -f _CONTAINER_NAME_`` 跟踪特定容器的日志

如果需要修改某个镜像，可以单独修改的构建脚本。构建脚本位于每个镜像目录中。


## Starting

``./start.sh`` (background process)

OR

``docker-compose up``  (foreground process)

## Stopping

``docker-compose stop``


## Web UI
- [HBASE](http://localhost:60010)
- [Storm](http://localhost:49080)
- [Kafka manager](http://localhost:9000)
- [Hadoop cluster](http://localhost:8088)


## Notice

根目录有一个.env文件, 是Window的路径设置.COMPOSE_CONVERT_WINDOWS_PATHS=1, 在Window平台运作docker,不然会报如下错误:

![env-img](/imgs/env_error.jpg)



## READMEs
请通过以下README文档 , 获取有关每个镜像的详细信息

- [Alpine base README](alpine-base/README.md)
- [Debian base README](debian-base/README.md)
- [Hadoop README](hadoop/README.md)
- [Pig README](hadoop/pig/README.md)
- [Zookeeper README](zookeeper/README.md)
- [Hbase README](hbase/README.md)
- [Kafka README](kafka/README.md)
- [Storm README](storm/README.md)
- [Flume README](flume/README.md)

## Reference
- https://hub.docker.com/r/wurstmeister/kafka/
- https://hub.docker.com/r/sheepkiller/kafka-manager/
- https://hub.docker.com/r/wurstmeister/storm/
- https://hub.docker.com/r/sequenceiq/hadoop-ubuntu/
- http://sookocheff.com/post/docker/containerizing-zookeeper-a-guided-tour/
- http://www.slideshare.net/fabiofumarola1/8a-setup-hbase
- https://docs.docker.com/engine/userguide/intro/
- https://docs.docker.com/compose/
- https://phoenix.apache.org/


## Fork Github
 - https://github.com/anair-it/hadoop-docker-lite