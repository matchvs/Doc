## init

```
int init(MatchVSResponse* pMatchVSResponse, const MsString &channel, const MsString &platform, int gameid);
```




### 参数

| 参数               | 类型              | 描述                   | 示例值       |
| ---------------- | --------------- | -------------------- | --------- |
| pMatchVSResponse | MatchVSResponse | MatchVSResponse派生类指针 |           |
| channel          | const MsString  | 渠道，固定值               | "Matchvs" |
| platform         | const MsString  | MatchVSResponse派生类指针 | "alpha"   |
| gameid           | int             | 游戏ID                 | 2001003   |



### 说明

1.在连接至 Matchvs 前须对SDK进行初始化操作。此时选择连接测试环境还是正式环境。

2.如果游戏属于调试阶段则连接至测试环境，游戏调试完成后即可发布到正式环境运行。

**注意** 发布之前须到官网控制台申请“发布上线” ，申请通过后在接口传”release“才会生效，否则将不能使用release环境。

### 错误码

| 错误码  | 含义                                       |
| ---- | ---------------------------------------- |
| -1   | 失败                                       |
| -2   | channel 非法，请检查是否正确填写为 “Matchvs”          |
| -3   | platform 非法，请检查是否正确填写为 “alpha”  或 “release” |

## uninit

```
int uninit();
```

### 说明

SDK反初始化工作

### 错误码

| 错误码  | 含义   |
| ---- | ---- |
| -1   | 失败   |



## registerUser  	

```
int registerUser();
```


### 返回值

| 参数         | 类型         | 描述      | 示例值  |
| ---------- | ---------- | ------- | ---- |
| MsUserInfo | MsUserInfo | 返回的用户信息 |      |

### 说明

注册用户信息，用以获取一个合法的userID，通过此ID可以连接至Matchvs服务器。一个用户只需注册一次，不必重复注册



## login

```
int login(int userid, const MsString &token, int gameid, int gameversion, const MsString &appkey, const MsString &secretkey, const MsString &deviceid, int gatewayid);
```

### 参数

| 参数          | 类型             | 描述                         | 示例值    |
| ----------- | -------------- | -------------------------- | ------ |
| userid      | int            | 用户ID，调用注册接口后获取             | 123456 |
| token       | const MsString | 用户token，调用注册接口后获取          | ""     |
| gameid      | int            | 游戏ID，来自Matchvs控制台游戏信息      | 210329 |
| gameversion | int            | 游戏版本，自定义，用于隔离匹配空间          | 1      |
| appkey      | const MsString | 游戏App key，来自Matchvs控制台游戏信息 | ""     |
| secretkey   | const MsString | 用户token，调用注册接口后获取          | ""     |
| deviceid    | const MsString | 设备ID，用于多端登录检测，请保证是唯一ID     | ""     |
| gatewayid   | int            | 服务器节点ID，默认为0               | 0      |

### 返回值

| 参数     | 类型     | 描述   | 示例值    |
| ------ | ------ | ---- | ------ |
| status | int    | 返回值  | 200    |
| roomID | string | 房间号  | 200289 |

### 说明

1.登录Matchvs服务端，与Matchvs建立连接。

2.服务端会校验游戏信息是否合法，保证连接的安全性。

3.如果一个账号在两台设备上登录，则后登录的设备会连接失败。

### 错误码

| 错误码  | 含义             |
| ---- | -------------- |
| -1   | 失败             |
| -2   | 未初始化，请先调用初始化接口 |
| -3   | 正在登录           |
| -4   | 已经登录，请勿重复登录    |


## logut

```
int logut();
```

### 返回值

| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| status | int  | 返回值  | 200  |

### 说明

退出登录，断开与Matchvs的连接。

### 错误码

| 错误码  | 含义   |
| ---- | ---- |
| -1   | 失败   |

## createRoom

``` 
int32_t createRoom(const MsCreateRoomInfo &roomInfo, const MsString &userProfile);
```

### 参数

