# 断线重连

Matchvs 提供了断线重连的功能：当客户端网络异常（包含网络关闭、弱网络、挂起至后台等情况），网络异常时应用层会收到“检测到客户端已经断线的`errorResponse` 错误码1001。此时可以调用SDK reconnect()接口进行重连（断线重连接口调用不要直接写在 errorReponse 回调后面，不然会出现反复断线反复重连死循环情况）。在reconnectResponse 接口可以得到重连的结果，如果调用重连成功，断线的用户将收到 reconnectResponse 接口返回 200 状态值，客户端需要把游戏定位到房间或者游戏界面还原游戏场景，其他用户会收到 networkStateNotify 接口的回调信息，根据 state 判断用户是否重连成功。 如果重连失败则会在 reconnectResponse 接口收到错误码，当错误码为 201 的时候说明你已经不能再加入房间了，这个时候你将处于已经登录状态，不用再次调用 login 接口。断线重连的时间默认用户断线20秒内可以重连回房间，如果超过20秒后，就不能重连回房间。



**断线重连超时时间默认是 20秒，可以由开发者自己调用 setReconnectTimeout 自己设置超时时间（可支持的SDK版本 v3.7.5.0+）** ，需要每次进入房间之前设置超时时间。

断线重连接口使用说明请看 [API文档](http://www.matchvs.com/service?page=JavaScript)    




重连频次 ： 每调用一次`reconnect()`会尝试重连一次，即从检测到断开开始，重连尝试20秒如果还没有重连成功，则会抛出失败消息。



![](http://imgs.matchvs.com/static/reconnect4.png)  



如果服务端检测到客户端网络异常，则服务端会通过`networkStateNotify`告诉其他客户端“检测到客户端C已断线，正在进行重连”。如果重连成功，服务端会通知其他客户端“客户端C已经重连成功”；如果重连失败，服务端会通知其他客户端“客户端C重连失败”。

![](http://imgs.matchvs.com/static/reconnect2.png)

## 接口使用

玩家断线20秒内可调用reconnect接口重连到原来房间，无论房间处于哪一种状态都可以连上。重连回房间使用方式有两种。

```
1、玩家断开20秒内马上 reconnect。
2、玩家断开后回到登录界面重新登录，loginResponse 返回参数 roomID 不为0 代表可以重新连接。这个时候调用reconnect 重连回房间。
```

> 注意：玩家断开后马上重连，不能写在 errorResponse 中，这样可能会出现无限重连的情况。最好是使用按钮，或者设置重连次数和重连触发时间。





