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

@end
