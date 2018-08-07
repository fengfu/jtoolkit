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

echo "欢迎使用JToolkit,本工具箱提供以下问题的排查辅助:"
echo "1.Load高"
echo "2.GC问题"
echo "3.Swap高"
echo "4.内存分析"
echo "5.JVM参数"
echo "6.工具安装"
echo "0.退出"
echo ""

#默认父目录为/home/q
home="/home/q"
if [ ! -d $home ]; then
  home="/usr/local"
fi
cd $home
#在指定的home目录下创建jtoolkit目录
if [ ! -d "jtoolkit" ]; then
  sudo mkdir jtoolkit
fi
cd jtoolkit
if [ ! -f "jtoolkit.sh" ]; then
  sudo wget --no-check-certificate --no-cache https://raw.githubusercontent.com/fengfu/jtoolkit/master/jtoolkit.sh >> /dev/null 2>&1
  sudo chmod +x jtoolkit.sh >> /dev/null 2>&1
fi

read -p "请输入选项编号:" num
#echo "您的选择是:" $num

if [ $num -eq '0' ];then
  echo "Goodbye"
  exit
elif [ $num -eq '1' ];then
  mod="load"
elif [ $num -eq '2' ];then
  mod="gc"
elif [ $num -eq '3' ];then
  mod="swap"
elif [ $num -eq '4' ];then
  mod="memory"
elif [ $num -eq '5' ];then
  mod="jvm"
elif [ $num -eq '6' ];then
  mod="tools"
fi

if [ ! -d "$mod" ]; then
  sudo mkdir $mod
fi
cd $mod
if [ ! -f "menu_$mod.sh" ]; then
  sudo wget --no-check-certificate --no-cache https://raw.githubusercontent.com/fengfu/jtoolkit/master/$mod/menu_$mod.sh >> /dev/null 2>&1
else
  cd $mod
fi
source ./menu_$mod.sh
