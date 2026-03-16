#!/bin/bash
# 工具箱入口
# @author: qufengfu@gmail.com

echo "1.查看端口是否占用"
echo "2.查看端口连接情况"
echo "3.查看端口占用进程"
echo "4.端口抓包"
echo "0.返回上级菜单"
echo "q.退出"
echo ""

has_unzip(){
  if ! [ -x "$(command -v unzip)" ]; then
    echo 'false'
  else
    echo 'true'
  fi
}

has_command(){
  if ! [ -x "$(command -v $1)" ]; then
    echo 'false'
  else
    echo 'true'
  fi
}

read -p "请输入功能序号:" num

if [[ $num == 'q' ]]; then
  echo "Goodbye"
elif [ $num -eq '0' ];then
  cd ..
  source ./jtoolkit.sh
elif [ $num -eq '1' ];then


  source ./sub_menu.sh
fi
