Linux(Ubuntu)下安装和部署 - 《书云(BookStack)使用手册》 - 书云网(bookoco.com)               

[书云(BookStack)使用手册](/books/help "书云(BookStack)使用手册")

Linux(Ubuntu)下安装和部署
===================

*   [ubuntu下部署](#ubuntu下部署)
    *   [安装宝塔控制面板(非必须)](#安装宝塔控制面板(非必须))
    *   [安装中文字体（非必须，但是建议安装）](#安装中文字体（非必须，但是建议安装）)
    *   [安装calibre](#安装calibre)
        *   [测试](#测试)
    *   [安装Chrome](#安装Chrome)
    *   [安装supervisor](#安装supervisor)
    *   [部署程序](#部署程序)
        *   [下载Linux版的程序](#下载Linux版的程序)
        *   [在本地解压，修改配置文件](#在本地解压，修改配置文件)
            *   [配置数据库和文档导出项](#配置数据库和文档导出项)
            *   [配置OSS](#配置OSS)
            *   [配置第三方登录](#配置第三方登录)
        *   [上传和部署](#上传和部署)
    *   [加入系统守护进行](#加入系统守护进行)
    *   [默认管理员账号和密码](#默认管理员账号和密码)
    *   [总结](#总结)
        

ubuntu下部署
=========

安装宝塔控制面板(非必须)
-------------

> 如果你已经有lnmp环境了，则不需要安装。

宝塔官网：[http://www.bt.cn](http://www.bt.cn)

安装命令：

1.  `wget -O install.sh http://download.bt.cn/install/install-ubuntu.sh && sudo bash install.sh`

安装完宝塔控制面板之后，登录面板，安装”lnmp”（Linux、Nginx、MySQL、PHP）

> 安装默认的即可

安装宝塔面板，主要是为了方便管理站点，如反向代理、SSL等

安装中文字体（非必须，但是建议安装）
------------------

有的Linux服务器并没有支持中文字体，需要手动安装。  
地址：[http://www.hc-cms.com/thread-41-1-1.html](http://www.hc-cms.com/thread-41-1-1.html)

安装命令：

1.  `apt install ttf-wqy-zenhei`
2.  `apt install fonts-wqy-microhei`

安装中文字体支持，主要是为了避免Linux系统不支持中文的时候，导致导出文档的时候出现乱码。

安装calibre
---------

calibre官网：[https://www.calibre-ebook.com/](https://www.calibre-ebook.com/)

安装命令：

1.  `sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"`

执行下面命令，能看到版本号，表示安装成功。

1.  `ebook-convert --version`

注意：

*   这里要安装最新版的calibre，执行上述命令，安装的就是最新版的了。
*   如果出现`warning`的提示，直接不用理会即可;`error`级别的提示，网上搜下看下如何解决

`calibre`主要用于将文档导出生成pdf、epub、mobi文档。

本人已经使用Go语言对calibre导出pdf、epub、mobi文档进行了一层封装，欢迎大家给个star ==》[https://github.com/TruthHun/converter](https://github.com/TruthHun/converter)

### 测试

随便创建一个txt文件

1.  `echo "Hello BookStack。你好，书云。"  > test.txt`

转成pdf

1.  `ebook-convert test.txt test.pdf`

查看测试的转化效果，主要看下转化的过程中有没有报错，以及转化后的文档有没有出现中文乱码。

安装Chrome
--------

直接使用命令一键安装：

1.  `apt install chromium-browser`

执行以下命令，如果能打印百度页面代码，则表示安装成功。

1.  `chromium-browser --headless --disable-gpu --dump-dom --no-sandbox https://www.baidu.com`

这个主要用于在发布文档的时候，渲染未被渲染的markdown文档，以及`强力模式`下的网页采集。

安装supervisor
------------

安装命令：

1.  `apt install supervisor`

判断是否安装成功:

1.  `supervisord --version`

显示版本号，即表示安装成功。

`supervisor`主要用于将程序加入到系统守护进程

`Supervisord` 安装完成后有两个可用的命令行 supervisord 和 supervisorctl，命令使用解释如下：

*   supervisord，初始启动 Supervisord，启动、管理配置中设置的进程。
*   supervisorctl stop programxxx，停止某一个进程(programxxx)，programxxx 为 \[program:beepkg\] 里配置的值，这个示例就是 beepkg。
*   supervisorctl start programxxx，启动某个进程
*   supervisorctl restart programxxx，重启某个进程
*   supervisorctl stop groupworker: ，重启所有属于名为 groupworker 这个分组的进程(start,restart 同理)
*   supervisorctl stop all，停止全部进程，注：start、restart、stop 都不会载入最新的配置文件。
*   supervisorctl reload，载入最新的配置文件，停止原有进程并按新的配置启动、管理所有进程。
*   supervisorctl update，根据最新的配置文件，启动新配置或有改动的进程，配置没有改动的进程不会受影响而重启。

部署程序
----

### 下载Linux版的程序

[https://github.com/TruthHun/BookStack/releases](https://github.com/TruthHun/BookStack/releases)

### 在本地解压，修改配置文件

配置文件在`conf`目录。

#### 配置数据库和文档导出项

把`app.conf.example`命名为`app.conf`,并根据提示，修改配置。这里主要修改MySQL数据库的配置以及生成下载文档的配置。其他项能不改就不改。

1.  `# 程序名称`
2.  `appname =  BookStack`

4.  `# 程序版本`
5.  `version = v1.0.0`

7.  `# 监听端口`
8.  `httpport =  8181`

10.  `# 运行模式。开发时，请设置为开发模式"dev"，即development；部署时，请设置为产品模式"prod"，即product。dev模式下，会打印各种调试信息`
11.  `runmode = dev`

13.  `# 是否开启session，这个必须开启，否则没法玩了。`
14.  `sessionon =  true`

16.  `# session名称，这个你自己定。`
17.  `sessionname = bookstack`
18.  `copyrequestbody =  true`

20.  `# 启动gzip压缩，则设置为true，否则设置为false。建议启动`
21.  `EnableGzip=true`

23.  `# 要压缩的静态文件扩展名，其中.xml是sitemap站点地图压缩。建议按照这个来就行了`
24.  `StaticExtensionsToGzip  =  .css,  .js,  .xml`

27.  `# 默认Session生成Key的秘钥`
28.  `beegoserversessionkey=bookstack`

30.  `########Session储存方式##############`
31.  `#以文件方式储存`
32.  `sessionprovider=file`
33.  `sessionproviderconfig=store/session`

35.  `# 静态目录。这个是站点地图的静态目录`
36.  `StaticDir  = sitemap:sitemap`

38.  `#生成下载文档的时间间隔。也就是距离用户第一次点击生成下载文档到第二次点击生成下载文档的时间间隔，避免用户频繁点击生成下载文档而导致大量耗费服务器资源导致服务器宕机`
39.  `GenerateInterval=300`

41.  `# 站点可直接访问的静态文件【注意，这里千万不能配置.conf文件扩展名，否则会把.conf文件当做静态文件而被外部访问，导致数据库账号密码等泄露。按照默认的来即可】`
42.  `StaticExt=.txt,.xml,.ico,.png,.jpg,.jpeg,.gif,.html`

44.  `#评论时间间隔，每次发表评论，限定间隔秒数，避免被恶意刷评论`
45.  `CommentInterval=10`

47.  `# 生成下载文档时导出pdf文档的配置，这里建议把关于bookoco.com的信息替换成你自己的就行，其他的建议不要动`
48.  `exportHeader=<p style='color:#8E8E8E;font-size:12px;'>_SECTION_</p>`
49.  `exportFooter=<p style='color:#8E8E8E;font-size:12px;'>本文档使用  <a href='http://www.bookoco.com' style='text-decoration:none;color:#1abc9c;font-weight:bold;'>书云网(bookoco.com)</a> 构建 <span style='float:right'>- _PAGENUM_ -</span></p>`
50.  `exportFontSize=14`
51.  `exportPaperSize=a4`
52.  `exportCreator=书云网(bookoco.com)`
53.  `exportMarginLeft=72`
54.  `exportMarginRight=72`
55.  `exportMarginTop=72`
56.  `exportMarginBottom=72`

58.  `#时区设置`
59.  `timezone =  Asia/Shanghai`

61.  `####################MySQL 数据库配置###########################`
62.  `db_adapter=mysql`

64.  `# 您的数据库host`
65.  `db_host=`

67.  `#您的数据库端口`
68.  `db_port=3306`

70.  `#您的数据库用户名`
71.  `db_username=`

73.  `# 您的数据库密码`
74.  `db_password=`

76.  `#您使用的数据库`
77.  `db_database=bookstack`

81.  `# 静态资源域名，没有则留空。比如你将static目录下的所有静态资源都放到了专门的服务器上，那么这个域名就行用来访问你的静态资源的域名。`
82.  `static_domain=http://static.bookoco.com`

84.  `# 谷歌浏览器，用于发布内容的时候渲染未被渲染的markdown。建议安装最新版的Chrome浏览器，并把Chrome浏览器加入系统环境变量。`
85.  `# 使用Chrome的headless去处理。之前考虑使用phantomjs的，但是phantomjs有些小问题，不如Chrome强大。`
86.  `chrome=chromium-browser`

88.  `#项目默认封面`
89.  `cover=/static/images/book.png`

91.  `#默认头像`
92.  `avatar=/static/images/avatar.png`

94.  `#默认阅读令牌长度`
95.  `token_size=12`

97.  `#上传文件的后缀`
98.  `upload_file_ext=txt|doc|docx|xls|xlsx|ppt|pptx|pdf|7z|rar|jpg|jpeg|png|gif`

100.  `####################邮件配置######################`
101.  `#是否启用邮件`
102.  `enable_mail=true`
103.  `#每小时限制指定邮箱邮件发送次数`
104.  `mail_number=5`
105.  `#smtp服务用户名`
106.  `smtp_user_name=admin@bookoco.com`
107.  `#smtp服务器地址`
108.  `smtp_host=smtpdm.aliyun.com`
109.  `#smtp密码`
110.  `smtp_password=BOOKSTACKi23456789c`
111.  `#端口号`
112.  `smtp_port=25`
113.  `#发送邮件的显示名称`
114.  `form_user_name=admin@bookoco.com`

116.  `#接收回件的邮箱。留空则表示使用发送邮件的邮箱作为接收回件邮箱`
117.  `reply_user_name=bookstack@qq.com`

119.  `#邮件有效期30分钟`
120.  `mail_expired=30`

123.  `################Active Directory/LDAP################`
124.  `#是否启用ldap`
125.  `ldap_enable=false`
126.  `#ldap主机名`
127.  `ldap_host=ad.example.com`
128.  `#ldap端口`
129.  `ldap_port=3268`
130.  `#ldap内哪个属性作为用户名`
131.  `ldap_attribute=sAMAccountName`
132.  `#搜索范围`
133.  `ldap_base=DC=example,DC=com`
134.  `#第一次绑定ldap用户dn`
135.  `ldap_user=CN=ldap helper,OU=example.com,DC=example,DC=com`
136.  `#第一次绑定ldap用户密码`
137.  `ldap_password=superSecret`
138.  `#自动注册用户角色：0 超级管理员 /1 管理员/ 2 普通用户` 
139.  `ldap_user_role=2`
140.  `#ldap搜索filter规则,AD服务器: objectClass=User, openldap服务器: objectClass=posixAccount ,也可以定义为其他属性,如: title=mindoc`
141.  `ldap_filter=objectClass=posixAccount`

144.  `include "oss.conf"`
145.  `include "oauth.conf"`

#### 配置OSS

1、登录你的阿里云，进入OSS，创建一个`只读Bucket`。  
2、在本地随便创建一个txt文档，将下面两行粘贴进去：

1.  `styleName:cover,styleBody:image/resize,m_fill,w_175,h_230,limit_0/auto-orient,1/quality,q_100`
2.  `styleName:avatar,styleBody:image/resize,m_fill,w_100,h_100,limit_0/auto-orient,1/quality,q_90`

3、在OSS的`图片处理`-`导入样式`中，将该txt文档导入  
![](http://static.bookoco.com/projects/help/1516802da0987a00.png)

4、将`oss.conf.example`修改成`oss.conf`，并根据您的阿里云OSS，配置该文件。

1.  `# 阿里云OSS配置`
2.  `[oss]`

4.  `# 是否是内网，如果您的阿里云服务器和OSS是同一内网，请设置为true，这样能更快地将文件移到oss上，否则设置为false。`
5.  `# 一般情况下，在开发阶段，设置为false`
6.  `IsInternal=false`

8.  `# 内网Endpoint,如：oss-cn-hongkong-internal.aliyuncs.com`
9.  `EndpointInternal=`

11.  `# 外网Endpoint，如：oss-cn-hongkong.aliyuncs.com`
12.  `EndpointOuter=`

15.  `# 您的阿里云AccessKeyId`
16.  `AccessKeyId=`

18.  `# 您的阿里云AccessKeySecret`
19.  `AccessKeySecret=`

21.  `# 只读状态的Bucket，不要私有的，也不要公共读写的`
22.  `Bucket=`

24.  `# oss中绑定的域名，如果您没有绑定域名，则使用阿里云oss的自带域名也行`
25.  `Domain=`

#### 配置第三方登录

将`oauth.conf.example`重命名成`oauth.conf`,并根据提示修改配置。

1.  `# 第三方登录配置`
2.  `[oauth]`

4.  `##### Gitee(码云) ####`
5.  `# 申请地址（需要先登录）：https://gitee.com/oauth/applications`

7.  `# 您的ClientId`
8.  `giteeClientId=`

10.  `# 您的ClientSecret`
11.  `giteeClientSecret=`

13.  `# 回调地址，把下面的bookoco.com的域名换成你的即可`
14.  `giteeCallback=http://www.bookoco.com/login/gitee`

16.  `# 下面这两项不要动`
17.  `giteeAccesstoken=https://gitee.com/oauth/token`
18.  `giteeUserInfo=https://gitee.com/api/v5/user`

22.  `######## GitHub ########`
23.  `# 申请地址(需要先登录你的GitHub)：https://github.com/settings/developers`

25.  `# 您的ClientId`
26.  `githubClientId=`

28.  `# 您的ClientSecret`
29.  `githubClientSecret=`

31.  `# 回调地址，把下面的bookoco.com的域名换成你的即可`
32.  `githubCallback=http://www.bookoco.com/login/github`

34.  `# 下面这两项不要动`
35.  `githubAccesstoken=https://github.com/login/oauth/access_token`
36.  `githubUserInfo=https://api.github.com/user`

40.  `#### QQ ####`
41.  `# 申请地址（需要先登录你的QQ）:https://connect.qq.com/manage.html`

43.  `#ClientId，即 APP ID`
44.  `qqClientId=`

46.  `#ClientSecret，即 APP Key`
47.  `qqClientSecret=`

49.  `# 回调地址，把下面的bookoco.com的域名换成你的即可`
50.  `qqCallback=http://www.bookoco.com/login/qq`

52.  `# 下面这三项不要动`
53.  `qqAccesstoken=https://graph.qq.com/oauth2.0/token`
54.  `qqOpenId=https://graph.qq.com/oauth2.0/me`
55.  `qqUserInfo=https://graph.qq.com/user/get_user_info`

57.  `### TODO 微信和微博登录，主要是我这边忘记了以前注册的个人开发者信息，当前没开发，后续会开发出来 ####`

### 上传和部署

1、将修改和配置好了的程序压缩，上传到站点根目录下，解压。  
2、执行数据库安装。程序安装一些站点配置项、SEO项等。命令：

1.  `./BookStack install`

3、配置反向代理  
宝塔面板用户，直接在站点的`设置`里面配置反向代理，但是需要注意的是，需要修改缓存，如把下面两句注释掉：

1.  `add_header X-Cache $upstream_cache_status;`

3.  `expires 12h;`

Nginx反向代理配置参考(宝塔的配置)：

1.  `server`
2.  `{`
3.   `listen 80;`
4.   `server_name demo.bookoco.com;`
5.   `index index.php index.html index.htm default.php default.htm default.html;`
6.   `root /www/wwwroot/demo.bookoco.com;`

9.   `location /` 
10.   `{`
11.   `proxy_pass http://localhost:8181;`
12.   `proxy_set_header Host $host;`
13.   `proxy_set_header X-Real-IP $remote_addr;`
14.   `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;`
15.   `proxy_set_header REMOTE-HOST $remote_addr;`

17.   `#缓存相关配置`
18.   `#proxy_cache cache_one;`
19.   `#proxy_cache_key $host$request_uri$is_args$args;`
20.   `#proxy_cache_valid 200 304 301 302 1h;`

22.   `#持久化连接相关配置`
23.   `#proxy_connect_timeout 30s;`
24.   `#proxy_read_timeout 86400s;`
25.   `#proxy_send_timeout 30s;`
26.   `#proxy_http_version 1.1;`
27.   `#proxy_set_header Upgrade $http_upgrade;`
28.   `#proxy_set_header Connection "upgrade";`
29.   `}`

31.   `location ~  .*\.(php|jsp|cgi|asp|aspx|flv|swf|xml)?$`
32.   `{`
33.   `proxy_set_header Host $host;`
34.   `proxy_set_header X-Real-IP $remote_addr;`
35.   `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;`
36.   `proxy_set_header REMOTE-HOST $remote_addr;`
37.   `proxy_pass http://localhost:8181;`

39.   `}`
40.   `#PROXY-END`

42.   `include enable-php-54.conf;`
43.   `#PHP-INFO-END`

45.   `#REWRITE-START URL重写规则引用,修改后将导致面板设置的伪静态规则失效`
46.   `include /www/server/panel/vhost/rewrite/demo.bookoco.com.conf;`
47.   `#REWRITE-END`

49.   `#禁止访问的文件或目录`
50.   `location ~  ^/(\.user.ini|\.htaccess|\.git|\.svn|\.project|LICENSE|README.md)`
51.   `{`
52.   `return  404;`
53.   `}`

55.   `access_log  off;`
56.  `}`

加入系统守护进行
--------

1、进入supervisor的配置目录

1.  `cd /etc/supervisor/conf.d/`

2、配置守护进程  
创建`bookstack.conf`文件，并配置。

1.  `[program:BookStack]`
2.  `directory =  你的程序目录`
3.  `command =你的程序执行命令`
4.  `autostart =  true`
5.  `autorestart=true`
6.  `user =  启动该程序的用户`
7.  `redirect_stderr =  true`
8.  `stdout_logfile =  日志地址`

配置示例：

1.  `[program:BookStack]`
2.  `directory =  /www/wwwroot/demo.bookoco.com`
3.  `command =/www/wwwroot/demo.bookoco.com/BookStack`
4.  `autostart =  true`
5.  `autorestart=true`
6.  `user = root`
7.  `redirect_stderr =  true`
8.  `stdout_logfile =  /var/log/supervisor/BookStack.log`

配置完成之后，重启supervisor

1.  `supervisorctl reload`

默认管理员账号和密码
----------

> admin  
> admin

总结
--

安装BookStack，需要先配置环境，安装依赖：`Nginx`、`MySQL`、`calibre`、`chorme（chromium-browser）`、`supervisor`，然后修改配置文件，配置MySQL数据库、OSS和第三方登录，然后上传部署和配置反向代理以及加入守护进程。
