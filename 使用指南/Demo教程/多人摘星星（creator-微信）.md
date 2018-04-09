## 准备

利用CocosCreator开发微信小游戏需要下载如下软件:

[微信开发工具](https://dldir1.qq.com/WechatWebDev/1.0.0/201801080/wechat_devtools_1.02.1801080_x64.exe)
[CocosCreator](http://cocos2d-x.org/filedown/CocosCreator_v1.8.1_win)

## 打开项目

1 解压`<Weixin-MatchvsCocosDemoJs.rar>`文件为目录
2 使用CocosCreatorv1.8.1以上的版本打开步骤1中的目录,如下图所示:
![wxdev-open](http://imgs.matchvs.com/static/wx/wxdev-open.png)

## 编译并发布

1 如下图所示选择下拉框中`WeChatGame`选项,点击`构建`,编译微信小游戏平台
2 点击运行拉起`微信开发工具`
![wxdev-build](http://imgs.matchvs.com/static/wx/wxdev-build.png)

**注意第一次运行,需要使用微信开发工具手动添加工程 如下图所示**:
![wxdev-firstopen](http://imgs.matchvs.com/static/wx/wxdev-firstopen.png)

另外需要注意的是,当前微信小游戏只对企业开发者账号开放.还不能正式发布.
![wxdev-running](http://imgs.matchvs.com/static/wx/wxdev-running.png)

## 设置

1 如下图所示,对`微信开发工具`开发工具进行设置.

![wxdev-setting](http://imgs.matchvs.com/static/wx/wxdev-setting.png)

## 运行

1 如下图所示,点击编译按钮,运行代码,启动游戏画面,
由于Demo必须要3个玩家同时在线,所以我们使用`cocoscreator`运行web平台的两个示例,与微信小游戏平台进行配对,对战.
![wxdev-running](http://imgs.matchvs.com/static/wx/wxdev-running.png)

注意事项
	1:在CococCreate中修改代码如果发现在微信小游戏中不生效. 则需要彻底杀死CocosCreator和微信开发工具进程(任务管理器). 同时删除 ./project/build/的所有文件.重新编译发布
	2:在微信小游戏中使用Matchvs-JS SDK 需要注意引用的js库带有.weixin后缀.
如下图所示:
```
//如果是微信小游戏平台则加载matchvs.all.weixin库
	jsMatchvs = require("matchvs.all.weixin")

//其他平台(browser)则加载matchvs.all库
	jsMatchvs = require("matchvs.all")
```
![wxdev-tip-library](http://imgs.matchvs.com/static/wx/wxdev-tip-library.png)

3:调用SDK的注册接口会缓存返回的注册信息，如果用户没有清除缓存数据，用户调用注册接口会拿到同一个用户信息。只有清除缓存数据才能注册新的用户信息。开发工具清除缓存数据如下图：

![](http://imgs.matchvs.com/static/wx/wxdev-cache.png)



## 效果展示

![wxdev-shotscreen](http://imgs.matchvs.com/static/wx/wxdev-shotscreen.png)



## 远端数据存储能力

SDK本身不提供远端的数据存储能力，但是我们提供了hashSet和hashGet 两个http接口可实现数据的存取功能。下面对两个接口的使用进行简单的说明，具体可参照 [API说明](http://cn.matchvs.com/service?page=APICocos)

#### hashSet 数据存储

接口地址：js-sdk的对象 HttpConf.VS_OPEN_URL

> HttpConf.VS_OPEN_URL 是js-sdk的对象，是一些http接口的host地址，HttpConf.VS_OPEN_URL 值是在调用js-sdk的init接口时赋值的，开发者调用 init接口时传入不同的channle和platform 对象HttpConf.VS_OPEN_URL 的值也不同。

接口路径：/wc5/hashSet.do?

请求参数：

| 参数名 | 说明                 |
| ------ | -------------------- |
| gameID | 游戏ID               |
| userID | 用户ID               |
| key    | 自定义存储字段编号   |
| value  | 自定义存储字段的值   |
| sign   | 请看下面sign拼接方法 |

返回参数：

| Key    | 含义                                       |
| ------ | ------------------------------------------ |
| data   | data=success表示存储数据成功，其他代表异常 |
| status | status=0 表示成功，其他代表异常            |

hashSet接口调用示例代码：此代码可以设置正确的Appkey和Token 加入js-sdk后可以使用

```javascript
var Appkey = "xxxx";
var Token = "xxxx";
var hashSet = function (gameID, userID, key, value) {
    //参数组合是安装首字母排序的
    var params = "gameID="+gameID+"&key="+key+"&userID="+userID+"&value="+value;
    //加上 appkey 和 token 进行MD5签名
    var sign = hex_md5( AppKey + "&"+ params+"&"+ Token);
    //组合请求链接，HttpConf.VS_OPEN_URL 必须SDK初始化成功才有效
    var url = HttpConf.VS_OPEN_URL + "/wc5/hashSet.do?"+params+"&sign="+sign;
    //设置请求回调 MatchvsNetWorkCallBack SDK中封装的
    var callback = new MatchvsNetWorkCallBack();
    var httpReq = new MatchvsHttp(callback);
    //请求成功回调 onMsg
    callback.onMsg = function (rsp) {
        console.log("hashSetRsp:",rsp);
    };
    //请求失败回调 onErr
    callback.onErr = function (errCode,errMsg) {
        console.log("hashSetRsp:errCode="+errCode+" errMsg="+errMsg);
    };
    //执行请求
    httpReq.get(url);
};

//调用hashSet
var doHashSet = function () {
        var gameID = 12345;
        var userID = 67890;
        var key = "title";
        var value = "Matchvs";
        hashSet(gameID,userID,key,value);
 };

```



#### hashGet 数据获取

接口地址：js-sdk的对象 HttpConf.VS_OPEN_URL

> HttpConf.VS_OPEN_URL 是js-sdk的对象，是一些http接口的host地址，HttpConf.VS_OPEN_URL 值是在调用js-sdk的init接口时赋值的，开发者调用 init接口时传入不同的channle和platform 对象HttpConf.VS_OPEN_URL 的值也不同。

接口路径：/wc5/hashGet.do?

请求参数：

| 参数名 | 说明                 |
| ------ | -------------------- |
| gameID | 游戏ID               |
| userid | 用户ID               |
| key    | 自定义存储字段键值   |
| sign   | 请看下面sign拼接方法 |

返回参数：

| Key    | 含义                            |
| ------ | ------------------------------- |
| data   | 查询的数据结果                  |
| status | status=0 表示成功，其他代表异常 |

hashGet 接口调用示例代码：此代码可以设置正确的Appkey和Token 加入js-sdk后可以使用

```javascript
var Appkey = "xxxx";
var Token = "xxxx";
var hashGet = function (gameID, userID, key) {
    //参数组合是安装首字母排序的
    var params = "gameID="+gameID+"&key="+key+"&userID="+userID;
    //加上 appkey 和 token 进行MD5签名
    var sign = hex_md5( AppKey + "&"+ params+"&"+ Token);
    //组合请求链接
    var url = HttpConf.VS_OPEN_URL + "/wc5/hashGet.do?"+params+"&sign="+sign;
    //设置请求回调
    var callback = new MatchvsNetWorkCallBack();
    var httpReq = new MatchvsHttp(callback);
    //请求成功回调 onMsg
    callback.onMsg = function (rsp) {
        console.log("hashGetRsp:",rsp);
    };
    //请求失败回调 onErr
    callback.onErr = function (errCode,errMsg) {
        console.log("hashGetRsp:errCode="+errCode+" errMsg="+errMsg);
    };
    //执行请求
    httpReq.get(url);
};

//调用 hashGet
var doHashGet = function () {
        var gameID = 12345;
        var userID = 67890;
        var key = "title";
        hashGet(gameID,userID,key);
};

```

#### sign值获取方法

##### 1. 按照如下格式拼接出字符串:

```
appKey&param1=value1&param2=value2&param3=value3&token
```

- `appKey`为您在官网配置游戏所得

- `param1、param2、param3`等所有参数，按照数字`0-9`、英文字母`a~z`的顺序排列

  例 ： 有三个参数`gameID`、`userID`、`key`，则按照`appkey&gameID=xxx&key=xxx&userID=xxx&token` 的顺序拼出字符串。

- `token`通过用户注册请求获取

##### 2. 计算第一步拼接好的字符串的`MD5`值，即为`sign`的值