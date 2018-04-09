## Demo简介

为了便于开发者使用和理解Matchvs的实时联网SDK，Matchvs提供了简洁的Demo来展示多人实时游戏的开发过程和效果。  


Demo支持两人同时游戏，匹配成功后，玩家点击攻击按钮进攻对手，血量先清0的一方失败。    

下载Demo源码后，通过CocosStudio打开项目，然后点击项目，发布为Visual Studio工程就可以正常使用。若Demo未经过合法校验而无法正常运行，请根据下方 **游戏配置** 操作。


## 游戏配置

Demo运行之前需要去 [官网](http://www.matchvs.com ) 配置游戏相关信息，以获取Demo运行所需要的GameID、AppKey、SecretID。如图：

![image](http://imgs.matchvs.com/static/guanwang1.png)

![image](http://imgs.matchvs.com/static/guanwang2.png)

获取到相关游戏信息之后，运行Demo，填写GameID,AppKey,SecretID,点击登录。 如图所示： 

![image](http://imgs.matchvs.com/static/ipone.png)


## 初始化SDK 

Matchvs SDK提供了两个很重要的文件，`MatchVSEngine`和`MatchVSResponse`。想要获取游戏中玩家加入、离开房间，数据收发的信息，需要先实现`MatchVSResponse`中的抽象方法。  

我们现在新建子类MatchVSDemo_Response继承自抽象类MatchVSResponse，如下：

```
class MatchVSDemo_Response : public MatchVSResponse
{
public:
	
	virtual ~MatchVSDemo_Response();
	MatchVSDemo_Response();
	//实现所有父类的抽象方法
	
};
```

文件路径：MatchvsCocosDemo\Classes\MatchVSDemo_Response.h 



完成以上步骤后，我们可以调用初始化接口建立相关资源。

```
MatchVSEngine::getInstance()->init(&m_Response_Test, sChannel.c_str(), sPlatform.c_str(), iGameId);
```
初始化操作，在MatchVSDemo_Work.cpp文件中完成。

文件路径：MatchvsCocosDemo\Classes\MatchVSDemo_Work.cpp

**注意** 在整个应用全局，开发者只需要对引擎做一次初始化。


## 建立连接

接下来，我们就可以从Matchvs获取一个合法的用户ID，通过该ID连接至Matchvs服务端。  

获取用户ID：

```
MatchVSEngine::getInstance()->registerUser();
```

登录连接：

```
MatchVSEngine::getInstance()->login(userid, token.c_str(), gameid, gameversion, appkey.c_str(), secretkey.c_str(), deviceid.c_str(), gatewayid);
```

文件路径 ：`MatchvsCocosDemo\Classes\MatchVSDemo_Work.cpp`

## 加入房间

成功连接至Matchvs后，即可加入一个房间进行游戏。  

![image](http://imgs.matchvs.com/static/matching.png)

```
MatchVSEngine::getInstance()->joinRandomRoom(iMaxPlayer, strUserProfile.c_str());
```

文件路径:`MatchvsCocosDemo\Classes\MatchVSDemo_Work.cpp`


## 停止加入

如果游戏人数已经满足开始条件且游戏设计中不提供中途加入，此时需告诉Matchvs不要再向房间里加人。 

- 我们设定如果3秒内有3个真人玩家匹配成功则调用JoinOver并立即开始游戏； 
- 如果3秒内只有2个真人玩家，则再添加一个机器人（机器人头像默认为一个即可，昵称为：机器人1），调用JoinOver并开始游戏；  
- 如果3秒内只有1个真人玩家，则添加两个机器人（机器人头像默认即可，昵称为：机器人1，机器人2），调用JoinOver并开始游戏。

```
MatchVSEngine::getInstance()->joinOver(cpProto.c_str());
```

文件路径：MatchvsCocosDemo\Classes\MatchVSDemo_Work.cpp


## 游戏数据传输

当一个玩家进行操作时，我们将这些操作广播给房间其他玩家。界面上同步展示各个玩家的状态变化。  

![image](http://imgs.matchvs.com/static/game.png)

```
MatchVSEngine::getInstance()->sendEvent(int priority, int type, const MsString &msg, int targetType, int targetSize, const int *targetUserId);
```

文件路径：MatchvsCocosDemo\Classes\MatchVSDemo_Work.cpp


数据传输回调 ：

```
int MatchVSDemo_Response::sendEventRsp(const MsSendEventRsp & rsp) {
}
```

收到其他人发的数据：

```
int MatchVSDemo_Response::sendEventNotify(const MsBusiHotelNotify & tRsp) {
}
```


## 离开房间

血量清0后游戏结束，游戏结束后离开房间。  

![image](http://imgs.matchvs.com/static/result.png)

离开房间 ：

```
MatchVSEngine::getInstance()->leaveRoom(cpProto.c_str());
```


文件路径：MatchvsCocosDemo\Classes\MatchVSDemo_Work.cpp


## 游戏登出

退出游戏时，需要调用登出接口将与Matchvs的连接断开。

```
MatchVSEngine::getInstance()->logout();
```

文件路径：MatchvsCocosDemo\Classes\MatchVSDemo_Work.cpp


## 反初始化

在登出后，调用反初始化对资源进行回收。  

```
MatchVSEngine::getInstance()->uninit();
```

文件路径：`MatchvsCocosDemo\Classes\MatchVSDemo_Work.cpp`

## 错误处理  

```
int MatchVSDemo_Response::errorResponse(const char * sError) {
}
```

文件路径：MatchvsCocosDemo\Classes\MatchVSDemo_Response.cpp