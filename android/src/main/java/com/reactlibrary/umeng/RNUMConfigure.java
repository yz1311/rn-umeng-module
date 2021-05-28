package com.reactlibrary.umeng;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build.VERSION_CODES;
import com.umeng.commonsdk.UMConfigure;

/**
 * Created by wangfei on 17/9/14.
 */

public class RNUMConfigure {
    private static Context context = null;
    private static String appKey = "";
    private static String channel = "";

    public static void preInit(Context context, String appkey, String channel) {
        initRN("react-native","2.0");
        UMConfigure.preInit(context, appkey, channel);
        //保存起来，用于init的初始化
        RNUMConfigure.context = context;
        RNUMConfigure.appKey = appkey;
        RNUMConfigure.channel = channel;
    }

    public static void init(int type, String secret){
        UMConfigure.init(context,appKey,channel,type,secret);
    }

    @TargetApi(VERSION_CODES.KITKAT)
    private static void initRN(String v, String t){
        Method method = null;
        try {
            Class<?> config = Class.forName("com.umeng.commonsdk.UMConfigure");
            method = config.getDeclaredMethod("setWraperType", String.class, String.class);
            method.setAccessible(true);
            method.invoke(null, v,t);
        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
