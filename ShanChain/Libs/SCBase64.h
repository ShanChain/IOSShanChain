//
//  SCBase64.h
//  ShanChain
//
//  Created by krew on 2017/7/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCBase64 : NSObject

+ (NSString *)encodeBase64String:(NSString *)input;

+ (NSString *)decodeBase64String:(NSString *)input;

+ (NSString *)encodeBase64Data:(NSData *)data;

+ (NSString *)decodeBase64Data:(NSData *)data;


@end
