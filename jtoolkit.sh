#!/bin/bash
# 工具箱入口
# @author: qufengfu@gmail.com

show_menu(){
 echo "欢迎使用JToolkit,本工具箱提供以下问题的排查辅助:"
 echo "1.CPU工具"
 echo "2.内存工具"
 echo "3.Swap工具"
 echo "4.磁盘工具"
 echo "5.网络工具"
 echo "6.JVM工具"
 echo "7.GC工具"
 echo "8.硬件信息"
 echo "9.其他工具安装"
 echo "q.退出"
 echo ""
}

echo "      ___   _________   ________   ________   ___        ___  __     ___   _________     "
echo "     |\  \ |\___   ___\|\   __  \ |\   __  \ |\  \      |\  \|\  \  |\  \ |\___   ___\   "
echo "     \ \  \ |___ \  \_|\ \  \|\  \  \  \|\  \  \  \     \ \  \/  /|_\ \  \ |___ \  \_|   "
echo "   __ \ \  \    \ \  \  \ \  \ \  \  \  \ \  \  \  \     \ \   ___  \  \  \    \ \  \    "
echo "  |\   \_\  \    \ \  \  \ \  \ \  \  \  \ \  \  \  \____ \ \  \  \  \  \  \    \ \  \   "
echo "  \ \________\    \ \__\  \ \_______\  \_______\  \_______ \ \__\  \__\  \__\    \ \__\  "
echo "   \|________|     \|__|   \|_______| \|_______| \|_______| \|__| \|__| \|__|     \|__|  "
echo "                                                                                         "

show_menu

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

if [ "$num" == 'q' ];then
  echo "Goodbye"
  exit
elif [ "$num" == '1' ];then
  mod="cpu"
elif [ "$num" == '2' ];then
   mod="memory"
elif [ "$num" == '3' ];then
  mod="swap"
elif [ "$num" == '4' ];then
  mod="disk"
elif [ "$num" == '5' ];then
  mod="net"
elif [ "$num" == '6' ];then
  mod="jvm"
elif [ "$num" == '7' ];then
  mod="gc"
elif [ "$num" == '8' ];then
  mod="hardware"
elif [ "$num" == '9' ];then
  mod="tools"
fi

if [ ! -d "$mod" ]; then
  sudo mkdir $mod
fi
cd $mod
if [ ! -f "sub_menu.sh" ]; then
  echo "正在下载$mod/sub_menu.sh"
  sudo wget --no-check-certificate --no-cache https://raw.githubusercontent.com/fengfu/jtoolkit/master/$mod/sub_menu.sh >> /dev/null 2>&1
fi
source ./sub_menu.sh
