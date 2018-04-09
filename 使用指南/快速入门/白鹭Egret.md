## Egret 开发环境搭建

1. [下载Egret Engine](http://tool.egret-labs.org/EgretLauncher/EgretLauncher-1.0.49.exe)
2. [下载Egret Wing](http://tool.egret-labs.org/EgretWing/electron/EgretWing-v3.2.6.exe)

## Matchvs 插件安装

- 前往[下载中心](http://www.matchvs.com/serviceDownload)下载白鹭插件  

- 离线安装   

  **注意 :** 插件仅适用于wing3.6.2及以下支持插件的版本;  文末注有 wing3.6.2 以上使用 MatchvsSDK 的方法

​        拖动 matchvs-1.0.0.wext 到 wing 中，wing 的消息通知栏会提示安装成功，重启wing生效。
![install](http://imgs.matchvs.com/static/egret/install.png)

## Matchvs插件启动

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

## 插件开发相关

**调试插件**

1. 用wing打开项目源码,在项目跟目录下 运行 `node install` 命令初始化nodeJS的依赖库
2. 按`ctrl+shift + B`编译
3. 编译完成后 按 `F5` 调试

**打包插件**

F1->package

WebView中能够使用的API与插件进程中不同。  

 - 不支持使用 `wing.d.ts` 中定义的所有API。
 - 支持所有 `node.d.ts` 中定义的所有API。
 - 支持 `electron.d.ts` 中渲染进程中定义的部分API。
 - 支持 `dom.d.ts` 中定义的所有浏览器中的API。
 - 内置 `wing` 命名空间，如： `wing.webview.ipc` 提供 `ipc` 通讯相关的接口。

## wing3.6.2 以上使用MatchvsSDK的方法

需手动配置Egret的工程配置:  

1)  解压matchvs-1.0.0.wext文件（将matchvs-1.0.0.wext重命名为matchvs-1.0.0.zip，然后解压）得到`MatchvsJSSDK.zip`SDK文件。  
文件路径：`matchvs-1.0.0\extension\web\res\MatchvsJSSDK.zip`  

2) 解压缩`MatchvsJSSDK.zip`并配置Egret项目文件添加一行配置以引用SDK
(**注意：** 如要发布微信小游戏项目则引用matchvs_wx下的SDK文件)  

3) build Egret项目生成库依赖

具体方法详见下图
![usepluginfor3.6.2+](http://imgs.matchvs.com/static/egret/usepluginfor3.6.2+.png)
