## Demo扩展简介

Demo扩展在Demo的基础上增加了自定义属性匹配、查看房间列表、加入指定房间和创建房间的功能

体验链接：<http://cocos.matchvs.com/cocos-matchvs-demo/web-desktop-extendex/>

**注意**：满三人才可以开始游戏，下载Demo扩展源码后，需使用Cocos Creator打开工程（建议使用1.7.0及以上版本）。

## 自定义属性匹配

Matchvs提供了属性匹配功能，开发者可以利用该功能实现各种自定义的规则匹配。

属性匹配机制：

开发者可以将需要使用的匹配参数例如 “等级：5-10 ” “地图 ： A” 以 key-value 的方式填至 `matchInfo`，Matchvs 将会严格对比各个玩家携带的 `matchInfo`，然后将`matchInfo`一致的用户匹配到一起。

如果用户当前匹配不到合适的对象，Matchvs 会创建一个房间给该用户。如果开发者想扩大范围再次进行匹配，可以退出当前房间，修改`matchInfo`，然后发起匹配。

如果开发者希望将用户的个人信息（比如：昵称、等级）广播给成功匹配到的房间成员，可以将这些信息填至`userProfile` 。Matchvs会在每一个成员加入房间时将成员信息广播给当前房间成员，同时将已有成员的信息通知给新加入成员。

**注意** 属性匹配不会匹配到客户端主动创建（通过`createRoom()`创建）的房间里。

用户在demo里成功登录后，点击demo游戏大厅的自定义属性匹配后，选择属性A或属性B，即可进行属性匹配，选择属性A的玩家只会和其他也选择属性A的玩家匹配到一起。  

代码如下:

```javascript
// 文件路径：assets\scripts\SelfDefMatch.js
cc.Class({
    onLoad () {
        var self = this;
        this.startMatch.on(cc.Node.EventType.TOUCH_END, function(event){
          // ...
          var tagsInfo;
          if (self.odd.isChecked) {
            tagsInfo={"title": "A"};
            self.labelLog('设置标签A');
          } else {
            tagsInfo={"title": "B"};
            self.labelLog('设置标签B');
          } 
          mvs.response.joinRoomResponse = self.joinRoomResponse.bind(self);
          var matchinfo = new mvs.MatchInfo();
          matchinfo.maxPlayer = GLB.MAX_PLAYER_COUNT;
          matchinfo.mode = 0;
          matchinfo.canWatch = 0;
          matchinfo.tags = tagsInfo;
          mvs.engine.joinRoomWithProperties(matchinfo, "joinRoomWithProperties");
          // ...
        });
    },
    joinRoomResponse: function(status, userInfoList, roomInfo) {
        // 加入房间成功，status表示结果，roomUserInfoList为房间用户列表，roomInfo为房间信息
        // ...
    },
    // ...
})
```

## 加入指定房间

Matchvs提供了加入指定房间的功能，在获取到房间ID后即可以通过此接口加入该房间。

**例如** 如果玩家希望和好友一起游戏，则可以创建一个房间后，将该房间ID发给好友，好友通过该ID进入房间。

demo里玩家可以输入房间号加入指定房间，与特定的玩家比赛。

代码如下:

```javascript
// 文件路径：assets\scripts\JoinCertainRoom.js
cc.Class({
    onLoad () {
        var self = this;
        // ...
        this.match.on(cc.Node.EventType.TOUCH_END, function(event){
            var roomidTmp = self.roomID.string;
            self.labelLog("开始加入指定房间, roomid:" + roomidTmp);
            mvs.response.joinRoomResponse = self.joinRoomResponse.bind(self);
            mvs.engine.joinRoom(roomidTmp, "joinRoomSpecial");          
        });
    },
    joinRoomResponse: function(status, userInfoList, roomInfo) {
        // 加入房间成功，status表示结果，roomUserInfoList为房间用户列表，roomInfo为房间信息
        // ...
    },  
})
```

## 获取房间列表

Matchvs提供了获取房间列表的功能，该列表为用户主动创建的房间列表。

开发者可以通过房间属性过滤获取房间列表。比如只想获取地图为A的所有房间列表，可以将地图A作为过滤条件来获取列表。

demo里玩家成功登录后，玩家可以获取当前游戏里客户端主动创建的房间列表。  

