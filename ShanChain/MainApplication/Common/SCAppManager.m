//
//  SCAppManager.m
//  ShanChain
//
//  Created by flyye on 2017/10/13.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SCTabbarController.h"
#import "SCAppManager.h"
#import "SCCacheTool.h"
#import "SCLoginController.h"
#import "SCBaseNavigationController.h"
#import "ShanChain-Swift.h"


//#import "JsonTool.h"
//开发时改成自己的IP
#define RN_RES_PATH @"http://192.168.137.217:8081/index.ios.bundle?platform=ios&dev=true"
//#define RN_RES_PATH @"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"


//#if DEBUG
//
//#define RN_DEBUG @"false"
//
//#if TARGET_OS_SIMULATOR
//#warning "DEBUG SIMULATOR"
//
//#define RN_RES_PATH @"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"
//
//#else
//#warning "DEBUG DEVICE"
//
//#define RN_RES_PATH  [NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios&dev=true",IP_ADDRESS]
//#endif
//#else
////release
//#define RN_DEBUG @"true"
//
//#endif

#define RN_DEBUG @"true"



@interface SCAppManager()

@end

@implementation SCAppManager

static SCAppManager *instance = nil;
+ (SCAppManager *)shareInstance {
    if (instance) {
        return instance;
    }
    @synchronized(self) {
        if (instance == nil) {
            instance = [[SCAppManager alloc] init];
            if([RN_DEBUG isEqualToString:@"false"]){
                instance.jsCodeLocation = [NSURL URLWithString:RN_RES_PATH];
            }else{
                instance.jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"RNBundle/index.ios" withExtension:@"jsbundle"];
//                instance.jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=false"];
            }
        }
    }
    return instance;
}


- (void)popViewControllerAnimated:(BOOL) animated{
    UIViewController* visibleVc = [self visibleViewController];
    if(visibleVc.navigationController != nil){
        [visibleVc.navigationController popViewControllerAnimated:animated];
    }else{
        [self openRootViewController];
    }
}

- (void)openRootViewController{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    SCTabbarController *tabbarC=[[SCTabbarController alloc]init];
    keyWindow.rootViewController=tabbarC;
}

- (UIViewController*)getRootViewController{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    return keyWindow.rootViewController;
}


- (void)pushToTopClass:(NSString *)className
            withController:(UIViewController *)controller
   withNavigationController:(UINavigationController *)navVc{
    
    [self popToClass:className withNavigationController:controller animated:NO];
    [navVc pushViewController:controller animated:YES];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController* visibleVc = [self visibleViewController];
    if(visibleVc.navigationController != nil){
        [visibleVc.navigationController pushViewController:viewController animated:animated];
    }else{
        [((UITabBarController*)[self getRootViewController]).selectedViewController.navigationController pushViewController:viewController animated:animated];
    }
}


- (void)pushViewController:(NSString *)viewController animated:(BOOL)animated parameter:(NSString *)jsonParam{
    UIViewController* visibleVc = [self visibleViewController];
    Class controllerCls = NSClassFromString(viewController);
    SCBaseViewController *vc = (SCBaseViewController *)[[controllerCls alloc] init];
    vc.rnParams = jsonParam;
    if(visibleVc.navigationController != nil){
        [visibleVc.navigationController pushViewController:vc animated:animated];
    }else{
        [((UITabBarController*)[self getRootViewController]).selectedViewController.navigationController pushViewController:vc animated:animated];
    }
}

