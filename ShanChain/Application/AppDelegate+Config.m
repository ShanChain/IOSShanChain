//
//  AppDelegate+Config.m
//  ShanChain
//
//  Created by 千千世界 on 2018/10/30.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "AppDelegate+Config.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"
#import "JPUSHService.h"



@implementation AppDelegate (Config)


- (void)setReceiveMonitorNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJMSGNetworkDidSetupNotification) name:kJMSGNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJMSGNetworkDidCloseNotification) name:kJMSGNetworkDidCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJPFNetworkDidSetupNotification) name:kJPFNetworkDidSetupNotification object:nil];
    
}
#pragma mark -- JMessage 建立连接成功
- (void)kJMSGNetworkDidSetupNotification{
    [SCCacheTool shareInstance].isJGSetup = YES;
}
#pragma mark -- JMessage 连接被关闭
- (void)kJMSGNetworkDidCloseNotification{
    
}
#pragma mark -- JPush 建立连接成功
- (void)kJPFNetworkDidSetupNotification{
    NSString  *userID = [SCCacheTool shareInstance].getCurrentUser;
    if (!NULLString(userID)) {
        [JPUSHService setAlias:userID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:10];
    }
 
}


- (void)setIQkeyboard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}


- (void)setupShareConfig{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ] onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType) {
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
                                                    break;
                                                case SSDKPlatformTypeQQ:
                                                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                    break;
                                                case SSDKPlatformTypeSinaWeibo:
                                                    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                    break;
                                                default:
                                                    break;
                                            }
                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                            switch (platformType) {
                                                case SSDKPlatformTypeSinaWeibo:
                                                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                                    [appInfo SSDKSetupSinaWeiboByAppKey:@"1752792699"
                                                                              appSecret:@"5e5e8068d9d59243eea2b66c413be68e"
                                                                            redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                                                               authType:SSDKAuthTypeBoth];
                                                    break;
                                                case SSDKPlatformTypeWechat:
                                                    [appInfo SSDKSetupWeChatByAppId:@"wxf3ca04328ebf58f1"
                                                                          appSecret:@"10f4c1761c9be09d630e766b4a700843"];
                                                    break;
                                                case SSDKPlatformTypeQQ:
                                                    [appInfo SSDKSetupQQByAppId:@"1106603714"
                                                                         appKey:@"cysXSCMGkW5yGU62"
                                                                       authType:SSDKAuthTypeBoth];
                                                    break;
                                                default:
                                                    break;
                                            }
                                        }];
}


- (void)setupUMPushNoticationWithLaunchOptions:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:kUMengPushKey launchOptions:launchOptions httpsEnable:YES];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    [UMessage setLogEnabled:NO];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    [self setupShareConfig];
}


#pragma mark --------------------------- init handler ---------------------------
- (void)setupHXConfigWithApplication:(UIApplication *)application{
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"develop";
#else
    apnsCertName = @"Hoc";
#endif
    EMOptions *options = [EMOptions optionsWithAppkey:KHXKey];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    EMPushOptions *pushOptions = [[EMClient sharedClient] pushOptions];
    pushOptions.displayStyle = EMPushDisplayStyleMessageSummary; // 显示消息内容
    // options.displayStyle = EMPushDisplayStyleSimpleBanner // 显示“您有一条新消息”
    EMError *error = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
    if(!error) {
        // 成功
    }else {
        // 失败
    }
    //iOS10 注册APNs
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                dispatch_main_async_safe(^{
                    [application registerForRemoteNotifications];
                });
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
    
    //添加监听在线推送消息
    //  [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

@end