代码如下:

```javascript
// 文件路径：assets\scripts\roomList.js
cc.Class({
    onLoad () {
        mvs.response.getRoomListResponse = this.getRoomListResponse.bind(this);
        var roomFilter = new mvs.RoomFilter();
        roomFilter.maxPlayer = GLB.MAX_PLAYER_COUNT;
        roomFilter.mode = 0;
        roomFilter.canWatch = 0;
        roomFilter.roomProperty = "2v2";
        mvs.engine.getRoomList(roomFilter);
    },
    getRoomListResponse: function (status, roomInfos) {
        // 获取房间列表结果，status表示结果，roomInfos为房间列表
        // ...
    },
    // ...
})
```

## 创建房间

Matchvs提供了创建房间的功能，开发者可以从客户端主动创建一个房间。

玩家创建房间后，Matchvs 会将该玩家自动加入此房间，该玩家即是房主。如果房主离开了房间，Matchvs会随机指定下一个房主并通知给房间所有成员。

在创建房间的时候可以指定该房间的属性，比如房间地图、房间人数等。

**注意**  玩家主动创建的房间和Matchvs 创建的房间是分开的。玩家通过随机匹配或者属性匹配无法匹配到主动创建的房间里。

demo里玩家成功登录后，玩家可以主动创建房间。  

代码如下:

```javascript
// 文件路径：assets\scripts\Lobby.js
cc.Class({
    onLoad () {
        // 创建房间
        this.createRoom.on(cc.Node.EventType.TOUCH_END, function(event){
            var create = new mvs.CreateRoomInfo();
            create.name = 'roomName';
            create.maxPlayer = GLB.MAX_PLAYER_COUNT;
            create.mode = 0;
            create.canWatch = 0;
            create.visibility = 1;
            create.roomProperty = 'roomProperty';
            mvs.response.createRoomResponse = self.createRoomResponse.bind(self);
            mvs.engine.createRoom(create, 'userProfile');
            // ...
        });
    },
    createRoomResponse: function(rsp) {
        // 加入房间成功，rsp.status表示结果，rsp.roomId为创建的房间号
        // ...
    },
    // ...
})
```

## 踢人

Matchvs提供了踢人的功能，玩家可以把房间内的玩家踢出房间。

demo里玩家成功创建房间后，玩家选择指定的用户并把他踢出房间。  

代码如下:

```javascript
// 文件路径：assets\scripts\createRoom.js
cc.Class({
    onLoad () {
        // ...
        this.kickPlayer2.on(cc.Node.EventType.TOUCH_END, function(event){
            var result = mvs.engine.kickPlayer(self.labelUserID2.string, '');
            if (result !== 0)
                return self.labelLog('踢人失败,错误码:' + result);
            mvs.response.kickPlayerResponse = self.kickPlayerResponse.bind(self);
            if (self.labelUserID2.string === self.labelUserID2.string) {
                self.labelUserID2.string = '';
            } else if (self.labelUserID3.string === self.labelUserID2.string) {
                self.labelUserID3.string = '';
            }
        });
    },
    kickPlayerResponse: function (rsp) {
        this.labelLog('kickPlayerResponse:' + JSON.stringify(rsp));
        var status = rsp.status;
        if (status !== 200) {
            return this.labelLog('踢人失败,异步回调错误码: ' + status);
        } else {

        }
    },
    // ...
})
```

## 消息订阅

在游戏中由于用户所在场景、队伍不同，游戏数据不必每次都广播给房间内所有成员。Matchvs 提供了消息订阅分组的机制，开发者可以将不同类型的消息进行分组，然后动态地让用户订阅或者取消订阅消息。这样可以很方便地实现消息管理同时节省流量。

当用户订阅某个消息组后，所有该消息组的内容用户均可以收到；如果取消订阅，则不会再收到该组消息。

**注意** 如果用户主动离开房间，则之前订阅的消息会自动被取消。如果用户再次进入该房间或其他房间，都需要重新订阅消息。

订阅消息代码如下:

```javascript
// 文件路径：assets\scripts\Game.js
cc.Class({
    onLoad () {
        var self = this;
        this.buttonSubscribe.on(cc.Node.EventType.TOUCH_END, function(event){
            var result = mvs.engine.subscribeEventGroup(["MatchVS"], ["hello"])
            if (result !== 0) 
                self.labelLog('订阅分组失败,错误码:' + result);
            mvs.response.subscribeEventGroupResponse = self.subscribeEventGroupResponse.bind(self);
        });
    },
    subscribeEventGroupResponse: function (status,groups) {
        this.labelLog("[Rsp]subscribeEventGroupResponse:status="+ status+" groups="+ groups);
    },
    // ...
})
```

发送分组消息代码如下:

```javascript
// 文件路径：assets\scripts\Game.js
cc.Class({
    onLoad () {
        var self = this;
        this.buttonSend.on(cc.Node.EventType.TOUCH_END, function(event){
            var result = mvs.engine.sendEventGroup("分组消息测试", ["MatchVS"])
            if (result !== 0)
                self.labelLog('发送分组消息失败,错误码:' + result);
            mvs.response.sendEventGroupResponse = self.sendEventGroupResponse.bind(self);
            mvs.response.sendEventGroupNotify = self.sendEventGroupNotify.bind(self);
        });
    },
    sendEventGroupResponse: function (status, dstNum) {
        this.labelLog("[Rsp]sendEventGroupResponse:status="+ status+" dstNum=" + dstNum);
    },
    sendEventGroupNotify: function (srcUid, groups, cpProto) {
        this.labelLog("收到分组消息：" + cpProto);
    },
})
```

## 帧同步

