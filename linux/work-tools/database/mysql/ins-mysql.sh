#! /usr/bin/env bash


# File Name    : extools/lang-install/mysql.sh
# Author       : AlanDing
# Created Time : Thu 18 Jul 2019 10:59:00 PM CST
# Description  : 


sudo apt-get install libjson-perl mecab-ipadic-utf8 libmecab2 libaio1 

cd /mnt/fun+downloads/linux系统安装/code-software/system-util/database/mysql || return
dpkg -i ./*.deb

cd /mnt/fun+downloads/linux系统安装/code-software/system-util/database/mysql/mysql-server_8.0.16 || return
dpkg -i ./*.deb

# 配置mysql-workbench中文
sudo cp -rf "$(dirname $0)/main_menu.xml" "/usr/share/mysql-workbench/data/main_menu.xml"
