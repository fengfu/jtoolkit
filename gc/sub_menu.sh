#!/bin/bash
# GC工具箱入口
# @author: qufengfu@gmail.com

has_command(){
  if ! [ -x "$(command -v $1)" ]; then
    echo 'false'
  else
    echo 'true'
  fi
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
      echo "正在上传文件进行分析，请稍候......"
      result=$(curl -sX POST --data-binary @$gc_file https://api.gceasy.io/analyzeGC?apiKey=9c4dc240-d620-4e4c-8369-ef4d6e5c6019 --header "Content-Type:text")
      if [[ -n "$result" ]]; then
        if [ ! -f "jq" ]; then
          #获取操作系统位数
          bit=`getconf LONG_BIT`
          sudo wget --no-check-certificate http://fengfu.io/attach/jq/jq-linux$bit >> /dev/null 2>&1
          sudo mv jq-linux$bit jq && sudo chmod +x jq
        fi
        if [ ! -f "jq" ]; then
          printf "找不到jq工具，无法解析分析结果，请将结果中的graphURL的地址粘贴到浏览器中查看结果"
          echo $result
        else
          url=`echo $result|./jq .graphURL`
          if [[ ! -n "$url" ]]; then
            printf "无法通过jq解析分析结果，请将结果中的graphURL的地址粘贴到浏览器中查看结果\n"
            echo $result
          else
            printf "分析结束，请将后面的URL粘贴到浏览器查看分析结果\n"
            echo $url
          fi
        fi
      else
        echo "分析失败，无法获取分析结果，请检查gceasy.io是否能正常访问"
      fi
    fi
  fi

  source ./sub_menu.sh
fi
