#! /usr/bin/env bash


# File Name    : linux/work-tools/docker/docker-restart.sh
# Author       : AlanDing
# Created Time : Mon 02 Dec 2019 02:34:53 PM CST
# Description  : 


systemctl daemon-reload
systemctl restart docker
docker start registry


