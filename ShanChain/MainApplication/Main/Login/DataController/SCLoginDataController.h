//
//  SCLoginDataController.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/12.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"
#import "JSHAREService.h"

@interface SCLoginDataController : NSObject

+ (void)successLoginedWithContent:(NSDictionary *)content;
+ (void)otherLoginWithPlatfrom:(JSHAREPlatform)platfrom bindPhoneNumberCallBack:(void (^)(NSString *encryptOpenId))callBack; //三方登录

@end
