#! /usr/bin/env bash


# File Name    : linux/work-tools/docker/rabbitmq/rabbitmq-docker.sh
# Author       : AlanDing
# Created Time : Mon 18 Nov 2019 03:55:40 PM CST
# Description  :


docker run -dit --name rabbitmq-01 -p 5672:5672 -p 15672:15672 --restart=always rabbitmq:3-management

