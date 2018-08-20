# 关于JToolkit #
![JToolkit](https://farm2.staticflickr.com/1818/43432185524_a2f20ef41e_o.png)
JToolkit是一个Java问题排查的工具集，通过集成各种Linux命令、Shell脚本、Java命令，以及各种第三方好用的工具，通过傻瓜式的界面和方便快捷的操作来帮助我们快速定位问题。目前已经集成了唯品会的 [VjTop](https://github.com/vipshop/vjtools/tree/master/vjtop)、[Async-Profiler](https://github.com/jvm-profiling-tools/async-profiler)。

# 包含的功能 #
## 1.CPU/LOAD问题分析 ##
1. 显示Java线程栈的CPU时间占比
2. 线程CPU时间占比排行(VJTop)
3. 生成火焰图(10分钟)
4. 生成飞行记录JFR(10分钟)

## 2.GC问题分析 ##
1. FullGC时间久
2. FullGC不断
3. FullGC频繁
4. YoungGC时间久
5. 远程分析gc.log

## 3.Swap问题 ##
1. 统计各进程Swap使用情况
2. 关闭Swap

## 4.内存问题 ##
1. 堆内存使用情况
2. 对象实例统计Top10
3. dump堆内存

## 5.JVM参数 ##
1. JVM参数检查
2. JVM参数生成

# 使用说明 #
## 1.copy脚本 ##
在有写入权限的目录下执行以下脚本即可：
```
mkdir jtoolkit && cd jtoolkit && wget --no-cache --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/jtoolkit.sh && source jtoolkit.sh
```

## 2.运行SecureCRT Script ##
使用SecureCRT的同学可以下载[run_jtoolkit.py](http://fengfu.io/attach/run_jtoolkit.py)文件到自己的机器上，通过[Script]-[Run]功能运行此下载的文件。

另外，某些脚本需要sudo权限，所以请确保您在运行的服务器上已经申请到了sudo权限。

# 反馈 #
欢迎移步https://github.com/fengfu/jtoolkit/issues 拍砖~
