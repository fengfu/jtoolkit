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
echo ""

#在/home/q目录下创建jtoolkit目录
cd /home/q
if [ ! -d "jtoolkit" ]; then
  sudo mkdir jtoolkit
fi
cd jtoolkit
if [ ! -f "jtoolkit.sh" ]; then
  sudo wget --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/jtoolkit.sh >> /dev/null 2>&1
  sudo chmod +x jtoolkit.sh >> /dev/null 2>&1
fi

read -p "请输入选项编号:" num
#echo "您的选择是:" $num

if [ $num -eq '1' ];then
  if [ ! -d "load" ]; then
    sudo mkdir load
  fi
  cd load
  if [ ! -f "menu_load.sh" ]; then
    sudo wget --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/load/menu_load.sh >> /dev/null 2>&1
  fi
  source menu_load.sh
elif [ $num -eq '2' ];then
  cd gc
  source ./menu_gc.sh
elif [ $num -eq '3' ];then
  if [ ! -d "swap" ]; then
    sudo mkdir swap
  fi
  cd swap
  if [ ! -f "menu_swap.sh" ]; then
    sudo wget --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/swap/menu_swap.sh >> /dev/null 2>&1
  else
    cd swap
  fi
  source ./menu_swap.sh

elif [ $num -eq '4' ];then
  echo "敬请期待..."
elif [ $num -eq '5' ];then
  if [ ! -d "tools" ]; then
    sudo mkdir tools
  fi
  cd tools
  source ./menu_tools.sh
elif [ $num -eq '0' ];then
  echo "Goodbye"
fi
