#!/bin/bash
# GC工具箱入口
# @author: qufengfu@gmail.com

echo ""
echo "1.FullGC时间久"
echo "2.FullGC不断"
echo "3.FullGC频繁"
echo "4.YoungGC时间久"
echo "5.远程分析gc.log"
echo "0.返回上级菜单"
echo ""

read -p "请输入:" num

if [[ $num -eq '0' ]]; then
  cd ..
  source ./jtoolkit.sh
elif [ $num -eq '1' ];then
  echo "开发中,敬请期待......"
elif [ $num -eq '2' ];then
  echo "开发中,敬请期待......"
elif [ $num -eq '3' ];then
  echo "开发中,敬请期待......"
elif [ $num -eq '4' ];then
  echo "开发中,敬请期待......"
elif [ $num -eq '5' ];then
  echo "开发中,敬请期待......"
fi
