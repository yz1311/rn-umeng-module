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

- (UMSocialPlatformType)platformType:(NSInteger)platform
{
  switch (platform) {
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

- (void)shareWithText:(NSString *)text icon:(NSString *)icon link:(NSString *)link title:(NSString *)title platform:(NSInteger)platform completion:(UMSocialRequestCompletionHandler)completion
{
  UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

  if (link.length > 0) {
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:icon];
    shareObject.webpageUrl = link;

    messageObject.shareObject = shareObject;
  } else if (icon.length > 0) {
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
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    shareObject.thumbImage = img;
    shareObject.shareImage = img;
    messageObject.shareObject = shareObject;

    messageObject.text = text;
  } else if (text.length > 0) {
    messageObject.text = text;
  } else {
    if (completion) {
      completion(nil, [NSError errorWithDomain:@"UShare" code:-3 userInfo:@{@"message": @"invalid parameter"}]);
      return;
    }
  }

  [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:nil completion:completion];

}

RCT_EXPORT_METHOD(share:(NSString *)text icon:(NSString *)icon link:(NSString *)link title:(NSString *)title platform:(NSInteger)platform completion:(RCTResponseSenderBlock)completion)
{
  UMSocialPlatformType plf = [self platformType:platform];
  if (plf == UMSocialPlatformType_UnKnown) {
    if (completion) {
      completion(@[@(UMSocialPlatformType_UnKnown), @"invalid platform"]);
      return;
    }
  }

  [self shareWithText:text icon:icon link:link title:title platform:plf completion:^(id result, NSError *error) {
    if (completion) {
      if (error) {
        NSString *msg = error.userInfo[@"NSLocalizedFailureReason"];
        if (!msg) {
          msg = error.userInfo[@"message"];
        }if (!msg) {
          msg = @"share failed";
        }
        NSInteger stcode =error.code;
        if(stcode == 2009){
         stcode = -1;
        }
        completion(@[@(stcode), msg]);
      } else {
        completion(@[@200, @"share success"]);
      }
    }
  }];

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




RCT_EXPORT_METHOD(shareExt:(int)shareStyle shareObject:(NSDictionary *)shareObject resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
//  UMSocialPlatformType plf = [self platformType:platform];
//  if (plf == UMSocialPlatformType_UnKnown) {
//    if (completion) {
//      completion(@[@(UMSocialPlatformType_UnKnown), @"invalid platform"]);
//      return;
//    }
//  }
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
            UMShareMiniProgramObject *shareObj = [UMShareMiniProgramObject shareObjectWithTitle:title descr:description thumImage:[UIImage imageNamed:icon]];
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
            UMShareVideoObject *shareObj = [UMShareVideoObject shareObjectWithTitle:title descr:description thumImage:[UIImage imageNamed:thumb]];
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
            UMShareMusicObject *shareObj = [UMShareMusicObject shareObjectWithTitle:title descr:description thumImage:[UIImage imageNamed:thumb]];
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
        [[UMSocialManager defaultManager] shareToPlatform:[shareMediaArr objectAtIndex:0] messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
               if (error) {
                   NSLog(@"************Share fail with error %@*********",error);
               }else{
                   if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                       UMSocialShareResponse *resp = data;
                       //分享结果消息
                       NSLog(@"response message is %@",resp.message);
                   }else{
                       NSLog(@"response data is %@",data);
                   }
               }
           }];
    } else {
//        [[UMSocialManager defaultManager] shareToPlatform:[shareMediaArr objectAtIndex:0] messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//               if (error) {
//                   NSLog(@"************Share fail with error %@*********",error);
//               }else{
//                   if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                       UMSocialShareResponse *resp = data;
//                       //分享结果消息
//                       NSLog(@"response message is %@",resp.message);
//                   }else{
//                       NSLog(@"response data is %@",data);
//                   }
//               }
//           }];
    }

}

RCT_EXPORT_METHOD(shareboard:(NSString *)text icon:(NSString *)icon link:(NSString *)link title:(NSString *)title platform:(NSArray *)platforms completion:(RCTResponseSenderBlock)completion)
{
  NSMutableArray *plfs = [NSMutableArray array];
  for (NSNumber *plf in platforms) {
    [plfs addObject:@([self platformType:plf.integerValue])];
  }
  if (plfs.count > 0) {
    [UMSocialUIManager setPreDefinePlatforms:plfs];
  }
  [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    [self shareWithText:text icon:icon link:link title:title platform:platformType completion:^(id result, NSError *error) {
      if (completion) {
        if (error) {
          NSString *msg = error.userInfo[@"NSLocalizedFailureReason"];
          if (!msg) {
            msg = error.userInfo[@"message"];
          }if (!msg) {
            msg = @"share failed";
          }
          NSInteger stcode =error.code;
          if(stcode == 2009){
            stcode = -1;
          }
          completion(@[@(stcode), msg]);
        } else {
          completion(@[@200, @"share success"]);
        }
      }
    }];
  }];
}


RCT_EXPORT_METHOD(auth:(NSInteger)platform completion:(RCTResponseSenderBlock)completion)
{
  UMSocialPlatformType plf = [self platformType:platform];
  if (plf == UMSocialPlatformType_UnKnown) {
    if (completion) {
      completion(@[@(UMSocialPlatformType_UnKnown), @"invalid platform"]);
      return;
    }
  }

  [[UMSocialManager defaultManager] getUserInfoWithPlatform:plf currentViewController:nil completion:^(id result, NSError *error) {
    if (completion) {
      if (error) {
        NSString *msg = error.userInfo[@"NSLocalizedFailureReason"];
        if (!msg) {
          msg = error.userInfo[@"message"];
        }if (!msg) {
          msg = @"share failed";
        }
        NSInteger stCode = error.code;
        if(stCode == 2009){
          stCode = -1;
        }
        completion(@[@(stCode), @{}, msg]);
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

        completion(@[@200, retDict, @""]);
      }
    }
  }];

}
@end
