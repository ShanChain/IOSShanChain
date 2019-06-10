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
#import "JSHAREService.h"
#import "ShanChain-Swift.h"
#import "JPushUserInfo.h"
#import "MyWalletViewController.h"
#import <Bugly/Bugly.h>
#import "SystemInformationViewController.h"
#import "NSDate+Formatter.h"


@implementation AppDelegate (Config)


- (void)setReceiveMonitorNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJMSGNetworkDidSetupNotification) name:kJMSGNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJMSGNetworkDidCloseNotification) name:kJMSGNetworkDidCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJPFNetworkDidSetupNotification) name:kJPFNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJPFNetworkDidRegisterNotification) name:kJPFNetworkDidRegisterNotification object:nil];
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
   
 
}
#pragma mark -- JPush 注册成功
- (void)kJPFNetworkDidRegisterNotification{
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
    }];
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

- (void)setupJshareConfig{
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = JMSSAGE_APPKEY;
    config.SinaWeiboAppKey = SinaWeibo_AppKey;
    config.SinaWeiboAppSecret = SinaWeibo_appSecret;
    config.SinaRedirectUri = @"https://api.weibo.com/oauth2/default.html";
    config.isSupportWebSina = YES;
    config.QQAppId = QQ_AppId;
    config.QQAppKey = QQ_Appkey;
    config.WeChatAppId = WeChat_AppId;
    config.WeChatAppSecret = WeChat_appSecret;
    config.JChatProAuth = JMSSAGE_APPKEY;
    config.FacebookAppID = FACEBOOK_ID;
    config.FacebookDisplayName = @"MarJar";
    [JSHAREService setupWithConfig:config];
    [JSHAREService setDebug:NO];
    
}



- (void)setupUMPushNoticationWithLaunchOptions:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:kUMengPushKey launchOptions:launchOptions httpsEnable:YES];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    [UMessage setLogEnabled:NO];
    [Bugly startWithAppId:@"0b5bef698c"];
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
    
  //  [self setupShareConfig];
}


#pragma mark --------------------------- init handler ---------------------------
- (void)setupHXConfigWithApplication:(UIApplication *)application{
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
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


- (void)showAlerWithUserInfo:(NSDictionary*)userInfo andSEL:(SEL)sel{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:userInfo.mj_JSONString message:NSStringFromSelector(sel) delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
    
    // webView
    if (![[SCAppManager shareInstance] isLogin]) {
        [[SCAppManager shareInstance]logout];
    }else{
        JPushUserInfo *j_userInfo = [JPushUserInfo yy_modelWithDictionary:userInfo];
        
        UINavigationController *nav  = (UINavigationController*)self.window.rootViewController;
        

        if (NULLString(j_userInfo.sysPage)) {
                NSDictionary  *custom = userInfo[@"custom"];
            if (!NULLString(custom[JM_COMVERSATION_TYPE])) {
                NSString  *conversationType = (NSString*)custom[JM_COMVERSATION_TYPE];
                NSString  *userName = custom[JM_USERNAME];
                NSString  *appkey = custom[JM_APPKET];
                if ([conversationType isEqualToString:@"single"]) {
                    // 单聊
                    
                    if ([nav.visibleViewController isKindOfClass:[JCChatViewController class]]) {
                        [nav popViewControllerAnimated:NO];
                    }
                    [JMSGConversation createSingleConversationWithUsername:userName appKey:appkey completionHandler:^(JMSGConversation * conversation, NSError *error) {
                        if (!error) {
                            [ChatPublicService jg_addFriendFeFocusWithFunsJmUserName:userName];
                            JCChatViewController *chatVC = [[JCChatViewController alloc]initWithConversation:conversation];
                            [conversation clearUnreadCount];
                            [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateConversation object:nil];
                            JCNavigationController *nav1 = [self mainNav];
                            [nav1.topViewController.navigationController pushViewController:chatVC animated:YES];
                        }
                    }];
                }else if ([conversationType isEqualToString:@"group"]){
                    // 群聊
                }
            }
            return;
        }
        
        if (nav.visibleViewController.navigationController.navigationBarHidden) {
            nav.visibleViewController.navigationController.navigationBarHidden = NO;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([j_userInfo.sysPage isEqualToString:@"webView"]) {
                if (!NULLString(j_userInfo.url)) {
                    
                    if ([nav.visibleViewController isKindOfClass:[MyWalletViewController class]]) {
                        MyWalletViewController *vc = (MyWalletViewController *)nav.visibleViewController;
                        [vc dismissViewControllerAnimated:NO completion:nil];
                        
                    }
                    NSString *tmp = [j_userInfo.url stringByAppendingString:[NSString stringWithFormat:@"&token=%@&JPush=JPush",[[SCCacheTool shareInstance] getUserToken]]];
                    MyWalletViewController *urlVC = [[MyWalletViewController alloc]init];
                    urlVC.urlStr = tmp;
                    JCNavigationController *walletNav = [[JCNavigationController alloc]initWithRootViewController:urlVC];
                    JCNavigationController *nav1 = [self mainNav];
                    [nav1.topViewController.navigationController presentViewController:walletNav animated:YES completion:nil];


                    
                }
            }else if ([j_userInfo.sysPage isEqualToString:@"messageList"]) {
//                return;                
            }else if ([j_userInfo.sysPage isEqualToString:@"couponsVendorList"]) {
                // 我的马甲劵 MyCardCouponContainerViewController
                if (![nav.visibleViewController isKindOfClass:[MyCardCouponContainerViewController class]]) {
                    MyCardCouponContainerViewController *vc = [[MyCardCouponContainerViewController alloc] init];
                    [nav.visibleViewController.navigationController pushViewController:vc animated:YES];
                }
                
            }else if ([j_userInfo.sysPage isEqualToString:@"couponsClientGet"]) {
                // 卡券详情 couponsClientGet
                //别人创建的
                if (![nav.visibleViewController isKindOfClass:[MyCardReceiveDetailsViewController class]]) {
                    MyCardReceiveDetailsViewController *vc = (MyCardReceiveDetailsViewController *)[HHTool storyBoardWithName:@"MyCardReceiveDetailsViewController" Identifier:@"ReceiveCardID"];
                    vc.orderId = j_userInfo.extra;
                    vc.isJPush = YES;
                    [nav.visibleViewController.navigationController pushViewController:vc animated:YES];
                }
                
                
            }else {
                if (![nav.visibleViewController isKindOfClass:[MyHelpContainerViewController class]]) {
                    MyHelpContainerViewController *vc = [[MyHelpContainerViewController alloc] init];
                    
                    if ([j_userInfo.sysPage isEqualToString:@"publishTaskList"]) {
                        // publishTaskList 帮过我的
                        vc._oc_scrollToIndex = 0;
                    }else if ([j_userInfo.sysPage isEqualToString:@"receiveTaskList"]) {
                        // receiveTaskList 我帮过的
                        vc._oc_scrollToIndex = 1;
                    }
                    
                    [nav.visibleViewController.navigationController pushViewController:vc animated:YES];
                }else {
                    MyHelpContainerViewController *vc = (MyHelpContainerViewController *)nav.visibleViewController;
                    if ([j_userInfo.sysPage isEqualToString:@"publishTaskList"]) {
                        // publishTaskList 帮过我的
                        vc._oc_scrollToIndex = 0;
                    }else if ([j_userInfo.sysPage isEqualToString:@"receiveTaskList"]) {
                        // receiveTaskList 我帮过的
                        vc._oc_scrollToIndex = 1;
                    }
                }
                
            }
           
        });
        
        
    }

}

