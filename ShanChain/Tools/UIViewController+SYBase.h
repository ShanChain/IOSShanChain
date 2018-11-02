//
//  UIViewController+SYBase.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/13.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (SYBase)

- (UIButton *)addNavigationBackButton;

- (UIButton *)addNavigationRightWithName:(NSString *)name withTarget:(id)target withAction:(SEL)action;

- (UIButton *)addNavigationRightWithImageName:(NSString *)imageName withTarget:(id)target withAction:(SEL)action;

- (void)backToPoppedController;


- (void)addRightBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
- (void)addLeftBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
- (void)addLeftBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage isCircle:(BOOL)isCircle;

- (void)addRightBarButtonItemWithTarget:(id)target sel:(SEL)selector title:(NSString*)title tintColor:(UIColor *)tintColor;
- (void)addLeftBarButtonItemWithTarget:(id)target sel:(SEL)selector title:(NSString*)title tintColor:(UIColor *)tintColor;

@end
