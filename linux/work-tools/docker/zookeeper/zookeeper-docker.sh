#! /usr/bin/env bash

# File Name    : linux/work-tools/docker/zookeeper/zookeeper-docker.sh
# Author       : AlanDing
# Created Time : Wed 20 Nov 2019 09:20:49 PM CST
# Description  : 


# -it
docker run -dit --name zookee-01 -p 2181:2181 --restart=always zookeeper

