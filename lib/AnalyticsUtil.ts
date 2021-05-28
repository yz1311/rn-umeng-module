/**
 * Created by wangfei on 17/8/30.
 */
var { NativeModules, Platform } = require('react-native');
const UMAnalyticsModule = NativeModules.UMAnalyticsModule;

export default class AnalyticsUtil {
    //是否已经初始化过了
    private static initialed = false;
    /**
     * umeng的初始化操作
     * 由于目前加强了隐私管理，所以需要在原生中进行的是preInit操作，
     * 只有用户同意隐私协议后，才能进行init操作，所以将init拆分到js中调用
     * @param type 设备类型，默认是手机
     * @param secret 密钥，可以不传
     */
    static init = (type?:INIT_DEVICE_TYPE, secret?: string) => {
        //因为目前只有android部分市场(譬如应用宝)有这方面的需求，所以暂时屏蔽掉ios平台
        if(Platform.OS !== 'android') {
            return;
        }
        //已经初始化过的，不再调用
        if(AnalyticsUtil.initialed) {
            return;
        }
        if(!type) {
            //默认是针对手机类型
            type = INIT_DEVICE_TYPE.DEVICE_TYPE_PHONE;
        }
        if(!secret) {
            //直接传空字符串即可
            secret = '';
        }
        //对老版本进行兼容性处理
        UMAnalyticsModule.init && UMAnalyticsModule.init(type, secret);
        if(!AnalyticsUtil.initialed) {
            AnalyticsUtil.initialed = true;
        }
    }

    /**
     * 手动页面统计接口
     * 调用时机: 页面可见的时候
     * @param pageName 页面名称
     */
    static onPageStart = (pageName: string) => {
        UMAnalyticsModule.onPageStart(pageName);
    }

    /**
     * 手动页面统计接口
     * 调用时机: 页面不可见的时候，包括被其他页面覆盖或者被销毁
     * @param pageName 页面名称
     */
    static onPageEnd = (pageName: string) => {
        UMAnalyticsModule.onPageEnd(pageName);
    }

    /**
     * 自定义事件
     * @param eventId 为当前统计的事件ID
     */
    static onEvent = (eventId: string) => {
        UMAnalyticsModule.onEvent(eventId);
    }

    /**
     * 自定义事件
     * @param eventId 当前统计的事件ID
     * @param eventLabel 分类标签
     */
    static onEventWithLable = (eventId: string, eventLabel: string) => {
        UMAnalyticsModule.onEventWithLable(eventId, eventLabel);
    }

    /**
     * 自定义事件
     * @param eventId 当前统计的事件ID
     * @param eventData 当前事件的属性和取值（键值对），不能为空，如：{name:”umeng”,sex:”man”}
     */
    static onEventWithMap = (eventId: string, eventData: {[key:string]: string}) => {
        UMAnalyticsModule.onEventWithMap(eventId, eventData);
    }

    /**
     * 自定义事件
     * @param eventId 当前统计的事件ID
     * @param eventData 当前事件的属性和取值（键值对），不能为空，如：{name:”umeng”,sex:”man”}
     * @param eventNum 用户每次触发的数值的分布情况，如事件持续时间、每次付款金额等
     */
    static onEventWithMapAndCount = (eventId: string, eventData: {[key:string]: string}, eventNum:number) => {
        UMAnalyticsModule.onEventWithMapAndCount(eventId, eventData, eventNum);
    }

    /**
     * 自定义事件
     * @param eventId 当前统计的事件ID
     * @param eventData 当前事件的属性和取值（键值对），不能为空，如：{name:”umeng”,sex:”man”}
     */
    static onEventObject = (eventId: string, eventData: {[key:string]: any}) => {
        UMAnalyticsModule.onEventObject(eventId, eventData);
    }

    /**
     * 注册预置事件属性
     * @param property 事件的超级属性（可以包含多对“属性名-属性值”）,如：{name:”umeng”,sex:”man”}
     */
    static registerPreProperties = (property: {[key:string]: any}) => {
        UMAnalyticsModule.registerPreProperties(property);
    }

    /**
     * 注销预置事件属性
     * @param propertyName 要注销的预置事件属性名
     */
    static unregisterPreProperty = (propertyName: string) => {
        UMAnalyticsModule.unregisterPreProperty(propertyName);
    }

    /**
     * 获取预置事件属性
     * @param callback 返回包含所有预置事件属性的JSONObject
     */
    static getPreProperties = (callback: (result: string)=>void):Promise<string> => {
        return UMAnalyticsModule.getPreProperties(callback);
    }

    /**
     * 清空全部预置事件属性
     */
    static clearPreProperties = () => {
        UMAnalyticsModule.clearPreProperties();
    }

    /**
     * 设置关注事件是否首次触发
     * @param eventList 只关注eventList前五个合法eventID.只要已经保存五个,此接口无效,如：[“list1”,”list2”,”list3”]
     */
    static setFirstLaunchEvent = (eventList: Array<any>) => {
        UMAnalyticsModule.setFirstLaunchEvent(eventList);
    }

    /**
     * 账号的统计
     * @param puid 用户账号ID.长度小于64字节
     */
    static profileSignInWithPUID = (puid: string) => {
        UMAnalyticsModule.profileSignInWithPUID(puid);
    }

    /**
     * 账号的统计
     * @param provider 账号来源
     * @param puid 用户账号ID。长度小于64字节.
     */
    static profileSignInWithPUIDWithProvider = (provider: string, puid: string) => {
        UMAnalyticsModule.profileSignInWithPUIDWithProvider(provider, puid);
    }

    /**
     * 账号登出时需调用此接口，调用之后不再发送账号相关内容
     */
    static profileSignOff = () => {
        UMAnalyticsModule.profileSignOff();
    }
}


export enum INIT_DEVICE_TYPE {
    DEVICE_TYPE_PHONE = 1,
    DEVICE_TYPE_BOX = 1,
}
