//
//  NSString+URL.m
//  ShanChain
//
//  Created by krew on 2017/7/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return encodedString;
}

@end
