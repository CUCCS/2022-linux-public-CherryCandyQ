# 基于主流Linux发行版本初次体验

**第一次实验作业**
****
### 1.实验环境

----

- Virtualbox
  - 苹果 M1 用户可以使用任意桌面虚拟化解决方案，例如 UTM
- Ubuntu 20.04 Server 64bit
- 阿里云 云起实验室 提供的【零门槛云上实践平台】
  - 备用场景资源一
  - 备用场景资源二

----
### 2.实验问题
----
#### 调查并记录实验环境的如下信息：
- 当前 Linux 发行版基本信息
- 当前 Linux 内核版本信息
- Virtualbox 安装完 Ubuntu 之后新添加的网卡如何实现系统开机自动启用和自动获取 IP？
- 如何使用 scp 在「虚拟机和宿主机之间」、「本机和远程 Linux 系统之间」传输文件？
- 如何配置 SSH 免密登录？
----

### 3.实验过程
----

#### 一、Linux发行版基本信息

- lsb_release [参数]
   
  lsb是Linux Standard Base的缩写，lsb_release命令用来显示lsb和特定版本的相关信息。如果使用该命令时不带参数，则默认加上-v参数。
  具体有：
    |  后缀 | 功能 |
    |-------|-------|
    | -i  | 显示系统名称简写 |
    |-d	|显示系统全称和版本号|
    |-r|显示版本号|
    |-a|显示LSB所有信息|

  - 采用代码：
    ```
    lsb_release -a
    ```

    这个命令适用于所有的Linux发行版，包括Redhat、SuSE、Debian等发行版。
    - CentOS:
    
    
    
    ![2](/chap0x01/img1/1-c-hostnamectl.png)
    
    - Ubuntu:



    ![2](/chap0x01/img1/1-u-lsb.png)

- cat/etc/[命令]

  查看etc文件夹下的信息,etc一般存放整个文件系统的配置文件。
  一般分为以下几个：

  - 采用代码：
    ```
    cat/etc/issue
    ```
    - CentOS:


   ![2](/chap0x01/img1/1-c-issue.png)
   
    - Ubuntu:


   ![2](/chap0x01/img1/1-u-issue.png)  

  - 采用代码：
    ```
    cat/etc/os-release
    ```
    - CentOS:


   ![2](/chap0x01/img1/1-c-os.png)
   
   
    - Ubuntu:
   ![2](/chap0x01/img1/1-u-os.png) 

  - 采用代码：
    ```
    cat/etc/*release*
    ```
    - CentOS:


    ![2](/chap0x01/img1/1-c-release.png)
    
    - Ubuntu：


    ![2](/chap0x01/img1/1-u-release.png)

  - 采用代码：
    ```
    cat/etc/redhat-release
    ```
    - CentOS:


   ![2](/chap0x01/img1/1-c-redhat.png)

  - *利用`ls -l /etc/*release*`命令对比Ubuntu和CentOS的区别:*


    ![2](/chap0x01/img1/1-compare.png)
    

- hostnamectl
  - 采用代码：
    ```
    hostnamectl 
    ```
    - CentOS:


    ![2](/chap0x01/img1/1-c-hostnamectl.png)
    
    - Ubuntu：


    ![2](/chap0x01/img1/1-u-hostnamectl.png) 
  


#### 二、当前 Linux 内核版本信息

- uname[参数]
用于显示系统相关信息，比如主机名、内核版本号、硬件架构等

  - 采用代码：
    ```
    uname -a
    ```
    - CentOS:



    ![2](/chap0x01/img1/2-c-uname-a.png)
    
    - Ubuntu：


    ![2](/chap0x01/img1/2-u-uname-a.png) 

  - 采用代码：
    ```
    uname -r
    ```
    - CentOS:


    ![2](/chap0x01/img1/2-c-uname-r.png)
    
    - Ubuntu：


    ![2](/chap0x01/img1/2-u-uname-r.png) 

  - 采用代码：
    ```
    uname -s            *只显示内核名称*
    uname -v            *只显示内核版本*
    ```
