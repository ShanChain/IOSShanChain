//
//  VersionUtils.h
//  ShanChain
//
//  Created by flyye on 2017/12/16.
//  Copyright © 2017年 ShanChain. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface VersionUtils : NSObject

+(BOOL)compareVersion:(NSString *)nowVersion withServerVersion:(NSString *)serverVersion;

@end

