//
//  YBNaviagtionViewController.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "YBNaviagtionViewController.h"


@interface YBNaviagtionViewController ()

@end

@implementation YBNaviagtionViewController

#pragma mark - life cycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self configNavigationBar];
    }
    return self;
}

#pragma mark - private

- (void)configNavigationBar {
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = YBGeneralColor.navigationBarColor;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.navigationBarTitleColor, NSFontAttributeName:YBGeneralFont.navigationBarTitleFont}];
}

#pragma mark - overwrite

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
