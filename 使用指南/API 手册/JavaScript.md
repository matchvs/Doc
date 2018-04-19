## getInstance
```javascript
var engine = Matchvs.MatchvsEngine.getInstance();
```
#### 说明
- getInstance()方法返回Matchvs引擎的一个实例，接下来可以调用这个实例的方法实现联网对战功能。
- 建议在调用getInstance()方法获取一个实例之后，将其作为单例或全局变量。



## init

```javascript
engine.init(response, channel, platform, gameId)
```

#### 参数

| 参数       | 类型     | 描述            | 示例值       |
| -------- | ------ | ------------- | --------- |
| response | object | 回调对象          | {}        |
| channel  | string | 渠道，固定值        | "Matchvs" |
| platform | string | 平台，选择测试or正式环境 | "Alpha"   |
| gameId   | number | 游戏ID          | 2001003   |

#### 说明

- response中设置一些回调方法，在执行注册、登录、发送事件等操作对应的方法之后，reponse中的回调函数会被SDK异步调用。
- 在连接至 Matchvs前须对SDK进行初始化操作。此时选择连接测试环境（Alpha）还是正式环境（Release）。
- 如果游戏属于调试阶段则连接至测试环境，游戏调试完成后即可发布到正式环境运行。

**注意** 发布之前须到官网控制台申请“发布上线”，申请通过后在调用init方法时传“Release”才会生效，否则将不能使用Release环境。

#### 错误码

| 错误码  | 含义                                       |
| ---- | ---------------------------------------- |
| 0    | 成功                                       |
| -1   | 失败                                       |
| -2   | channel 非法，请检查是否正确填写为 “Matchvs”          |
| -3   | platform 非法，请检查是否正确填写为 “Alpha”  或 “Release” |


## initResponse

```javascript
response.initResponse(status)
```

#### 参数

| 参数     | 类型     | 描述                | 示例值  |
| ------ | ------ | ----------------- | ---- |
| status | number | 状态返回，200表示成功，其他失败 | 200  |

#### 说明

- response是engine.init方法中传入的对象，init初始化完成之后，会异步回调initResponse方法


## uninit

```javascript
engine.uninit()
```

#### 说明

SDK反初始化工作

#### 错误码

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -1   | 失败   |



## registerUser

```javascript
engine.registerUser()
```

#### 返回值

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -1   | 失败   |



## registerUserResponse
```javascript
response.registerUserResponse(userInfo)
```

#### 参数userInfo的属性

| 属性     | 类型     | 描述      | 示例值                                      |
| ------ | ------ | ------- | ---------------------------------------- |
| id     | number | 用户ID    | 123456                                   |
| token  | string | 用户Token | "XGBIULHHBBSUDHDMSGTUGLOXTAIPICMT"       |
| name   | string | 用户名称    | "张三"                                     |
| avatar | string | 头像      | "http://pic.vszone.cn/upload/head/1416997330299.jpg" |

#### 说明

- response是engine.init方法中传入的对象，调用engine.registerUser注册成功之后，response对象的registerUserResponse方法如果存在则会被调用，调用时传入一个封装了用户信息的参数userInfo。

- 注册用户信息，用以获取一个合法的userId，通过此ID可以连接至Matchvs服务器。一个用户只需注册一次。

> 需要注意：调用此接口成功注册用户后，SDK会缓存用户信息。即使再次调用`regist()`会返回相同的UserID,如需重新注册新的用户须调用SDK的 `LocalStore_Clear()` 函数以清除缓存的用户信息。
>
> 如果需要同时调试多个客户端，则需要打开多个不同的浏览器进行调试。



## login

```javascript
engine.login(userId, token, gameId, gameVersion, appKey, secretKey, deviceId, gatewayId)
```

#### 参数

