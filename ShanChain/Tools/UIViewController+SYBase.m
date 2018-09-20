//
//  UIViewController+SYBase.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/13.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "UIViewController+SYBase.h"

@implementation UIViewController (SYBase)

#pragma mark ------------------- add navigation bar ----------------------------------
- (UIButton *)addNavigationBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"nav_btn_back_default"]  forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    [backButton addTarget:self action:@selector(backToPoppedController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action: nil];
    flexItem.width = -15;
    self.navigationItem.leftBarButtonItems = @[flexItem, barItem];
    return backButton;
}

- (UIButton *)addNavigationRightWithName:(NSString *)name withTarget:(id)target withAction:(SEL)action {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    backButton.titleLabel.textAlignment = UITextAlignmentRight;
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [backButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [backButton setTitle:name forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action: nil];
    [flexItem setWidth:-15];
    self.navigationItem.rightBarButtonItems = @[flexItem, barItem];
    return backButton;
}

- (UIButton *)addNavigationRightWithImageName:(NSString *)imageName withTarget:(id)target withAction:(SEL)action {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action: nil];
    [flexItem setWidth:-15];
    self.navigationItem.rightBarButtonItems = @[flexItem, barItem];
    return backButton;
}

- (void)backToPoppedController {
    [self.navigationController popViewControllerAnimated:true];
}

@end