| 参数        | 类型           | 描述                       | 示例值 |
| ----------- | -------------- | -------------------------- | ------ |
| roomInfo    | MsCreateRoomInfo | name:房间名;<br />maxPlayer:最大玩家数;<br />mode:模式;<br />canWatch:是否可以观战;<br />visibility:是否可见;<br />roomProperty:房间属性 | name:'roomName';<br />maxPlayer:3;<br />mode:0;<br />canWatch:1可观战，2不可观战;<br />visibility:1是可见，0是不可见;<br />roomProperty:'roomProperty' |
| userProfile | const MsString | 玩家简介   | ""     |

### 返回值

| 参数        | 类型           | 描述                       | 示例值 |
| ----------- | -------------- | -------------------------- | ------ |
| status | int32_t    | 进房状态  | 200    |
| roomID | uint64_t | 房间号  | 15452154312454 |
| owner  | uint32_t | 房主ID  | 34556775435 |

### 说明

- 开发者可以在客户端主动创建房间，创建成功后玩家会被自动加入该房间，创建房间者即为房主，如果房主离开房间则matchvs会自动转移房主并通知房间内所有成员，开发者通过设置CreateRoomInfo创建不同类型的房间

## getRoomList

```
int32_t getRoomList(const MsRoomFilter &filter);
```

### 参数 

| 参数        | 类型           | 描述                       | 示例值 |
| ----------- | -------------- | -------------------------- | ------ |
| filter      | MsRoomFilter   | maxPlayer:最大玩家数;<br />mode:模式;<br />canWatch:是否可以观战<br />roomProperty:房间属性 | maxPlayer:3;<br />mode:0;<br />canWatch:1可观战，2不可观战;<br />roomProperty:'roomProperty' |


### 返回值

| 参数        | 类型           | 描述                       | 示例值 |
| ----------- | -------------- | -------------------------- | ------ |
| status       | int    | 返回值  | 200            |
| roomID       | uint64_t | 房间ID | "156231454561" |
| roomName     | MsString | 房间名称 | "matchvs"      |
| maxPlayer    | uint32_t    | 最大人数 | 3              |
| mode         | int32_t    | 模式   | 0              |
| canWatch     | int32_t    | 可否观战 | 1可观战，2不可观战 |
| roomProperty | MsString | 房间属性 | ""             |

### 说明

- 开发者通过该接口可以获取所有客户端主动创建的房间列表。不同模式(mode)下的玩家不会被匹配到一起，开发者可以利用mode区分竞技模式，普通模式等游戏模式。开发者可以通过设置RoomFilter来对获取的房间进行过滤

## getRoomListEx

```
int32_t getRoomListEx(const MsRoomFilterEx &filter);
```

### 参数 

| 参数        | 类型           | 描述                       | 示例值 |
| ----------- | -------------- | -------------------------- | ------ |
| filter      | MsRoomFilter   | 获取房间列表过滤条件       |        |
| maxPlayer   | uint32_t      | 最大玩家数                 | 10     |
| mode  	  | int32_t      | 模式                   |0  |
| canWatch    | int32_t      | 是否可观战         |  0是全部，1是可观战，2是不可观战|
| roomProperty| MsString      | 房间属性         | "" |

### 返回值

| 参数        | 类型           | 描述                       | 示例值 |
| ----------- | -------------- | -------------------------- | ------ |
| status       | int32_t    | 返回值  | 200            |
| total       | int32_t    | total  | 5            |
| roomID       | uint64_t | 房间ID | "156231454561" |
| roomName     | MsString | 房间名称 | "matchvs"      |
| maxPlayer    | uint32_t    | 最大人数 | 3              |
| gamePlayer    | uint32_t    | 游戏人数 | 3              |
| mode         | int32_t | 模式   | 0              |
| canWatch     | int32_t    | 可否观战 | 1是可观战，2是不可观战  |
| roomProperty | MsString | 房间属性 | ""  |
| owner | uint32_t | 房主ID | "1233344455"             |
| state | RoomState | 房间状态 0-全部 1-开放 2-关闭 | 0 |
| createTime | uint64_t | 创建时间 | ""             |

### 说明

获取房间列表拓展接口

## getRoomDetail

```
int32_t getRoomDetail(uint64_t roomId);
```

### 参数 

| 参数        | 类型           | 描述                       | 示例值 |
| ----------- | -------------- | -------------------------- | ------ |
| roomId      | uint64_t       | 房间ID       |    237890    |

### 返回值

