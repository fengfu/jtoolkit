# jtoolkit
Java问题排查工具集，通过集成各种第三方好用的工具来帮助我们快速定位问题

# 包含的功能 #
## CPU相关 ##
1. 显示Java线程栈的CPU时间占比
2. 线程CPU时间占比排行(VJTop)
3. 生成火焰图(10分钟)
4. 生成飞行记录JFR(10分钟)
## GC相关 ##
1. FullGC时间久
2. FullGC不断
3. FullGC频繁
4. YoungGC时间久
5. 远程分析gc.log
## Swap相关 ##
1. 统计各进程Swap使用情况
2. 关闭Swap
## 内存相关 ##
1. 堆内存使用情况
2. 对象实例统计Top10
3. dump堆内存
## JVM参数 ##
1. JVM参数检查
2. JVM参数建议

### 使用说明 ###

在有写入权限的目录下执行以下脚本即可：
```
mkdir jtoolkit && cd jtoolkit && wget --no-cache --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/jtoolkit.sh && source jtoolkit.sh
```
