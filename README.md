
# rn-umeng-module

[![npm version](http://img.shields.io/npm/v/rn-umeng-module.svg?style=flat-square)](https://npmjs.org/package/rn-umeng-module "View this project on npm")
[![npm version](http://img.shields.io/npm/dm/rn-umeng-module.svg?style=flat-square)](https://npmjs.org/package/rn-umeng-module "View this project on npm")

umeng for react-native,支持统计、分享、授权

## 安装

> `$ npm install rn-umeng-module --save`

* react-native <0.60

> `$ react-native link rn-umeng-module`

* react-native >=0.60

新版RN会自动link,不需要执行link命令

---
不管是哪个版本的react-native，ios端都需要在`ios`文件夹下执行
```shell
$ cd ios
$ pod install
```


### 配置
为了防止包的体积太大，该库里面不包含任何第三方平台的分享库(umeng统计相关的库已添加，不必在重复添加)，需要按需集成
#### iOS
* 1.配置分享库(按需集成)
  打开`Podfile`文件，按需添加需要的分享平台库(注意：老的库以前是`UMCShare`开头的，注意更改过来)
  ```
    # 集成微信(完整版14.4M)
    pod 'UMShare/Social/WeChat'

    # 集成QQ/QZone/TIM(完整版7.6M)
    pod 'UMShare/Social/QQ'  

    # 集成QQ/QZone/TIM(精简版0.5M)
    pod 'UMShare/Social/ReducedQQ'

    # 集成新浪微博(完整版25.3M)
    pod 'UMShare/Social/Sina' 

    # 集成新浪微博(精简版1M)
    pod 'UMShare/Social/ReducedSina'

    # 集成钉钉
    pod 'UMShare/Social/DingDing'

    # 企业微信
    pod 'UMShare/Social/WeChatWork'

    # 抖音
    pod 'UMShare/Social/DouYin'

    # 集成支付宝
    pod 'UMShare/Social/AlipayShare'

    # 集成邮件
    pod 'UMShare/Social/Email'

    # 集成短信
    pod 'UMShare/Social/SMS'

    # 集成有道云笔记
    pod 'UMShare/Social/YouDao'

    # 集成印象笔记
    pod 'UMShare/Social/EverNote'

    # 集成易信
    pod 'UMShare/Social/YiXin'

    # 集成Facebook/Messenger
    pod 'UMShare/Social/Facebook'

    # 集成Twitter
    pod 'UMShare/Social/Twitter'

    # 集成Flickr
    pod 'UMShare/Social/Flickr'

    # 集成Kakao
    pod 'UMShare/Social/Kakao'

    # 集成Tumblr
    pod 'UMShare/Social/Tumblr'

    # 集成Pinterest
    pod 'UMShare/Social/Pinterest'

    # 集成Instagram
    pod 'UMShare/Social/Instagram'

    # 集成Line
    pod 'UMShare/Social/Line'

    # 集成WhatsApp
    pod 'UMShare/Social/WhatsApp'

    # 集成Google+
    pod 'UMShare/Social/GooglePlus'

    # 集成Pocket
    pod 'UMShare/Social/Pocket'

    # 集成DropBox
    pod 'UMShare/Social/DropBox'

    # 集成VKontakte
    pod 'UMShare/Social/VKontakte'
  ```
* 2.初始化

```
#import "RNUMConfigure.h"

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...
  //打开调试模式
  //[UMConfigure setLogEnabled:YES];
  //初始化umeng，会自动读取info.plist中的参数
  [RNUMConfigure initWithAppkey:@"599d6d81c62dca07c5001db6" channel:@"App Store"];
	return YES;
}
```

* 3.第三方平台配置，点击[跳转](https://developer.umeng.com/docs/128606/detail/193653#h1-u7B2Cu4E09u65B9u5E73u53F0u914Du7F6E4)
  查看umeng官方的配置教程

#### Android
* 1.配置分享库(按需集成)

打开`app/build.gradle`,按需添加分享库()
```javascript
//QQ
implementation  'com.umeng.umsdk:share-qq:7.1.4'
implementation  'com.tencent.tauth:qqopensdk:3.51.2' //QQ官方SDK依赖库    

//微信
implementation  'com.umeng.umsdk:share-wx:7.1.4'
implementation  'com.tencent.mm.opensdk:wechat-sdk-android-without-mta:6.6.5'//微信官方SDK依赖库

//新浪微博        
implementation  'com.umeng.umsdk:share-sina:7.1.4'
implementation  'com.sina.weibo.sdk:core:10.10.0:openDefaultRelease@aar'//新浪微博官方SDK依赖库

//支付宝
implementation  'com.umeng.umsdk:share-alipay:7.1.4'

//钉钉
implementation  'com.umeng.umsdk:share-dingding:7.1.4'
```

* 2.配置sdk的仓库地址

打开project的build.gradle文件中添加
```javascript
buildscript {
  repositories {
    google()
    jcenter()
    maven { url 'https://dl.bintray.com/umsdk/release' }
    maven { url "https://dl.bintray.com/thelasterstar/maven/" }
    ....
  }
}
allprojects {
    repositories {
        //umeng的仓库地址
        maven { url 'https://dl.bintray.com/umsdk/release' }
        //sina的仓库地址
        maven { url "https://dl.bintray.com/thelasterstar/maven/" }
        ....
    }
}
```


* 3.在`包名`目录下创建wxapi文件夹，wxapi下面创建`WXEntryActivity.java`文件
```Java
package [你的包名].wxapi;

import com.umeng.socialize.weixin.view.WXCallbackActivity;

public class WXEntryActivity extends WXCallbackActivity {


}
```

<font color="red">QQ、微博:</font> 在当前的7.1.4版本中，已经不需要添加回调activity文件了

<font color="red">支付宝:</font> 在`包名`目录下创建`apshare`文件夹,然后建立一个`ShareEntryActivity`的类，
继承`ShareCallbackActivity`。

<font color="red">钉钉:</font> 在`包名`目录下创建`ddshare`文件夹,然后建立一个`DDShareActivity`的类，
继承`DingCallBack`。



* 4.在res/xml目录(如果没有xml目录，则新建一个)下,创建``文件
  (如果已经存在，则按照下面代码添加缺失的部分即可)file_paths.xml
  
```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- QQ 官方分享SDK 共享路径 -->
    <root-path name="opensdk_root" path=""/>
    <external-files-path name="opensdk_external" path="Images/tmp"/>
    <!-- 友盟微信分享SDK 共享路径 -->
    <external-files-path name="umeng_cache" path="umeng_cache/"/>
    <!-- 新浪微博 官方分享SDK 10.10.0共享路径 -->
    <external-files-path name="share_files" path="." />
</paths>
```

* 5.在`AndroidManifest.xml`清单文件中增加

微信、支付宝、钉钉的回调类
```xml
<!--微信的分享回调类-->
<activity
    android:name=".wxapi.WXEntryActivity"
    android:configChanges="keyboardHidden|orientation|screenSize"
    android:exported="true"
    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
<!--支付宝的分享回调类-->
<activity
    android:name=".apshare.ShareEntryActivity"
    android:configChanges="keyboardHidden|orientation|screenSize"
    android:exported="true"
    android:screenOrientation="portrait"
    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
<!--钉钉的分享回调类-->
<activity
    android:name=".ddshare.DingCallBack"
    android:configChanges="keyboardHidden|orientation|screenSize"
    android:exported="true"
    android:screenOrientation="portrait"
    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
```


```xml
<!-- Android 7.0 文件共享配置，必须配置 -->
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
  <meta-data
          android:name="android.support.FILE_PROVIDER_PATHS"
          <!-- 如果编译报错的话，打开下面这个 -->
          <!--tools:replace="android:resource"-->
          android:resource="@xml/file_paths" />
</provider>
```


集成QQ需要设置`compileSdkVersion = 29`

<font color="red">新版本sdk中已经内置AndroidManifest中的配置项，只需要在`app/buid.gradle`中设置</font>
```javascript
defaultConfig {
    ...
    manifestPlaceholders= [
        qqappid: '你的QQ的appId'
    ]
    ...
}
```

* 6.在`Application`文件的`onCreate()`中进行初始化

```Javascript

 @Override
  public void onCreate() {
      super.onCreate();
      SoLoader.init(this, /* native exopackage */ false);
      RNUMConfigure.init(this, "59892f08310c9307b60023d0", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "");
      PlatformConfig.setWeixin("wxdc1e388c3822c80b", "3baf1193c85774b3fd9d18447d76cab0");
      //QQ和QQ空间的appId
      PlatformConfig.setQQZone("100424468", "c7394704798a158208a74ab60104f0ba");
      PlatformConfig.setSinaWeibo("3921700954", "04b48b094faeb16683c32669824ebdad", "http://sns.whalecloud.com");
      ...
  }
```
  
`RNUMConfture.init`接口一共五个参数，其中第一个参数为`Context`，
第二个参数为友盟`Appkey`，第三个参数为`channel`，第四个参数为应用类型（手机或平板），
第五个参数为push的`secret`（如果没有使用push，可以为空）。

在`MainActivity`中进行初始化和回调
```Javascript
    @Override
    protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      RNShareModule.initSocialSDK(this);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
      super.onActivityResult(requestCode, resultCode, data);
      UMShareAPI.get(this).onActivityResult(requestCode, resultCode, data);
    }
```

## 使用

### 统计
```javascript
import {AnalyticsUtil, ShareUtil, UMWeb} from 'rn-umeng-module';

//统计
AnalyticsUtil.onPageStart("HomeIndex");
...
```
---

### 分享
分享支持的平台(在[SHARE_MEDIAS](./lib/ShareUtil.ts)枚举中)

|值|平台名|
|---|---|
|QQ|QQ|
|SINA|新浪微博|
|WEIXIN|微信|
|WEIXIN_CIRCLE|微信朋友圈|
|WEIXIN_CIRCLE|微信朋友圈|
|QZONE|QQ空间|
|...|...|

分享支持的方式(在[SHARE_STYLES](./lib/ShareUtil.ts)枚举中)

|值|解释|对应ts定义 |
|---|---|---|
|LINK|网页链接（网页H5链接）|UMWeb|
|WEIXIN_MINI_PROGRAM|微信小程序|UMMini|
|QQ_MINI_PROGRAM|QQ小程序|UMMini|
|IMAGE|单图| UMImage|
|TEXT|纯文本|UMText|
|MULITI_IMAGE|多图（多图要包含文字描述）只支持android平台(ios没发现相关的api)的新浪微博和QQ空间，都是最多上传9张图片新浪微博超过9张不会上传,QQ控件超过9张会上传QQ控件相册|UMImage|
|VIDEO|视频|UMVideo|
|MUSIC|音乐|UMMusic|
|Emotion|表情（GIF图片，即Emotion类型，只有微信支持）(<font color=red>暂未实现</font>)|UMEmoji|


```javascript
import {AnalyticsUtil, ShareUtil, UMWeb} from 'rn-umeng-module';

//分享(链接)
ShareUtil.share(SHARE_STYLES.LINK, {
  thumb: 'https://xxxxx.jpg',  //卡片图片链接地址
  title: '这是标题',  //标题
  description: '这是描述',  //描述
  shareMedias: [SHARE_MEDIAS.WEIXIN],  //需要分享的平台,注意，是一个数组，只传一个，调用固定的平台，传多个，则调用分享面板
  //如果shareMedias大于1个平台，可以自定义分享面板
  shareBoardConfig: {
      
  }
} as UMWeb);  //如果使用typescript,第二个参数可以指定具体的类型

//分享(QQ小程序)
ShareUtil.share(SHARE_STYLES.QQ_MINI_PROGRAM, {
  thumb: 'https://xxxxx.jpg',  //小程序卡片的缩略图 
  miniAppId: 'gh_xxxxxxxxxxxx',  //小程序原始id,在微信平台查询
  url: '',  //若客户端版本低于6.5.6或在iPad客户端接收，小程序类型分享将自动转成网页类型分享。
  path: '/xxx/xxx/xxx',  //小程序页面路径
} as UMMini);  //如果使用typescript,第二个参数可以指定具体的类型
...
```
---

### 授权
```javascript
import {AnalyticsUtil, ShareUtil, UMWeb} from 'rn-umeng-module';

//授权
try {
    let response = await ShareUtil.auth(SHARE_MEDIAS.WEIXIN);
} catch (e) {
    
}
...
```
response的返回值可以在[UmengAuthResponse](./types/index.d.ts)

---

具体所有方法定义请查看: [index.d.ts](./types/index.d.ts)

## 注意事项&&疑问