| 参数          | 类型     | 描述                          | 示例值    |
| ----------- | ------ | --------------------------- | ------ |
| userId      | number | 用户ID，调用注册接口后获取              | 123546 |
| token       | string | 用户token，调用注册接口后获取           | ""     |
| gameId      | number | 游戏ID，来自Matchvs控制台游戏信息       | 210329 |
| gameVersion | number | 游戏版本，自定义，用于隔离匹配空间           | 1      |
| appKey      | string | 游戏App key，来自Matchvs控制台游戏信息  | ""     |
| secretKey   | string | secret key，来自Matchvs控制台游戏信息 | ""     |
| deviceId    | string | 设备ID，用于多端登录检测，请保证是唯一ID      | ""     |
| gatewayId   | number | 服务器节点ID，默认为0                | 0      |

#### 返回值

| 错误码  | 含义             |
| ---- | -------------- |
| 0    | 成功             |
| -1   | 失败             |
| -2   | 未初始化，请先调用初始化接口 |
| -3   | 正在登录           |
| -4   | 已经登录，请勿重复登录    |



## loginResponse

```javascript
response.loginResponse(loginRsp)
```
#### 参数loginRsp的属性

| 属性     | 类型     | 描述                | 示例值    |
| ------ | ------ | ----------------- | ------ |
| status | number | 状态返回<br>200 成功<br>402 应用校验失败，确认是否在未上线时用了release环境，并检查gameId、appkey 和 secret<br>403 检测到该账号已在其他设备登录<br>404 无效用户 | 200  |
| roomId | number | 房间号               | 210039 |

#### 说明

- 登录Matchvs服务端，与Matchvs建立连接。
- 服务端会校验游戏信息是否合法，保证连接的安全性。
- 如果一个账号在两台设备上登录，则后登录的设备会连接失败。
- 如果用户加入房间之后掉线，再重新登录进来，则roomId为之前加入的房间的房间号。



## logout

```javascript
engine.logout(cpProto)
```

#### 参数

| 参数      | 类型     | 描述   | 示例值  |
| ------- | ------ | ---- | ---- |
| cpProto | string | 负载信息 | ""   |

#### 返回值

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -1   | 失败   |

#### 说明

- 退出登录，断开与Matchvs的连接。



## logoutResponse

```javascript
response.logoutResponse(status)
```

#### 参数

| 参数     | 类型     | 描述                | 示例值  |
| ------ | ------ | ----------------- | ---- |
| status | number | 状态返回，200表示成功，其他失败 | 200  |



## joinRandomRoom

```javascript
 engine.joinRandomRoom(maxPlayer, userProfile)
```

#### 参数

| 参数          | 类型     | 描述       | 示例值  |
| ----------- | ------ | -------- | ---- |
| maxPlayer   | number | 房间内最大玩家数 | 3    |
| userProfile | string | 玩家简介     | ""   |

#### 返回值

