#!/bin/bash
# JVM工具箱入口
# @author: qufengfu@gmail.com

echo ">>>>>>>>>>JVM工具箱<<<<<<<<<<"
echo ""
echo "1.JVM参数检查"
echo "2.JVM参数建议"
echo "0.返回上级菜单"
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

if [[ $num -eq '0' ]]; then
  cd ..
  source ./jtoolkit.sh
elif [ $num -eq '1' ];then
  read -p "请输入PID或进程路径关键字:" process

  is_num=`is_number $process`
  if [[ $is_num -eq 'false' ]]; then
    #根据进程关键字获取pid
    pid=`ps aux |grep "java"|grep "$process"|grep -v "grep"|awk '{ print $2}'`
  else
    pid=process
  fi

  #获取启动进程的用户名
  user=`ps aux | awk -v PID=$pid '$2 == PID { print $1 }'`

  #获取VM.options
  vm_line=`sudo -u $user jcmd $pid VM.command_line|grep jvm_args`

  #获取VM.version
  vm_version=`sudo -u $user jcmd $pid VM.option|grep JDK`

  #在当前进程执行
  source ./menu_swap.sh
elif [ $num -eq '2' ];then
  echo "关闭Swap"
fi
