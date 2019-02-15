//
//  SCBaseVC.h
//  ShanChain
//
//  Created by krew on 2017/5/15.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBaseViewController.h"

@interface SCBaseVC : SCBaseViewController

- (void)setKeyBoardAutoHidden;

- (void)showLoading;

- (void)hideLoading;

- (void)layoutUI;

- (void)registerNotification;

- (void)addLeftEdgeSwipeBack;

- (void)popToViewControllerClass:(Class)viewControllerClass withAnimation:(BOOL)animated;

- (void)pushPage:(UIViewController *)viewController Animated:(BOOL)animated;

- (void)showNavigationBarWithNormalColor;
- (void)showNavigationBarWhiteColor;

//返回到上一层，直到dismiss
- (UIViewController *)backViewController;
- (void)dismissPrestingViewController;

@end
