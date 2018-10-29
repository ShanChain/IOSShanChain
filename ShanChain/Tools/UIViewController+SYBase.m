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

- (void)addLeftBarButtonItemWithTarget:(id)target sel:(SEL)selector title:(NSString*)title tintColor:(UIColor *)tintColor
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:(UIBarButtonItemStylePlain) target:target action:selector];
    item.tintColor = tintColor;
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [array addObject:item];
    self.navigationItem.leftBarButtonItems = array;
}



- (void)addLeftBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = CGRectMake(0, 0, image.size.width <= 25 ? 25 : image.size.width, image.size.height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [array addObject:item];
    self.navigationItem.leftBarButtonItems = array;
}

- (void)addRightBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, image.size.width <= 25 ? 25 : image.size.width, image.size.height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [array addObject:item];
    self.navigationItem.rightBarButtonItems = array;
}

- (void)addRightBarButtonItemWithTarget:(id)target sel:(SEL)selector title:(NSString*)title tintColor:(UIColor *)tintColor

{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80,30);
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:(UIControlStateNormal)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitleColor:tintColor forState:UIControlStateNormal];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [array addObject:item];
    self.navigationItem.rightBarButtonItems = array;
}

- (void)backToPoppedController {
    [self.navigationController popViewControllerAnimated:true];
}

@end
