import {BaseMediaObject} from "../types";
import {
    Platform,
    NativeModules
} from 'react-native';

const UMShareModule = NativeModules.UMShareModule;

export default class ShareUtil {
    /**
     * 分享
     * 成功或者取消都是resolve(根据code判断)，失败才是reject
     * ios下面，如果分享失败，返回的error，code即为umeng返回的错误码，message即为错误信息
     * android下，返回的error
     * @param shareStyle
     * @param shareObject
     */
    static share = (shareStyle: SHARE_STYLES, shareObject: BaseMediaObject):
        Promise<{shareMedia: SHARE_MEDIAS,code: SAHRE_RESULT_CODES, message?: string}> => {
        if(!shareObject) {
            console.warn('shareObject不能为空');
            return;
        }
        if(!shareObject.shareMedias) {
            shareObject.shareMedias = [];
        }
        if(shareStyle === SHARE_STYLES.MULITI_IMAGE) {
            if(Platform.OS !== 'android' ||
            Platform.OS === 'android' && shareObject.shareMedias.length>0
                && shareObject.shareMedias.some(x=>x!==SHARE_MEDIAS.SINA && x!==SHARE_MEDIAS.QZONE)) {
                console.warn("多图模式只支持android平台下的新浪微博和QQ空间");
                return;
            }
            if(!shareObject.description || shareObject.description?.trim() === '') {
                console.warn("多图模式下必须要带文字描述:description");
                return;
            }
        }
        if(shareStyle === SHARE_STYLES.Emotion) {
            console.warn("分享表情暂未实现");
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
     * 单图
     */
    IMAGE,
    /**
     * 纯文本
     */
    TEXT,
    /**
     * 多图（多图要包含文字描述）
     * 只支持android平台(ios没发现相关的api)的新浪微博和QQ空间，都是最多上传9张图片
     * 新浪微博超过9张不会上传,QQ控件超过9张会上传QQ控件相册
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
