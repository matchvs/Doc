# 如何使用Matchvs实现分享房间短号(二维码)邀请加入指定房间的功能

## 流程图  

 

![flow](https://raw.githubusercontent.com/matchvs/Doc/master/flow.png)

高清示意图链接 (https://raw.githubusercontent.com/matchvs/Doc/master/flow.png)

##  流程说明:

- 以UserID作为房间短号,并以房间短号作为属性来创建房间 
- 通过微信/短信/二维码分享房间短号 
- 输入短号来加入指定房间 

## 流程详解

#### 1. 以UserID作为房间短号,并以房间短号作为属性来创建房间

因为UserID是Matchvs的regist接口返回的,具有唯一性,且长度较小, 所以我们用userID作为房间短号来标识一个房间. 调用`createRoom`并设置房间属性
示意代码如下:

```javascript
 var userID = GameData.UserID;

 engine.createRoom({roomName:'',maxPlayer:4,mode:1,canWatch:1,visibilty:1,roomProperty:userID}, '', {})

```
> 注意：创建房间的时候，如果定向约战，不希望被非目标用户加入，可以设置visbility:0，否则可能被其他用户通过房间列表(getRoomList接口)看到并加入

#### 2. 通过微信/短信/二维码分享传播房间短号

#### 微信分享:

微信如何分享数据, 可参考这篇文章(./微信约战[wechatInvite].md)



短信分享:

#### 3.输入短号来加入指定房间

收到短号的玩家通过建议的输入交互,输入房间短号,开发者拿到短号调用`joinRoomWithProperties` 即可达到邀请加入制定房间的目的.
示意代码:

```javascript
//相同属性的tags(即房间属性)的玩家将会被匹配到一起。

engine.joinRoomWithProperties(
{maxPlayer:4,mode:0, canWatch:1,tags:'9527'}
, "");//9527为邀请者的userID,即为加入指定房间的房间短号
```

