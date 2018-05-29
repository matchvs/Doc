# Egret中使用Matchvs SDK指引

本文主要讲述如何在Egret中使用MatchvsSDK.

## CHANGELOG

时间：2018.05.29

版本：v1.6.202

```
- 调整微信小游戏适配机制的说明,只需引用matchvs.all.js,不再引用matchvs.all.weixin.js
- 修改本文档的结构. 着重推荐离线安装SDK的方式
```

## Egret 开发环境搭建

### 开发工具下载

1. [下载Egret Engine](http://tool.egret-labs.org/EgretLauncher/EgretLauncher-1.0.49.exe)
2. [下载Egret Wing](http://tool.egret-labs.org/EgretWing/electron/EgretWing-v3.2.6.exe)

### 后台新建游戏

1. 使用Matchvs游戏云需要AppKey、AppSecret，与Cocos的AppID、AppSecret并不相同，需进入Matchvs官网创建游戏获取。[进入官网](http://www.matchvs.com/manage/gameContentList/)
2. 登陆官网，点击右上角控制台进入，若没有Matchvs官网账号。[立即注册](http://www.matchvs.com/vsRegister)
3. 进入控制台，点击新建游戏，填写《游戏名称》即可，新建成功如下：![](http://imgs.matchvs.com/static/2_2.png)





## 离线安装SDK(推荐 * )

适合wing3.6.2 以上

#### 1)  下载TypeScript版本的SDK

下载TypeScript版本的SDK,[下载链接](http://www.matchvs.com/serviceDownload),[下载链接](http://www.matchvs.com/serviceDownload)

#### 2) 解压缩SDK

得到matchvs目录到Egret工程目录的同级目录下, 加压后检查目录下是否存在如下3个文件

1. matchvs.d.ts
2. matchvs.js
3. matchvs.min.js

#### 3) 引用SDK

  配置Egert工程,引用SDK.编辑工程目录下的 `egretProperties.json` 文件,增加如下代码以引用SDK

```

    {
      "name": "matchvs",
      "path": "../matchvs"
    }
```

完成示例如下:

```javascript
{
  "engineVersion": "5.1.5",
  "compilerVersion": "5.1.5",
  "template": {},
  "target": {
    "current": "web"
  },
  "eui": {
    "exmlRoot": [
      "resource/eui_skins"
    ],
    "themes": [
      "resource/default.thm.json"
    ],
    "exmlPublishPolicy": "commonjs"
  },
  "modules": [
    {
      "name": "egret"
    },
    {
      "name": "eui"
    },
    {
      "name": "assetsmanager"
    },
    {
      "name": "tween"
    },
    {
      "name": "game"
    },
    {
      "name": "promise"
    },
    {
      "name": "socket"
    },
    {
      "name": "matchvs",
      "path": "../matchvs"
    }
  ]
}

```
#### 4) 使用

clean并build,生成Egret项目库依赖,就可以在Egret中使用Matchvs SDK 了,具体使用方式可参考[Eget Demo](http://www.matchvs.com/serviceCourse) 



## 在线安装SDK

在线安装Matchvs Egret 插件 (适合wing3.6.2 以下)

- 前往[下载中心](http://www.matchvs.com/serviceDownload)下载白鹭插件  

- 离线安装   

  **注意 :** 插件仅适用于wing3.6.2及以下支持插件的版本;  文末注有 wing3.6.2 以上使用 MatchvsSDK 的方法

​        拖动 matchvs-1.0.0.wext 到 wing 中，wing 的消息通知栏会提示安装成功，重启wing生效。
![install](http://imgs.matchvs.com/static/egret/install.png)

### Matchvs插件启动

插件有3种启动方式:

- wing命令行
- wing菜单栏
- wing右侧栏

![open](http://imgs.matchvs.com/static/egret/open.png)

**wing命令行启动插件**

键盘 `F1` 或者 `ctrl+shift+p` 唤起wing 命令悬浮窗口,
输入 `mpre` 或者 `mshow` 唤起Matchvs插件

- mpre 在wing中编辑区打开插件主界面
- mshow  以弹出框的形式打开插件主界面

**wing菜单栏启动插件**

菜单栏 -> 插件 ->Matchvs ->mpre 

**wing右侧栏启动插件**

右侧栏 -> 点击Matchvs图标 