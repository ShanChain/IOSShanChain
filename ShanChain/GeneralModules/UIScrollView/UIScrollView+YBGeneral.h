//
//  UIScrollView+YBGeneral.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/20.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (YBGeneral)

- (void)YBGeneral_addRefreshHeader:(void(^)(void))block;
- (void)YBGeneral_addRefreshFooter:(void(^)(void))block;
- (void)YBGeneral_addRefreshHeader:(void(^)(void))blockH footer:(void(^)(void))blockF;

@end

NS_ASSUME_NONNULL_END
