//
//  JsonTool.m
//  ShanChain
//
//  Created by flyye on 2017/12/16.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionUtils.h"

@implementation VersionUtils

+(BOOL)compareVersion:(NSString *)nowVersion withServerVersion:(NSString *)serverVersion{
    if (![NSString isBlankString:nowVersion] && ![NSString isBlankString:serverVersion]) {
        NSArray *nowVersions = [nowVersion componentsSeparatedByString:@"."];
        NSArray *serverVersions = [serverVersion componentsSeparatedByString:@"."];
        if (nowVersions != nil && serverVersions != nil && nowVersions.count > 1 && serverVersions.count > 1) {
            int nowVersionsFirst = [nowVersions[0] integerValue];
            int serverVersionFirst = [serverVersions[0] integerValue];
            int nowVersionsSecond = [nowVersions[1] integerValue];
            int serverVersionSecond = [serverVersions[1] integerValue];
            int nowVersionsThird = [nowVersions[2] integerValue];
            int serverVersionThird = [serverVersions[2] integerValue];
            if (nowVersionsFirst < serverVersionFirst) {
                return YES;
            } else if (nowVersionsFirst == serverVersionFirst && nowVersionsSecond < serverVersionSecond) {
                return YES;
            } else if (nowVersionsFirst == serverVersionFirst && nowVersionsSecond == serverVersionSecond && nowVersionsThird < serverVersionThird) {
                return YES;
            }
        }
    }
    return NO;
}


@end