//- (void)pushRNViewController:(NSString *)rnPageName animated:(BOOL)animated parameter:(NSString *)jsonParam{
//    NSDictionary *paramsDic = nil;
//    if(![jsonParam isEqualToString:@""]){
//        paramsDic = @{@"screenProps":jsonParam};
//    }
//    RNBaseViewController *rnVc = [[RNBaseViewController alloc] initWithScreenName:rnPageName initProperties:paramsDic];
//    UIViewController* visibleVc = [self visibleViewController];
//    
//    if(visibleVc.navigationController != nil){
//        [visibleVc.navigationController pushViewController:rnVc animated:animated];
//    }else{
//        
//        JCNavigationController *nav;
//        if ([[HHTool mainWindow].rootViewController isKindOfClass:[JCMainTabBarController  class]]) {
//            JCMainTabBarController  *tab = (JCMainTabBarController*)[HHTool mainWindow].rootViewController;
//            JCNavigationController *navController = tab.selectedViewController;
//            nav = navController;
//        }else{
//            nav = (JCNavigationController*)[HHTool mainWindow].rootViewController;
//        }
//        
//        [nav.topViewController.navigationController pushViewController:rnVc animated:animated];
////        [((UITabBarController*)[self getRootViewController]).selectedViewController.navigationController pushViewController:rnVc animated:animated];
//    }
//}

- (void)popToClass:(NSString *)className
                 withNavigationController:(UINavigationController *)navVc
                                animated:(BOOL)animated {
    if (navVc == nil || className == nil || [className length] < 1) {
        return;
    }
    
    UIViewController *topController = nil;
    for (NSInteger i = [navVc.viewControllers count] - 1; i >= 0; i--) {
        UIViewController *controller = [navVc.viewControllers objectAtIndex:i];
        if ([controller isKindOfClass:NSClassFromString(className)]) {
            topController = controller;
            break;
        }
    }
    
    if (topController) {
        [navVc popToViewController:topController animated:animated];
    } else {
        [navVc popToRootViewControllerAnimated:animated];
    }
}

- (UIViewController*)visibleViewController{
    AppDelegate *delegate = [AppDelegate sharedInstance];
    UIViewController *rootVc = delegate.window.rootViewController;
    
    if ([rootVc isKindOfClass:[SCTabbarController class]]) {
        SCTabbarController *tabVc = (SCTabbarController *)rootVc;
        if (tabVc.presentedViewController != nil) {
            UIViewController *presentedVc = tabVc.presentedViewController;
            if ([presentedVc isKindOfClass:[UINavigationController class]]) {
                return [(UINavigationController *)presentedVc visibleViewController];
            } else {
                return presentedVc;
            }
        } else {
            UIViewController *con = tabVc.selectedViewController;
            if ([con isKindOfClass:[UINavigationController class]]) {
                return [(UINavigationController *)con visibleViewController];
            }
            return con;
        }
    }else if ([rootVc isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)rootVc visibleViewController];
    }
    return rootVc;
}

- (BOOL)isLogin{
    NSString *userId = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:@"0" andKey:@"curUser"];
    if (userId == nil || [userId isEqualToString:@""]) {
        return NO;
    }
    NSString *token = @"";
    token = [[SCCacheTool shareInstance]getCacheValueInfoWithUserID:userId andKey:@"token"];
    if (token == nil || [token isEqualToString:@""]) {
        return NO;
    }
    return YES;
}


-(void)cacheLoginUserId:(NSString *)userId
                  token:(NSString *)token
                spaceId:(NSString *)spaceId
            chatacterId:(NSString *)characterId
             hxUserName:(NSString *)hxUserName
             hxPassword:(NSString *)hxPassword channel:(NSString *)channel
{
    [[SCCacheTool shareInstance]setCacheValue:characterId withUserID:userId andKey:CACHE_CHARACTER_ID];
    [[SCCacheTool shareInstance]setCacheValue:spaceId withUserID:userId andKey:CACHE_SPACE_ID];
    [[SCCacheTool shareInstance] setCacheValue:userId withUserID:@"0" andKey:CACHE_CUR_USER];
    if (!NULLString(channel)) {
        [[SCCacheTool shareInstance] setCacheValue:channel withUserID:userId  andKey:CACHE_APP_CHANNEL];
    }
    if (!NULLString(token)) {
        [[SCCacheTool shareInstance] setCacheValue:token withUserID:userId  andKey:CACHE_TOKEN];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:characterId forKey:@"characterId"];
    [dict setObject:spaceId forKey:@"spaceId"];
    [dict setObject:token forKey:@"token"];
    //缓存gData，目前主要提供h5和RN使用
    NSString *gData = [JsonTool stringFromDictionary:dict];
    [[SCCacheTool shareInstance]setCacheValue:gData withUserID:userId andKey:CACHE_GDATA];
    [[SCCacheTool shareInstance] setCacheValue:hxUserName withUserID:userId andKey:CACHE_HX_USER_NAME];
    [[SCCacheTool shareInstance]setCacheValue:hxPassword withUserID:userId andKey:CACHE_HX_PWD];
}

