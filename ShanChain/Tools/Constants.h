//
//  Constants.h
//  smartapc-ios
//
//  Created by list on 16/6/20.
//  Copyright © 2016年 list. All rights reserved.
//
//微信 :f9a343a0a1c83c249d4d161978432ecb
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kNavStatusBarHeight 64
// 百度地图key:
static NSString * const kBaiduMapKey = @"Lp5FSsHWUaVvhgsKfsveuZXRP3LsqEB6";
//友盟统计的appKey
static NSString *const kUMengKey = @"5982c26c4544cb7cc9000528";
//友盟推送功能
//友盟推送APPKey
static NSString *const kUMengPushKey = @"59883219f29d980960000e80";
static NSString *const kUMengPushSecret = @"h2owbgogfbl8q7onca91vhf9lviwkycp";

//环信SDK的AppKey
static NSString *const KHXKey = @"1145170810178434#shanchain";

//域名
//static NSString * const kPrefixUrl   = @"http://115.29.177.22:18480";
//static NSString * const kPrefixUrl   = @"http://192.168.0.143:8080";
//static NSString * const kPrefixUrl = @"https://api.shanchain.com";
//static NSString * const kPrefixUrl = @"http://123.207.123.170:8090";
//static NSString *const kPrefixUrl = @"http://192.168.0.110:8080";

//static NSString * const KArkspotUrl = @"http://192.168.0.110:8080";
static NSString * const KArkspotUrl = @"http://47.91.178.114:8080";
static NSString * const KArkspotUrl1 = @"http://115.29.176.143:80";

static NSString * const KArkspotUrl2 = @"http://47.91.178.114:8090";

//阿里云地址
static NSString * const kAliFileHost = @"http://shanchain-seller.oss-cn-hongkong.aliyuncs.com";
//static NSString * const kAliFileAccessKeyId = @"";
//static NSString * const kAliFileAccessKeySecret = @"";
static NSString * const kAliFileBucketName = @"shanchain-seller";
static NSString * const kEndPoint = @"https://oss-cn-hongkong.aliyuncs.com";
static NSString * const kVersion = @"1.1";

//static NSString * const KResponseCodeSuccess = @"000000";

static NSString * const kContactPhone = @"";
static NSString * const kErrTip = @"系统错误，请联系客服协助处理。";
static NSString * const kNotReachableTip = @"你的网络好像不太给了，请稍后再试";
@interface Constants : NSObject
+ (NSString *)prefixUrl;

+ (NSString *)arkspotUrl;
+ (NSString *)arkspotUrl1;
+ (NSString *)arkspotUrl2;

+ (NSString *)getImgStrUrl:(NSString *)key;
+ (NSURL *)getImgUrl:(NSString *)key;

@end
