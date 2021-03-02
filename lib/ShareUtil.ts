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

    static addAlias = (alias: string, aliasType: string, callback: (code:number)=>void) => {
        UMShareModule.addAlias(alias, aliasType, callback);
    }

    /**
     * android端暂未实现
     * @param eventId
     * @param map
     */
    static addAliasType = (eventId: string, map: {[key:string]: string}) => {
        // UMShareModule.onEventWithMap(eventId, map);
    }

    static addExclusiveAlias = (exclusiveAlias: string, aliasType: string, callback: (code:number)=>void) => {
        UMShareModule.addExclusiveAlias(exclusiveAlias, aliasType, callback);
    }

    static deleteAlias = (alias: string, aliasType: string, callback: (code:number)=>void) => {
        UMShareModule.deleteAlias(alias, aliasType, callback);
    }

    static appInfo = (callback: (info: string)=>void) => {
        UMShareModule.appInfo(callback);
    }
}