- cat /pro/version
  - 采用代码：
    ```
    cat /pro/version
    ```
    - CentOS:


    ![2](/chap0x01/img1/2-c-version.png)
    
    
    - Ubuntu：


    ![2](/chap0x01/img1/2-u-version.png) 


#### 三、Virtualbox 安装完 Ubuntu 之后新添加的网卡如何实现系统开机自动启用和自动获取 IP

首先Netplan默认配置文件在/etc/netplan目录下。
- 采用代码：
  ```
  ls /etc/netplan/
  ```

就可以看到配置文件名称。


![2](/chap0x01/img1/3-netplan.png)

查看现在的网卡使用情况。
- 采用代码
  ```
  ip -a
  ```
  
可以看到现在虚拟机启动了两片网卡，分别为enp0s3和enp0s8，并且虚拟机可以自动获取两片网卡的ip。


![2](/chap0x01/img1/3-ip.png)

创建一个新的网卡，把网络设为“仅主机”。


![2](/chap0x01/img1/3-create.png)

再次检查网卡，发现新添加的网卡（enp0s9）虽然已经启动，但是没有获取ip地址。


![2](/chap0x01/img1/3-check.png)

使用vim打开打开文件00-installer-config.yaml
- 采用代码：
  ```
  sudo vim /etc/netplan/00-installer-config.yaml
  ```

可以看到文件里面网卡enp0s3和enp0s8有参数dhcp4: true，说明这两张网卡网卡开启了dhch地址分配，enp0s9虽然已经启用，但是没有出现在文件里。


![2](/chap0x01/img1/3-filecheck.png)

手动输入`enp0s9: dhcp4: true`


![2](/chap0x01/img1/3-fileadd.png)

输入`wq`保存并退出。
- 采用代码：
  ```
  sudo netplan apply
  ```

使改变生效。此时再查看网卡使用情况，enp0s9正常运行。


![2](/chap0x01/img1/3-apply.png)

#### 四、使用 scp 在「虚拟机和宿主机之间」、「本机和远程 Linux 系统之间」传输文件

##### 虚拟机和宿主机之间（运用cmd)
  
- 从虚拟机传输给主机
  - 在虚拟机上创建文件viper并保存。
    - 采用代码：
      ```
      touch viper   *创建viper文件*
      ls     *显示文件夹下所有文件和目录的详细资料*
      pwd   *查看当前所在工作目录*
      cat viper     
      echo "Be careful,I'm viper." > viper  *对viper文件输入语句*
      cat viper       *检查语句是否输入*
      ```

    ![2](/chap0x01/img1/4-cmd-create.png)
    
  - 利用scp命令将viper文件传输到d盘。
    - 采用代码：
      ```
      scp cuc@192.168.56.101:/home/cuc/viper ./
      ```
    
    
    ![2](/chap0x01/img1/4-cmd-scpviper.png)
    
  - 然后输入密码，显示传输完毕。打开d盘目录发现对应文件。


    ![2](/chap0x01/img1/4-cmd-vipercheck.png)

- 从主机传输给虚拟机文件
  - 先查看虚拟机上的文件,确认现在虚拟机上没有desktop.ini文件，再查看宿主机的desktop.ini文件是否存在。
    - 采用代码：
      ```
      ls -la
      ls -i desktop.ini
      ls
      ```
      

    ![2](/chap0x01/img1/4-cmd-checkUbuntu.png)
  
  
    ![2](/chap0x01/img1/4-cmd-checkdesktop.png)

  - 利用scp命令复制到虚拟机的默认文件夹下。
    - 采用代码：
      ```
      scp desktop.ini cuc@192.168.56.101:/home/cuc/
      ```
    
    ![2](/chap0x01/img1/4-cmd-scpdesktop.png)
    
  - 使用代码`ls`查看虚拟机的desktop.ini文件，发现存在。


    ![2](/chap0x01/img1/4-cmd-desktopinicheck.png)

