## 新建游戏

1.使用Matchvs游戏云需要AppKey、AppSecret，通过Matchvs官网创建游戏获取。[进入官网](http://www.matchvs.com/manage/gameContentList/)

2.登陆官网，点击右上角控制台进入，若没有Matchvs官网账号。[立即注册](http://www.matchvs.com/vsRegister)

3.进入控制台，点击新建游戏，填写《游戏名称》即可，新建成功如下：![](http://imgs.matchvs.com/static/2_2.png)

## 下载Matchvs游戏云

您可以通过访问 [服务中心-SDK下载](http://res.matchvs.com/sdk/MatchVS_Unity.unitypackage) 下载Matchvs游戏云SDK。

## 创建Unity项目

![](http://imgs.matchvs.com/static//2_5.png)

## 加载SDK

将Matchvs SDK导入至你的项目：

![](http://imgs.matchvs.com/static/2_3.png)

## 初始化

**注意**  在整个应用全局，开发者只需要对引擎做一次初始化。

新建一个子类（如：`MatchVSResponseInner`）继承抽象类 `MatchVSResponse`，并实现其中的的抽象方法。

```
MatchVSResponseInner.cs

public class MatchVSResponseInner : MatchVSResponse
{
    //实现所有父类的抽象方法
}
```

Matchvs 提供了两个环境，alpha 调试环境和 release 正式环境。

游戏开发调试阶段请使用 alpha 环境，即 platform 传参"alpha"。如下：

```
engine.init(matchVSResponses, "Matchvs", "alpha", 201016);
```

channel 固定参数为 “Matchvs” ，GameID 为你在官网上新建游戏后获取的ID信息。

## 开发游戏逻辑

如果是第一次使用SDK，需调用注册接口获取一个用户ID。通过此合法ID连接至Matchvs服务器。
```
engine.registerUser();
```

调用登录接口即可建立连接，此时用户ID和创建游戏后获取的AppKey、Secret、GameID为必要参数。
```
engine.login(3513,"ETOHLWXYJZMMNQUDQDPBAHMYKBQSLLCW",201016,1,"***************** ","afecedab415e40a4a1d1329962940191","","");
```

接下来就可以使用Matchvs提供的接口实现游戏联网逻辑，详情请参考 [接入指南](http://www.matchvs.com/service?page=AccessUnity)


## 发布上线

开发和调试过程在测试环境（alpha）下进行，调试完成后即可申请将游戏转到正式环境（release）：

1. 前往官网控制台进行“发布上线”操作，如图，点击按钮后即向Matchvs提交了上线申请。 ![](http://imgs.matchvs.com/static/2_4.png)
2. 申请通过后，在客户端的初始化接口将 platform 置为 release。  

至此，游戏就可以运行在正式环境下啦！
