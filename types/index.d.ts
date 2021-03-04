import AnalyticsUtil from "../lib/AnalyticsUtil";
// import PushUtil from "../lib/PushUtil";
import ShareUtil from '../lib/ShareUtil';

/**
 * umeng分享/授权回调的code
 */
export enum UMENG_SAHRE_RESULT_CODES {
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

/**
 * 所有分类类型的基类型
 */
export type BaseMediaObject = {
    /**
     * 图片的地址
     */
    thumb: string;
    /**
     * 描述
     */
    description: string;
    /**
     * 标题
     */
    title: string;
    /**
     * 其他
     */
    extra: Record<string, Object>;
    /**
     * 平台(如果长度为1，则调用指定平台，否则调用默认的分享面板)
     */
    shareMedias: Array<SHARE_MEDIAS>;
    /**
     * 暂不知作用
     */
    follow?: string;
    /**
     * 暂不知作用
     */
    subject?: string;
}


export interface UMQQMini extends Omit<BaseMediaObject, 'shareMedia'> {
    /**
     *
     */
    url: string;
    /**
     * 小程序原始id,在微信平台查询,例如 gh_xxxxxxxxxxxx
     */
    miniAppId: string;
    /**
     * 小程序页面路径
     */
    path: string;
    /**
     * 暂不知道啥参数，不过原生已经进行处理了(android)
     */
    type?: string;
};

/**
 * 链接Model
 */
export interface UMWeb extends BaseMediaObject {
    /**
     * 分享的url
     */
    url: string;
};

/**
 * 图片Model
 */
export interface UMImage extends Omit<BaseMediaObject, 'description'> {
    /**
     * 图片的描述
     */
    description?: string;
    images: Array<{
        /**
         * 图片的url
         */
        url: string;
        /**
         *
         * SCALE: 大小压缩，默认为大小压缩，适合普通很大的图
         * QUALITY: 质量压缩，适合长图的分享
         */
        compressStyle: 'SCALE' | 'QUALITY',
        /**
         * 用户分享透明背景的图片可以设置这种方式，但是qq好友，微信朋友圈，不支持透明背景图片，会变成黑色
         */
        compressFormat: 'JPEG' | 'PNG' | 'WEBP'
    }>

};

/**
 * 音乐只能使用网络音乐
 * 特别说明：播放链接是指在微信qq分享音乐，是可以在当前聊天界面播放的，
 * 要求这个musicurl（播放链接）必须要以.mp3等音乐格式结尾，跳转链接是指点击linkcard之后进行跳转的链接。
 */
export interface UMMusic extends BaseMediaObject {
    /**
     * 视频的播放链接
     */
    url: string;
};

/**
 * 视频只能使用网络视频
 */
export interface UMVideo extends BaseMediaObject {
    /**
     * 音乐的播放链接
     */
    url: string;
    /**
     * 音乐的跳转链接
     */
    targetUrl: string;
};

/**
 * QQ不支持纯文本方式的分享，但QQ空间支持
 */
export interface UMText extends Pick<BaseMediaObject, "description"> {

}

/**
 * 目前只有微信好友分享支持Emoji表情，其他平台暂不支持
 * 暂未实现
 */
export type UMEmoji = {

} & BaseMediaObject;

export {
    AnalyticsUtil,
    // PushUtil,
    ShareUtil
};
