//
//  ShareModule.h
//  UMComponent
//
//  Created by wyq.Cloudayc on 11/09/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "UMShareModule.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>

@implementation UMShareModule

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}


- getImage:(NSString*) icon {
    id img = nil;
    if ([icon hasPrefix:@"http"]) {
      img = icon;
    } else {
      if ([icon hasPrefix:@"/"]) {
        img = [UIImage imageWithContentsOfFile:icon];
      } else {
        img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:icon ofType:nil]];
      }
    }
    return img;
}




RCT_EXPORT_METHOD(share:(NSInteger)shareStyle shareObject:(NSDictionary *)shareObject resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
//  UMSocialPlatformType plf = [self platformType:platform];
//  if (plf == UMSocialPlatformType_UnKnown) {
//    if (completion) {
//      completion(@[@(UMSocialPlatformType_UnKnown), @"invalid platform"]);
//      return;
//    }
//  }
    [self invokeShare:shareStyle shareObject:shareObject resolve:resolve reject:reject];
}

- (void)invokeShare:(NSInteger)shareStyle shareObject:(NSDictionary *)shareObject resolve:(RCTPromiseResolveBlock)resolve
             reject:(RCTPromiseRejectBlock)reject
{
    NSString *title = [RCTConvert NSString:shareObject[@"title"]];
    NSString *description = [RCTConvert NSString:shareObject[@"description"]];
    NSArray *shareMediaArr = [RCTConvert NSArray:shareObject[@"shareMedias"]];
      UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
      switch (shareStyle) {
          //网页链接（网页H5链接）
          case 0:
          {
              NSString *url = [RCTConvert NSString:shareObject[@"url"]];
              NSString *thumb = [RCTConvert NSString:shareObject[@"thumb"]];
              UIImage* icon = [self getImage:thumb];
              //创建网页内容对象
              UMShareWebpageObject *shareObj = [UMShareWebpageObject shareObjectWithTitle:title descr:description thumImage:icon];
              shareObj.webpageUrl = url;
              messageObject.shareObject = shareObj;
          }
              break;
          //微信小程序
          //QQ小程序
          case 1:
          case 2:
          {
              NSString *path = [RCTConvert NSString:shareObject[@"path"]];
              NSString *userName = [RCTConvert NSString:shareObject[@"userName"]];
              NSString *url = [RCTConvert NSString:shareObject[@"url"]];
              NSString *thumb = [RCTConvert NSString:shareObject[@"thumb"]];
              UIImage* icon = [self getImage:thumb];
              UMShareMiniProgramObject *shareObj = [UMShareMiniProgramObject shareObjectWithTitle:title descr:description thumImage:icon];
              shareObj.webpageUrl = url;
              shareObj.userName = userName;
              shareObj.path = path;
              shareObj.hdImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
              shareObj.miniProgramType = UShareWXMiniProgramTypeRelease; // 可选体验版和开发板
              messageObject.shareObject = shareObj;
          }
              break;
          //图片
          case 3:
          {
              NSArray* images = [RCTConvert NSArray:shareObject[@"images"]];
              if(images.count != 1) {
                  reject(@"0", @"单图分享只支持一张图片", nil);
              }
              NSDictionary* first = [images objectAtIndex:0];
              NSString *url = [NSString stringWithFormat:@"%@",[first objectForKey:@"url"]];
              NSString *thumb = [NSString stringWithFormat:@"%@",[first objectForKey:@"thumb"]];
              UMShareImageObject *shareObj = [[UMShareImageObject alloc] init];
              //如果有缩略图，则设置缩略图
              if(thumb!=nil && [thumb length]>0) {
                  shareObj.thumbImage = [self getImage:thumb];
              }
              [shareObj setShareImage:url];
              messageObject.shareObject = shareObj;
          }
              break;
          //纯文本
          case 4:
          {
              messageObject.text = title;
          }
              break;
          //多图（多图要包含文字描述）(ios的接口不支持多图)
          case 5:
          {
              messageObject.text = title;
              NSArray* images = [RCTConvert NSArray:shareObject[@"images"]];
              if(images.count != 1) {
                  reject(@"0", @"单图分享只支持一张图片", nil);
              }
              NSDictionary* first = [images objectAtIndex:0];
              NSString *url = [NSString stringWithFormat:@"%@",[first objectForKey:@"url"]];
              NSString *thumb = [NSString stringWithFormat:@"%@",[first objectForKey:@"thumb"]];
              UMShareImageObject *shareObj = [[UMShareImageObject alloc] init];
              //如果有缩略图，则设置缩略图
              if(thumb!=nil && [thumb length]>0) {
                  shareObj.thumbImage = [self getImage:thumb];
              }
              [shareObj setShareImage:url];
              messageObject.shareObject = shareObj;

          }
              break;
          //视频
          case 6:
          {
              NSString *thumb = [RCTConvert NSString:shareObject[@"thumb"]];
              NSString *url = [RCTConvert NSString:shareObject[@"url"]];
              UIImage* icon = [self getImage:thumb];
              UMShareVideoObject *shareObj = [UMShareVideoObject shareObjectWithTitle:title descr:description thumImage:icon];
              shareObj.videoUrl = url;
              messageObject.shareObject = shareObj;
          }
              break;
          //音乐
          case 7:
          {
              NSString *thumb = [RCTConvert NSString:shareObject[@"thumb"]];
              NSString *url = [RCTConvert NSString:shareObject[@"url"]];
              NSString *targetUrl = [RCTConvert NSString:shareObject[@"targetUrl"]];
              UIImage* icon = [self getImage:thumb];
              UMShareMusicObject *shareObj = [UMShareMusicObject shareObjectWithTitle:title descr:description thumImage:icon];
              shareObj.musicUrl = url;
              shareObj.musicDataUrl = targetUrl;
              messageObject.shareObject = shareObj;
          }
              break;
          //表情（GIF图片，即Emotion类型，只有微信支持）
          case 8:

              break;
      }
      if([shareMediaArr count] == 1) {
          [[UMSocialManager defaultManager] shareToPlatform:[self platformType:(NSNumber*)[shareMediaArr objectAtIndex:0]] messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
           if (error) {
               NSString *msg = error.userInfo[@"NSLocalizedFailureReason"];
               if (!msg) {
                 msg = error.userInfo[@"message"];
               }if (!msg) {
                 msg = @"share failed";
               }
               NSInteger stCode = error.code;
               reject([NSString stringWithFormat:@"%ld", stCode], msg, error);
           }else{
               if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                   UMSocialShareResponse *resp = data;
                   //分享结果消息
                   NSLog(@"response message is %@",resp.message);
                   resolve(@{
                       @"shareMedia": [NSNumber numberWithInt:[(NSNumber*)[shareMediaArr objectAtIndex:0] intValue]],
                       @"code": @200,
                       @"message": resp.message,
                       @"originalResponse": resp.originalResponse
                   });
               }else{
                   NSLog(@"response data is %@",data);
                   resolve(@{
                       @"shareMedia": [NSNumber numberWithInt:[(NSNumber*)[shareMediaArr objectAtIndex:0] intValue]],
                       @"code": @200,
                       @"originalResponse": data
                   });
               }
           }
       }];
      } else {
          //调用分享面板
          //设置分享的平台
          [UMSocialUIManager setPreDefinePlatforms:shareMediaArr];
          [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
              //获取到选中的平台，重新调用接口
              NSArray* newShareMedias = @[@((int)platformType)];
              [shareObject setValue:newShareMedias forKey:@"shareMedias"];
              [self invokeShare:shareStyle shareObject:shareObject resolve:resolve reject:reject];
          }];
      }
}


