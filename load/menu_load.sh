#!/bin/bash
# Load工具箱入口
# @author: qufengfu@gmail.com

echo "1.显示Java线程栈的CPU时间占比"
echo "2.线程CPU时间占比排行(VJTop)"
echo "3.生成火焰图(10分钟)"
echo "4.生成飞行记录JFR(10分钟)"
echo "0.返回上级菜单"
read -p "请输入:" num

if [ $num -eq '1' ];then

elif [ $num -eq '2' ];then
  #statements
elif [ $num -eq '3' ];then
  #statements
elif [ $num -eq '4' ];then
  #statements
elif [ $num -eq '0' ];then
  sh menu_load.sh
fi
