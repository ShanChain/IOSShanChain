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

+ (BOOL)_IS_IPHONE_5;
+ (BOOL)_IS_IPHONE_6;
+ (BOOL)_IS_IPHONE_6P;
+ (BOOL)_IS_IPHONE_X;

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
// 获取视频第一帧
+ (UIImage*) getVideoPreViewImage:(NSURL *)path;

// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

#pragma mark -- 获取当前语言
+ (NSString*)getPreferredLanguage;
/**
 * @method
 *
 * @brief 根据路径获取视频时长和大小
 * @param path       视频路径
 * @return    字典    @"size"－－文件大小   @"duration"－－视频时长
 */
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSURL *)path;

@end
