## [中文说明](https://github.com/fengfu/jtoolkit/blob/master/README_CN.md) ##
# About JToolkit #
![JToolkit](https://farm2.staticflickr.com/1818/43432185524_a2f20ef41e_o.png)

JToolkit is a tool set for Java troubleshooting. It integrates various Linux commands, Shell scripts, Java commands, and various third-party useful tools to help us quickly locate problems through a fool-like interface and convenient operations. Currently, [VjTop](https://github.com/vipshop/vjtools/tree/master/vjtop), [Async-Profiler](https://github.com/jvm-profiling-tools) of Vipshop has been integrated /async-profiler).

# Features included #
## 1.CPU/LOAD issues analysis ##
1. Display the percentage of CPU time in the Java thread stack
2. Thread CPU time percentage ranking (VJTop)
3. Generate flame graph (10 minutes)
4. Generate flight record JFR (10 minutes)

## 2.GC issues analysis ##
1. Long FullGC time
2. FullGC keeps
3. FullGC is frequent
4. Long time for YoungGC
5. Remote analysis of gc.log

## 3.Swap issues analysis ##
1. Statistics on the Swap usage of each process
2. Close Swap

## 4. Memory issues analysis ##
1. Heap memory usage
2. Top 10 object instance statistics
3. Dump heap memory

## 5.JVM parameters ##
1. JVM parameter check
2. JVM parameter generation

# Instructions for use #
## 1.copy script ##
Execute the following script in a directory with write permission:
```
mkdir jtoolkit && cd jtoolkit && wget --no-cache --no-check-certificate https://raw.githubusercontent.com/fengfu/jtoolkit/master/jtoolkit.sh && source jtoolkit.sh
```

## 2. Run SecureCRT Script ##
Students who use SecureCRT can download the [run_jtoolkit.py](http://fengfu.io/attach/run_jtoolkit.py) file to their own machine, and run the downloaded file through the [Script]-[Run] function.

In addition, some scripts require sudo permissions, so please make sure you have applied for sudo permissions on the running server.

# Feedback #
Welcome to https://github.com/fengfu/jtoolkit/issues to make a brick~