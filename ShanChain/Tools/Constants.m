//
//  Constants.m
//  smartapc-ios
//
//  Created by list on 16/6/20.
//  Copyright © 2016年 list. All rights reserved.
//

#import "Constants.h"
//@interface Constants ()
//@property(nonatomic,copy)NSString *data;
//
//@end
@implementation Constants
+ (NSString *)prefixUrl {
    return @"";
}

+ (NSString *)arkspotUrl{
    return KArkspotUrl;
}

+ (NSString *)arkspotUrl1{
    return KArkspotUrl1;
}

+ (NSString *)arkspotUrl2{
    return KArkspotUrl2;
}

+ (NSURL *)getImgUrl:(NSString *)key {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kAliFileHost,key]];
}
@end
