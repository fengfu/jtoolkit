#!/bin/bash
# GC工具箱入口
# @author: qufengfu@gmail.com

function get_json_value(){
  local json=$1
  local key=$2

  if [[ -z "$3" ]]; then
    local num=1
  else
    local num=$3
  fi

  local value=$(echo "${json}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'${key}'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p)

  echo ${value}
}

echo ""
echo ">>>>>>>>>>GC工具<<<<<<<<<<"
echo "1.使用gceasy.io分析gc.log"
echo "0.返回上级菜单"
echo "q.退出"
echo ""

read -p "请输入:" num

if [[ "$num" == 'q' ]]; then
  echo "Goodbye"
elif [[ "$num" == '0' ]]; then
  cd ..
  source ./jtoolkit.sh
elif [ "$num" == '1' ];then
  read -p "请输入gc.log文件全路径:" gc_file

  if [[ -n "$gc_file" ]]; then
    if [ ! -f "$gc_file" ]; then
      echo "$gc_file文件不存在"
    else
      result=`curl -X POST --data-binary @$gc_file https://api.gceasy.io/analyzeGC?apiKey=9c4dc240-d620-4e4c-8369-ef4d6e5c6019 --header "Content-Type:text"`
      url=`get_json_value $result graphURL`
      if [[ $url == 'http'* ]]; then
        echo "分析完毕，请将后面的URL粘贴到浏览器查看分析结果\n$url"
      else
        echo "无法获取分析结果:\n$result"
      fi
    fi
  fi

  source ./sub_menu.sh
fi
