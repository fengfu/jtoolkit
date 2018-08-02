#!/bin/bash
# JVM参数合理性检查
# @author: qufengfu@gmail.com

is_number(){
  regex='^[0-9]+$'
  if ! [[ $1 =~ $regex ]] ; then
    echo "false"
  else
    echo "true"
  fi
}


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
vm_version=`sudo -u $user jcmd $pid VM.version|grep JDK|awk '{print $2}'`
#获取大版本
ver=`${vm_version:0:1}`

#idx=`expr index $vm_line "-XX:+DisableExplicitGC"`
result="==========JVM参数建议=========="
if [[ $vm_line = *"-XX:+DisableExplicitGC"* ]]; then
  result="$result请将DisableExplicitGC参数替换为ExplicitGCInvokesConcurrent\n"
fi

#JDK 1.8及以上参数有效性检查
if [[ $ver -ge '8' ]]; then
  if [[ $vm_line = *"-XX:PermSize"* ]]; then
    result="$result\nPermSize已废弃,请替换为MetaspaceSize"
  fi
  if [[ $vm_line = *"-XX:MaxPermSize"* ]]; then
    result="$result\nMaxPermSize已废弃,请替换为MaxMetaspaceSize"
  fi
fi

#获取gc概况
gc_stat=`(sudo -u $user jstat -gcutil $pid | awk 'NR>1 {print $0}')`
ygc="0"
ygct="0"
fgc="0"
fgct="0"
perm_u="0"

perm_u=${gc_stat[4]}
if [[ $ver -ge '8' ]]; then
  ygc=${gc_stat[6]}
  ygct=${gc_stat[7]}
  fgc=${gc_stat[8]}
  fgct=${gc_stat[9]}
else
  ygc=${gc_stat[5]}
  ygct=${gc_stat[6]}
  fgc=${gc_stat[7]}
  fgct=${gc_stat[8]}
fi

if [[ $fgc -gt '0' ]]; then
  fgc_avgt=`bc <<< 'scale=1; $fgct/$fgc'`
  if [[ $fgc_avgt -gt '1' ]]; then
    result="$result\nFullGC平均时间超过1秒,请注意优化."
  fi
fi

printf $result
