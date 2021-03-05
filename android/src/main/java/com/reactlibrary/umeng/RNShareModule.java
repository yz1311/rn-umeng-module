package com.reactlibrary.umeng;

import java.lang.reflect.Field;
import java.util.Map;

import android.app.Activity;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableMap;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMAuthListener;
import com.umeng.socialize.UMShareAPI;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.common.ResContainer;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMMin;
import com.umeng.socialize.media.UMQQMini;
import com.umeng.socialize.media.UMWeb;
import com.umeng.socialize.media.UMVideo;
import com.umeng.socialize.media.UMusic;
import com.umeng.socialize.shareboard.ShareBoardConfig;

/**
 * Created by wangfei on 17/8/28.
 * Modified by yangzhao on 21/3/4
 */

public class RNShareModule extends ReactContextBaseJavaModule {
    private static Activity ma;
    private final int SUCCESS = 200;
    private final int ERROR = 0;
    private final int CANCEL = -1;
    private static Handler mSDKHandler = new Handler(Looper.getMainLooper());
    private ReactApplicationContext contect;
    public RNShareModule(ReactApplicationContext reactContext) {
        super(reactContext);
        contect = reactContext;

    }
    public static void initSocialSDK(Activity activity){
        ma = activity;
    }
    @Override
    public String getName() {
        return "UMShareModule";
    }
    private static void runOnMainThread(Runnable runnable) {
        mSDKHandler.postDelayed(runnable, 0);
    }
    @ReactMethod
    public void share(final int shareStyle, final ReadableMap shareObject, final Promise promise){
        runOnMainThread(new Runnable() {
            @Override
            public void run() {
                invokeShare(shareStyle, shareObject, promise);
            }
        });

    }
    private UMShareListener getUMShareListener(final Promise promise){
        return new UMShareListener() {
            @Override
            public void onStart(SHARE_MEDIA share_media) {

            }

            @Override
            public void onResult(SHARE_MEDIA share_media) {
                WritableMap map = Arguments.createMap();
                map.putInt("shareMedia", share_media.ordinal());
                map.putInt("code", SUCCESS);
                promise.resolve(map);
            }

            @Override
            public void onError(SHARE_MEDIA share_media, Throwable throwable) {
                WritableMap map = Arguments.createMap();
                map.putInt("shareMedia", share_media.ordinal());
                map.putInt("code", ERROR);
                map.putString("message", throwable.getMessage());
                promise.reject(ERROR+"", throwable.getMessage(), map);
            }

            @Override
            public void onCancel(SHARE_MEDIA share_media) {
                WritableMap map = Arguments.createMap();
                map.putInt("shareMedia", share_media.ordinal());
                map.putInt("code", CANCEL);
                promise.resolve(map);
            }
        };
    }
    private UMImage getImage(String url){
        if (TextUtils.isEmpty(url)){
            return null;
        }else if(url.startsWith("http")){
            return new UMImage(ma,url);
        }else if(url.startsWith("/")){
            return new UMImage(ma,url);
        }else if(url.startsWith("res")){
            return new UMImage(ma, ResContainer.getResourceId(ma,"drawable",url.replace("res/","")));
        }else {
            return new UMImage(ma,url);
        }
    }
    @ReactMethod
    public void auth(final int  sharemedia, final Promise promise){
        runOnMainThread(new Runnable() {
            @Override
            public void run() {
                UMShareAPI.get(ma).getPlatformInfo(ma, getShareMedia(sharemedia), new UMAuthListener() {
                    @Override
                    public void onStart(SHARE_MEDIA share_media) {

                    }

                    @Override
                    public void onComplete(SHARE_MEDIA share_media, int i, Map<String, String> map) {
                        WritableMap resultMap = Arguments.createMap();
                        resultMap.putInt("shareMedia", share_media.ordinal());
                        resultMap.putInt("code", SUCCESS);
                        WritableMap result = Arguments.createMap();
                        for (String key:map.keySet()){
                            result.putString(key,map.get(key));
                            Log.e("todoremove","key="+key+"   value"+map.get(key).toString());
                        }
                        resultMap.putMap("data", result);
                        promise.resolve(resultMap);
                    }

                    @Override
                    public void onError(SHARE_MEDIA share_media, int i, Throwable throwable) {
                        WritableMap map = Arguments.createMap();
                        map.putInt("shareMedia", share_media.ordinal());
                        map.putInt("code", ERROR);
                        map.putString("message", throwable.getMessage());
                        promise.reject(ERROR+"", throwable.getMessage(), map);
                    }

                    @Override
                    public void onCancel(SHARE_MEDIA share_media, int i) {
                        WritableMap map = Arguments.createMap();
                        map.putInt("shareMedia", share_media.ordinal());
                        map.putInt("code", CANCEL);
                        promise.resolve(map);
                    }
                });
            }
        });

    }


