//
//  AppDelegate.h
//  ShanChain
//
//  Created by krew on 2017/5/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSURL      *url;

+ (AppDelegate *)sharedInstance;

// 进入登录页面
- (void)enterLoginWindowVC;

@end

