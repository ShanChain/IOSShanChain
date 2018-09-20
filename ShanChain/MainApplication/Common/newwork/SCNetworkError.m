//
//  SCNetworkError.m
//  ShanChain
//
//  Created by flyye on 2017/10/23.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetworkError.h"

@implementation SCNetworkError

+ (NSError *)errorWithCode:(NSInteger)code msg:(NSString *)msg {
    return [NSError errorWithDomain:@"SCRequestErrDomain" code:code userInfo:@{NSLocalizedDescriptionKey:msg}];
}

@end