    private void invokeShare(final int shareStyle, final ReadableMap shareObject, final Promise promise) {
        final String title = shareObject.getString("title");
        final String description = shareObject.getString("description");
        final ReadableArray shareMediaArr = shareObject.getArray("shareMedias");
        SHARE_MEDIA[] shareMediaValues = new SHARE_MEDIA[shareMediaArr.size()];
        for (int i = 0;i<shareMediaArr.size();i++) {
            shareMediaValues[i] = getShareMedia(shareMediaArr.getInt(i));
        }
        ShareAction action = new ShareAction(ma)
                .setCallback(getUMShareListener(promise));
        //如果只传入一个平台，则不调用分享面板
        if(shareMediaValues.length == 1) {
            action = action.setPlatform(shareMediaValues[0]);
        } else {
            action = action.setDisplayList(shareMediaValues);
        }
        final String follow = shareObject.getString("follow");
        final String subject = shareObject.getString("subject");
        if(follow!=null&&!"".equals(follow)) {
            action = action.withFollow(follow);
        }
        if(subject!=null&&!"".equals(subject)) {
            action = action.withSubject(subject);
        }
        ReadableArray images = null;
        switch (shareStyle) {
            //网页链接（网页H5链接）
            case 0:
                final String webUrl = shareObject.getString("url");
                final String webThumb = shareObject.getString("thumb");
                UMWeb web = new UMWeb(webUrl);
                web.setTitle(title);
                web.setThumb(getImage(webThumb));
                web.setDescription(description);
                action = action.withMedia(web);
                break;
            //微信小程序
            case 1:
                final String path = shareObject.getString("path");
                final String userName = shareObject.getString("miniAppId");
                final String minUrl = shareObject.getString("url");
                final String minThumb = shareObject.getString("thumb");
                UMMin umMin = new UMMin(minUrl);
                umMin.setTitle(title);
                umMin.setThumb(getImage(minThumb));
                umMin.setDescription(description);
                umMin.setPath(path);
                umMin.setUserName(userName);
                action = action.withMedia(umMin);
                break;
            //QQ小程序
            case 2:
                final String miniAppId = shareObject.getString("miniAppId");
                final String miniAppPath = shareObject.getString("path");
                final String miniAppType = shareObject.getString("type");
                final String miniAppUrl = shareObject.getString("url");
                final String miniAppThumb = shareObject.getString("thumb");
                UMQQMini qqMini = new UMQQMini(miniAppUrl);
                qqMini.setTitle(title);
                qqMini.setThumb(getImage(miniAppThumb));
                qqMini.setDescription(description);
                qqMini.setMiniAppId(miniAppId);
                qqMini.setPath(miniAppPath);
                if(miniAppType != null && !"".equals(miniAppType)) {
                    qqMini.setType(miniAppType);
                }
                action = action.withMedia(qqMini);
                break;
            //图片
            case 3:
                images = shareObject.getArray("images");
                if(images.size() != 1) {
                    promise.reject(ERROR+"", "单图分享只支持一张图片");
                    return;
                }
                final String imageUrl = images.getMap(0).getString("url");
                final String imageThumb = images.getMap(0).getString("thumb");
                final UMImage image = getImage(imageUrl);
                //对于部分平台，需要设置缩略图
                if(imageThumb != null && !"".equals(imageThumb)) {
                    image.setThumb(getImage(imageThumb));
                }
                //TODO:设置压缩方式和文件格式
                action = action.withText(description!=null?description:"");
                action = action.withMedia(image);
                break;
            //纯文本
            case 4:
                action = action.withText(description);
                break;
            //多图（多图要包含文字描述）
            case 5:
                images = shareObject.getArray("images");
                UMImage[] mediasArr = new UMImage[images.size()];
                for (int i=0;i<images.size();i++) {
                    ReadableMap tempImage = images.getMap(i);
                    String tempUrl = tempImage.getString("url");
                    String tempThumb = tempImage.getString("thumb");
                    final UMImage mediaImage = getImage(tempUrl);
                    //对于部分平台，需要设置缩略图
                    if(tempThumb != null && !"".equals(tempThumb)) {
                        mediaImage.setThumb(getImage(tempThumb));
                    }
                    mediasArr[i] = mediaImage;
                }
                //TODO:设置压缩方式和文件格式
                action = action.withText(description!=null?description:"");
                action = action.withMedias(mediasArr);
                break;
            //视频
            case 6:
                final String videoUrl = shareObject.getString("url");
                final String videoThumb = shareObject.getString("thumb");
                UMVideo video = new UMVideo(videoUrl);
                video.setTitle(title);
                video.setThumb(getImage(videoThumb));
                video.setDescription(description);
                action = action.withMedia(video);
                break;
            //音乐
            case 7:
                final String musicUrl = shareObject.getString("url");
                final String musicThumb = shareObject.getString("thumb");
                final String musicTargetUrl = shareObject.getString("targetUrl");
                UMusic music = new UMusic(musicUrl);
                music.setTitle(title);
                music.setThumb(getImage(musicThumb));
                music.setDescription(description);
                music.setmTargetUrl(musicTargetUrl);
                action = action.withMedia(music);
                break;
            //表情（GIF图片，即Emotion类型，只有微信支持）
            case 8:

                break;
        }
        if(shareMediaValues.length == 1) {
            action.share();
        } else {
            final ReadableMap shareBoardConfig = shareObject.getMap("shareBoardConfig");
            final ShareBoardConfig config = new ShareBoardConfig();
            if(shareBoardConfig!=null) {
                ReadableMapKeySetIterator iter = shareBoardConfig.keySetIterator();
                while (iter.hasNextKey()) {
                    String key = iter.nextKey();
                    //由于java中它的属性都是m开头，譬如js中是titleText,java中是mTitleText，需要转换下
                    String realKey = "m"+key.substring(0,1).toUpperCase()+key.substring(1);
                    checkKeyAndSet(shareBoardConfig, realKey, config, key);
                }
            }
            if(config != null) {
                action.open(config);
            } else {
                action.open();
            }
        }
    }

