## 新建游戏

1. 使用Matchvs游戏云需要AppKey、AppSecret，与Cocos的AppID、AppSecret并不相同，需进入Matchvs官网创建游戏获取。[进入官网](http://www.matchvs.com/manage/gameContentList/)
2. 登陆官网，点击右上角控制台进入，若没有Matchvs官网账号。[立即注册](http://www.matchvs.com/vsRegister)
3. 进入控制台，点击新建游戏，填写《游戏名称》即可，新建成功如下：![](http://imgs.matchvs.com/static/2_2.png)

## 创建Matchvs-Cocos项目

![](http://imgs.matchvs.com/static/cocos/quick_start1_1.png)



## 下载插件

打开项目，从creator商店下载Matchvs插件并安装。安装完成后，可以看到“扩展”菜单下多了一个“Matchvs”选项：

![](http://imgs.matchvs.com/static/cocos/quick_start1_3.png)



## 构建项目

点击“扩展”里的“Matchvs”，打开插件面板：

![](http://imgs.matchvs.com/static/cocos_plugin1.png)



根据指引，先去“构建项目” ：

![](http://imgs.matchvs.com/static/cocos_plugin2.png)



## 导入Matchvs

回到Matchvs插件面板，可以看到此时已经构建完成，下一步需要导入Matchvs：

![](http://imgs.matchvs.com/static/cocos_plugin3.png)



导入成功界面如下：

![](http://imgs.matchvs.com/static/cocos_plugin4.png)



## 开始编码

### 初始化

**注意**  在整个应用全局，开发者只需要对引擎做一次初始化。

调用Matchvs.MatchvsEngine.getInstance方法获取Matchvs引擎对象：

```javascript
var engine = Matchvs.MatchvsEngine.getInstance();
```

另外创建一个回调对象，在进行注册、登录、发送消息等操作之后，该对象的方法会被异步调用：

```javascript
var response = {/* 按照文档规范定义一些回调方法 */};
```

接入下可以调用初始化方法init：

```javascript
engine.init(response, channel, platform, gameId);
```

Matchvs 提供了两个环境，alpha 调试环境和 release 正式环境。

游戏开发调试阶段请使用 alpha 环境，即 platform 传参"alpha"。如下：

```javascript
engine.init(response, "MatchVS", "alpha", 201016);
```

channel 固定参数为 “MatchVS” ，gameId 为你在官网上新建游戏后获取的ID信息。

### 开发游戏逻辑

如果是第一次使用SDK，需调用注册接口获取一个用户ID。通过此合法ID连接至Matchvs服务器。

```javascript
engine.registerUser();
```

调用登录接口即可建立连接：

```javascript
engine.login(userId, token, gameId, gameVersion, appKey, secretKey, deviceId, gatewayId);
```

此时用户ID和创建游戏后获取的AppKey、Secret、GameID为必要参数，具体的调用实例如：

```javascript
engine.login(3513, "ETOHLWXYJZMMNQUDQDPBAHMYKBQSLLCW", 201016, 1, "***************** ", "afecedab415e40a4a1d1329962940191", "", "");
```

接下来就可以使用Matchvs提供的接口实现游戏联网逻辑，详情请参考[接入指南](http://www.matchvs.com/service?page=guideCreator)

### 发布上线

开发和调试过程在测试环境（alpha）下进行，调试完成后即可申请将游戏转到正式环境（release）：

1. 前往官网控制台进行“发布上线”操作，如图，点击按钮后即向MatchVS提交了上线申请。 ![](http://imgs.matchvs.com/static/2_4.png)
2. 申请通过后，在客户端的初始化接口将 platform 置为 release。  
   至此，游戏就可以运行在正式环境下啦！


## 异常说明

Q. 直接下载的这个工程，按步骤运行，出现模拟器报错，但浏览器正常 ?

A. native平台暂不能在模拟器下运行，需要用vs或其他工具打开工程完成编译。另外，目前只对android studio做插件，eclipse还不支持。