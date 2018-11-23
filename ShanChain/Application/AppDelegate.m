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
#import "AppDelegate+Config.h"
#import "SCLoginController.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"
#import "NotificationHandler.h"
#import "SCAppManager.h"
#import "SYGuiderScrollview.h"
#import "VersionUtils.h"
#import "BMKTestLocationViewController.h"
#import "UncaughtExceptionHandler.h"
#import "ShanChain-Swift.h"

#define JMSSAGE_APPKEY  @"0a20b6277a625655791e3cd9"

@interface AppDelegate ()<UNUserNotificationCenterDelegate, UIAlertViewDelegate,UIApplicationDelegate,JMessageDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setupHXConfigWithApplication:application];
    
    [self setIQkeyboard];
    [self setBMKManager];
    
    [self setupMapConfig];
    
    [self setJMessageSDK:launchOptions];
    
    [self setupUMPushNoticationWithLaunchOptions:launchOptions];
   
   __block UIViewController *rootVc = nil;
   // rootVc = [[SCTabbarController alloc]init];
    
    if ([[SCAppManager shareInstance] isLogin]) {
//        rootVc = [[SCTabbarController alloc]init];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:kJCCurrentUserName]) {
            BMKTestLocationViewController  *locationVC = [[BMKTestLocationViewController alloc]init];
            rootVc = [[JCNavigationController alloc]initWithRootViewController:locationVC];
        }
    
    } else {
        SCLoginController *loginVC=[[SCLoginController alloc]init];
        rootVc = [[SCBaseNavigationController alloc]initWithRootViewController:loginVC];
       
    }
//    BMKTestLocationViewController  *locationVC = [[BMKTestLocationViewController alloc]init];
//    rootVc = [[JCNavigationController alloc]initWithRootViewController:locationVC];
    self.window.rootViewController = rootVc;
    
    [self.window makeKeyAndVisible];
    
    [self checkVersion];
    
    [self checkGuideView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJMSGNetworkDidSetupNotification) name:kJMSGNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJMSGNetworkDidCloseNotification) name:kJMSGNetworkDidCloseNotification object:nil];
    
    [EditInfoService sc_requstWalletCurrency]; // 获取当前汇率
    // 捕获异常
    InstallExceptionHandler();
    return YES;
}


- (void)kJMSGNetworkDidSetupNotification{
    [SCCacheTool shareInstance].isJGSetup = YES;
}

- (void)kJMSGNetworkDidCloseNotification{
    
}


- (void)setJMessageSDK:(NSDictionary *)launchOptions{
    [JMessage setupJMessage:launchOptions appKey:JMSSAGE_APPKEY channel:nil apsForProduction:NO category:nil messageRoaming:YES];
    [JMessage setDebugMode];
    [JMessage addDelegate:self withConversation:nil];
    // Required - 注册 APNs 通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    } else {
        //categories 必须为nil
        [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
    }
    
//     UIImage  *defaultImage = [UIImage imageNamed:@"sc_com_icon_DefaultAvatar"];
//     NSData *imagedata= UIImagePNGRepresentation(defaultImage);
//    [JMSGUser updateMyAvatarWithData:imagedata avatarFormat:nil completionHandler:^(id resultObject, NSError *error) {
//    
//    }];
}

- (void)setBMKManager{
    
    _mapManager = [[BMKMapManager alloc]init];
   [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BMKAPPKEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

// 提交deviceToken给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *string = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    if(string){
        [[SCCacheTool shareInstance] setCacheValue:string withUserID:@"0" andKey:CACHE_DEVICE_TOKEN];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
    SCLog(@"DeviceToken: %@", string);
    [JMessage registerDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

- (void)checkGuideView {
    NSString *hasEnter = [NSUserDefaults.standardUserDefaults objectForKey:[@"qianqianfirstenter-" stringByAppendingString:XcodeAppVersion]];
    if (!hasEnter) {
        SYGuiderScrollview *scrollView = [[SYGuiderScrollview alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
            [SCCacheTool shareInstance].status = dictionary[@"status"];
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
        [HHTool openAppStore];
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




- (void)setupMapConfig {
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:kBaiduMapKey generalDelegate:nil];
    if (!ret) {
        SCLog(@"百度地图启动失败!");
    }
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



- (void)resetBadge:(UIApplication*)application{
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    [JMessage resetBadge];
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
    [self resetBadge:application];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [self resetBadge:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
//    return YES;
//}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

//MARK: - JMessage Delegate
-(void)onDBMigrateStart{
    [HHTool show:@"数据库升级中"];
}
-(void)onDBMigrateFinishedWithError:(NSError *)error{
    [HHTool dismiss];
    if (!error) {
        [HHTool showSucess:@"数据库升级完成"];
    }
}

@end