    private void checkKeyAndSet(ReadableMap map,String fieldName, Object target, String originalFieldName) {
        if(originalFieldName == null) {
            originalFieldName = fieldName;
        }
        try {
            switch (map.getType(originalFieldName)) {
                //不可能为这个
                case Map:
                case Array:

                    break;
                case Null:
                    setFieldValueByName(target, fieldName, null);
                    break;
                case String:
                    //有部分是颜色，需要转换
                    if(fieldName.endsWith("Color")) {
                        setFieldValueByName(target, fieldName, Color.parseColor(map.getString(originalFieldName)));
                    } else {
                        setFieldValueByName(target, fieldName, map.getString(originalFieldName));
                    }
                    break;
                case Boolean:
                    setFieldValueByName(target, fieldName, map.getBoolean(originalFieldName));
                    break;
                case Number:
                    setFieldValueByName(target, fieldName, map.getDouble(originalFieldName));
                    break;
            }
        } catch (Exception e) {
            Log.i("LINK","RNShareModule:checkKeyAndSet:"+e.getMessage());
        }
    }

    private void setFieldValueByName(Object obj, String fieldName, Object value) {
        try {
            // 获取obj类的字节文件对象
            Class c = obj.getClass();
            // 获取该类的成员变量
            Field f = c.getDeclaredField(fieldName);
            // 取消语言访问检查
            f.setAccessible(true);
            // 给变量赋值
            f.set(obj, value);
        } catch (Exception e) {
            Log.i("LINK","RNShareModule:setFieldValueByName:"+e.getMessage());
        }
    }

    private SHARE_MEDIA getShareMedia(int num){
        switch (num){
            case 0:
                return SHARE_MEDIA.QQ;
            case 1:
                return SHARE_MEDIA.SINA;
            case 2:
                return SHARE_MEDIA.WEIXIN;
            case 3:
                return SHARE_MEDIA.WEIXIN_CIRCLE;
            case 4:
                return SHARE_MEDIA.QZONE;
            case 5:
                return SHARE_MEDIA.EMAIL;
            case 6:
                return SHARE_MEDIA.SMS;
            case 7:
                return SHARE_MEDIA.FACEBOOK;
            case 8:
                return SHARE_MEDIA.TWITTER;
            case 9:
                return SHARE_MEDIA.WEIXIN_FAVORITE;
            case 10:
                return SHARE_MEDIA.GOOGLEPLUS;
            case 11:
                return SHARE_MEDIA.RENREN;
            case 12:
                return SHARE_MEDIA.TENCENT;
            case 13:
                return SHARE_MEDIA.DOUBAN;
            case 14:
                return SHARE_MEDIA.FACEBOOK_MESSAGER;
            case 15:
                return SHARE_MEDIA.YIXIN;
            case 16:
                return SHARE_MEDIA.YIXIN_CIRCLE;
            case 17:
                return SHARE_MEDIA.INSTAGRAM;
            case 18:
                return SHARE_MEDIA.PINTEREST;
            case 19:
                return SHARE_MEDIA.EVERNOTE;
            case 20:
                return SHARE_MEDIA.POCKET;
            case 21:
                return SHARE_MEDIA.LINKEDIN;
            case 22:
                return SHARE_MEDIA.FOURSQUARE;
            case 23:
                return SHARE_MEDIA.YNOTE;
            case 24:
                return SHARE_MEDIA.WHATSAPP;
            case 25:
                return SHARE_MEDIA.LINE;
            case 26:
                return SHARE_MEDIA.FLICKR;
            case 27:
                return SHARE_MEDIA.TUMBLR;
            case 28:
                return SHARE_MEDIA.ALIPAY;
            case 29:
                return SHARE_MEDIA.KAKAO;
            case 30:
                return SHARE_MEDIA.DROPBOX;
            case 31:
                return SHARE_MEDIA.VKONTAKTE;
            case 32:
                return SHARE_MEDIA.DINGTALK;
            case 33:
                return SHARE_MEDIA.MORE;
            default:
                return SHARE_MEDIA.QQ;
        }
    }
}
