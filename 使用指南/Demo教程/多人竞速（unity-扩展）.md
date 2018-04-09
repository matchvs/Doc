
## 创建房间

点击Demo首页“创建房间”按钮即由用户自主创建一个房间，创建成功后会返回当前房号。如果有其他用户加入该房间，自动刷新房间内成员列表。

- 如果房主中途离开房间，系统会自动指定下一个房主。开发者可以根据需要选择是否采用系统指定的房主。目前Demo在客户端实现了一套房主转移机制。
- 系统没有对踢人的权限做限制，即无论是否房主，都可以拥有踢人权限。开发者可以在客户端合理控制该权限。

![](http://imgs.matchvs.com/static/3_1_1.png)

创建房间代码：

```
engine.createRoom(info, userProfile);
```
文件路径：`Assets\Script\MainUI\GameManager.cs`

创建房间回调：

```
 int createRoomResponse(MsCreateRoomRsp tRsp)
```

文件路径：`Assets\Script\MainUI\CreateRoomBoard.cs`

踢人代码:

```
 engine.kickPlayer(userid,cpProto);
```

文件路径：`Assets\Script\MainUI\CreateRoomBoard.cs`

踢人回调:

```
int kickPlayerResponse(int status)
```

文件路径：`Assets\Script\MainUI\CreateRoomBoard.cs`

房间其他成员获取通知:

```
int kickPlayerNotify(MsKickPlayerNotify tRsp)
```

文件路径：`Assets\Script\MainUI\CreateRoomBoard.cs`

## 加入指定房间

通过输入房间号来加入用户自定义房间。

![](http://imgs.matchvs.com/static/3_1_2.png)

加入指定房间：

```
 engine.joinRoom(roomID, profile);
```

加入房间回调：

```
int joinRoomResponse(MsJoinRandomRsp tRsp)
```

文件路径：`Assets\Script\MainUI\GameRoomBoard.cs`


## 自定义属性匹配

可以自定义匹配方案，匹配相同属性的玩家。

![](http://imgs.matchvs.com/static/3_1_3.png)

```
engine.joinRoomWithProperties(info, userProfile);
```

加入房间回调：

```
int joinRoomResponse(MsJoinRandomRsp tRsp)
```

文件路径：`Assets\Script\MainUI\GameRoomBoard.cs`


## 消息订阅分组

开始游戏后，游戏区域中的黄色区域内成员可以互相通信，区域内和区域外的消息不互通。

当成员进入黄色区域时即订阅消息，走出区域则取消订阅该范围消息。

![](http://imgs.matchvs.com/static/3_1_5.png)

订阅与取消订阅:

```
int subscribeEventGroup(string[] subGroups, string[] unsubGroups)
```

订阅与取消订阅回调:

```
int subscribeEventGroupRsp(MsSubscribeEventGroupRsp tRsp)

```

发送消息到消息订阅组:

```
int subscribeEventGroupRsp(MsSubscribeEventGroupRsp tRsp)

```

订阅消息推送:

```
int sendEventGroupNotify(MsSendEventGroupNotify tRsp)

```

文件路径：`Assets\Script\MainUI\GameRoomBoard.cs`

进入特殊区域，发送订阅请求:

```
	....
	   GameManager.SubscribteEventGroup(new []{"specialArea"},new string[]{});
	....

```

订阅该消息的玩家，收到请求后，调整相应小车的状态并发送自己当前状态:

```
	....
	    int id = (int) data["id"];
        GameObject target = GetPlayerInfoByID(id).Target;
        target.GetComponent<CharacterMove>().OnEnter();

        data = new JsonData();
        data["action"] = "enterResponse";
        data["id"] = GameManager.userID;
        string value = JsonUtil.toJson(data);
        GameManager.SendEventGroup(value, new string[] {"specialArea"});
	....

```

订阅该消息的玩家，收到请求后，调整相应小车的状态：

```
	....
	  int id = (int) data["id"];
      GameObject target = GetPlayerInfoByID(id).Target;
      target.GetComponent<CharacterMove>().OnEnter();
   ....

```

离开特殊区域之后，发送取消订阅请求，同时改变所有小车状态，并取消订阅:

```
	....
		JsonData data = new JsonData();
        data["action"] = "exist";
        data["id"] = GameManager.userID;
        string value = JsonUtil.toJson(data);
        GameManager.SendEventGroup(value,new string[] { "specialArea" });

        for (int i = 0; i < players.Length; i++) {
            players[i].Target.GetComponent<CharacterMove>().OnExist();
        }
	....
  GameManager.SubscribteEventGroup(new string[] { }, new string[] { "specialArea" });
	....

```

订阅该消息的玩家，收到请求后，调整相应小车的状态:

```
	....
	 int id = (int) data["id"];
    GameObject target = GetPlayerInfoByID(id).Target;
    target.GetComponent<CharacterMove>().OnExist();
	....

```

## 展示房间列表

点击Demo首页“查看房间列表”按钮即可查看当前所有玩家主动创建的房间列表。点击房间列表里的某个房间即可加入该房间。

![](http://imgs.matchvs.com/static/3_1_4.png)

获取房间列表:

```
engine.getRoomList(filter);

```

消息回调:

```
int getRoomListResponse(MsRoomListRsp tRsp)

```

文件路径：`Assets\Script\MainUI\GameRoomBoard.cs`



## 帧同步

在目前的手游开发中，帧同步作为更多游戏的选择，已经被多数开发者和厂商积极使用，并且根据基础帧同步的概念，各自进行着不断的完善和改进。

Matchvs 所提供的帧同步能力，让您可以根据游戏需要，直接设置同步帧率，比如10帧每秒，然后您可以调用发送帧同步数据的接口来发送逻辑帧数据。Matchvs 会缓存每100毫秒的数据，将这100毫秒的数据作为一帧发给各个客户端。



![](http://imgs.matchvs.com/static/frame.png)



设置帧率：

设置帧同步

```
# Assets\Script\MainUI\GameManager.cs
public static void SetFrameSync(int rate)
{
	engine.setFrameSync(rate);
}
```

调用代码：

```
# Assets\Script\MainUI\GameRoomBoard.cs
GameManager.SetFrameSync(10);
```

**注意：** 设置帧率代表了开启帧同步功能，该操作需加入房间后调用。



发送帧同步数据：

```
# Assets\Script\MainUI\GameRoomBoard.cs
···
JsonData data = new JsonData();
data["action"] = "AccelerateUp";
string value = data.ToJson();
if (GameManager.Instance.Mode == GameMode.FrameMode) {
    GameManager.SendFrameEvent(value);
} 
···
```

接收帧同步数据：

设置帧率，每隔相应帧率，FrameUpdate执行一次。

```
# Assets\Script\MainUI\GameRoomBoard.cs
···
private void FrameUpdate(MsFrameData frameData)
{
	MsFrameItem[] items = frameData.frameItems;
	for (int i = 0; i < items.Length; i++)
	{
		MsFrameItem tRsp = items[i];
		string payload = tRsp.cpProto;
		JsonData jsonInfo = JsonUtil.toObject(payload);
		string action = (string)jsonInfo["action"];
		if (action.Equals("AccelerateDown")) {
				AccelerateDown(tRsp.srcUserID);
				Message("[帧同步消息:]" + tRsp.srcUserID + "加速");
		}

		if (action.Equals("AccelerateUp")) {
				AccelerateUp(tRsp.srcUserID);
				Message("[帧同步消息:]" + tRsp.srcUserID + "减速");
		}
		
		if (action.Equals("RightDown")) {
				RightDown(tRsp.srcUserID);
				Message("[帧同步消息:]" + tRsp.srcUserID + "开始向右");
		}
		
		if (action.Equals("RightUp")) {
				RightUp(tRsp.srcUserID);
				Message("[帧同步消息:]" + tRsp.srcUserID + "停止向右");
		}
		
		if (action.Equals("LeftDown")) {
				LeftDown(tRsp.srcUserID);
				Message("[帧同步消息:]" + tRsp.srcUserID + "开始向左");
		}
		
		if (action.Equals("LeftUp")) {
				LeftUp(tRsp.srcUserID);
				Message("[帧同步消息:]" + tRsp.srcUserID + "停止向左");
		}
	}
}
···
```