| 参数        | 类型           | 描述                       | 示例值 |
| ----------- | -------------- | -------------------------- | ------ |
| status      | int32_t       | 返回值       |    200    |
| state      | uint32_t       |  房间状态 0-全部 1-开放 2-关闭       |    0    |
| maxPlayer      | uint32_t       | 最大人数       |    10    |
| mode      | int32_t       | 游戏模式       |    0    |
| canWatch      | int32_t       | 是否可以观战     |    1 可观战，2不可观战  |
| roomProperty      | MsString       | 房间属性       |   ""   |
| owner      | uint32_t       | 房主     |   655522   |
| createFlag      | uint32_t       |  房间创建途径    | 0未知，1系统创建，2玩家创建     |
| userInfos     | std::list<MsRoomUserInfo>  | 房间用户信息列表 |      |
| userID     | uint32_t  |  用户ID |   432444   |
| userProfile     | MsString  |  用户简介|   “”  |



### 说明

根据roomID获取房间详细信息


## joinRandomRoom

```
int joinRandomRoom(int iMaxPlayer, const MsString &strUserProfile);
```

### 参数

| 参数             | 类型             | 描述       | 示例值  |
| -------------- | -------------- | -------- | ---- |
| iMaxPlayer     | int            | 房间内最大玩家数 | 3    |
| strUserProfile | const MsString | 玩家简介     | ""   |

### 返回值

| 参数           | 类型             | 描述       | 示例值    |
| ------------ | -------------- | -------- | ------ |
| status       | int            | 返回值      | 200    |
| roomInfo     | MsRoomInfo     | 房间信息     |        |
| userId       | int            | 用户ID     | 321    |
| roomProperty | const MsString | 房间属性     | “”     |
| cpProto      | const MsString | 负载数据     | “”     |
| status       | int            | 返回值      | 200    |
| userInfo_v | std::vector<MsRoomUserInfo> | 房间已有用户列表 |        |
| userProfile  | MsString | 用户简介     | 321    |
| roomID       | uint64_t | 房间号      | 200289 |
| owner       | uint32_t | 房主ID      | 200289234 |


### 说明

当房间里人数等于IMaxPlayer时，房间人满。系统会将玩家随机加入到人未满且没有JoinOver的房间。

### 错误码

| 错误码  | 含义                            |
| ---- | ----------------------------- |
| -1   | 正在加入房间                        |
| -4   | 未login，请先调用login              |
| -12  | 已经JoinRoom并JoinOver，不允许重复加入房间 |
| -20  | maxPlayer 超出范围 ，maxPlayer须≤20 |

## joinRoomWithProperties

```
int32_t joinRoomWithProperties(const MsMatchInfo &matchInfo, const MsString &userProfile);
```

### 参数

| 参数           | 类型           | 描述     | 示例值  |
| -------------- | -------------- | -------- | ------- |
| matchInfo      | MsMatchInfo    | 返回值   | 200    |
| maxPlayer      | uint32_t    | 最大人数   | 10    |
| mode      | int32_t    | 模式   | 1    |
| canWatch      | int32_t    | 是否观战   | 1    |
| tags      | std::map<MsString, MsString>    |  匹配标签   |     |

### 返回值

| 参数           | 类型             | 描述       | 示例值    |
| ------------ | -------------- | -------- | ------ |
| status       | int            | 返回值      | 200    |
| roomInfo     | MsRoomInfo     | 房间信息     |        |
| userId       | int            | 用户ID     | 321    |
| roomProperty | const MsString | 房间属性     | “”     |
| cpProto      | const MsString | 负载数据     | “”     |
| status       | int            | 返回值      | 200    |
| userInfo_v | std::vector<MsRoomUserInfo> | 房间已有用户列表 |        |
| userProfile  | MsString | 用户简介     | 321    |
| roomID       | uint64_t | 房间号      | 200289 |
| owner       | uint32_t | 房主ID      | 200289234 |

### 说明

通过指定匹配属性匹配指定玩家

## joinRoom

```
int32_t joinRoom(uint64_t roomID, const MsString &userProfile);
```

### 参数

| 参数           | 类型           | 描述     | 示例值  |
| -------------- | -------------- | -------- | ------- |
| roomID      | uint64_t    | 房间ID   | 258744    |
| userProfile    | MsString       | 房间信息 |        |

