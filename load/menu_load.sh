#!/bin/bash
# Load工具箱入口
# @author: qufengfu@gmail.com

echo "1.显示Java线程栈的CPU时间占比"
echo "2.线程CPU时间占比排行(VJTop)"
echo "3.生成火焰图(10分钟)"
echo "4.生成飞行记录JFR(10分钟)"
echo "0.返回上级菜单"
read -p "请输入功能序号:" num

is_number(){
  regex='^[0-9]+$'
  if ! [[ $1 =~ $regex ]] ; then
    echo "false"
  else
    echo "true"
  fi
}

if [ $num -eq '0' ];then
  sh ../jtoolkit.sh
elif [ $num -eq '1' ];then
  #如果文件不存在，先下载文件
  if [ ! -f "show_busy_threads_with_percent.sh" ]; then
    wget --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/load/show_busy_threads_with_percent.sh && chmod +x show_busy_threads_with_percent.sh
  fi

  sudo ./show_busy_threads_with_percent.sh
elif [ $num -eq '2' ];then
  read -p "请输入PID或:进程路径关键字:" process

  is_num=`is_number $process`
  if [[ $is_num -eq 'false' ]]; then
    pid=`ps aux |grep "java"|grep "$process"|grep -v "grep"|awk '{ print $2}'`
  else
    pid=process
  fi

  if [ ! -d "vjtop" ]; then
    wget --no-check-certificate http://repo1.maven.org/maven2/com/vip/vjtools/vjtop/1.0.1/vjtop-1.0.1.zip && unzip vjtop-1.0.1.zip
  fi
  cd vjtop
  ./vjtop.sh $pid
elif [ $num -eq '3' ];then
  echo "敬请期待"
elif [ $num -eq '4' ];then
  echo "敬请期待"
fi
