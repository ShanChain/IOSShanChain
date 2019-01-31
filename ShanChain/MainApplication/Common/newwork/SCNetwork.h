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
#import "HHBaseModel.h"

//static NSString * const SC_BASE_URL = @"https://api.shanchain.com";
//static NSString * const SC_BASE_URL = @"http://47.91.178.114:8080";
//static NSString * const SC_BASE_URL = @"http://192.168.1.113:8080";
#define SC_BASE_URL  Base_url


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


- (void)downFileWithUrl:(NSString *)urlString
                  block:(void (^)(id objc,BOOL success))block;


-(void)v1_postWithUrl:(NSString *)url params:(id)parameters showLoading:(BOOL)show callBlock:(void (^)(HHBaseModel *baseModel, NSError *error))callBlock;
- (void)HH_postWithUrl:(NSString *)url params:(NSDictionary *)parameters showLoading:(BOOL)show callBlock:(void(^)(HHBaseModel *baseModel,NSError *error))callBlock;
- (void)HH_GetWithUrl:(NSString *)url parameters:(id)parameters showLoading:(BOOL)show callBlock:(void (^)(HHBaseModel *baseModel, NSError *error))callBlock;

- (void)HH_uploadFileWithArr:(NSArray*)imgArr url:(NSString *)url parameters:(id)parameters showLoading:(BOOL)show callBlock:(void(^)(HHBaseModel *baseModel,NSError *error))callBlock;

@end


#endif /* SCNetwork_h */
