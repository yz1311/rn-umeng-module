import {BaseMediaObject} from "../types";

const { NativeModules } = require('react-native');
const UMShareModule = NativeModules.UMShareModule;

export default class PushUtil {
    /**
     * 分享
     * 成功或者取消都是resolve(根据code判断)，失败才是reject
     * @param shareStyle
     * @param shareObject
     */
    static share = (shareStyle: SHARE_STYLES, shareObject: BaseMediaObject):
        Promise<{shareMedia: SHARE_MEDIAS,code: SAHRE_RESULT_CODES, message?: string}> => {
        if(!shareObject) {
            console.warn('shareObject不能为空');
            return;
        }
        return UMShareModule.share(shareStyle, shareObject);
    }

    /**
     * 授权
     * 成功或者取消都是resolve(根据code判断)，失败才是reject
     * @param shareMedia
     */
    static auth = (shareMedia: SHARE_MEDIAS):
        Promise<{shareMedia: SHARE_MEDIAS,code: SAHRE_RESULT_CODES, data?: Record<string, string>, message?: string}> => {
        return UMShareModule.auth(shareMedia);
    }
}


/**
 * umeng分享/授权回调的code
 */
export enum SAHRE_RESULT_CODES {
    SUCCESS = 200,
    ERROR = 0,
    CANCEL = -1
}

/**
 * umeng分享样式(这个顺序不要乱动，原生是按照这个判断实现的)
 */
export enum SHARE_STYLES {
    /**
     * 网页链接（网页H5链接）
     */
    LINK,
    /**
     * 微信小程序
     */
    WEIXIN_MINI_PROGRAM,
    /**
     * QQ小程序
     */
    QQ_MINI_PROGRAM,
    /**
     *
     */
    IMAGE,
    /**
     * 纯文本
     */
    TEXT,
    /**
     * 多图（多图要包含文字描述）
     */
    MULITI_IMAGE,
    /**
     * 视频
     */
    VIDEO,
    /**
     * 音乐
     */
    MUSIC,
    /**
     * 表情（GIF图片，即Emotion类型，只有微信支持）
     */
    Emotion,
}

/**
 * umeng分享的类型
 */
export enum SHARE_MEDIAS {
    QQ = 0,
    SINA,
    WEIXIN,    //微信
    WEIXIN_CIRCLE,   //朋友圈
    QZONE,   //QQ空间
    EMAIL,   //电子邮件
    SMS,     //短信
    FACEBOOK,  //facebook
    TWITTER,   //twitter
    WEIXIN_FAVORITE,  //微信收藏
    GOOGLEPLUS,   //google+
    RENREN,     //人人
    TENCENT,    //腾讯微博
    DOUBAN,     //豆瓣
    FACEBOOK_MESSAGER,  //facebook messager
    YIXIN,    //易信
    YIXIN_CIRCLE,   //易信朋友圈
    INSTAGRAM,
    PINTEREST,
    EVERNOTE,   //印象笔记
    POCKET,
    LINKEDIN,
    FOURSQUARE,
    YNOTE,   //有道云笔记
    WHATSAPP,
    LINE,
    FLICKR,
    TUMBLR,
    ALIPAY,   //支付宝
    KAKAO,
    DROPBOX,
    VKONTAKTE,
    DINGTALK,   //钉钉
    MORE,    //系统菜单
}
