//
//  AppDelegate+Config.h
//  ShanChain
//
//  Created by 千千世界 on 2018/10/30.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Config)

- (void)setupUMPushNoticationWithLaunchOptions:(NSDictionary *)launchOptions;
- (void)setupHXConfigWithApplication:(UIApplication *)application;
- (void)setIQkeyboard;

@end
