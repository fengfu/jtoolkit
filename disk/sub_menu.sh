#!/bin/bash
# disk工具箱入口
# @author: qufengfu@gmail.com

echo ""
echo ">>>>>>>>>>Disk工具箱<<<<<<<<<<"
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

if [[ $num == 'q' ]]; then
  echo "Goodbye"
elif [[ $num -eq '0' ]]; then
  cd ..
  source ./jtoolkit.sh
fi
