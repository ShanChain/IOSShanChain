//
//  SCNetwork.h
//  ShanChain
//
//  Created by flyye on 2017/10/23.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#ifndef SCNetwork_h
#define SCNetwork_h

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

//static NSString * const SC_BASE_URL = @"https://api.shanchain.com";
//static NSString * const SC_BASE_URL = @"http://47.91.178.114:8080";
//static NSString * const SC_BASE_URL = @"http://192.168.1.113:8080";
#define SC_BASE_URL  Base_url
#define SC_BASE_PORT_8082  @"http://95.169.24.11:8082"
#define SC_BASE_PORT_8083  @"http://95.169.24.11:8083"

@interface SCNetwork : NSObject

+(SCNetwork *)shareInstance;


- (void)postWithUrl:(NSString *)url
                parameters:(id)parameters
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

-(void)getWithUrl:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

- (void)uploadImagesWihtImgArr:(NSArray *)imgArr
                           url:(NSString *)url
                    parameters:(id)parameters
                         block:(void (^)(id objc,BOOL success))block;

- (void)downFileWithUrl:(NSString *)urlString
                  block:(void (^)(id objc,BOOL success))block;


- (void)rnRequest:(NSDictionary *)options
  successCallback:(RCTResponseSenderBlock)successCallback
    errorCallBack:(RCTResponseErrorBlock)errorCallBack;

@end


#endif /* SCNetwork_h */