| 错误码  | 含义                                       |
| ---- | ---------------------------------------- |
| 0    | 成功加入房间                                   |
| -1   | 正在加入房间                                   |
| -4   | 未登录，请先调用login                            |
| -12  | 已经joinRoom并[joinOver](#joinOver)，不允许重复加入房间 |
| -20  | maxPlayer超出范围 ，maxPlayer须≤20             |

#### 说明

- 当房间里人数等于maxPlayer时，房间人满。系统会将玩家随机加入到人未满且没有[joinOver](#joinOver)的房间。
- 如果不存在人未满且没有joinOver的房间，则系统会再创建一个房间，然后将玩家加入到该房间。
- 玩家userProfile的值可以自定义，接下来会通过回调函数（如joinRoomResponse）传给其他客户端。


## joinRoomWithProperties

```javascript
engine.joinRoomWithProperties(MsMatchInfo, userProfile)
```

#### 参数

| 参数          | 类型     | 描述                                       | 示例值                                      |
| ----------- | ------ | ---------------------------------------- | ---------------------------------------- |
| MsMatchInfo | object | maxPlayer:最大玩家数;<br />mode:模式;<br />canWatch:是否可以观战<br />tags:标签 | maxPlayer:3;<br />mode:0;<br />canWatch:0<br />tags:{"title": "A"} |
| userProfile | string | 玩家简介                                     | ""                                       |

#### 返回值

| 错误码  | 含义                                       |
| ---- | ---------------------------------------- |
| 0    | 成功加入房间                                   |
| -1   | 正在加入房间                                   |
| -4   | 未登录，请先调用login                            |
| -12  | 已经joinRoom并[joinOver](#joinOver)，不允许重复加入房间 |
| -20  | maxPlayer超出范围 ，maxPlayer须≤20             |

#### 说明

- tags为匹配标签，开发者通过设置不同的标签进行自定义属性匹配，相同MsMatchInfo的玩家将会被匹配到一起。

## createRoom

```javascript
engine.createRoom(CreateRoomInfo, userProfile)
```

#### 参数

| 参数             | 类型     | 描述                                       | 示例值                                      |
| -------------- | ------ | ---------------------------------------- | ---------------------------------------- |
| CreateRoomInfo | object | name:房间名;<br />maxPlayer:最大玩家数;<br />mode:模式;<br />canWatch:是否可以观战;<br />visibility:是否可见;<br />roomProperty:房间属性 | name:'roomName';<br />maxPlayer:3;<br />mode:0;<br />canWatch:0;<br />visibility:1;<br />roomProperty:'roomProperty' |
| userProfile    | string | 玩家简介                                     | ""                                       |

#### 返回值

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -4   | 未初始化 |

#### 说明

- 开发者可以在客户端主动创建房间，创建成功后玩家会被自动加入该房间，创建房间者即为房主，如果房主离开房间则matchvs会自动转移房主并通知房间内所有成员，开发者通过设置CreateRoomInfo创建不同类型的房间

## createRoomResponse

```javascript
response.createRoomResponse(CreateRoomRsp)
```

#### 参数

| 参数     | 类型     | 描述                | 示例值    |
| ------ | ------ | ----------------- | ------ |
| status | number | 状态返回，200表示成功，其他失败 | 200    |
| roomId | number | 房间号               | 210039 |
| owner  | number | 房主                | 210000 |

#### 说明

- response是engine.createRoom方法中传入的对象，createRoom完成之后，会异步回调createRoomResponse方法

## joinRoom

```javascript
engine.joinRoom(roomId, userProfile)
```

#### 参数

| 参数          | 类型     | 描述   | 示例值     |
| ----------- | ------ | ---- | ------- |
| roomId      | number | 房间号  | 1344333 |
| userProfile | string | 玩家简介 | ""      |

#### 返回值

| 错误码  | 含义                                       |
| ---- | ---------------------------------------- |
| 0    | 成功加入房间                                   |
| -1   | 正在加入房间                                   |
| -4   | 未登录，请先调用login                            |
| -12  | 已经joinRoom并[joinOver](#joinOver)，不允许重复加入房间 |
| -20  | maxPlayer超出范围 ，maxPlayer须≤20             |

#### 说明

- 客户端可以通过调用该接口加入指定房间，roomId为加入指定房间的房间号

## getRoomList

```javascript
engine.getRoomList(RoomFilter)
```

#### 参数

| 参数         | 类型     | 描述                                       | 示例值                                      |
| ---------- | ------ | ---------------------------------------- | ---------------------------------------- |
| RoomFilter | object | maxPlayer:最大玩家数;<br />mode:模式;<br />canWatch:是否可以观战<br />roomProperty:房间属性 | maxPlayer:3;<br />mode:0;<br />canWatch:0<br />roomProperty:'roomProperty' |

#### 返回值

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -4   | 未初始化 |

#### 说明

- 开发者通过该接口可以获取所有客户端主动创建的房间列表。不同模式(mode)下的玩家不会被匹配到一起，开发者可以利用mode区分竞技模式，普通模式等游戏模式。开发者可以通过设置RoomFilter来对获取的房间进行过滤

## getRoomListResponse

```javascript
response.getRoomListResponse(status, [RoomInfoEx])
```

#### 参数

| 参数         | 类型     | 描述                                       | 示例值                                      |
| ---------- | ------ | ---------------------------------------- | ---------------------------------------- |
| status     | number | 状态返回，200表示成功，其他失败                        | 200                                      |
| RoomInfoEx | object | roomId:房间号;<br />roomName:房间名;<br />maxPlayer:最大玩家数;<br />mode:模式;<br />canWatch:是否可观战;<br />roomProperty:房间属性 | roomId:123333;<br />roomName:'roomName';<br />maxPlayer:3;<br />mode:0;<br />canWatch:1;<br />roomProperty:'roomProperty' |

#### 说明

- response是engine.getRoomList方法中传入的对象，getRoomList完成之后，会异步回调getRoomListResponse方法

## kickPlayer

```javascript
engine.kickPlayer(userId, cpProto)
```

#### 参数

| 参数      | 类型     | 描述    | 示例值    |
| ------- | ------ | ----- | ------ |
| userId  | number | 用户id  | 655444 |
| cpProto | string | 自定义数据 | “kick” |

#### 返回值

| 错误码  | 含义      |
| ---- | ------- |
| 0    | 成功      |
| -6   | 用户未加入房间 |

#### 说明

- 开发者通过该接口可以将用户踢出房间，让正确的用户加入自定义创建的房间里。

## kickPlayerResponse

```javascript
response.kickPlayerResponse(KickPlayerRsp)
```

#### 参数

| 参数            | 类型     | 描述                      | 示例值                         |
| ------------- | ------ | ----------------------- | --------------------------- |
| KickPlayerRsp | object | status:状态<br />owner:房主 | status:200<br />owner:65522 |

#### 说明

- response是engine.kickPlayerResponse方法中传入的对象，kickPlayer完成之后，会异步回调kickPlayerResponse方法

## kickPlayerNotify

```javascript
response.kickPlayerNotify(KickPlayerNotify)
```

#### 参数

| 参数               | 类型     | 描述                                       | 示例值                                      |
| ---------------- | ------ | ---------------------------------------- | ---------------------------------------- |
| KickPlayerNotify | object | srcUserId:踢人用户id<br />userId:被踢用户id<br />cpProto:自定义数据<br />owner:房主 | srcUserId:223333<br />userId:344222<br />cpProto:'kick'<br />owner:223333 |

#### 说明

- 某个玩家被踢之后，房间里的其它玩家会收到回调通知，response.kickPlayerNotify方法会被SDK调用，调用时传入的KickPlayerNotify是踢人的信息。

## subscribeEventGroup

```javascript
engine.subscribeEventGroup([subscribe], [unsubscribe])
```

#### 参数

| 参数          | 类型    | 描述    | 示例值         |
| ----------- | ----- | ----- | ----------- |
| subscribe   | array | 订阅组   | ["MatchVS"] |
| unsubscribe | array | 取消订阅组 | ["hello"]   |

#### 返回值

| 错误码  | 含义           |
| ---- | ------------ |
| 0    | 成功           |
| -20  | 订阅组和取消订阅组都为空 |
| -6   | 用户未加入房间      |

#### 说明

- 开发者通过该接口可以订阅和取消订阅相关的组。

## subscribeEventGroupResponse

```javascript
response.subscribeEventGroupResponse(status, [group])
```

#### 参数

| 参数     | 类型     | 描述         | 示例值         |
| ------ | ------ | ---------- | ----------- |
| status | number | 状态，200代表成功 | 200         |
| group  | array  | 组数组        | ["MatchVS"] |

#### 说明

- response是engine.subscribeEventGroupResponse方法中传入的对象，subscribeEventGroup完成之后，会异步回调engine.subscribeEventGroupResponse方法

## sendEventGroup

```
engine.sendEventGroup(cpProto, [group])
```

#### 参数

| 参数      | 类型     | 描述     | 示例值         |
| ------- | ------ | ------ | ----------- |
| cpProto | string | 自定义消息  | "test"      |
| group   | array  | 发送的组列表 | ["MatchVS"] |

#### 返回值

| 错误码  | 含义           |
| ---- | ------------ |
| 0    | 成功           |
| -20  | 发送的内容或发送的组为空 |

#### 说明

- 开发者可以通过该接口给对应的组发消息。

## sendEventGroupResponse

```
response.sendEventGroupResponse(status, dstNum)
```

#### 参数

| 参数     | 类型     | 描述         | 示例值  |
| ------ | ------ | ---------- | ---- |
| status | number | 状态，200代表成功 | 200  |
| dstNum | number | 推送的用户个数    | 5    |

#### 说明

- response是engine.sendEventGroupResponse方法中传入的对象，sendEventGroup完成之后，会异步回调engine.sendEventGroupResponse方法

## sendEventGroupNotify

```
response.sendEventGroupNotify(srcUid, [group], cpProto)
```

#### 参数

| 参数      | 类型     | 描述    | 示例值         |
| ------- | ------ | ----- | ----------- |
| srcUid  | number | 源用户id | 277773      |
| groups  | number | 组数组   | ["MatchVS"] |
| cpProto | string | 消息内容  | "test"      |

#### 说明

- response是engine.sendEventGroupNotify方法中传入的对象，收到订阅组的推送之后，会异步回调engine.sendEventGroupNotify方法

## setFrameSync

```
engine.setFrameSync(frameRate)
```

#### 参数

| 参数        | 类型     | 描述       | 示例值  |
| --------- | ------ | -------- | ---- |
| frameRate | number | 每秒钟同步的帧数 | 5    |

#### 返回值

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -20  | 帧数非法 |

#### 说明

- 开发者可以通过该接口设置帧同步的帧率。同步帧率有效范围在1≤n≤20，n=0代表取消帧同步。当设置的同步帧率不在合法范围内，将会收到 -20 的错误码。

## setFrameSyncResponse

```
response.setFrameSyncResponse(status)
```

#### 参数

| 参数     | 类型     | 描述   | 示例值  |
| ------ | ------ | ---- | ---- |
| status | number | 状态   | 200  |

#### 说明

- response是engine.setFrameSyncResponse方法中传入的对象，setFrameSync完成之后，会异步回调engine.setFrameSyncResponse方法

## sendFrameEvent

```
engine.sendFrameEvent(cpProto)
```

#### 参数

| 参数      | 类型     | 描述      | 示例值       |
| ------- | ------ | ------- | --------- |
| cpProto | string | 帧同步消息内容 | "message" |

#### 返回值

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -1   | 连接失败 |

#### 说明

- 开发者可以通过该接口发送帧同步消息。

## sendFrameEventResponse

```
response.sendFrameEventResponse(rsp)
```

#### 参数

| 参数   | 类型     | 描述         | 示例值  |
| ---- | ------ | ---------- | ---- |
| rsp  | object | mStatus:状态 | 200  |

#### 说明

- response是engine.sendFrameEventResponse方法中传入的对象，sendFrameEvent完成之后，会异步回调engine.sendFrameEventResponse方法

## frameUdpate

```
response.frameUdpate(frameIndex, frameWaitCount, [FrameItem])
```

#### 参数

| 参数             | 类型     | 描述                                       | 示例值                                      |
| -------------- | ------ | ---------------------------------------- | ---------------------------------------- |
| frameIndex     | number | 帧序号                                      | 10                                       |
| frameWaitCount | number | 等待帧数                                     | 5                                        |
| FrameItem      | object | srcUserId:发起方用户id<br />cpProto:自定义消息内容<br />timestamp:时间戳 | srcUserId:763333<br />cpProto:"test"<br />timestamp:3874747833 |

#### 说明

- frameUdpate是engine.frameUdpate方法中传入的对象，收到帧同步推送之后，会异步回调engine.frameUdpate方法

## joinRoomResponse

```javascript
response.joinRoomResponse(status, roomUserInfoList, roomInfo)
```

#### 参数

| 参数               | 类型     | 描述                | 示例值  |
| ---------------- | ------ | ----------------- | ---- |
| status           | number | 状态返回，200表示成功，其他失败 | 200  |
| roomUserInfoList | array  | 房间内玩家信息列表         |      |
| roomInfo         | object | 房间信息构成的对象         |      |

#### <span id="roomUserInfo">roomUserInfoList中每个元素包含的属性</span>

| 属性          | 类型     | 描述   | 示例值   |
| ----------- | ------ | ---- | ----- |
| userId      | number | 用户ID | 32322 |
| userProfile | string | 玩家简介 | ""    |

#### 参数roomInfo的属性

| 属性           | 类型     | 描述         | 示例值    |
| ------------ | ------ | ---------- | ------ |
| roomId       | number | 房间号        | 238211 |
| roomProperty | string | 房间属性       | ""     |
| ownerId      | number | 房间创建者的用户ID | 0      |

#### 说明
- 如果本房间是某个玩家调用joinRandomRoom随机加入房间时创建的，那么roomInfo中的ownerId为0。只有在调用engine.createRoom主动创建房间时ownerId才不为0。
- roomUserInfoList用户信息列表是本玩家加入房间前的玩家信息列表，不包含本玩家。
- roomUserInfoList中的玩家的userProfile的值来自于其他客户端调用joinRandomRoom时传递的userProfile的值。


## joinRoomNotify

```javascript
response.joinRoomNotify(roomUserInfo)
```

#### 参数

| 参数           | 类型     | 描述         | 示例值  |
| ------------ | ------ | ---------- | ---- |
| roomUserInfo | object | 房间新加的用户的信息 |      |

#### 说明
- 某个玩家加入房间之后，如果该房间后来又有其他玩家加入，那么将会收到回调通知，response.joinRoomNotify方法会被SDK调用，调用时传入的roomUserInfo是新加入的其他玩家的信息，不是本玩家的信息。
- roomUserInfo的属性与response.joinRoomResponse中的[roomUserInfoList中的元素包含的属性](#roomUserInfo)相同。



## <span id="joinOver">joinOver</span>

```javascript
engine.joinOver(cpProto)
```

#### 参数

| 参数      | 类型     | 描述   | 示例值  |
| ------- | ------ | ---- | ---- |
| cpProto | string | 负载信息 | ""   |

#### 返回值

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -1   | 失败   |

#### 说明

- 客户端调用该接口通知服务端：房间人数已够，不要再向房间加人。



## joinOverResponse

```javascript
response.joinOverResponse(joinOverRsp)
```

#### 参数joinOverRsp的属性

| 属性      | 类型     | 描述                | 示例值  |
| ------- | ------ | ----------------- | ---- |
| status  | number | 状态返回，200表示成功，其他失败 | 200  |
| cpProto | string | 负载信息              |      |

#### 说明
- 客户端调用engine.joinOver发送关闭房间的指令之后，SDK异步调用reponse.joinOverResponse方法告诉客户端joinOver指令的处理结果。



## <span id="leaveRoom">leaveRoom</span>

```javascript
engine.leaveRoom(cpProto)
```

#### 参数

| 参数      | 类型     | 描述   | 示例值  |
| ------- | ------ | ---- | ---- |
| cpProto | string | 负载信息 | ""   |

#### 返回值

| 错误码  | 含义   |
| ---- | ---- |
| 0    | 成功   |
| -1   | 失败   |

#### 说明

- 客户端调用该接口通知服务端该客户端对应的用户要离开房间。



## leaveRoomResponse

```javascript
response.leaveRoomResponse(leaveRoomRsp)
```

#### 参数leaveRoomRsp的属性

| 属性      | 类型     | 描述                | 示例值    |
| ------- | ------ | ----------------- | ------ |
| status  | number | 状态返回，200表示成功，其他失败 | 200    |
| roomId  | number | 房间号               | 317288 |
| userId  | number | 用户ID              | 317288 |
| cpProto | string | 负载信息              |        |

#### 说明
- 客户端调用engine.leaveRoom发送关闭房间的指令之后，SDK异步调用reponse.leaveRoomResponse方法告诉客户端leaveRoom指令的处理结果。



## leaveRoomNotify

```javascript
response.leaveRoomNotify(roomId, roomUserInfo)
```

#### 参数

| 参数           | 类型     | 描述           | 示例值  |
| ------------ | ------ | ------------ | ---- |
| roomId       | number | 房间号          | 200  |
| roomUserInfo | object | 刚刚离开房间的用户的信息 |      |

#### 说明
- 当同房间中的其他玩家调用leaveRoom发送离开房间的指令之后，本客户端将会收到回调通知，response.leaveRoomNotify方法会被SDK调用，调用时传入的roomUserInfo是离开房间的玩家的信息。
- roomUserInfo的属性与response.joinRoomResponse中的[roomUserInfoList中的元素包含的属性](#roomUserInfo)相同。



## <span id="sendEvent">sendEvent</span>

```javascript
engine.sendEvent(msg)
```

#### 参数

| 参数   | 类型     | 描述   | 示例值     |
| ---- | ------ | ---- | ------- |
| msg  | string | 消息内容 | "hello" |

#### 返回值
- 返回值为一个对象，该对象包含以下属性：

| 属性       | 类型     | 描述               | 示例值    |
| -------- | ------ | ---------------- | ------ |
| result   | number | 错误码，0表示成功，其他表示失败 | 0      |
| sequence | number | 事件序号，作为事件的唯一标识   | 231212 |

#### 说明

- 在进入房间后即可调用该接口进行消息发送，消息会发给房间里所有成员。
- 同一客户端多次调用engine.sendEvent方法时，每次返回的sequence都是唯一的。但同一房间的不同客户端调用sendEvent时生成的sequence之间会出现重复。


## sendEventEx

```javascript
engine.sendEventEx(type, cpProto, targetType, [targetUserId])
```

#### 参数

| 参数           | 类型     | 描述                                       | 示例值         |
| ------------ | ------ | ---------------------------------------- | ----------- |
| type         | number | 消息类型。0表示转发给房间成员；1表示转发给game server；2表示转发给房间成员及game server | 0           |
| cpProto      | string | 消息内容                                     | "hello"     |
| targetType   | number | 目标类型。0表示发送目标为目标列表成员；1表示发送目标为除目标列表成员以外的房间成员 | 0           |
| targetUserId | array  | 目标列表                                     | [1001,1002] |

#### 返回值

- 返回值为一个对象，该对象包含以下属性：

| 属性       | 类型     | 描述               | 示例值    |
| -------- | ------ | ---------------- | ------ |
| result   | number | 错误码，0表示成功，其他表示失败 | 0      |
| sequence | number | 事件序号，作为事件的唯一标识   | 231212 |

#### 说明

- 在进入房间后即可调用该接口进行消息发送，消息会发给房间里所有成员。
- 同一客户端多次调用engine.sendEvent方法时，每次返回的sequence都是唯一的。但同一房间的不同客户端调用sendEvent时生成的sequence之间会出现重复。


## sendEventResponse

```javascript
response.sendEventResponse(sendEventRsp)
```

#### 参数sendEventRsp的属性

| 属性       | 类型     | 描述                | 示例值    |
| -------- | ------ | ----------------- | ------ |
| status   | number | 状态返回，200表示成功，其他失败 | 200    |
| sequence | number | 事件序号，作为事件的唯一标识    | 231212 |

#### 说明
- 客户端调用engine.sendEvent发送消息之后，SDK异步调用reponse.sendEventResponse方法告诉客户端消息是否发送成功。



## sendEventNotify

```javascript
response.sendEventNotify(eventInfo)
```

#### 参数eventInfo的属性

| 参数        | 类型     | 描述                                    | 示例值     |
| --------- | ------ | ------------------------------------- | ------- |
| srcUserId | number | 推送方用户ID，表示是谁发的消息                      | 321     |
| cpProto   | string | 消息内容，对应[sendEvent](#sendEvent)中的msg参数 | "hello" |

#### 说明

- 在其他客户端调用engine.sendEvent方法之后，本客户端的response.sendEventNotify会被SDK调用，调用时传入其他玩家的用户ID和发送的消息。




