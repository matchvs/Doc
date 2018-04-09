## 创建gameServer

准备条件 ：

- Matchvs 官网账号，如果没有，可以前往[Matchvs官网](http://www.matchvs.com/vsRegister)进行注册

- 在官网控制台创建了游戏，如果未创建，可以前往[控制台](http://www.matchvs.com/manage)创建游戏

成功创建游戏后，点击gameServer，即可进入gameServer列表页。

![](http://imgs.matchvs.com/static/gs_creategs.png)

点击创建gameServer，填写基本信息，创建成功后获取gameServer的相关信息。

![](http://imgs.matchvs.com/static/gs_createsuc1.png)

或者也可以使用命令行工具查询gameServer相关信息：

登录的账号密码为在Matchvs官网注册的账号密码。

```shell
$ matchvs login
$ matchvs list
		=========================No. 1 =========================
        GS ID:           92
        Game ID:         201078
        GS name:         demo-gs
        GS key:          f350a464668e797916423c7b490ea33c
        GS secret:       7tWFyIsILxq9lTxzSV+Jtg==
        Port:            30092
        Git:             ssh://git@192.168.8.5:22/f350a464668e797916423c7b490ea33c.git
        Version:         6
        Create time:     2018-01-03T01:46:51+08:00
```

然后将代码仓库克隆到本地：

```shell
$ git clone ssh://git@192.168.8.5:22/f350a464668e797916423c7b490ea33c.git demo-gs
```

## 下载 gameServer框架

前往[下载中心](http://www.matchvs.com/serviceDownload)即可下载对应语言版本的gameServer框架。将js gameServer 框架代码复制到上一步clone下来的demo-gs目录。

## 基本配置

配置文件路径为`demo-gs/conf/config.json`，其中包含以下默认配置项：

- addr：gameServer服务监听地址。IP一般默认为“0.0.0.0”即可，不建议修改。端口号可以从matchvs命令行工具（使用`matchvs list 或 matchvs info`）或者官网查询到，该端口号由系统在创建gameServer时分配以保证全局唯一性。**每个gameServer只能使用系统分配的端口号，否则发布上线后将无法正常提供服务。**

- log：日志配置。gameServer_nodejs使用[log4js](https://www.npmjs.com/package/log4js)作为日志管理框架，如需自定义log输出可在了解log4js的前提下自行修改配置文件。

端口和ID在gameServer详情页：

![](http://imgs.matchvs.com/static/gs_detailbu.png)



![](http://imgs.matchvs.com/static/gs_detail.png)


修改配置文件`gameServer/conf/config.json`，`addr`端口修改为上一步中查询到的端口：

```json
"addr": "0.0.0.0:30098"
```
## 本地开发调试

开发者可以进入项目目录执行以下命令在本地启动gameServer服务：

```shell
$ npm install 
$ node main.js
```

npm相关资料可前往[npm文档](https://www.npmjs.com.cn/)了解。

本地搭建项目时，`npm install`失败或进度慢,可尝试使用`cnpm install`。

`npm install`和`cnpm install`混用时报错,建议删除`node_modules`, 重新使用一种方式安装。

为了方便开发者在开发过程中快速调试和定位问题，matchvs命令行工具提供了本地调试模式：

```shell
$ matchvs debug <GS_key>
```

当开启本地调试模式后，Matchvs引擎会将测试环境中所有客户端的请求转到开发者本地服务，开发者无须提交代码即可在本地调试代码。

如果想要退出调试，在Matchvs命令行终端输入`quit`回车即可。如果本地尚未安装[Node.js](https://nodejs.org)，请前往官网下载安装最新LTS版本。

gameServer的开发请参考[接入指南](http://www.matchvs.com/service?page=guideJSgameServer)。

gameServer是服务端框架，客户端SDK的使用请参考对应接入指南。

## 上传gameServer代码

在本地调试成功后，即可将代码上传至Matchvs服务器。代码须上传至gameServer对应的git仓库，仓库地址在gameServer详情页里有展示。上传的文件内容：

![](http://imgs.matchvs.com/static/gameserverJSupload.png)

上传后，服务器会自动编译代码，如果出现以下内容说明上传成功：

![](http://imgs.matchvs.com/static/gs_buildsuc.png)

**注意：** 上传后服务器会自动下载服务器会自动下载依赖，故在上传时可将`node_modules`添加至`.gitignore`。

## 正式环境启动服务

代码上传并编译成功后即可启动服务，Matchvs提供了两种服务启动方式：[命令行工具](http://www.matchvs.com/service?page=gameServerCommand)和控制台。控制台启动方式如下：

进入“我的游戏”页面，将游戏发布上线 ：

![](http://imgs.matchvs.com/static/gs_publish.png)

进入“gameServer”页面，启动 gameServer：

![](http://imgs.matchvs.com/static/gs_webstart.png)

也可以通过命令行工具发布、启停：

```shell
$ matchvs publish <GS_key>
$ matchvs run stop <GS_key>
$ matchvs run start <GS_key>
```

- **publish**，发布gameServer到Matchvs私有docker镜像仓库。Matchvs服务端收到publish命令后会执行以下操作：
  - 读取gameServer配置，拉取git仓库到编译目录；
  - 进入gameServer目录执行`make image`。
- **stop/start**，控制gameServer启停。需要注意的是，stop命令将完全中断gameServer服务，由此可能对正式环境中的在线用户产生影响。如需不间断服务更新，请使用restart命令。

**Makefile**和**Dockerfile**，这两个文件定义了gameServer项目的编译发布规则，开发者不能修改。

## 资源监控和日志

在正式环境下启动gameServer后，即可进入gameServer详情页查看资源监控和日志等信息。

您可以在日志页面查看最近200行日志，或者选择下载最近n行日志。
