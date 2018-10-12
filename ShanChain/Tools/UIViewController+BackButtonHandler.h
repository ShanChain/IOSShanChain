//
//  UIViewController+BackButtonHandler.h
//  BL_BaseApp
//
//  Created by 黄宏盛 on 2017/1/5.
//  Copyright © 2017年 黄宏盛. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>

-(void)hh_rewriteBackActionFunc:(SEL)sel;
- (void)QRCodeScanVC:(UIViewController *)scanVC;//push到二维码页面

@end
