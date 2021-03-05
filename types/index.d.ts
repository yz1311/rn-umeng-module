import AnalyticsUtil from "../lib/AnalyticsUtil";
// import PushUtil from "../lib/PushUtil";
import ShareUtil, {SHARE_MEDIAS, SHARE_STYLES, SAHRE_RESULT_CODES} from '../lib/ShareUtil';

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


/**
 * 小程序(支持微信和QQ)
 */
export interface UMMini extends Omit<BaseMediaObject, 'shareMedia'> {
    /**
     * 若客户端版本低于6.5.6或在iPad客户端接收，小程序类型分享将自动转成网页类型分享。开发者必须填写网页链接字段，确保低版本客户端能正常打开网页链接。
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
         * 压缩质量(Android Only)
         * SCALE: 大小压缩，默认为大小压缩，适合普通很大的图
         * QUALITY: 质量压缩，适合长图的分享
         */
        compressStyle: 'SCALE' | 'QUALITY',
        /**
         * 压缩格式(Android Only)
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
    ShareUtil,
    SHARE_MEDIAS,
    SHARE_STYLES,
    SAHRE_RESULT_CODES
};
