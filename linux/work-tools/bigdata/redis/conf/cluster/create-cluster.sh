#! /usr/bin/env bash


# File Name    : /home/alanding/software/bigdata/redis/conf/cluster/create-cluster.sh
# Author       : AlanDing
# Created Time : Thu 05 Mar 2020 09:15:09 PM CST
# Description  : 

redis-cli --cluster create --cluster-replicas 1 \
  192.168.1.102:6379 192.168.1.102:6380 192.168.1.102:6381 192.168.1.102:6391 192.168.1.102:6389 192.168.1.102:6390


# /home/alanding/software/bigdata/redis/src/redis-trib.rb create --replicas 1 \
  # 192.168.1.101:6379 192.168.1.101:6380 192.168.1.101:6381 192.168.1.101:6389 192.168.1.101:6390 192.168.1.101:6391