### 返回值

| 参数           | 类型             | 描述       | 示例值    |
| ------------ | -------------- | -------- | ------ |
| status       | int            | 返回值      | 200    |
| roomInfo     | MsRoomInfo     | 房间信息     |        |
| userId       | int            | 用户ID     | 321    |
| roomProperty | const MsString | 房间属性     | “”     |
| cpProto      | const MsString | 负载数据     | “”     |
| status       | int            | 返回值      | 200    |
| userInfo_v | std::vector<MsRoomUserInfo> | 房间已有用户列表 |        |
| userProfile  | MsString | 用户简介     | 321    |
| roomID       | uint64_t | 房间号      | 200289 |
| owner       | uint32_t | 房主ID      | 200289234 |

### 说明

通过输入房间号码来加入用户自定义房间。

### 错误码

| 错误码  | 含义                            |
| ---- | ----------------------------- |
| -1   | 正在加入房间                        |
| -4   | 未login，请先调用login              |
| -12  | 已经JoinRoom并JoinOver，不允许重复加入房间 |
| -20  | maxPlayer 超出范围 ，maxPlayer须≤20 |


## joinOver

```
int joinOver(const MsString& cpProto);
```

### 参数

| 参数      | 类型             | 描述   | 示例值  |
| ------- | -------------- | ---- | ---- |
| cpProto | const MsString | 负载信息 |      |


### 返回值

| 参数      | 类型             | 描述   | 示例值    |
| ------- | -------------- | ---- | ------ |
| status  | int            | 返回值  | 200    |
| cpProto | const MsString | 负载数据 | ""    |

### 说明

客户端调用该接口通知服务端：房间人数已够，不要再向房间加人。

## leaveRoom

```
int leaveRoom(const MsString& sPayload);
```

### 参数

| 参数      | 类型             | 最大长度 | 描述   | 示例值  |
| ------- | -------------- | ---- | ---- | ---- |
| cpProto | const MsString |      | 负载信息 |      |

### 返回值

| 参数      | 类型             | 描述   | 示例值    |
| ------- | -------------- | ---- | ------ |
| status  | int            | 返回值  | 200    |
| roomID  | string         | 房间号  | 200289 |
| userId  | int            | 用户ID | 321    |
| cpProto | const MsString | 负载数据 | “”     |

### 说明

退出房间，玩家退出房间后将不能再发送数据，也不能再接收到其他玩家发的数据。

## kickPlayer

```
int32_t kickPlayer(uint32_t userID, const MsString &cpProto);
```

### 参数

| 参数      | 类型             | 描述   | 示例值  |
| ------- | -------------- | ---- | ---- |
| userID  | uint32_t    | 用户ID  | 20098778    |
| cpProto | const MsString | 负载信息 | ""      |


### 返回值

| 参数      | 类型             | 描述   | 示例值    |
| -------   | --------------   | ----   | ------ 	|
| status    | int32_t     | 返回值  | 200  |
| owner     | uint32_t     | 房主ID  | 43564  |
| userID     | uint32_t     | 被踢玩家ID  | 43566  |

### 说明

房主将指定ID的玩家踢出房间

### 错误码
| 错误码  | 含义       |
| ---- | -------- |
| -6   | 登录状态无法踢人 |


## sendEvent

```
int sendEvent(const MsString &msg);
```

| 参数      | 类型             | 最大长度 | 描述   | 示例值     |
| ------- | -------------- | ---- | ---- | ------- |
| cpProto | const MsString |      | 消息内容 | "Hello" |

### 返回值

| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| status | int  | 返回值  | 200  |

### 说明

简易版发送消息


## sendEvent

```
int sendEvent(int priority, int type, const MsString &msg, int targetType, int targetSize, const int *targetUserId);
```

### 参数
| 参数          | 类型           | 描述                                     | 描述   |
| ------------- | -------------- | ---------------------------------------- | ---- |
| type          | int            | 消息类型。0表示转发给其他玩家；1表示转发给game server；2表示转发给其他玩家及game server | 0    |
| msg           | const MsString | 消息内容                                     | ""   |
| targetType    | int            | 目标类型。0表示发送目标为pTargetUserId；1表示发送目标为除pTargetUserId以外的房间其他人 | 0    |
| targetSize    | int            | 目标个数                                     | ""   |
| *targetUserId | const int      | 目标列表                                     |      |
| seq 			| int 			 | 目标列表                                     | 序列器 |

