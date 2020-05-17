#! /usr/bin/env bash

dep_pkg=$(pwd)/boot-sav_4ppa65_all.deb

sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt-get update
sudo dpkg -i "$dep_pkg"

sudo apt-get install -y boot-repair && boot-repair


#--------------------------------------------------------------------------------
# grub.cfg的文件位置　/boot/grub/grub.cfg
#--------------------------------------------------------------------------------

