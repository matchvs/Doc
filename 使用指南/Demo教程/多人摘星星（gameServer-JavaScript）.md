## Demo简介

JavaScript 版本的 gameServer 模式的 Demo。开发者可以前往[下载Demo代码](http://www.matchvs.com/serviceCourse) 代码中包含了gameServer 相关的处理逻辑。

**注意：**  creator 商店下载的 Matchvs 插件版本需要V1.1，如果插件版本为V1.0，Demo运行将会报错。

## gameServer模式

### 非gameServer模式

在不采用gameServer模式下，全部游戏逻辑都是在客户端处理。例如摘星星Demo，在玩家加入房间后，客户端需要处理：禁止加入房间，开始游戏，星星生成位置，获取星星以及累计加分等逻辑。

### gameServer模式

采用 gameServer 模式，我们将禁止加入房间，开始游戏，星星生成位置，获取星星以及累计加分等这些游戏逻放在服务器来处理。客户端只需要告诉 gameServer 玩家已经准备好游戏以及玩家的移动位置。具体如何生成星星，如何加分等逻辑在服务器中处理即可。

gameServer可参考[gameServer接入流程](http://www.matchvs.com/service?page=processgameServerJS)以及[gameServer使用指南](http://cn.matchvs.com/service?page=guideJSgameServer)。

## Demo 解析

### 运行Demo  等待开始游戏

 在cocos create 打开下载好的 Demo 里的 client 项目， 点击运行按钮即可。Demo设定的是三个人才能开始的游戏，故需打开三个客户端（**注意：** 是三个不同浏览器或者三台不同设备，因为注册后会在本地缓存用户信息）。打开游戏后是等待游戏开始，如下界面：

![](http://imgs.matchvs.com/static/creatorlogin.png)

初始化，注册用户，登录游戏，加入房间处理都是需要在客户端处理的逻辑，相关实现可参考[creator 快速入门](http://cn.matchvs.com/service?page=QuickstartCreator)和[creator 接入指南](http://cn.matchvs.com/service?page=guideCreator)。

**注意：** client 和 server 里的gameID信息需保持一致；如果想要提交 gameServer 并运行，则需要将 gameServer 和 client 里的gameID以及端口号**信息修改为自己在官网控制台获取的信息**，同时需要**将所用的游戏发布上线**。具体修改方法可参考[gameServer接入流程](http://www.matchvs.com/service?page=processgameServerJS)里的基本配置以及[creator 快速入门](http://www.matchvs.com/service?page=QuickstartCreator)里的`init()`及`login()`。



当加入房间后，就给服务器发送玩家已准备好的信息等待服务器回复开始游戏的信息。相关代码如下：

- 客户端处理：收到加入房间成功的信息，就给服务器发送准备游戏的信息

```javascript
// demo\client\assets\scripts\Lobby.js


//加入房间后Matchvs服务返回加入房间回调 joinRoomResponse
joinRoomResponse: function (status, userInfoList, roomInfo) {
    if (status !== 200) {
        return this.labelLog('进入房间失败,异步回调错误码: ' + status);
    } else {
        this.labelLog('进入房间成功');
        this.labelLog('房间号: ' + roomInfo.roomId);
    }
    //记录用户ID
    var userIds = [GLB.userInfo.id]
    userInfoList.forEach(function(item) {if (GLB.userInfo.id !== item.userId) userIds.push(item.userId)});
    this.labelLog('房间用户: ' + userIds);
    // 设置事件接收的回调
    mvs.response.sendEventNotify = this.sendEventNotify.bind(this); 
    GLB.playerUserIds = userIds;
    //发送准备信息给gameServer
    this.gameReady();
    if (userIds.length >= GLB.MAX_PLAYER_COUNT) {
        //设置最后一个加入的为房主
        GLB.isRoomOwner = true; 
    }
}

gameReady: function(){
    var event = {
        action : GLB.GAME_READY
    };
    mvs.response.sendEventResponse = this.sendEventResponse.bind(this);// 设置事件发射之后的回调
    /**
         * param 1 : msType 0-客户端+not CPS    1-not 客户端+CPS   2-客户端+CPS
         * param 2 : 用户数据
         * param 3 : destType 可默认为0
         * param 4 : 发送的userID集合
         */
    var result = mvs.engine.sendEventEx(1,JSON.stringify(event), 0, GLB.playerUserIds);
    if (result.result !== 0)
        return this.labelLog('发送游戏准备通知失败，错误码' + result.result);
    GLB.events[result.sequence] = event;
    this.labelLog("发起游戏开始的通知，等待回复");
}
```

- gameServer：gameServer的开发流程和使用可以参考[gameServer接入流程](http://cn.matchvs.com/service?page=processgameServerJS)以及[gameServer使用指南](http://cn.matchvs.com/service?page=guideJSgameServer)收到游戏准备的消息检查房间内是否所有人都已经准备。如果准备好就禁止房间再加入，发送开始游戏消息通知每个用户。

```javascript
//  demo\server\src\room.js

	/** 
     * 房间事件
     * @param {number} userid 
     * @param {string} event 
     * @memberof Room
     */
    roomEvent(userid, event) {
			......
            switch (action) {
                ......
                case glb.GAME_READY://收到准备消息
                    player = this.players.get(userid);
                    if (player) {
                        player.ready = true;
                        this.checkGameStart(userid);//检查是否人满
                    }
                    log.info('receive game ready:', userid);
                    break;
				......
            }
        }
    }

	/**
     * 检查房间内是否所有人都已经准备
     * @param {number} userid
     * @memberof Room
     */
    checkGameStart(userid) {
        if (!this.isStarted && this.players.size >= glb.MAX_PLAYER_COUNT) {
            let allReady = true;
            for (let [k, p] of this.players) {
                if (!p.ready) {
                    allReady = false;
                }
            }
            if (allReady) {
                // 房间停止加人
                this.pushHander.joinOver({
                    gameid: this.gameid, 
                    roomid: this.roomid,
                    userid: userid,
                });
                // 通知房间内玩家开始游戏
                this.notifyGameStart();
                this.isStarted = true;
            }
        }
    }

	/**
     * 通知客户端开始游戏
     * @memberof Room
     */
    notifyGameStart() {
        let userIds = [];
        for (let id of this.players.keys()) {
            userIds.push(id);
        }
        let event = {
            action: glb.GAME_START_EVENT,
            userIds: userIds,
        }
        this.sendEvent(event);
        log.info('notifyGameStart event:', event);
    }
```

### 客户端收到gameServer开始游戏消息

- 客户端收到开始游戏的消息，切换到游戏界面。

```javascript
// demo\client\assets\scripts\Lobby.js


	//收到消息开始游戏的异步回调
	sendEventNotify: function (info) {
        if (info
            && info.cpProto
            && info.cpProto.indexOf(GLB.GAME_START_EVENT) >= 0) {

            GLB.playerUserIds = [GLB.userInfo.id]
            // 通过游戏开始的玩家会把userIds传过来，这里找出所有除本玩家之外的用户ID，
            // 添加到全局变量playerUserIds中
            JSON.parse(info.cpProto).userIds.forEach(function(userId) {
                if (userId !== GLB.userInfo.id) GLB.playerUserIds.push(userId)
            });
            this.startGame()
        }
    }
```

- 切换到游戏界面，并发送游戏场景信息给gameServer

```javascript
//  demo\client\assets\scripts\Game.js


	onLoad: function () {
        ......
        //设置回调
        mvs.response.sendEventNotify = this.sendEventNotify.bind(this);
        //发送游戏场景信息给gameServer
        this.spawnNewStarFromServer();
		......
    }
        
    spawnNewStarFromServer: function () {
        if (!GLB.isRoomOwner) return;    // 只有房主可发送场景信息

        var event = {
            action: GLB.SCENE_INFO,
            starMaxX: this.starMaxX,
            groundY: this.groundY,
            playerJumpHeight: this.playerJumpHeight,
            compensation: this.compensation,
            pickRadius: this.pickRadius //用来判断获取星星时最近距离
        };

        /**
         * param 1 : msType 0-客户端+not CPS    1-not 客户端+CPS   2-客户端+CPS
         * param 2 : 用户数据
         * param 3 : destType 可默认为0
         * param 4 : 发送的userID集合
         */
        var result = mvs.engine.sendEventEx(1,JSON.stringify(event), 0, GLB.playerUserIds);
        if (!result || result.result !== 0)
            return console.error('创建星星事件发送失败');
    }
```

- gameServer 收到游戏场景信息，生成信息的位置发送给客户端。

```javascript
//  demo\server\src\room.js


	/**
     * 房间事件
     * @param {number} userid 
     * @param {string} event 
     * @memberof Room
     */
    roomEvent(userid, event) {
        ......
            switch (action) {
                case glb.SCENE_INFO:
                    this.scene.starMaxX = event.starMaxX;
                    this.scene.groundY = event.groundY;
                    this.scene.playerJumpHeight = event.playerJumpHeight;
                    this.scene.compensation = event.compensation;
                    this.scene.pickRadius = event.pickRadius;
                    log.info('receive scene info:', event);
                    // 初始化星星
                    this.spawnNewStar();
                    break;
                ......
            }
        }
    }

	/**
     * 生成“新星星”
     * @memberof Room
     */
    spawnNewStar() {
        this.getNewStarPosition();
        let event = {
            action: glb.NEW_START_EVENT,
            x: this.star.x,
            y: this.star.y,
        }
        this.sendEvent(event);
        log.info('spawnNewStar event:', event);
    }
```

### 客户端生成星星，并且控制游戏角色

- 客户端收到生成星星的位置，显示星星。

````javascript
//  demo\client\assets\scripts\Game.js


sendEventNotify: function (info) {
	......
    if (info.cpProto.indexOf(GLB.NEW_START_EVENT) >= 0) {
        // 收到创建星星的消息通知，根据消息给的坐标创建星星
        var piz = JSON.parse(info.cpProto);
        this.createStarNode(cc.p(piz.x, piz.y))

    }
    ......
}
````

- 客户端角色移动(定时)发送位置信息给gameServer

```javascript
	onLoad: function () {
        setInterval(() => {
            mvs.engine.sendEventEx(2,JSON.stringify({
                action: GLB.PLAYER_POSITION_EVENT,
                x: this.node.x,
                y: this.node.y,
                xSpeed: this.xSpeed,
                accLeft: this.accLeft,
                accRight: this.accRight,
                ts: new Date().getTime()
            }),1,[]);
           ......
        }, 200);

        // 初始化键盘输入监听
        ......
    }
```

### gameServer 处理玩家位置

- gameServer 收到玩家位置，判断是否能收集星星，获取分数，玩家获得星星就发送消息给客户端创建星星。并且发送获得分数信息给玩家。

```javascript
//  demo\server\src\room.js


	/**
     * 房间事件
     * @param {number} userid 
     * @param {string} event 
     * @memberof Room
     */
    roomEvent(userid, event) {
        ......
            switch (action) {
               case glb.PLAYER_POSITION_EVENT:
                    player = this.players.get(userid);
                    if (player) {
                        player.position.x = event.x;
                        player.position.y = event.y;
                        this.checkStar(userid, player);
                    }
                    break;
                ......
            }
        }
    }
	/**
     * 判断星星是否被收集
     * @param {number} userid 
     * @param {Object} player 
     * @param {number} player.score
     * @param {Object} player.position
     * @param {number} player.position.x
     * @param {number} player.position.y
     * @memberof Room
     */
    checkStar(userid, player) {
        if (this.getDistanceSQ(player.position) < this.scene.pickRadius * this.scene.pickRadius) {
            player.score += 1;
            let event = {
                action: glb.GAIN_SCORE_EVENT,
                userId: userid,
                score: player.score,
            }
            log.info('send gain score event:', event);
            this.sendEvent(event);
            
            // 产生新星星 
            this.spawnNewStar();
        }
    }
```

### 客户端显示分数

- 客户端收到用户获得分数的信息，进行分数展示。

```javascript
//  demo\client\assets\scripts\Game.js


	sendEventNotify: function (info) {
        if (info && info.cpProto) {
            ......
            if (info.cpProto.indexOf(GLB.GAIN_SCORE_EVENT) >= 0) {
                // 收到其他玩家的得分信息，更新页面上的得分数据
                var cpproto = JSON.parse(info.cpProto);
                if(cpproto.userId === GLB.userId ){
                    this.gainScore();
                }else{
                    //更新其他玩家的分数
                    var playerIndex = this.getPlayerIndexByUserId(cpproto.userId);
                    var label = GLB.playerUserIds[playerIndex - 1] + ': ' + cpproto.score;
                    this.scoreDisplays[playerIndex - 1].string = label;
                }
            }
        }
    }
```

