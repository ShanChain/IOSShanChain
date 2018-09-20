//
//  GPTabbarController.h
//  09-自定义TabbarController
//
//  Created by vera on 15/8/19.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTabbarController : UITabBarController

- (void)showBadgeAtIndex:(NSInteger *)index badgeValue:(NSString *)value;
- (void)setNotificationsShowStatus:(BOOL)status;
@end

