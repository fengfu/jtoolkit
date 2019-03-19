#!/bin/bash
# 工具箱入口
# @author: qufengfu@gmail.com

echo "1.安装阿里Arthas"
echo "0.返回上级菜单"
echo "q.退出"
echo ""

has_unzip(){
  if ! [ -x "$(command -v unzip)" ]; then
    echo 'false'
  else
    echo 'true'
  fi
}

read -p "请输入功能序号:" num

if [[ $num == 'q' ]]; then
  echo "Goodbye"
elif [ $num -eq '0' ];then
  cd ..
  source ./jtoolkit.sh
elif [ $num -eq '1' ];then
  if [ ! -d "arthas" ]; then

    has_it=`has_unzip`
    if [[ $has_it == 'false' ]]; then
      #根据进程关键字获取pid
      sudo yum install unzip -y
    fi
    has_it=`has_unzip`
    if [[ $has_it == 'false' ]]; then
      echo 'unzip未安装，无法解压安装文件，请先安装unzip'
    else
      echo "正在下载arthas......"
      sudo wget --no-check-certificate http://fengfu.io/attach/arthas-packaging-3.0.4-bin.zip >> /dev/null 2>&1
      sudo mkdir arthas
      sudo unzip arthas-packaging-3.0.4-bin.zip -d arthas >> /dev/null 2>&1
      sudo rm -f arthas-packaging-3.0.4-bin.zip >> /dev/null 2>&1

      read -p "请输入Java进程的所属用户:" user

      #获取用户所在组
      group=`id -gn $user`

      #修改属主
      sudo chown $group.$user -R arthas >> /dev/null 2>&1
    fi
  fi
  cd arthas
  sudo -u $group.$user ./install-local.sh

  sudo -u $group.$user ./as.sh

  source ./sub_menu.sh
fi
