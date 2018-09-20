//
//  RNCommonCachehelper.m
//  ShanChain
//
//  Created by flyye on 2017/10/12.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "RNCommonCachehelper.h"
#import "SCCacheTool.h"


@implementation RNCommonCachehelper 

RCT_EXPORT_MODULE(CommonCacheHelper);


RCT_EXPORT_METHOD(setCache:(NSString *)userId key: (NSString*)key value: (NSString*)value){
    SCLog(@"open alert with userId:%@,key:%@,value:%@",userId,key,value);
    [[SCCacheTool shareInstance] setCacheValue:value withUserID:userId andKey:key];
    
}


RCT_EXPORT_METHOD(getCacheAsync:(NSString *)userId key:(NSString *)key resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
 SCLog(@"getCacheAsync");
   NSString *value = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:key];
    resolve(value);
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getCache:(NSString *)userId key: (NSString*)key)
{
    SCLog(@"getCache");
    NSString *value = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:key];
    return value;
}

@end
