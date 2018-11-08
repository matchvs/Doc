# 如何使用Matchvs实现分享房间短号邀请加入指定房间的功能

## 流程图  

 

![flow](https://raw.githubusercontent.com/matchvs/Doc/master/flow.png)

高清示意图链接 (https://raw.githubusercontent.com/matchvs/Doc/master/flow.png)

##  流程说明:

1. 1. 以UserID作为房间短号,并以房间短号作为属性来创建房间 

2. 2. 通过微信/短信分享房间短号 

3. 3. 输入短号来加入指定房间 


#### 1. 以UserID作为房间短号,并以房间短号作为属性来创建房间

因为UserID是Matchvs的regist接口返回的,具有唯一性,且长度较小, 所以我们用userID作为房间短号来标识一个房间. 调用`createRoom`并设置房间属性
示意代码如下:

```javascript
 var userID = GameData.UserID;
 engine.createRoom({roomName:'',maxPlayer:4,mode:1,canWatch:1,visibilty:1,roomProperty:userID}, '', {})

```

#### 2. 通过微信/短信分享房间短号

微信如何分项数据, 可参考这篇文章(./微信约战[wechatInvite].md)

#### 3.输入短号来加入指定房间

收到短号的玩家通过建议的输入交互,输入房间短号,开发者拿到短号调用`joinRoomWithProperties` 即可达到邀请加入制定房间的目的.
示意代码:

```javascript
//相同属性的tags的玩家将会被匹配到一起。
engine.joinRoomWithProperties(
{maxPlayer:4,mode:0, canWatch:1,tags:'9527'}
, "");
```