- (JCNavigationController*)mainNav{
    JCNavigationController *nav;
    if ([[HHTool mainWindow].rootViewController isKindOfClass:[JCMainTabBarController  class]]) {
        JCMainTabBarController  *tab = (JCMainTabBarController*)[HHTool mainWindow].rootViewController;
        JCNavigationController *navController = tab.selectedViewController;
        nav = navController;
    }else{
        nav = (JCNavigationController*)[HHTool mainWindow].rootViewController;
    }
    return nav;
}

- (void)systemInformationActionWithUserInfo:(NSDictionary *)info {
    
    JPushUserInfo *j_userInfo = [JPushUserInfo yy_modelWithDictionary:info];

    if (![[SCAppManager shareInstance] isLogin]) {
        [[SCAppManager shareInstance]logout];
    }else{

        if ([j_userInfo.sysPage isEqualToString:@"messageList"]) {
            
            UINavigationController *nav  = (UINavigationController*)self.window.rootViewController;
            if (nav.visibleViewController.navigationController.navigationBarHidden) {
                nav.visibleViewController.navigationController.navigationBarHidden = NO;
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [[SCCacheChatRecord shareInstance] insertDataWithType:j_userInfo.type TITLE:j_userInfo.title EXTRA:j_userInfo.extra block:^(BOOL success) {
                        if (success) {

                            if (![nav.visibleViewController isKindOfClass:[SystemInformationViewController class]]) {
                                SystemInformationViewController *vc = [[SystemInformationViewController alloc]init];
                                [nav.visibleViewController.navigationController pushViewController:vc animated:YES];
                            }else {
                                SystemInformationViewController *vc = (SystemInformationViewController *)nav.visibleViewController;
                                NSDate *date = [NSDate date];
                                NSString *time = [date yyyyMMddByLineWithDate];
                                NSDictionary *dic = @{
                                                      @"type":j_userInfo.type,
                                                      @"title":j_userInfo.title,
                                                      @"extra":j_userInfo.extra,
                                                      @"time":time,
                                                      };
                                [vc reloadViewWithNewObj:dic];
                            }

                        }
                    }];

            });

        }

    }
}

@end