RCT_EXPORT_METHOD(auth:(NSNumber*)platform resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
//  UMSocialPlatformType plf = [self platformType:platform];
//  if (plf == UMSocialPlatformType_UnKnown) {
//    if (completion) {
//      completion(@[@(UMSocialPlatformType_UnKnown), @"invalid platform"]);
//      return;
//    }
//  }
//
  [[UMSocialManager defaultManager] getUserInfoWithPlatform:[self platformType:platform] currentViewController:nil completion:^(id result, NSError *error) {
      if (error) {
        NSString *msg = error.userInfo[@"NSLocalizedFailureReason"];
        if (!msg) {
          msg = error.userInfo[@"message"];
        }if (!msg) {
          msg = @"auth failed";
        }
        NSInteger stCode = error.code;
        reject([NSString stringWithFormat:@"%ld", stCode], msg, error);
      } else {
        UMSocialUserInfoResponse *authInfo = result;

        NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:8];
        retDict[@"uid"] = authInfo.uid;
        retDict[@"openid"] = authInfo.openid;
        retDict[@"unionid"] = authInfo.unionId;
        retDict[@"accessToken"] = authInfo.accessToken;
        retDict[@"refreshToken"] = authInfo.refreshToken;
        retDict[@"expiration"] = authInfo.expiration;

        retDict[@"name"] = authInfo.name;
        retDict[@"iconurl"] = authInfo.iconurl;
        retDict[@"gender"] = authInfo.unionGender;

        NSDictionary *originInfo = authInfo.originalResponse;
        retDict[@"city"] = originInfo[@"city"];
        retDict[@"province"] = originInfo[@"province"];
        retDict[@"country"] = originInfo[@"country"];

        resolve(@{
          @"shareMedia": @((int)platform),
          @"code": @200,
          @"data": retDict,
          @"message": @"",
          @"originalResponse": authInfo.originalResponse
        });
      }
  }];

}


