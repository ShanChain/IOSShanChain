//
//  MBProgressHUD.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/8.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYProgressHUD.h"

@implementation SYProgressHUD

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil)
        //拿到最上面的view的视图
        view = [SYProgressHUD windowTopView];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.opacity = 0.65;
    hud.margin = 22;
    hud.cornerRadius = 6;
    hud.dimBackground = YES;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.5];
}

+ (void)showError:(NSString *)msg {
    dispatch_main_async_safe(^{
        [SYProgressHUD show:msg icon:@"MBProgressHUD.bundle/error" view:nil];
    });
}

+ (void)showMessage:(NSString *)text {
    dispatch_main_async_safe(^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[SYProgressHUD windowTopView] animated:YES];
        hud.label.text = text;
        hud.opacity = 0.65;
        hud.margin = 22;
        hud.square = YES;
        hud.labelFont = [UIFont systemFontOfSize:15];
        hud.detailsLabelFont = [UIFont systemFontOfSize:13];
        hud.cornerRadius = 6;
        hud.dimBackground = YES;
        hud.removeFromSuperViewOnHide = YES;
        hud.dimBackground = YES;
        hud.minShowTime = 0.3;
    });
}

+ (void)showSuccess:(NSString *)msg {
    dispatch_main_async_safe(^{
        [SYProgressHUD show:msg icon:@"MBProgressHUD.bundle/success" view:nil];
    });
}

+ (void)hideHUD {
    dispatch_main_async_safe(^{
        [MBProgressHUD hideHUDForView:[SYProgressHUD windowTopView] animated:YES];
    });
}

+ (UIView *)windowTopView {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    return window.rootViewController.view;
}
@end
