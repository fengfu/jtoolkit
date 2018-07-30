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
    sudo mkdir load && cd load
    sudo wget --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/load/menu_load.sh
  fi
  sh menu_load.sh
elif [ $num -eq '2' ];then
  cd gc
  sh menu_gc.sh
elif [ $num -eq '3' ];then
  if [ ! -f "swap/menu_swap.sh" ]; then
    sudo mkdir swap && cd swap
    sudo wget --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/swap/menu_swap.sh
  fi
  cd swap
  sh menu_swap.sh

elif [ $num -eq '4' ];then
  echo "敬请期待..."
elif [ $num -eq '5' ];then
  cd tools
  sh menu_tools.sh
elif [ $num -eq '0' ];then
  echo "Goodbye"
fi
