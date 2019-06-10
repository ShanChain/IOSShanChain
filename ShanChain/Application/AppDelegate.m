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

@interface AppDelegate ()< UIAlertViewDelegate,UIApplicationDelegate,JMessageDelegate,JPUSHRegisterDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setupJshareConfig];
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
          
        }
//            PopularCommunityViewController *locationVC = [[PopularCommunityViewController alloc]init];
        PopularContainViewController *locationVC = [[PopularContainViewController alloc]init];
#ifdef DEBUG
   // AppointmentListViewController *locationVC = [[AppointmentListViewController alloc]init];
   // MyWalletViewController * locationVC = [[MyWalletViewController alloc]init];
//     BMKTestLocationViewController  *locationVC = [[BMKTestLocationViewController alloc]init];

       // SCSettingViewController *locationVC = (SCSettingViewController*)[HHTool storyBoardWithName:@"SCSettingViewController" Identifier:nil];
#else
//    BMKTestLocationViewController  *locationVC = [[BMKTestLocationViewController alloc]init];
#endif
        rootVc = [[JCNavigationController alloc]initWithRootViewController:locationVC];
    
    } else {
        SCLoginController *loginVC=[[SCLoginController alloc]init];
        rootVc = [[SCBaseNavigationController alloc]initWithRootViewController:loginVC];
       
    }

    self.window.rootViewController = rootVc;
    
    [self.window makeKeyAndVisible];
    
    [self checkVersion];
    
    [self checkGuideView];
    
    [self setReceiveMonitorNotification];
    // 创建系统消息表
    [[SCCacheChatRecord shareInstance] createSystemInformationTable];
    
    [EditInfoService sc_requstWalletCurrency]; // 获取当前汇率
    // 捕获异常
    InstallExceptionHandler();
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    BOOL  isProduction = NO;
    if (PN_ENVIRONMENT == 3) {
        isProduction = YES;
    }
    [JPUSHService setupWithOption:launchOptions appKey:JMSSAGE_APPKEY
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    // 如果​remoteNotification不为空，代表有推送发过来
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotification) {
        [self showAlerWithUserInfo:remoteNotification andSEL:_cmd];
        [self systemInformationActionWithUserInfo:remoteNotification];
    }

    
    return YES;
}



- (void)setJMessageSDK:(NSDictionary *)launchOptions{
    [JMessage setupJMessage:launchOptions appKey:JMSSAGE_APPKEY channel:nil apsForProduction:NO category:nil messageRoaming:YES];
    [JMessage setDebugMode];
    [JMessage setLogOFF];
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
  
    SCLog(@"DeviceToken: %@", string);
    [JMessage registerDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
    
    
   
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
     NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)checkGuideView {
    NSString *hasEnter = [NSUserDefaults.standardUserDefaults objectForKey:[@"qianqianfirstenter-" stringByAppendingString:XcodeAppVersion]];
    if (!hasEnter) {
        SYGuiderScrollview *scrollView = [[SYGuiderScrollview alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [UIApplication.sharedApplication.keyWindow addSubview: scrollView];
    }
}

- (void)checkVersion {
    [PersonalCenterService _checkingUpdate:NO];
    // 初始版本状态
    [[SCCacheTool shareInstance] reViewVersion];
    // 监听网络状态
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
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

    NSDictionary *custom = userInfo[@"custom"];
    [NotificationHandler handlerNotificationWithCustom:custom];

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];

}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler{

    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    NSDictionary *custom = userInfo[@"custom"];
    [NotificationHandler handlerNotificationWithCustom:custom];

    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        // 在前台 不做操作
        [self showAlerWithUserInfo:userInfo andSEL:_cmd];
    }

    [self systemInformationActionWithUserInfo:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);

}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self showAlerWithUserInfo:userInfo andSEL:_cmd];
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
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];

    }else{
        //应用处于后台时的本地推送接受
    }
    NSDictionary *custom = userInfo[@"custom"];
    [self showAlerWithUserInfo:userInfo andSEL:_cmd];
//    [self systemInformationActionWithUserInfo:userInfo];
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
    [self resetBadge:application];
    [[SCWebSocket share] closeWebSocket];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self resetBadge:application];
    [[SCWebSocket share] openWebSocket];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}


#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }

//    NSDictionary * userInfo = notification.request.content.userInfo;
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required 在应用内收到推送会先执行这里
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }

    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support  前台点击通知调用方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required 点击通知栏就会执行这里
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [self showAlerWithUserInfo:userInfo andSEL:_cmd];
    [self systemInformationActionWithUserInfo:userInfo];
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark -- JShare 相关

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [JSHAREService handleOpenUrl:url];
    self.url = url;
    return YES;
}

//仅支持 iOS9 以上系统，iOS8 及以下系统不会回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [JSHAREService handleOpenUrl:url];
    self.url = url;
    return YES;
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