- (UMSocialPlatformType)platformType:(NSNumber*)platform
{
  switch ([platform intValue]) {
    case 0: // QQ
      return UMSocialPlatformType_QQ;
    case 1: // Sina
      return UMSocialPlatformType_Sina;
    case 2: // wechat
      return UMSocialPlatformType_WechatSession;
    case 3:
      return UMSocialPlatformType_WechatTimeLine;
    case 4:
      return UMSocialPlatformType_Qzone;
    case 5:
      return UMSocialPlatformType_Email;
    case 6:
      return UMSocialPlatformType_Sms;
    case 7:
      return UMSocialPlatformType_Facebook;
    case 8:
      return UMSocialPlatformType_Twitter;
    case 9:
      return UMSocialPlatformType_WechatFavorite;
    case 10:
      return UMSocialPlatformType_GooglePlus;
    case 11:
      return UMSocialPlatformType_Renren;
    case 12:
      return UMSocialPlatformType_TencentWb;
    case 13:
      return UMSocialPlatformType_Douban;
    case 14:
      return UMSocialPlatformType_FaceBookMessenger;
    case 15:
      return UMSocialPlatformType_YixinSession;
    case 16:
      return UMSocialPlatformType_YixinTimeLine;
    case 17:
      return UMSocialPlatformType_Instagram;
    case 18:
      return UMSocialPlatformType_Pinterest;
    case 19:
      return UMSocialPlatformType_EverNote;
    case 20:
      return UMSocialPlatformType_Pocket;
    case 21:
      return UMSocialPlatformType_Linkedin;
    case 22:
      return UMSocialPlatformType_UnKnown; // foursquare on android
    case 23:
      return UMSocialPlatformType_YouDaoNote;
    case 24:
      return UMSocialPlatformType_Whatsapp;
    case 25:
      return UMSocialPlatformType_Line;
    case 26:
      return UMSocialPlatformType_Flickr;
    case 27:
      return UMSocialPlatformType_Tumblr;
    case 28:
      return UMSocialPlatformType_APSession;
    case 29:
      return UMSocialPlatformType_KakaoTalk;
    case 30:
      return UMSocialPlatformType_DropBox;
    case 31:
      return UMSocialPlatformType_VKontakte;
    case 32:
      return UMSocialPlatformType_DingDing;
    case 33:
      return UMSocialPlatformType_UnKnown; // more
    default:
      return UMSocialPlatformType_QQ;
  }
}
@end