在游戏中由于不同用户的网络延迟，会导致房间内用户收到的画面不一致，通过帧同步可以解决这个问题。
Matchvs 所提供的帧同步能力，让您可以根据游戏需要，直接设置同步帧率，比如10帧每秒，然后您可以调用发送帧同步数据的接口来发送逻辑帧数据。
Matchvs 会缓存每100毫秒的数据，将这100毫秒的数据作为一帧发给各个客户端。
![](http://imgs.matchvs.com/static/frame.png)  

**注意** 用户需在客户端保存状态信息

帧同步代码如下:

```javascript
// 文件路径：assets\scripts\Game.js
cc.Class({
    onLoad () {
        // ...
        if (GLB.syncFrame === true && GLB.isRoomOwner === true) {
            mvs.response.setFrameSyncResponse = self.setFrameSyncResponse.bind(self);
            var result = mvs.engine.setFrameSync(GLB.FRAME_RATE);
            if (result !== 0)
                this.labelLog('设置同步帧率失败,错误码:' + result);
        }
    },
    setFrameSyncResponse: function (status) {
        this.labelLog('setFrameSyncResponse, status=' + status);
        if (status !== 200) {
            this.labelLog('设置同步帧率失败，status=' + status);
        } else {
            this.labelLog('设置同步帧率成功, 帧率为:' + GLB.FRAME_RATE);
        }
    },
    frameUdpate: function(frameIndex, frameWaitCount, FrameItems) {
        for (var i = 0 ; i < FrameItems.length; i++) {
            var info = FrameItems[i];
            if (info && info.cpProto) {
            }
            // ...
        }
    },
})
```

## 获取房间列表-扩展

Matchvs提供了获取房间列表的功能，该列表为用户主动创建（通过调用createRoom() 创建）的房间列表。
房间列表里会提供房间的部分信息：房间最大人数、房间当前已有人数、房间状态（开放或关闭）等信息。
房间状态指的是该房间有没有被`JoinOver` ，如果房间内调用过`JoinOver()` 则房间状态为关闭；否则房间为开放状态（即使此时房间已满）。
你可以定义获取房间的类型和序列，比如获取 “未满且未关闭的所有房间，按照当前人数降序排列”。
你也可以通过房间属性过滤获取房间列表。比如只想获取地图为A的所有房间列表，可以将包含地图A的完整房间属性作为过滤条件来获取列表。

```javascript
// 文件路径：assets\scripts\roomList.js
getRooomList () {
    mvs.engine.getRoomListEx(RoomFilterEx);
},

getRoomListExResponse: function(roomListExInfo) {
    refreshNum ++;
    this.refreshNumText.string = '获取列表次数'+ refreshNum;
    for (var i = 0; i < 3; i++) {
        this.roomIDs[i].string = "";
        this.stateS[i].string = "";
        this.stateS[i].string = "";
        this.gamePlayerS[i].string = "";
        this.maps[i].string = "";
        this.buttonS[i].active = false;
    }
    for(var i = 0; i < roomListExInfo.total; i++) {
        this.roomIDs[i].string = roomListExInfo.roomAttrs[i].roomID;
        this.buttonS[i].active = true;
        var state = roomListExInfo.roomAttrs[i].state;
        if (state == 1) {
            this.stateS[i].string = "开放";
        } else {
            this.stateS[i].string = "关闭";
        }
        this.maps[i].string = roomListExInfo.roomAttrs[i].roomProperty;
        this.gamePlayerS[i].string = roomListExInfo.roomAttrs[i].gamePlayer+"/"+roomListExInfo.roomAttrs[i].maxPlayer;
    }
},
```

## 获取房间详情

Matchvs 提供了获取房间详情的接口，你可以在加入房间之后随时获取房间当前的各种状态：房间成员列表、成员简介、房间状态等。
每次调用接口获取的是该房间的全部信息，该接口在客户端和gameServer均可以被调用。
房间状态指的是该房间有没有被`JoinOver`，如果房间内调用过`JoinOver() `，则房间状态为关闭；否则房间为开放状态（即使此时房间已满）。

```javascript
// 文件路径：assets\scripts\GameRoom.js
var result = mvs.engine.getRoomDetail(GLB.roomId);

getRoomDetailResponse : function (roomDetailRsp) {
    if (roomDetailRsp.status === 200) {
        this.labelLog("获取房间详情成功");
        mvs.response.joinRoomNotify = this.joinRoomNotify.bind(this);
        mvs.response.leaveRoomNotify = this.leaveRoomNotify.bind(this);
        this.mapString.string = roomDetailRsp.roomProperty;
        if (roomDetailRsp.roomProperty === '白天模式') {
            this.seleButton.getChildByName("Label").getComponent(cc.Label).string = '切换为黑夜模式';
        } else {
            this.seleButton.getChildByName("Label").getComponent(cc.Label).string = '切换为白天模式';
        }
        GLB.mapType = roomDetailRsp.roomProperty;
        for (var i = 0; i < roomDetailRsp.userInfos.length; i++) {
            if (roomDetailRsp.userInfos[i].userId !== GLB.userInfo.id) {
                this.userIds.push(roomDetailRsp.userInfos[i].userId);
            }
            GLB.playerSet.add(Number(roomDetailRsp.userInfos[i].userId));
        }
        for (var i = 0; i < this.userIds.length; i++) {
            this.labelUserIDs[i].string = this.userIds[i];
        }
    } else {
        this.labelLog("获取房间详情失败");
    }
},

```

## 修改房间属性

当玩家进入房间后，可以通过“房间属性”来记录共享信息，比如玩家序列、房间地图等。

修改房间属性后，其他玩家会收到修改通知。

当新玩家进入房间时，修改后的房间属性也会通知给他。

修改房间属性后，获取到的房间列表里的属性也会随之相应修改。

修改房间属性代码如下:

```javascript
// 文件路径：assets\scripts\createRoom.js
this.seleButton.on(cc.Node.EventType.TOUCH_END, function(event){
    mvs.response.setRoomPropertyResponse = self.setRoomPropertyResponse.bind(self);
    var mapType = self.mapString.string;
    if (mapType === '白天模式') {
        mvs.engine.setRoomProperty(GLB.roomId,"黑夜模式");
    } else {
        mvs.engine.setRoomProperty(GLB.roomId,"白天模式");
    }
});

setRoomPropertyResponse: function (rsp) {
    var status = rsp.status;
    if (status !== 200) {
        return this.labelLog('修改房间属性失败,异步回调错误码: ' + status);
    } else {
        if (rsp.roomProperty === '白天模式') {
            this.mapString.string = rsp.roomProperty;
            GLB.mapType = rsp.roomProperty;
            this.seleButton.getChildByName("Label").getComponent(cc.Label).string = '切换黑夜模式';

        } else {
            this.mapString.string = rsp.roomProperty;
            GLB.mapType = rsp.roomProperty;
            this.seleButton.getChildByName("Label").getComponent(cc.Label).string = '切换为白天模式';
        }
    }
},
```

