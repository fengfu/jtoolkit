#!/bin/bash
# Load工具箱入口
# @author: qufengfu@gmail.com

shell_file = "show-busy-java-threads"

#如果文件不存在，先下载文件
if [ ! -f "$shell_file" ]; then
  wget https://raw.github.com/oldratlee/useful-scripts/release/show-busy-java-threads && chmod +x show-busy-java-threads
fi

sudo ./show-busy-java-threads
