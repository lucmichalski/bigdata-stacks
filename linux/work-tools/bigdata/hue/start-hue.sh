#! /usr/bin/env bash


# File Name    : start-hue.sh
# Author       : AlanDing
# Created Time : Sat 14 Dec 2019 05:10:47 PM CST
# Description  : 




docker run -it -p 8888:8888 --name=hue \
  -v $PWD/hue/desktop/conf/hue.ini:/usr/share/hue/desktop/conf/z-hue.ini \
  gethue/hue:latest
