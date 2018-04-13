---
style: candy
---
## 新建游戏

1. 使用Matchvs游戏云需要AppKey、AppSecret，与Cocos的AppID、AppSecret并不相同，需进入Matchvs官网创建游戏获取。[进入官网](http://www.matchvs.com/manage/gameContentList/)
2. 登陆官网，点击右上角控制台进入，若没有Matchvs官网账号。[立即注册](http://www.matchvs.com/vsRegister)
3. 进入控制台，点击新建游戏，填写《游戏名称》即可，新建成功如下：![](http://imgs.matchvs.com/static/2_2.png)

## Laya JavaScript开发者

## 环境搭建
TS和JS开发者，仅下载LayaAir IDE即可.

## 导入SDK

1. [下载JavaScriptSDK](http://www.matchvs.com/serviceDownload)
2. 新建一个 Laya 空工程,或者打开一个现有Laya JS项目
3. 解压SDK的zip文件,copy `matchvs.all.js`文件到Laya工程的src目录,如下图所示:



![laya_copysdk](http://imgs.matchvs.com/static/Laya/laya_copysdk.png)



4. 按`F5`键编译一个工程,Laya Air IDE会自动在index.html中插入引用matchvs的JS库的代码,如下图所示:


![laya_build](http://imgs.matchvs.com/static/Laya/laya_build.png)



完成以上步骤,开发者便可以使用MatchvsSDK开发游戏了.

Matchvs SDK 更多用法参考:
[Cocos creator的JavaScript版本的Demo教程](http://www.matchvs.com/service?page=Demo-Creator)

## Laya TypeScript 开发者


## TS 环境搭建   

TS和JS开发者，仅下载LayaAir IDE即可,由于采用TS在发布产品的时候把项目代码编译为JS代码运行，所以这TypeScript语言的开发者，还需要进行一些额外的准备工作。

TypeScript编译器安装,参考教程
http://ldc.layabox.com/doc/?nav=ch-as-1-0-6

## 导入SDK

1. [下载TypeScriptSDK](http://www.matchvs.com/serviceDownload)
2. 新建一个 Laya TS空工程,或者打开一个现有Laya TS项目
3. 解压SDK的zip文件,copy `matchvs.d.ts`文件到Laya工程的libs目录,如下图所示:

![laya-ts](http://imgs.matchvs.com/static/Laya/laya-ts.png)

4. copy `matchvs.js`到 `bin/libs/`目录下
5. copy `matchvs.min.js`到 `bin/libs/min/`目录下

![laya-ts-js](http://imgs.matchvs.com/static/Laya/laya-ts-js.png)


5.在`bin\index.html`中导入JS.
代码片段如下:
```HTML
	// .....省略
	<script type="text/javascript" src="libs/matchvs.js"></script>
    <!--核心包，封装了显示对象渲染，事件，时间管理，时间轴动画，缓动，消息交互,socket，本地存储，鼠标触摸，声音，加载，颜色滤镜，位图字体等-->
	<script type="text/javascript" src="libs/laya.core.js"></script>
	
	// .....省略
```
## 代码中使用SDK

以 TS版本的 Laya UI Sample工程为例,对示例代码中的onLoaded函数稍作修改,添加Matchvs SDK的调用代码:
``` TypeScript
function onLoaded(): void {
	//实例UI界面
	var testUI: TestUI = new TestUI();
	Laya.stage.addChild(testUI);
	//MatchvsSDK示例代码
	var engine:MatchvsEngine = new MatchvsEngine();
	var listener:MatchvsResponse = new MatchvsResponse();
	listener.initResponse = function(stauts){
		console.log(stauts);
	}
	engine.init(listener,"MatchVS","alpha",102000);
}
```
F5调试运行工程. 在console中查看代码运行结果

Matchvs更多用法参考:
[Egret的TypeScript版本的Demo教程](http://www.matchvs.com/service?page=DemoEgret)

[Laya接入指南](http://www.matchvs.com/service?page=guideLaya)

---------
关于Laya开发者如何开发微信小游戏的说明见Laya官网文档:
https://ldc.layabox.com/doc/?nav=zh-js-5-0-1

	PS: 微信小游戏平台请开发者引用`Matchvs SDK/matchvs_wx`目录下的matchvs.all.js文件
