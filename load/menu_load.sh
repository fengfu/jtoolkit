#!/bin/bash
# Load工具箱入口
# @author: qufengfu@gmail.com

echo ""
echo ">>>>>>>>>>LOAD工具箱<<<<<<<<<<"
echo "1.显示Java线程栈的CPU时间占比"
echo "2.线程CPU时间占比排行(VJTop)"
echo "3.生成火焰图(10分钟)"
echo "4.生成飞行记录JFR(10分钟)"
echo "0.返回上级菜单"
echo "q.退出"
echo ""

read -p "请输入功能序号:" num

is_number(){
  regex='^[0-9]*$'
  if ! [[ $1 =~ $regex ]] ; then
    echo "false"
  else
    echo "true"
  fi
}

get_core_version(){
  release_version=`uname -r`
  vers=(${release_version//\-/ })
  echo ${vers[0]//./}
}

if [[ $num == 'q' ]]; then
  echo "Goodbye"
elif [ $num -eq '0' ];then
  cd ..
  source ./jtoolkit.sh
elif [ $num -eq '1' ];then

  #如果文件不存在，先下载文件
  if [ ! -f "show_busy_threads_with_percent.sh" ]; then
    echo "正在下载show_busy_threads_with_percent.sh......"
    sudo wget --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/load/show_busy_threads_with_percent.sh >> /dev/null 2>&1
    sudo chmod +x show_busy_threads_with_percent.sh >> /dev/null 2>&1
  fi

  read -p "请输入PID或进程路径关键字(不输入则从所有Java进程中找出最消耗CPU的线程):" process

  if [[ ! -n "$process" ]]; then
    sudo ./show_busy_threads_with_percent.sh
  else
    is_num=`is_number $process`
    if [[ $is_num == 'false' ]]; then
      #根据进程关键字获取pid
      pid=`ps aux |grep "java"|grep "$process"|grep -v "grep"|awk '{ print $2}'`
    else
      pid=`echo $process`
    fi

    sudo ./show_busy_threads_with_percent.sh -p $pid
  fi

  source ./menu_load.sh
elif [ $num -eq '2' ];then
  read -p "请输入PID或进程路径关键字:" process

  if [[ -n "$process" ]]; then
    is_num=`is_number $process`
    if [[ $is_num == 'false' ]]; then
      #根据进程关键字获取pid
      pid=`ps aux |grep "java"|grep "$process"|grep -v "grep"|awk '{ print $2}'`
    else
      pid=`echo $process`
    fi

    #获取启动进程的用户名
    user=`ps aux | awk -v PID=$pid '$2 == PID { print $1 }'`

    #获取用户所在组
    group=`id -gn $user`

    if [ ! -d "vjtop" ]; then
      echo "正在下载vjtop......"
      sudo wget --no-check-certificate http://repo1.maven.org/maven2/com/vip/vjtools/vjtop/1.0.1/vjtop-1.0.1.zip >> /dev/null 2>&1
      sudo unzip vjtop-1.0.1.zip >> /dev/null 2>&1
      sudo rm -f vjtop-1.0.1.zip >> /dev/null 2>&1
      #修改属主
      sudo chown $group.$user -R vjtop >> /dev/null 2>&1
    fi
    cd vjtop
    sudo -u $user ./vjtop.sh $pid
    cd ..
  fi

  source ./menu_load.sh
elif [ $num -eq '3' ];then
  read -p "此功能会小概率导致Java应用Crash,是否继续？[y/n]" yesno
  if [[ $yesno == 'y' ]]; then

    read -p "请输入PID或进程路径关键字:" process

    if [[ -n "$process" ]]; then
      is_num=`is_number $process`
      if [[ $is_num == 'false' ]]; then
        #根据进程关键字获取pid
        pid=`ps aux |grep "java"|grep "$process"|grep -v "grep"|awk '{ print $2}'`
      else
        pid=`echo $process`
      fi

      #获取启动进程的用户名
      user=`ps aux | awk -v PID=$pid '$2 == PID { print $1 }'`

      duration_sec="600"
      read -p "请输入要采样的时间(单位:分钟,默认10分钟,建议5分钟以上):" duration

      if [[ ! -n "$duration" ]]; then
        duration="10"
      else
        is_num=`is_number $duration`
        if [[ $is_num == 'false' ]]; then
          duration="10"
        fi
      fi

      duration_sec=`echo "scale=0; $duration*10"|bc -l`

      if [ ! -d "async-profiler" ]; then
        core_version=`get_core_version`
        if [[ $core_version -gt '2634' ]]; then
          sudo wget --no-check-certificate http://fengfu.io/attach/async-profiler-1.4-linux-x64.tar.gz >> /dev/null 2>&1
          sudo mkdir async-profiler
          sudo tar -xvf async-profiler-1.4-linux-x64.tar.gz -C async-profiler >> /dev/null 2>&1
          sudo rm -f async-profiler-1.4-linux-x64.tar.gz >> /dev/null 2>&1
        else
          sudo wget --no-check-certificate http://fengfu.io/attach/async-profiler-1.4-linux-2.6.34-x64.tar.gz >> /dev/null 2>&1
          sudo mkdir async-profiler
          sudo tar -xvf async-profiler-1.4-linux-2.6.34-x64.tar.gz -C async-profiler >> /dev/null 2>&1
          sudo rm -f async-profiler-1.4-linux-2.6.34-x64.tar.gz >> /dev/null 2>&1
        fi
        #修改属主
        #sudo chown $group.$user -R vjtop >> /dev/null 2>&1
      fi
      cd async-profiler
      fname="/tmp/hsperfdata_$user/flamegraph_$pid.svg"
      echo "正在收集数据,需要等待$duration分钟......"

      sudo ./profiler.sh -d $duration_sec -f $fname $pid

      if [ -f "$fname" ]; then
        echo "火焰图文件已生成,路径为:$fname"
        #TODO:是否使用sz下载？
        echo ""
      else
        echo "采样失败,火焰图文件未生成."
      fi
      cd ..
    fi
  fi

  source ./menu_load.sh
elif [ $num -eq '4' ];then
  read -p "此功能会小概率导致Java应用Crash,是否继续？[y/n]" yesno
  if [[ $yesno == 'y' ]]; then
    read -p "请输入PID或进程路径关键字:" process

    if [[ -n "$process" ]]; then
      is_num=`is_number $process`
      if [[ $is_num == 'false' ]]; then
        #根据进程关键字获取pid
        pid=`ps aux |grep "java"|grep "$process"|grep -v "grep"|awk '{ print $2}'`
      else
        pid=`echo $process`
      fi

      #获取启动进程的用户名
      user=`ps aux | awk -v PID=$pid '$2 == PID { print $1 }'`

      duration_sec="600"
      read -p "请输入要采样的时间(单位:分钟,默认10分钟,建议5分钟以上):" duration

      if [[ ! -n "$duration" ]]; then
        duration="10"
      else
        is_num=`is_number $duration`
        if [[ $is_num == 'false' ]]; then
          duration="10"
        fi
      fi

      duration_sec=`echo "scale=0; $duration*10"|bc -l`

      if [ ! -d "async-profiler" ]; then
        echo "正在下载async-profiler......"

        core_version=`get_core_version`
        if [[ $core_version -gt '2634' ]]; then
          sudo wget --no-check-certificate http://fengfu.io/attach/async-profiler-1.4-linux-x64.tar.gz >> /dev/null 2>&1
          sudo mkdir async-profiler
          sudo tar -xvf async-profiler-1.4-linux-x64.tar.gz -C async-profiler >> /dev/null 2>&1
          sudo rm -f async-profiler-1.4-linux-x64.tar.gz >> /dev/null 2>&1
        else
          sudo wget --no-check-certificate http://fengfu.io/attach/async-profiler-1.4-linux-2.6.34-x64.tar.gz >> /dev/null 2>&1
          sudo mkdir async-profiler
          sudo tar -xvf async-profiler-1.4-linux-2.6.34-x64.tar.gz -C async-profiler >> /dev/null 2>&1
          sudo rm -f async-profiler-1.4-linux-2.6.34-x64.tar.gz >> /dev/null 2>&1
        fi

        #修改属主
        #sudo chown $group.$user -R vjtop >> /dev/null 2>&1
      fi
      cd async-profiler
      fname="/tmp/hsperfdata_$user/jfr_$pid.jfr"
      echo "正在收集数据,需要等待$duration分钟......"

      sudo ./profiler.sh -d $duration_sec -o jfr -f $fname $pid

      if [ -f "$fname" ]; then
        echo "JFR文件已生成,路径为:$fname"
        #TODO:是否使用sz下载？
        echo ""
      else
        echo "采样失败,JFR文件未生成."
      fi
      cd ..
    fi
  fi

  source ./menu_load.sh
fi
