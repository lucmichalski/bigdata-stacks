#! /usr/bin/env bash


# File Name    : web-brower/plugin-list.sh
# Author       : AlanDing
# Created Time : Thu 24 Oct 2019 04:26:44 AM CST
# Description  : 

set -e

declare -a paths=(
"/mnt/fun+downloads/linux系统安装/code-software/lang/nodejs/Chrome插件/better-onetab"
"/mnt/fun+downloads/linux系统安装/code-software/lang/nodejs/Chrome插件/FeHelper"
"/mnt/fun+downloads/linux系统安装/code-software/lang/nodejs/Chrome插件/github-hovercard"
"/mnt/fun+downloads/linux系统安装/code-software/lang/nodejs/Chrome插件/octotree"
"/mnt/fun+downloads/linux系统安装/code-software/lang/nodejs/Chrome插件/Surfingkeys"
)

declare -a repos=(
git@github.com:cnwangjie/better-onetab.git
git@github.com:zxlie/FeHelper.git
git@github.com:Justineo/github-hovercard.git
git@github.com:ovity/octotree.git
git@github.com:brookhong/Surfingkeys.git
)

  
function clone_repo() {
  for repo in "${repos[@]}" ; do
    # 找出路径对应的github仓库地址
    if print $repo | grep -q "$(basename $1)" ; then
      git clone $repo $1
    fi
  done
}


function main() {
  for path in "${paths[@]}" ; do
    if [ ! -d $path ]; then
      clone_repo $path
    fi
    cd $path && npm build
  done
}

main

