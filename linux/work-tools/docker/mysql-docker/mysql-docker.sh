#! /usr/bin/env bash


# File Name    : run-docker.sh
# Author       : AlanDing
# Created Time : Mon 21 Oct 2019 08:24:41 PM CST
# Description  :


if [ $1 == '' ]; then
  # -rm 如果已经存在同名容器则删除
  # --restart=always 容器和docker守护进程一起启动
  docker run -dit --name mysql-latest -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root --restart=always mysql:latest
elif [ $1 == '5' ]; then
  docker run -dit --name mysql-5.7 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root --restart=always mysql:5.7
else
  echo 'invalid version args'
fi

