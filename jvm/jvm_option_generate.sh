#!/bin/bash
# JVM参数生成
# @author: qufengfu@gmail.com

is_number(){
  regex='^[0-9]+$'
  if ! [[ $1 =~ $regex ]] ; then
    echo "false"
  else
    echo "true"
  fi
}

#获取操作系统位数
bit=`getconf LONG_BIT`

#获取物理内存数,KB
mem=`cat /proc/meminfo|grep MemTotal|awk '{print $2}'`

mem_g=`echo "scale=0; $mem*1024/1000000000"|bc -l`

#获取JVM version
vm_version=`java -version 2>&1 | awk -F '"' '/version/ {print $2}'`
#获取大版本
vers=(${vm_version//./ })

ver_major=${vers[1]}

java_opts=""

#xms,xms
xmx=""
if [[ $mem_g -gt '8' ]]; then
  xmx=`echo "scale=0; $mem_g*2/3*1024"|bc -l`
elif [[ $mem_g -eq '8' ]]; then
  xmx="5440"
elif [[ $mem_g -eq '4' ]]; then
  xmx="2688"
elif [[ $mem_g -eq '2' ]]; then
  xmx="1024"
elif [[ $mem_g -eq '1' ]]; then
  xmx="512"
fi
xms_opt="-Xms${xmx}m"
xmx_opt="-Xmx${xmx}m"

perm_size_opt=""
maxperm_size_opt=""
extra_opts=""
xmn_opt=""
if [[ $ver_major -le '7' ]]; then
  perm_size_opt="-XX:PermSize=128m"
  maxperm_size_opt="-XX:MaxPermSize=256m"
  extra_opts="$extra_opts -XX:+PrintGCCause"
else
  perm_size_opt="-XX:MetaspaceSize=128m"
  maxperm_size_opt="-XX:MaxMetaspaceSize=256m"
  xmn="echo "scale=0; $xmx*1/3*1024"|bc -l"
  xmn_opt="-Xmn${xmn}m"
fi

java_opts="$xms_opt $xmx_opt $xmn_opt $perm_size_opt $maxperm_size_opt"

#32位系统加上-server参数
if [[ $bits -eq '32' ]]; then
  extra_opts = "$extra_opts -server"
fi

java_opts="$java_opts $extra_opts"

#gc
java_opts="$java_opts -verbose:gc -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Xloggc:$CATALINA_BASE/logs/gc.log"

echo "您的服务器内核为$bits位,内存${mem_g}G,JDK版本:${vm_version},建议JVM参数:"
printf java_opts
