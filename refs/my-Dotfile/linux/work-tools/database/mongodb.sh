#! /usr/bin/env bash


# File Name    : extools/tools/database/mongodb.sh
# Author       : AlanDing
# Created Time : Fri 19 Jul 2019 11:57:39 PM CST
# Description  : 

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

cp -r /mnt/fun+downloads/my-Dotfile/linux/alan-root/etc/mongod.conf /etc

print "开两个终端创建数据库，然后设置开机启动守护进程"

#每次运行都要开启服务器，要指定数据库地址且数据库地址文件夹要先创建好
# mongod --port 27017 --dbpath /home/alanding/software/database/mongodb

# 开机自启守护进程
# systemctl enable mongod.service

