#! /usr/bin/env bash

mydotfile=/tmp/my-Dotfile


echo "=================================================================="
printf "\n\n"
echo "======================== 开始安装 ================================"

[ ! -x "git" ] && sudo apt-install git

rm -rf $mydotfile && \
    git clone git@github.com:alanding1989/my-Dotfile.git $mydotfile && \
    cd $mydotfile || return

if [ ! -d "$mydotfile/log" ]; then
  mkdir "$mydotfile/log"
fi

bash "$mydotfile/linux/ubuntu-setup.sh" | tee "$mydotfile/log/install-log.txt"


if ! $?; then
  printf "\n\n"
  echo "=========================== 安装完成！ ==============================="
  printf "\n"
  echo "安装记录保存在$mydotfile/log/install-log.txt文件中。"
else
  echo "========================= 安装发生错误！=============================="
fi
