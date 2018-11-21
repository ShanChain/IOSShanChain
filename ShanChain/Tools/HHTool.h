//
//  HHTool.h
//  ShanChain
//
//  Created by 千千世界 on 2018/10/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYHud.h"

@interface HHTool : NSObject

+ (YYHud *)showSucess:(NSString *)msg;
+ (YYHud *)showError:(NSString *)msg;
+ (void)dismiss;
+ (YYHud *)show:(NSString *)msg;
+ (YYHud *)showResponseObject:(NSDictionary *)response;
+ (YYHud *)showChrysanthemum;
+ (id)getControllerResponsder:(UIView*)view;
+ (void)openAppStore;
//获取设备当前网络IP地址
+(NSString *)getDeviceIPIpAddresses;
//获取当前window
+ (UIWindow *)mainWindow;
+ (UIImage*)getHeadImageWithSize:(CGSize)size;

@end
