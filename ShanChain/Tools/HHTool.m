//
//  HHTool.m
//  ShanChain
//
//  Created by 千千世界 on 2018/10/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "HHTool.h"

@implementation HHTool

+ (YYHud *)showSucess:(NSString *)msg{
   return  [YYHud showSucess:msg];
}

+ (YYHud *)showError:(NSString *)msg{
    return  [YYHud showError:msg];
}

+ (void)dismiss {
    [[YYHud sharedInstance] dismiss];
}

+ (YYHud *)show:(NSString *)msg {
    return [[YYHud sharedInstance] show:msg];
}

+ (YYHud *)showChrysanthemum{
    return [[YYHud sharedInstance] show:@""];
}

+ (YYHud *)showResponseObject:(NSDictionary *)response{
    if (!response) {
        return nil;
    }
    NSString  *msg = response[@"message"];
    if NULLString(msg) return nil;
    return  [YYHud showSucess:msg];
}

+ (id)getControllerResponsder:(UIView*)view{
    id  object = [view nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object!= nil) {
        object = [object nextResponder];
    }
    return object;
}

+(void)openAppStore{
    NSString * url = [NSString stringWithFormat:@"itms://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",AppStoreID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
