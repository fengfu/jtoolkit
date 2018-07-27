#!/bin/bash
# 工具箱入口
# @author: qufengfu@gmail.com

echo "1.统计Swap使用情况"
echo "2.关闭Swap"
echo "0.返回上级菜单"
read -p "请输入:" num

if [ $num -eq '1' ];then
  echo "执行show_swap_processes.sh..."
  sh show_swap_processes.sh
elif [ $num -eq '2' ];then
  echo "关闭Swap"
fi
