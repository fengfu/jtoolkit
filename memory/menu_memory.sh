#!/bin/bash
# 内存工具箱入口
# @author: qufengfu@gmail.com

echo ""
echo ">>>>>>>>>>内存工具箱<<<<<<<<<<"
echo "1.堆内存使用情况"
echo "2.对象实例统计"
echo "3.dump堆内存"
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

if [ $num -eq '1' ];then
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

  echo "sudo -u $user jmap -heap $pid"
  sudo -u $user jmap -heap $pid

  #在当前进程执行
  source ./menu_memory.sh
elif [ $num -eq '2' ];then
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

  echo "sudo -u $user jmap -histo:live $pid"
  sudo -u $user jmap -histo:live $pid

  source ./menu_memory.sh
elif [ $num -eq '3' ];then

  read -p "请输入PID或进程路径关键字:" process

  is_num=`is_number $process`
  if [[ $is_num -eq 'false' ]]; then
    #根据进程关键字获取pid
    pid=`ps aux |grep "java"|grep "$process"|grep -v "grep"|awk '{ print $2}'`
  else
    pid=process
  fi

  fname="/tmp/hsperfdata_$user/dump_$pid.bin"

  #获取启动进程的用户名
  user=`ps aux | awk -v PID=$pid '$2 == PID { print $1 }'`

  echo "正在执行sudo -u $user jmap -F -dump:format=b,file=$fname $pid导出堆内存..."
  sudo -u $user jmap -F -dump:format=b,file=$fname $pid

  if [ -f "$fname" ]; then
    sudo -u $user gzip $fname
    if [ -f "$fname.gz" ]; then
      echo "堆内存已导出,路径为:$fname.gz"
    else
      echo "堆内存已导出,路径为:$fname"
    fi
  fi

  source ./menu_memory.sh
elif [[ $num -eq '0' ]]; then
  cd ..
  source ./jtoolkit.sh
fi
