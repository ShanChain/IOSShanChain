//
//  UIViewController+YBGeneral.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "UIViewController+YBGeneral.h"

@implementation UIViewController (YBGeneral)

- (void)YBGeneral_baseConfig {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

@end

@implementation UIViewController (YBGeneralBackItem)

- (void)YBGeneral_configBackItem {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(YBGeneral_clickBackItem:)];
    backItem.image = [[UIImage imageNamed:@"btn_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)YBGeneral_clickBackItem:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
