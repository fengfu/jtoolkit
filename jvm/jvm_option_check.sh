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
if [[ ! -n "$process" ]]; then
  return 0
fi

is_num=`is_number $process`
if [[ $is_num == 'false' ]]; then
  #根据进程关键字获取pid
  pid=`ps aux |grep "java"|grep "$process"|grep -v "grep"|awk '{ print $2}'`
else
  pid=`echo $process`
fi

#获取启动进程的用户名
user=`ps aux | awk -v PID=$pid '$2 == PID { print $1 }'`

#获取VM.options
vm_line=`sudo -u $user jcmd $pid VM.command_line|grep jvm_args`

# #获取VM.version
# vm_version=`sudo -u $user jcmd $pid VM.version|grep JDK|awk '{print $2}'`
# #获取大版本
# ver=${vm_version:0:1}

#获取JVM version
vm_version=`java -version 2>&1 | awk -F '"' '/version/ {print $2}'`
#获取大版本
vers=(${vm_version//./ })

ver_major=${vers[1]}
ver_minors=(${vers[2]}//_/ })
ver_minor=${ver_minors[0]}
ver_update=${ver_minors[1]}

#idx=`expr index $vm_line "-XX:+DisableExplicitGC"`
result="==========JVM参数建议=========="
if [[ $vm_line = *"-XX:+DisableExplicitGC"* ]]; then
  result="$result\n请将DisableExplicitGC参数替换为ExplicitGCInvokesConcurrent"
fi

if [[ $vm_line = *"-XX:NativeMemoryTracking=summary"* ]]; then
  result="$result\n开启NativeMemoryTracking会导致JVM性能有5~10%的下降,建议关闭.详情见:https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr007.html"
fi

if [[ $vm_line = *"-XX:NativeMemoryTracking=detail"* ]]; then
  result="$result\n开启NativeMemoryTracking会导致JVM性能有5~10%的下降,建议关闭.详情见:https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr007.html"
fi

has_permSize='0'
has_MetaSpaceSize='0'

if [[ $vm_line = *"-XX:PermSize"* ]]; then
  has_permSize='1'
fi
if [[ $vm_line = *"-XX:MetaspaceSize"* ]]; then
  has_MetaSpaceSize='1'
fi

#JDK 1.8及以上参数有效性检查
if [[ $ver_major -ge '8' ]]; then
  if [[ $has_permSize -eq '1' ]]; then
    result="$result\nPermSize已废弃,请替换为MetaspaceSize"
  fi
  if [[ $vm_line = *"-XX:MaxPermSize"* ]]; then
    result="$result\nMaxPermSize已废弃,请替换为MaxMetaspaceSize"
  fi
fi

#获取gc概况
gc_str=`(sudo -u $user jstat -gcutil $pid | awk 'NR>1 {print $0}')`
gc_stat=($gc_str)
ygc="0"
ygct="0"
fgc="0"
fgct="0"
meta_u="0"

meta_u=${gc_stat[4]}
#检查Metaspace区使用率
meta_result=`echo "$meta_u < 40"|bc -lq`
#perm/metaSpace使用率低于40%,检查是否显示设置了permSize/metaspaceSize
if [[ $meta_result -eq '1' ]]; then
  if [[ $has_permSize -eq '1' ]]; then
    result="$result\nPerm区使用率低于40%%,建议调小Perm区大小"
  fi
  if [[ $has_MetaSpaceSize -eq '1' ]]; then
    result="$result\nMetaSpace使用率低于40%%,建议调小MetaSpace大小"
  fi
fi

#G1相关参数检查
if [[ $vm_line = *"-XX:+UseG1GC"* ]]; then
  #G1 MaxGCPauseMillis
  if [[ $vm_line = *"-XX:MaxGCPauseMillis"* ]]; then
    result="$result\n开启了G1的情况下,建议显示设置MaxGCPauseMillis"
  fi
  #G1中xmn的检查
  if [[ $vm_line = *"-Xmn"* ]]; then
    result="$result\n开启了G1的情况下请去掉-Xmn参数,因为G1会自动调整Young/Old区的大小"
  fi
  if [[ $vm_line = *"-XX:NewSize"* ]]; then
    result="$result\n开启了G1的情况下请去掉-XX:NewSize参数,因为G1会自动调整Young/Old区的大小"
  fi

  if [[ $ver_major -le '7' ]]; then
    result="$result\n您使用了G1,为保证垃圾回收的性能,建议将JDK版本升级到JDK8u40之后"
  elif [[ $ver_update -lt '40' ]]; then
    result="$result\n您使用了G1,为保证垃圾回收的性能,建议将JDK版本升级到JDK8u40之后"
  fi
fi

if [[ $ver_major -ge '8' ]]; then
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

#检查FullGC平均时间
if [[ $fgc -gt '0' ]]; then
  fgc_avgt=`echo "scale=1; $fgct/$fgc"|bc -l`
  fgc_result=`echo "$fgc_avgt > 1"|bc -lq`
  if [[ $fgc_result -eq '1' ]]; then
    result="$result\nFullGC平均时间超过1秒,请注意优化."
  fi
fi

result="$result\n===============================\n"
printf $result
