# Linux命令行使用基础

**第二次实验作业**

------
### 1.实验环境

----

- 当前课程推荐的 Linux 发行版本
    - 本地环境（Ubuntu）
    - 云环境（CentOS）
- 在asciinema注册一个账号，并在本地安装配置好asciinema
- 确保本地已经完成asciinema auth，并在asciinema成功关联了本地账号和在线账号
- 在自己的github仓库上新建markdown格式纯文本文件附上asciinema的分享URL
- 提醒 避免在终端操作录像过程中暴漏密码、个人隐私等任何机密数据
------

### 2.实验问题
----
#### 调查并记录实验环境的如下信息：

- 使用表格方式记录至少 2 个不同 Linux 发行版本上以下信息的获取方法，使用 asciinema 录屏方式「分段」记录相关信息的获取过程和结果
- 【软件包管理】在目标发行版上安装 tmux 和 tshark ；查看这 2 个软件被安装到哪些路径；卸载 tshark ；验证 tshark 卸载结果
- 【文件管理】复制以下 shell 代码到终端运行，在目标 Linux 发行版系统中构造测试数据集，然后回答以下问题：
    - 找到 /tmp 目录及其所有子目录下，文件名包含 666 的所有文件
    - 找到 /tmp 目录及其所有子目录下，文件内容包含 666 的所有文件
    ```
    cd /tmp && for i in $(seq 0 1024);do dir="test-$RANDOM";mkdir "$dir";echo "$RANDOM" > "$dir/$dir-$RANDOM";done
    ```
- 【文件压缩与解压缩】练习课件中 文件压缩与解压缩 一节所有提到的压缩与解压缩命令的使用方法
- 【跟练】 子进程管理实验
- 【硬件信息获取】目标系统的 CPU、内存大小、硬盘数量与硬盘容量

-----

### 3.实验过程
---

#### 一、asciinema安装和录制
查阅官方文档之后，采用代码：
- Ubuntu:
    ```
    sudo apt-add-repository ppa:zanchey/asciinema
    sudo apt-get update
    sudo apt-get install asciinema
    asciinema auth
    asciinema rec
    ```

#### 二、软件包管理

