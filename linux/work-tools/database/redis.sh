#! /usr/bin/env bash


# File Name    : extools/tools/database/redis.sh
# Author       : AlanDing
# Created Time : Sat 20 Jul 2019 01:40:29 AM CST
# Description  : 


sudo apt-get -y install redis-server
cp -r /mnt/fun+downloads/my-Dotfile/linux/alan-root/etc/redis/redis.conf /etc/redis
sudo /etc/init.d/redis-server restart