### 返回值

| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| status | int  | 返回值  | 200  |


### 说明

发送消息，可以指定发送对象，比如只给玩家A发送消息。

优先级是相对的，SDK收到多个消息，会优先将优先级低的消息传给上层应用。如果所有消息优先级一样，则SDK会根据接收顺序依次将消息传给上层应用。

可以发送二进制数据，开发者可以将数据用json、pb等工具先进行序列化，然后将序列化后的数据通过SendEvent的一系列接口发送。

### 错误码

| 错误码  | 含义                            |
| ---- | ----------------------------- |
| -1   | 失败                            |
| -3   | priority 非法，priority须在0-3范围内  |
| -4   | type 非法                       |
| -5   | targetType 非法                 |
| -6   | targetnum 非法，targetnum不可以超过20 |

## subscribeEventGroup

```
public int subscribeEventGroup(string[] subGroups, string[] unsubGroups)
```

### 参数

| 参数          | 类型       | 描述     | 示例值  |
| ----------- | -------- | ------ | ---- |
| subGroups   | const std::vector<MsString> | 订阅分组   | ""   |
| unsubGroups |  const std::vector<MsString>| 取消订阅分组 | ""   |

### 返回值

| 参数        | 类型       | 描述   | 示例值  |
| --------- | -------- | ---- | ---- |
| status    | int      | 返回值  | 200  |
| subGroups | string[] | 订阅分组 |      |

### 说明

订阅分组与取消订阅分组

### 错误码

| 错误码  | 含义          |
| ---- | ----------- |
| -4   | 初始化状态无法订阅   |
| -20  | 订阅和取消订阅的组为空 |

## sendEventGroup

```
public int sendEventGroup(int priority, string cpProto, string[] groups)
```

### 参数

| 参数       | 类型       | 描述   | 示例值         |
| -------- | -------- | ---- | ----------- |
| cpProto  | const MsString   | 消息   | ""          |
| groups   | std::vector<MsString> | 订阅组  | {"matchvs"} |

### 返回值

| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| status | int  | 返回值  | 200  |
| dstNum | int  | 目标人数 | 2    |

### 说明

发送订阅消息

### 错误码

| 错误码  | 含义            |
| ---- | ------------- |
| -1   | 未加入房间无法发送订阅消息 |
| -20  | 发送的内容为空或组大小为0 |

## setFrameSync

```
int32_t setFrameSync(int32_t frameRate);
```

### 参数

| 参数     | 类型     | 描述   | 示例值      |
| -------- | -------- | ------ | ----------- |
| frameRate| int32_t  | 帧率   | 0是关闭，1~20是每秒的帧率 |

## sendFrameEvent

```
int32_t sendFrameEvent(const MsString &cpProto);
```

### 参数

| 参数        | 类型           | 描述     | 示例值|
| ----------- | -------------- | -------- | ----- |
| cpProto 	  | const MsString | 发送帧同步的消息 | ""    |


## frameUpdate

```
virtual void frameUpdate(const MsFrameData &data) override;
```

### 返回值

| 参数        | 类型           | 描述     | 示例值|
| ----------- | -------------- | -------- | ----- |
| frameIndex 	  | int32_t    | 帧索引   | 2   |
| frameItems 	  | std::list<MsFrameItem> | 同步帧内的数据包数组 | ""    |
| frameWaitCount  | int32_t |同步帧内的数据包数组数量 | ""    |


## roomPeerJoinNotify

### 返回值

| 参数          | 类型             | 描述   | 示例值  |
| ----------- | -------------- | ---- | ---- |
| userID      | int            | 用户ID | 321  |
| userProfile | const MsString | 用户简介 | ""   |

### 说明

加入房间广播通知，当有其他玩家加入房间时客户端会收到该通知。


##  roomPeerLeaveNotify

### 返回值

| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| userID | int  | 用户ID | 321  |

### 说明

离开房间广播通知，当房间内其他玩家离开房间时客户端会收到该通知。


## joinOverNotify

### 返回值

| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| roomId | uint64_t  | 房间ID | 321233  |
| srcUserId | uint64_t  | 发送通知joinOver通知用户ID | 12435543  |
| cpProto | MsString  | 负载数据 | “”  |

## kickPlayerNotify

```
virtual void kickPlayerNotify(const MsKickPlayerNotify &notify) = 0;
```

### 参数

| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| srcUserID | uint32_t  | 踢人者 | 32123322  |
| userID    | uint32_t  | 房间ID | 12435543  |
| cpProto   | MsString  | 负载数据 | “”  |
| owner   | uint32_t  |  房主ID | 12343434  |


## gameServerNotify

```
virtual void gameServerNotify(const MsGameServerNotifyInfo &info) = 0;
```

### 参数

| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| srcUserID | uint32_t  | 无意义 | 0  |
| cpProto   | MsString  | 负载数据 | “”  |

## networkStateNotify

```
virtual int networkStateNotify(const MsNetworkStateNotify &notify) = 0;
```

### 参数
| 参数     | 类型   | 描述   | 示例值  |
| ------ | ---- | ---- | ---- |
| roomID | uint64_t  | 房间ID | 32123322  |
| userID | uint32_t  | 网络状况变化用户ID | “”  |
| state | uint32_t  | 网络状态 | 32123322  |
| owner | uint32_t  | 房主 | “”  |

##  sendEventNotify

### 返回值

| 参数       | 类型             | 描述      | 示例值  |
| -------- | -------------- | ------- | ---- |
| userID   | int            | 推送方用户ID | 321  |
| priority | int            | 优先级     | 1    |
| userID   | const MsString | 负载均衡    | “”   |



### 说明

数据发送通知，当房间内其他玩家发送数据时，客户端会接收到该通知。





## hashSet

**接口地址**
`http://alphavsopen.matchvs.com/wc5/hashSet.do`

**注意** Matchvs 环境分为测试环境（alpha）和 正式环境（release），所以在使用http接口时，需要通过域名进行区分。使用正式环境需要先在官网将您的游戏发布上线。

**alpha环境域名：alphavsopen.matchvs.com**

**release环境域名：vsopen.matchvs.com**



**说明**

服务器存储设置 

**参数**

| 参数名    | 说明        |
| ------ | --------- |
| gameID | 游戏ID      |
| userID | 用户ID      |
| key    | 自定义存储字段编号 |
| value  | 自定义存储字段的值 |
| sign   |           |

**返回值**

- 部分参数说明

| Key    | 含义                          |
| ------ | --------------------------- |
| data   | data=success表示存储数据成功，其他代表异常 |
| status | status=0 表示成功，其他代表异常        |

## hashGet

**接口地址**
`http://alphavsopen.matchvs.com/wc5/hashGet.do`



**注意** Matchvs 环境分为测试环境（alpha）和 正式环境（release），所以在使用http接口时，需要通过域名进行区分。使用正式环境需要先在官网将您的游戏发布上线。

**alpha环境域名：alphavsopen.matchvs.com**

**release环境域名：vsopen.matchvs.com**



**说明**

服务器存储查询

**参数**

| 参数名    | 说明        |
| ------ | --------- |
| gameID | 游戏ID      |
| userid | 用户ID      |
| key    | 自定义存储字段键值 |
| sign   |           |

**返回值**

- 部分参数说明

| Key    | 含义                   |
| ------ | -------------------- |
| data   | 查询的数据结果              |
| status | status=0 表示成功，其他代表异常 |



## sign值获取方法

##### 1. 按照如下格式拼接出字符串:

```
appKey&param1=value1&param2=value2&param3=value3&token
```

- `appKey`为您在官网配置游戏所得

- `param1、param2、param3`等所有参数，按照数字`0-9`、英文字母`a~z`的顺序排列

  例 ： 有三个参数`gameID`、`userID`、`key`，则按照`appkey&gameID=xxx&key=xxx&userID=xxx&token` 的顺序拼出字符串。

- `token`通过用户注册请求获取

##### 2. 计算第一步拼接好的字符串的`MD5`值，即为`sign`的值。


## 通用错误码

| status | 含义        |
| ------ | --------- |
| 200    | 成功        |
| 500    | 网络错误      |
| 501    | gateway错误 |
| 502    | 房间管理错误    |

 
