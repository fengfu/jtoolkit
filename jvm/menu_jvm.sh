#!/bin/bash
# JVM工具箱入口
# @author: qufengfu@gmail.com

echo ""
echo ">>>>>>>>>>JVM工具箱<<<<<<<<<<"
echo "1.JVM参数检查"
echo "2.JVM参数建议"
echo "0.返回上级菜单"
echo "q.退出"
echo ""
read -p "请输入:" num

is_number(){
  regex='^[0-9]+$'
  if ! [[ $1 =~ $regex ]] ; then
    echo "false"
  else
    echo "true"
  fi
}

if [[ $num = 'q' ]]; then
  echo "Goodbye"
elif [[ $num -eq '0' ]]; then
  cd ..
  source ./jtoolkit.sh
elif [ $num -eq '1' ];then
  if [ ! -f "jvm_option_check.sh" ]; then
    echo "正在下载jvm_option_check.sh......"
    sudo wget --no-check-certificate --no-cache https://raw.githubusercontent.com/fengfu/jtoolkit/master/jvm/jvm_option_check.sh >> /dev/null 2>&1
  fi
  sh jvm_option_check.sh

  #在当前进程执行
  source ./menu_jvm.sh
elif [ $num -eq '2' ];then
  echo "关闭Swap"
fi
