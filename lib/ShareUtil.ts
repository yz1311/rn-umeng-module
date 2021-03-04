import {BaseMediaObject, SHARE_MEDIAS, SHARE_STYLES, UMENG_SAHRE_RESULT_CODES} from "../types";

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
        Promise<{shareMedia: SHARE_MEDIAS,code: UMENG_SAHRE_RESULT_CODES, message?: string}> => {
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
        Promise<{shareMedia: SHARE_MEDIAS,code: UMENG_SAHRE_RESULT_CODES, data?: Record<string, string>, message?: string}> => {
        return UMShareModule.auth(shareMedia);
    }
}
