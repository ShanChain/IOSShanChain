//
//  APIClient.h
//  smartapc-ios
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 list. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"

// 请求响应的状态
typedef NS_ENUM(NSInteger, ApiRequestStatusCode) {
    ApiRequestNotReachable = -2,    // 当前网络已断开
    ApiRequestErr          = -1,    // 请求出错
    ApiRequestOK           = 0,     // 请求成功
};

// 请求的方法类型
typedef NS_ENUM(NSInteger, HttpMethod) {
    GET         = 0,
    POST        = 1,
    DELETE      = 2,
    PUT         = 3,
    PATH_GET    = 4, // GET请求,填充参数到url上,处理@"user/account/check/{phone}",{phone}这种情况
    QUERY_GET   = 5, // GET请求,填充query参数到url上,处理"?a=1&b=2"这种情况
};

typedef NS_ENUM(NSInteger,HttpRespond){
    COMMON_SUC_CODE = 000000,
    COMMON_ERR_CODE = 999999,
    SMSVC_ERR_CODE  = 999998,
    USER_REPEAT_ERR_CODE = 999997,
    LOGIN_ERR_CODE = 999996,
    
};

typedef NS_ENUM(NSInteger,UserType){
    USER_TYPE_WEIXIN = 0,
    USER_TYPE_WEIBO  = 1,
    USER_TYPE_QQ     = 2,
    USER_TYPE_FB     = 3,
    USER_TYPE_MOBILE = 4,
    USER_TYPE_EMAIL  = 5,
    USER_TYPE_SC     = 6,
};


// 请求响应Block
typedef void (^APIClientRequestResponse)(ApiRequestStatusCode requestStatusCode, id JSON);

@protocol APIClientDelegate <NSObject>

@required
// 拦截成功请求响应数据进行处理
- (void)handleSuccessRequest:(id)JSON completion:(void(^)(id aJSON))cb;

@end

@interface APIClient : NSObject

// 为处理拦截的响应数据而设置的委托
@property (nonatomic, weak) id<APIClientDelegate> delegate;

// 声明单例
AS_SINGLETON(APIClient);

// 获取当前的网络状态类型(返回:0-No wifi or cellular(无网络), 1-2G, 2-3G, 3-4G, 4-LTE, 5-wifi)
+ (int)networkType;

// 网络状态监听，应用当前是否有网络:有返回YES,没有返回NO
+ (void)networkReachableWithBlock:(void(^)(BOOL isReachable))block;

// 发送请求，返回JSON格式的响应数据
+ (void)requestURL:(NSString *)urlString
        httpMethod:(HttpMethod)method
            params:(NSDictionary *)params
          response:(APIClientRequestResponse)response;

// 取消掉所有网络请求
+ (void)cancelAllRequest;

@end
