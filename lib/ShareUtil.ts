/**
 * Created by wangfei on 17/8/28.
 */
import {SHARE_MEDIAS, UMENG_SAHRE_RESULT_CODES} from "../types";

var { NativeModules } = require('react-native');
const UMShareModule = NativeModules.UMShareModule;


export default class PushUtil {
    static share = (text: string, img: string, webUrl: string, title: string,
                    shareMedia: SHARE_MEDIAS, callback: (code: UMENG_SAHRE_RESULT_CODES, message: string)=>void) => {
        UMShareModule.share(text, img, webUrl, title, shareMedia, callback);
    }

    static auth = (shareMedia: number, callback: (code:number, ret: {[key: string]: string}, message: string)=>void) => {
        UMShareModule.auth(shareMedia, callback);
    }

    static shareboard = (text: string, img: string, webUrl: string, title: string,
                         shareMedias: Array<SHARE_MEDIAS>, callback: (code: UMENG_SAHRE_RESULT_CODES, message: string)=>void) => {
        UMShareModule.shareboard(text, img, webUrl, title, shareMedias, callback);
    }
}
