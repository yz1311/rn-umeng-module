import AnalyticsUtil from "../lib/AnalyticsUtil";
// import PushUtil from "../lib/PushUtil";
import ShareUtil from '../lib/ShareUtil';

/**
 * umeng分享回调的code
 */
export enum UMENG_SAHRE_RESULT_CODES {
    SUCCESS = 200,
    ERROR = 0,
    CANCEL = -1
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

export {
    AnalyticsUtil,
    // PushUtil,
    ShareUtil
};
