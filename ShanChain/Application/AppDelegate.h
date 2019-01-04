//
//  AppDelegate.h
//  ShanChain
//
//  Created by krew on 2017/5/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSURL      *url;

+ (AppDelegate *)sharedInstance;

// 进入登录页面
- (void)enterLoginWindowVC;

@end

