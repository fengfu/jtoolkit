#!/bin/bash
# Swap工具箱入口
# @author: qufengfu@gmail.com

echo ""
echo ">>>>>>>>>>SWAP工具箱<<<<<<<<<<"
echo "1.统计各进程Swap使用情况"
echo "2.关闭Swap"
echo "0.返回上级菜单"
echo "q.退出"
echo ""
read -p "请输入:" num

if [[ $num == 'q' ]]; then
  echo "Goodbye"
elif [[ $num -eq '0' ]]; then
  cd ..
  source ./jtoolkit.sh
elif [ $num -eq '1' ];then
  if [ ! -f "show_swap_processes.sh" ]; then
    echo "正在下载show_swap_processes.sh......"
    wget --no-check-certificate --no-cache https://raw.githubusercontent.com/fengfu/jtoolkit/master/swap/show_swap_processes.sh >> /dev/null 2>&1
  fi
  echo "执行show_swap_processes.sh..."
  sh show_swap_processes.sh

  #在当前进程执行
  source ./sub_menu.sh
elif [ $num -eq '2' ];then
  fname=`cat /proc/swaps|awk -v Type=partition '$2 == Type { print $1 }'`
  read -p "关闭Swap可能会导致进程被OOM Kill,是否继续?[y/n]:" choice
  if [ $num == 'y' ];then
    swapoff $fname
  fi
  source ./sub_menu.sh
fi
