#!/bin/bash
# 工具箱入口
# @author: qufengfu@gmail.com

echo "      ___   _________   ________   ________   ___        ___  __     ___   _________     "
echo "     |\  \ |\___   ___\|\   __  \ |\   __  \ |\  \      |\  \|\  \  |\  \ |\___   ___\   "
echo "     \ \  \ |___ \  \_|\ \  \|\  \  \  \|\  \  \  \     \ \  \/  /|_\ \  \ |___ \  \_|   "
echo "   __ \ \  \    \ \  \  \ \  \ \  \  \  \ \  \  \  \     \ \   ___  \  \  \    \ \  \    "
echo "  |\   \_\  \    \ \  \  \ \  \ \  \  \  \ \  \  \  \____ \ \  \  \  \  \  \    \ \  \   "
echo "  \ \________\    \ \__\  \ \_______\  \_______\  \_______ \ \__\  \__\  \__\    \ \__\  "
echo "   \|________|     \|__|   \|_______| \|_______| \|_______| \|__| \|__| \|__|     \|__|  "
echo "                                                                                         "

echo "欢迎使用Linux开发工具箱,本工具箱提供以下问题的排查辅助:"
echo "1.Load高"
echo "2.GC问题"
echo "3.Swap高"
echo "4.JVM参数检查"
echo "5.工具安装"
echo "0.退出"

read -p "请输入选项编号:" num
echo "您的选择是:" $num

if [ $num -eq '1' ];then
  if [ ! -f "load/menu_load.sh" ]; then
    mkdir load && cd load
    wget http://gitlab.corp.qunar.com/fengfu.qu/jtoolkit/raw/master/load/menu_load.sh
  fi
  sh menu_load.sh
elif [ $num -eq '2' ];then
  sh GC_index.sh
elif [ $num -eq '3' ];then
  sh Swap_index.sh

elif [ $num -eq '4' ];then
  echo "敬请期待..."
elif [ $num -eq '5' ];then
  sh Tools_index.sh
elif [ $num -eq '0' ];then
  echo "Goodbye"
fi
