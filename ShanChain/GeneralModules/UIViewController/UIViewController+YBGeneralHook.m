//
//  UIViewController+YBGeneralHook.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "UIViewController+YBGeneralHook.h"
#import "UIViewController+YBGeneral.h"
#import <objc/runtime.h>

@implementation UIViewController (YBGeneralHook)

+ (void)load {
    [self YBGeneralHook_exchangeImplementationsWithOriginSel:@selector(viewDidLoad) customSel:@selector(YBGeneralHook_viewDidLoad)];
}

+ (void)YBGeneralHook_exchangeImplementationsWithOriginSel:(SEL)originSel customSel:(SEL)customSel {
    Method origin = class_getInstanceMethod(self, originSel);
    Method custom = class_getInstanceMethod(self, customSel);
    if (origin && custom) {
        method_exchangeImplementations(origin, custom);
    }
}

- (void)YBGeneralHook_viewDidLoad {
    NSLog(@"进入：%@", self);
    if (self.navigationController && [self.navigationController.viewControllers indexOfObject:self] != 0) {
        [self YBGeneral_configBackItem];
    }
    
    [self YBGeneralHook_viewDidLoad];

    
}


@end
