//
//  AppDelegate.m
//  ShanChain
//
//  Created by krew on 2017/5/12.
//  Copyright © 2017年 krew. All rights reserved.
//

//Lp5FSsHWUaVvhgsKfsveuZXRP3LsqEB6
//5982c26c4544cb7cc9000528 友盟统计

#import "AppDelegate.h"
#import "SCTabbarController.h"
#import "SCBaseNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "SCLoginController.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"
#import "NotificationHandler.h"
#import "SCAppManager.h"
#import "SYGuiderScrollview.h"
#import "VersionUtils.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate, UIAlertViewDelegate,UIApplicationDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setupHXConfig];
    
    [self setupMapConfig];
    
    [self setupUMPushNoticationWithLaunchOptions:launchOptions];

    UIViewController *rootVc = nil;
    rootVc = [[SCTabbarController alloc]init];
    if ([[SCAppManager shareInstance] isLogin]) {
        rootVc = [[SCTabbarController alloc]init];
    } else {
        SCLoginController *loginVC=[[SCLoginController alloc]init];
        rootVc = [[SCBaseNavigationController alloc]initWithRootViewController:loginVC];
    }

    self.window.rootViewController = rootVc;
    
    [self.window makeKeyAndVisible];
    
    [self checkVersion];
    
    [self checkGuideView];
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *string = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    if(string){
        [[SCCacheTool shareInstance] setCacheValue:string withUserID:@"0" andKey:CACHE_DEVICE_TOKEN];
    }
    SCLog(@"DeviceToken: %@", string);
}

- (void)checkGuideView {
    NSString *hasEnter = [NSUserDefaults.standardUserDefaults objectForKey:[@"qianqianfirstenter-" stringByAppendingString:XcodeAppVersion]];
    if (!hasEnter) {
        SYGuiderScrollview *scrollView = [[SYGuiderScrollview alloc] initWithFrame: self.window.rootViewController.view.frame];
        [UIApplication.sharedApplication.keyWindow addSubview: scrollView];
    }
}

- (void)checkVersion {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"ios" forKey:@"type"];
    [param setObject:XcodeAppVersion forKey:@"version"];
    [SCNetwork.shareInstance postWithUrl:COMMONCHECKVERSION parameters:param success:^(id responseObject) {
        NSDictionary *dictionary = responseObject[@"data"];
        if (dictionary != [NSNull null]) {
            NSString *version = dictionary[@"version"];
            if (version && [VersionUtils compareVersion:XcodeAppVersion withServerVersion:version]) {
                if ([dictionary[@"forceUpdate"] isEqualToString:@"true"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新版本有较大改进，请更新" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本，请更新" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }
        }
    } failure:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id1296793048"]];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.firstOtherButtonIndex != 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:true];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新版本有较大改进，请更新" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark --------------------------- init handler ---------------------------
- (void)setupHXConfig {
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"SCD";
#else
    apnsCertName = @"SC";
#endif
    EMOptions *options = [EMOptions optionsWithAppkey:KHXKey];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
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

- (void)setupMapConfig {
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:kBaiduMapKey generalDelegate:nil];
    if (!ret) {
        SCLog(@"百度地图启动失败!");
    }
}


- (void)setupShareConfig {
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
        //定制自定的的弹出框
//        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
//                                                                message:@"Test On ApplicationStateActive"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//
//            [alertView show];
//
//        }

    NSDictionary *custom = userInfo[@"custom"];
    [NotificationHandler handlerNotificationWithCustom:custom];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler{
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    NSDictionary *custom = userInfo[@"custom"];
    [NotificationHandler handlerNotificationWithCustom:custom];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    NSDictionary *custom = userInfo[@"custom"];
    [NotificationHandler handlerNotificationWithCustom:custom];
}


- (void)enterLoginWindowVC {
    SCLoginController *vc = [SCLoginController new];
    self.window.rootViewController = [[SCBaseNavigationController alloc]initWithRootViewController:vc];
}

+ (void)setWindowRootVC:(UIViewController *)vc
                  isNav:(BOOL)isNav {
    UIWindow *window = [AppDelegate sharedInstance].window;
    if (isNav) {
        UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:vc];
        window.rootViewController = nil;
        window.rootViewController = newNavController;
    } else {
        window.rootViewController = nil;
        window.rootViewController = vc;
    }
    [window makeKeyAndVisible];
}



#pragma mark -
+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
