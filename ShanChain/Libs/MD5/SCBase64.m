//
//  SCBase64.m
//  ShanChain
//
//  Created by krew on 2017/7/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCBase64.h"

@implementation SCBase64

+ (NSString *)encodeBase64String:(NSString * )input {
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    data = [GTMBase64 encodeData:data];
    
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
    
}



+ (NSString*)decodeBase64String:(NSString * )input {
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    data = [GTMBase64 decodeData:data];
    
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
    
}



+ (NSString*)encodeBase64Data:(NSData *)data {
    
    data = [GTMBase64 encodeData:data];
    
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
    
}



+ (NSString*)decodeBase64Data:(NSData *)data {
    
    data = [GTMBase64 decodeData:data];
    
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
    
}


@end