##### 本机和远程 Linux 系统之间(运用git-bash)
- 从CentOS上传输到本机。
  - 在虚拟机中建立test-dir文件夹，创建两个文件并查询路径。
    - 采用代码：
      ```
      mkdir test-dir
      ls
      cd test-dir
      ls
      touch 123
      touch abcd
      ls -l
      pwd
      ```
      

    ![2](/chap0x01/img1/4-bash-create.png)

  - 利用scp命令将两个文件复制到本机。
    - 采用代码：
      ```
      scp -r root@101.133.139.2:/root/test-dir ./
      ```

    ![2](/chap0x01/img1/4-bash-scpdown.png)
  - 输入密码后,检查本地有文件。


    ![2](/chap0x01/img1/4-bash-checkdown.png)

- 从本机传递文件夹到CentOS
  - 从虚拟机中删除test-dir文件夹，并检查删除是否成功。
    - 采用代码：
      ```
      rm -rf test-dir
      ls
      ```


    ![2](/chap0x01/img1/4-bash-delete.png)
  - 利用scp命令将文件夹传输到CentOS上。
    - 采用代码：
      ```
      scp -r test-dir/ root@101.133.139.2:/root/
      ```

    ![2](/chap0x01/img1/4-bash-scpup.png)

  - 输入密码后用`ls`查看：


    ![2](/chap0x01/img1/4-bash-checkup.png)

#### 五、配置 SSH 免密登录
利用git-bash生成公钥。
- 采用代码：
  ```
  ssh-keygen -t rsa
  ```

![2](/chap0x01/img1/5-createkey.png)

在本地的.ssh文件夹里查看，有id_rsa（私钥）和id_rsa.pub（公钥）两个文件


![2](/chap0x01/img1/5-sshfilecheck.png)

将公钥拷到虚拟机的目录下。
- 采用代码：
```
ssh-copy-id cuc@192.168.56.101
```

![2](/chap0x01/img1/5-copykey.png)
再次登录便不需要输入密码，完成免密配置。


![2](/chap0x01/img1/5-login.png)

---------- 
### 4.实验问题与解决方案

--------------
- 显示或设置网络设备时，利用`ifconfig`命令无法实现查询。


![2](/chap0x01/img1/error-3-ifconfig.png)
  - 原因：从 Ubuntu 20.04 开始，查看主机 IP 地址使用 `ip a`，不支持使用`ifconfig`。
  - 解决方法：使用`ip a` 

- 修改文件00-installer-config.yaml的内容后，并未实现相应变化。
  - 原因：在退出文件时使用了`q!`，没有保存修改的文件内容。
  - 解决方法：使用`wq`


![2](/chap0x01/img1/error-3-wq.png)
----------------------------
### 5.引用文献
- https://blog.csdn.net/qq_31278903/article/details/83146031

- https://www.jianshu.com/p/2b2a7955a8ef

- https://blog.csdn.net/weixin_39529128/article/details/111116405

- https://blog.csdn.net/xiongyangg/article/details/110206220

- https://www.cnblogs.com/sunshc/p/10875400.html#:~:text=Linux%E4%B8%AD%E9%80%80%E5%87%BA%E7%BC%96%E8%BE%91%E6%A8%A1%E5%BC%8F%E7%9A%84%E5%91%BD%E4%BB%A4%201%201.vim%20%E6%96%87%E4%BB%B6%E5%90%8D%20%E8%BF%9B%E5%85%A5%E4%B8%80%E8%88%AC%E6%A8%A1%E5%BC%8F%EF%BC%9B%202%202.%E6%8C%89%20i,%E8%BF%9B%E5%85%A5%E6%8C%87%E4%BB%A4%E5%88%97%E5%91%BD%E4%BB%A4%E6%A8%A1%E5%BC%8F%20%EF%BC%9B%205%201.%E4%BF%9D%E5%AD%98%E4%B8%8D%E9%80%80%E5%87%BA%EF%BC%9A%206%202.%E4%BF%9D%E5%AD%98%E5%B9%B6%E9%80%80%E5%87%BA%EF%BC%9A%207%203.%E4%B8%8D%E4%BF%9D%E5%AD%98%E5%B9%B6%E9%80%80%E5%87%BA%EF%BC%9A

- https://blog.csdn.net/qq_32224047/article/details/112799362

- https://blog.csdn.net/qq_15903671/article/details/113252158

- https://blog.csdn.net/jeikerxiao/article/details/84105529