-(void)clearUserCache{
    
}

-(void)switchRoleWithSpaceId:(NSString *)spaceId modelId:(NSString *)modelId{
    
    NSString *userId = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:@"0" andKey:CACHE_CUR_USER];
    NSString *token = [[SCCacheTool shareInstance]getCacheValueInfoWithUserID:userId andKey:CACHE_TOKEN];
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    [params1 setObject:modelId forKey:@"modelId"];
    [params1 setObject:spaceId forKey:@"spaceId"];
    [params1 setObject:userId forKey:@"userId"];
    [params1 setObject:token forKey:@"token"];
    [SYProgressHUD showMessage:@"正在穿越..."];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[SCNetwork shareInstance]postWithUrl:STORYCHARACTERCHANGE parameters:params1 success:^(id responseObject) {
            if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
                NSDictionary *data = responseObject[@"data"];
                NSDictionary *hxAccount = data[@"hxAccount"];
                NSDictionary *characterInfo = data[@"characterInfo"];
                [[SCCacheTool shareInstance] setCacheValue:[JsonTool stringFromDictionary:characterInfo] withUserID:userId andKey:CACHE_CHARACTER_INFO];
                NSString *spaceId = [characterInfo[@"spaceId"] stringValue];
                NSString *characterId = [characterInfo[@"characterId"] stringValue];
                NSString *hxUserName = hxAccount[@"hxUserName"];
                NSString *hxPassword = hxAccount[@"hxPassword"];
                [[SCAppManager shareInstance] cacheLoginUserId:userId token:token spaceId:spaceId chatacterId:characterId hxUserName:hxUserName hxPassword:hxPassword channel:SC_APP_CHANNEL];
                NSMutableDictionary *params0 = [NSMutableDictionary dictionary];
                [params0 setObject:spaceId forKey:@"spaceId"];
                [params0 setObject:token forKey:@"token"];
                [[SCNetwork shareInstance]postWithUrl:GET_SPACE_BY_ID parameters:params0 success:^(id responseObject) {
                    if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
                        NSDictionary *data = responseObject[@"data"];
                        NSString *spaceInfo = @"";
                        NSString *spaceName = @"";
                        spaceName = data[@"name"];
                        spaceInfo = [JsonTool stringFromDictionary:data];
                        if(![spaceInfo isEqualToString:@""]){
                            [[SCCacheTool shareInstance] setCacheValue:spaceName withUserID:userId andKey:CACHE_SPACE_NAME];
                            [[SCCacheTool shareInstance] setCacheValue:spaceInfo withUserID:userId andKey:CACHE_SPACE_INFO];
                        }
                        
                        [SYProgressHUD hideHUD];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                            SCTabbarController *tabbarC=[[SCTabbarController alloc]init];
                            keyWindow.rootViewController=tabbarC;
                        });
                    }
                } failure:^(NSError *error) {
                    SCLog(@"%@",error);
                    [SYProgressHUD hideHUD];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                        SCTabbarController *tabbarC=[[SCTabbarController alloc]init];
                        keyWindow.rootViewController=tabbarC;
                    });
                }];
            }
        } failure:^(NSError *error) {
            [SYProgressHUD hideHUD];
            SCLog(@"%@",error);
        }];
    });
}