- CentOS:
    - 安装tumx和wireshark/tshark
        ```
        yum install tmux
        yum install wireshark
        ```
    - 查看tmux安装路径
        ```
        rpm -qa|grep tmux
        rpm -ql tmux-1.8-4.el7.x86_64
        ```
    - 查看wiresharke/tshark安装路径
        ```
        rpm -qa|grep wireshark
        rpm -ql wireshark-1.10.14-25.el7.x86_64
        ```
    - 卸载wireshark/tshark并验证
        ```
        yum remove wireshark
        wireshark -v
        rpm -qa|greg wireshark
        ```

    [![asciicast](https://asciinema.org/a/476632.svg)](https://asciinema.org/a/476632)



- Ubuntu:
    - 安装tumx和tshark
        ```
        sudo apt-get install tmux
        sudo apt-get install tshark
        ```
    - 查看tmux和tshark安装路径
        ```
        dpkg -L tmux
        dpkg -L tshark
        ```
    - 卸载tshark并验证
        ```
        sudo apt-get --purge remove tshark
        sudo apt-get autoremove tshark
        dpkg --get-selections|grep tshark
        ps -ef|grep tsahrk
        ```

    [![asciicast](https://asciinema.org/a/476643.svg)](https://asciinema.org/a/476643)



#### 三、文件管理

- CentOS:
    ```
    find ./ -type f -name '*666*'
    grep -r '666' ./
    ```

    [![asciicast](https://asciinema.org/a/478276.svg)](https://asciinema.org/a/478276)

- Ubuntu:
    ```
    sudo find ./ -type f -name '*666*'
    sudo grep -r '666' ./ --exclude=*.cast
    ```

    [![asciicast](https://asciinema.org/a/478273.svg)](https://asciinema.org/a/478273)


#### 四、文件压缩与解压缩

*进程中若出现同样的操作代码（如`ls`)，整理时不再重复叙述。*
- 创建文件：
    ```
    touch purpose
    ls
    pwd
    cat purpose
    echo "hello,world." > purpose
    cat purpose
    ```
    
    ![2](chap0x02/img2/touchpurpose.png)


- CenOS:

    - gzip:
        ```
        yum install gzip
        gzip purpose
        ls
        gzip -d purpose.gz
        ```

    - bzip2:
        ```
        yum install bzip2
        bzip2 purpose
        ls
        bzip2 -d purpose.bz2
        ```

    - zip:
        ```
        yum install zip
        ls
        zip -r text.zip purpose
        yum install unzip
        rm -f purpose
        unzip text.zip
        ```
    - tar:
        ```
        yum install tar
        tar -zcvf log.tar.gz purpose
        ls
        rm -f purpose
        tar -zxvf log.tar.gz
        ```

    - 7zip:
        ```
        yum install -y p7zip p7zip-plugins
        7z a text.7z purpose
        ls
        rm -f purpose
        7z e text.7z
        ```

    - rar:
        ```    
        uname -a
        wget --no-check-certificate https://www.rarlab.com/rar/rarlinux-x64-611.tar.gz
        tar -zxvf rarlinux-x64-611.tar.gz
        cd rar
        make
        cd..
        rar a text.rar purpose
        ls
        rm -f purpose
        rar e text.rar
        ```
    
    [![asciicast](https://asciinema.org/a/477138.svg)](https://asciinema.org/a/477138)

- Ubuntu:

    - gzip:
        ```
        sudo apt-get install gzip
        gzip purpose
        ls
        gzip -d purpose.gz
        ```

    - bzip2:
        ```
        sudo apt-get install bzip2
        bzip2 purpose
        ls
        bzip2 -d purpose.bz2
        ```

    - zip:
        ```
        sudo apt-get install zip
        ls
        zip -r text.zip purpose
        sudo apt-get install unzip
        rm -f purpose
        unzip text.zip
        ```
    - tar:
        ```
        sudo apt-get install tar
        tar -zcvf log.tar.gz purpose
        ls
        rm -f purpose
        tar -zxvf log.tar.gz
        ```

    - 7zip:
        ```
        sudo apt-get install p7zip-full
        7z a text.7z purpose
        ls
        rm -f purpose
        7z e text.7z
        ```

    - rar:
        ```    
        sudo apt-get install rar
        rar a text.rar purpose
        ls
        rm -f purpose
        rar e text.rar
        ```
    
    [![asciicast](https://asciinema.org/a/477172.svg)](https://asciinema.org/a/477172)


#### 四、子进程管理实验跟练

- CentOS:
  
   [![asciicast](https://asciinema.org/a/477542.svg)](https://asciinema.org/a/477542)



- Ubuntu:

    [![asciicast](https://asciinema.org/a/477386.svg)](https://asciinema.org/a/477386)


#### 五、硬件信息获取

- CentOS:
    - CPU:
        ```
        lscpu
        cat /proc/cpuinfo | grep name | cut -f2 -d: |uniq -c
        cat /proc/cpuinfo | grep "physical id" | sort -u | wc -l
        cat /proc/cpuinfo | grep "processor" | wc -l
        cat /proc/cpuinfo | grep "cpu cores" | uniq
        ```
    
    - 内存：
        ```
        free
        cat /proc/meminfo 
        ```
    - 硬盘：
        ```
        df
        df -h
        ```
    [![asciicast](https://asciinema.org/a/477551.svg)](https://asciinema.org/a/477551)


- Ubuntu:
    - CPU:
        ```
        lscpu
        cat /proc/cpuinfo
        ```
    
    - 内存：
        ```
        free
        free -m
        cat /proc/meminfo
        ```
    - 硬盘：
        ```
        dh
        dh -f
        fdisk -l |grep Disk(补充 查看硬盘大小)
        ```
     [![asciicast](https://asciinema.org/a/477563.svg)](https://asciinema.org/a/477563)


--------
### 4.实验问题
-----
#### 一、tshark安装问题
- 问题：
    在CentOS中安装tshark时报错，安装包不存在。
    - 采用代码：
        ```
        yum insatll tshark
        ```

    ![2](chap0x02/img2/error-tsharkinstall.png)


- 解决方法：
    经过搜索后，发现CentOS中在其他的安装包中提供tshark的功能。
    - 采用代码：
        ```
        yum whatprovides *tshark*
        ```

    ![2](chap0x02/img2/error-findtshark.png)

    本次实验中选择安装wireshark安装包。


#### 二、p7zip安装问题
- 问题：
    在采用`yum install p7zip`安装p7zip软件包之后，发现无法使用命令进行压缩。

    ![2](chap0x02/img2/7zipinstall.png)

- 解决方法：
    CentOS安装p7zip-plugins，Ubuntu安装p7zip-full

#### 三、rar安装问题
- 问题：
    在Centos连接下载地址时，出现报错。
    - 采用代码：
        ```
        wget https://www.rarlab.com/rar/rarlinux-x64-611.tar.gz
        ```

    ![2](chap0x02/img2/rarinstall.png)


- 解决方法：
    报错显示链接不安全，所以按照要求，添加`--no-check-certificate`，使用“不检查证书”。


#### 四、文件关键字查询乱码问题
- 问题：
    在Ubuntu中查询tmp目录及子目录下内容含有“666”的文件时，除了目标文件外出现很多带有.cast的乱码文件。

    ![2](chap0x02/img2/cast.png)



- 解决方法：
    因为asciinema录制时，会在当前目录中写入后缀为".cast"的文件，所以产生乱码。
    可以利用`--exclude=*.cast`来排除后缀为".cast"的文件

------
### 5.总结表格

|  | CentOS |Ubuntu|
|-------|-------|-----|
|软件安装 | yum install |sudo apt-get install|
|查看安装路径| `rpm -qa|grep` `rpm -ql`|dpkg -L|
|删除软件|yum remove|sudo apt-get --purge remove|
|文件名查找| find ./ -type f -name ''|sudo find ./ -type f -name ''|
|文件内容查找|grep -r ''|sudo grep -r ''|
|gzip|gzip{filename};gzip -d|gzip{filename};gzip -d|
|bzip2|bzip2{filename};bzip2 -d|bzip2{filename};bzip2 -d|
|zip/unzip|zip {.zip-filename} {filename-to-compress};unzip {.zip-filename}|zip {.zip-filename} {filename-to-compress};unzip {.zip-filename}|
|tar|tar -zcvf {.tgz-file} {filename};tar -zxvf {.tgz-file}|tar -zcvf {.tgz-file} {filename};tar -zxvf {.tgz-file}|
|7zip|7z a {.7z-filename} {filename};7z e {.7z-filename}|7z a {.7z-filename} {filename};7z e {.7z-filename}|
|rar|rar a {.rar-filename} {filename};rar e {.rar-filename}|rar a {.rar-filename} {filename};rar e {.rar-filename}|
|cpu|lscpu;cat /proc/cpuinfo|lscpu;cat /proc/cpuinfo|
|内存|free;cat /proc/meminfo |free;cat /proc/meminfo|
|硬盘|df|df;`fdisk -l |grep Disk`|

------
### 6.参考文献
https://c4pr1c3.github.io/LinuxSysAdmin/chap0x02.md.html#/title-slide

https://www.cnblogs.com/alog9/p/11805716.html

https://www.cnblogs.com/whowhere/p/10550623.html

https://blog.csdn.net/get_set/article/details/51276609

https://www.cnblogs.com/Baron-Lu/p/6991269.html

https://cloud.tencent.com/developer/article/1454847

https://cloud.tencent.com/developer/article/1455822

https://www.jianshu.com/p/5a5f17e4a911

https://www.cnblogs.com/rosesmall/archive/2012/05/08/2490522.html

https://zhuanlan.zhihu.com/p/28423868

https://www.cyberciti.biz/howto/question/general/compress-file-unix-linux-cheat-sheet.php

https://blog.csdn.net/yu876876/article/details/79656422

http://courses.cuc.edu.cn/course/82669/forum#/topics/224452?show_sidebar=false&scrollTo=topic-224452&pageIndex=2&pageCount=3&topicIds=229102,228487,228229,228070,227158,225778,225676,224452,224041,223642&predicate=lastUpdatedDate&reverse