- (void)selectLogout{
    [JMSGUser logout:nil];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    SCBaseNavigationController *nav = (SCBaseNavigationController*)keyWindow.rootViewController;
    [nav.topViewController hrShowAlertWithTitle:nil message:NSLocalizedString(@"sc_login_Exitcurrentaccount", nil) buttonsTitles:@[NSLocalizedString(@"sc_cancel", nil),NSLocalizedString(@"sc_login_Confirm", nil)] andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
        if (indexOfAction == 1) {
            NSString *userId = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:@"0" andKey:CACHE_CUR_USER];
            [[SCCacheTool shareInstance] dropTableWithUserId:userId];
            [[SCCacheTool shareInstance] setCacheValue:@"" withUserID:@"0" andKey:CACHE_CUR_USER];
            SCLoginController *loginVC=[[SCLoginController alloc]init];
            keyWindow.rootViewController = [[SCBaseNavigationController alloc]initWithRootViewController:loginVC];
        }
    }];
}

-(void)logout{
    [JMSGUser logout:nil];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    NSString *userId = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:@"0" andKey:CACHE_CUR_USER];
    [[SCCacheTool shareInstance] dropTableWithUserId:userId];
    [[SCCacheTool shareInstance] setCacheValue:@"" withUserID:@"0" andKey:CACHE_CUR_USER];
    SCLoginController *loginVC=[[SCLoginController alloc]init];
    keyWindow.rootViewController = [[SCBaseNavigationController alloc]initWithRootViewController:loginVC];
}

// 实名认证
- (void)realNameAuthenticate{
    [HHTool immediatelyDismiss];
    RealNameVeifiedViewController  *realNameVC = [[RealNameVeifiedViewController alloc]init];
    JCNavigationController *nav = [[JCNavigationController alloc]initWithRootViewController:realNameVC];
    [[HHTool getCurrentVC]presentViewController:nav animated:YES completion:nil];
}

-(void)configWalletInfoWithType:(NSString*)type{
    [HHTool immediatelyDismiss];
    if ([type isEqualToString:SC_ERROR_WalletAccountNotexist]) {
        [[HHTool getCurrentVC]sc_hrShowAlertWithTitle:nil message:@"您尚未开通马甲钱包，开通后方可使用该功能" buttonsTitles:@[@"返回",@"去开通"] andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
            if (indexOfAction == 1) {
                [self openH5_WalletInfo];
            }
        }];
    } else {
        [self openH5_WalletInfo];
    }
}


-(void)openH5_WalletInfo{
    MyWalletViewController  *walletVC = [[MyWalletViewController alloc]init];
    JCNavigationController *walletNav = [[JCNavigationController alloc]initWithRootViewController:walletVC];
    UINavigationController  *nav;
    if ([[HHTool getCurrentVC] isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController*)[HHTool getCurrentVC];
    }else{
        nav = [HHTool getCurrentVC].navigationController;
    }
    
    [nav presentViewController:walletNav animated:YES completion:nil];
}

- (void)againUploadPasswordWithUrl:(NSString*)url parameters:(NSDictionary*)parameters Callback:(void(^)(NSString * authCode, NSString * _url, NSDictionary * _parameters))callback{
    UploadPhotePasswordView  *uploadView = [[UploadPhotePasswordView alloc]initWithFrame:[HHTool getCurrentVC].view.frame];
    weakify(uploadView);
    uploadView.closure = ^(BOOL  success, NSString * _Nonnull authCode) {
        BLOCK_EXEC(callback,authCode,[[[NSMutableString alloc]initWithString:url]copy],parameters.copy);
        [weak_uploadView removeFromSuperview];
    };
    [[HHTool getCurrentVC].view addSubview:uploadView];
}

- (void)againUploadPasswordCallback:(void(^)(NSString * authCode))callback{
    UploadPhotePasswordView  *uploadView = [[UploadPhotePasswordView alloc]initWithFrame:[HHTool getCurrentVC].view.frame];
    weakify(uploadView);
    uploadView.closure = ^(BOOL  success, NSString * _Nonnull authCode) {
        BLOCK_EXEC(callback,authCode);
        [weak_uploadView removeFromSuperview];
    };
    [[HHTool getCurrentVC].view addSubview:uploadView];
    
}


@end
