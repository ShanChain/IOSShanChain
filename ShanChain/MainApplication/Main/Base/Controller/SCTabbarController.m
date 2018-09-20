//
//  SCTabbarController.m
//  09-自定义TabbarController
//
//  Created by vera on 15/8/19.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "SCTabbarController.h"
#import "SYChatController.h"
#import "SYStoryController.h"
#import "SCBaseNavigationController.h"
#import "SCTabBar.h"
#import  <React/RCTRootView.h>
#import "SCAppManager.h"
#import "SYStoryMarkController.h"
#import "SCCacheTool.h"
#import "RNBaseViewController.h"
#import "RNConstants.h"

@interface SCTabbarController ()

@property (strong,nonatomic) UIViewController *storyVC;
@property (strong,nonatomic) UIViewController *chatVC;
@property (strong,nonatomic) UIViewController *squareVC;
@property (strong,nonatomic) UIViewController *mineVC;
@end

@implementation SCTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 1.初始化子控制器
     _storyVC = [[SYStoryController alloc] init];
    [self addChildVc:_storyVC title:@"故事" image:@"abs_home_btn_story_default" selectedImage:@"abs_home_btn_story_selected"];
    
    _chatVC = [[SYChatController alloc] init];
    [self addChildVc:_chatVC title:@"对话" image:@"abs_home_btn_news_default" selectedImage:@"abs_home_btn_news_selected"];
    
    NSDictionary *paramsDic = nil;
    NSDictionary *gData = nil;
    NSString *jsonParam = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:[[SCCacheTool shareInstance] getCurrentUser] andKey:CACHE_GDATA];
    if(![jsonParam isEqualToString:@""]){
        gData = @{@"gData":[JsonTool dictionaryFromString:jsonParam]};
         paramsDic = @{@"screenProps":[JsonTool stringFromDictionary:gData]};
    }
//    RNBaseViewController *squareVc = [[RNBaseViewController alloc] initWithScreenName:@"SquarePage" initProperties:paramsDic];
      _squareVC = [[UIViewController alloc] init];
    RCTRootView *squareRootView = [[RCTRootView alloc] initWithBundleURL:[SCAppManager shareInstance].jsCodeLocation
                                                              moduleName:@"SquarePage"
                                                       initialProperties:paramsDic
                                                           launchOptions:nil];
    _squareVC.view = squareRootView;
    [self addChildVc:_squareVC title:@"广场" image:@"abs_home_btn_square_default" selectedImage:@"abs_home_btn_square_selected"];
    

//     RNBaseViewController *mineVc = [[RNBaseViewController alloc] initWithScreenName:@"MinePage" initProperties:paramsDic];
    _mineVC = [[UIViewController alloc] init];
    RCTRootView *mineRootView = [[RCTRootView alloc] initWithBundleURL:[SCAppManager shareInstance].jsCodeLocation
                                                            moduleName:@"MinePage"
                                                     initialProperties:paramsDic
                                                         launchOptions:nil];
    _mineVC.view = mineRootView;
     _mineVC.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(openNotificationPage) image:@"mine_btn_news_default" highImage:@"mine_btn_news_default"];
    [self addChildVc:_mineVC title:@"我的" image:@"abs_home_btn_mine_default" selectedImage:@"abs_home_btn_mine_selected"];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userId = [[SCCacheTool shareInstance] getCurrentUser];
        NSString *hxUserName = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:CACHE_HX_USER_NAME];
        NSString *hxPassword = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:CACHE_HX_PWD];
        if(hxUserName && ![hxUserName isEqualToString:@""] && hxPassword && ![hxPassword isEqualToString:@""] ){
            EMError *error = [[EMClient sharedClient] loginWithUsername:hxUserName password:hxPassword];
            if (error) {
                SCLog(@"%@",error);
            }
        }
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [self initDeviceToken];
    [self checkMsgReadStatus];
}

- (void)checkMsgReadStatus{
    if([[[SCCacheTool shareInstance] getCacheValueInfoWithUserID:[[SCCacheTool shareInstance] getCurrentUser] andKey:CACHE_USER_MSG_READ_STATUS] isEqualToString:@"false"]){
        _mineVC.tabBarItem.badgeValue = @" ";
        _mineVC.tabBarItem.badgeColor = [UIColor redColor];
         [self setNotificationsShowStatus:YES];
    }else{
        _mineVC.tabBarItem.badgeValue = nil;
         [self setNotificationsShowStatus:NO];
    }
}
- (void)initDeviceToken{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if([NSString isBlankString:[[SCCacheTool shareInstance] getCacheValueInfoWithUserID:@"0" andKey:CACHE_DEVICE_TOKEN]]){
            return ;
        }
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setObject:[[SCCacheTool shareInstance] getCurrentUser] forKey:@"userId"];
        [params setValue:[[SCCacheTool shareInstance] getUserToken] forKey:@"token"];
        [params setValue:@"ios" forKey:@"osType"];
        [params setValue:[[SCCacheTool shareInstance] getCacheValueInfoWithUserID:@"0" andKey:CACHE_DEVICE_TOKEN] forKey:@"deviceToken"];
        [[SCNetwork shareInstance]postWithUrl:SET_DEVICE_TOKEN parameters:params success:^(id responseObject) {

        } failure:^(NSError *error) {
            SCLog(@"%@",error);
        }];
    });
}


- (void)openNotificationPage{
    [[SCCacheTool shareInstance] setCacheValue:@"true" withUserID:[[SCCacheTool shareInstance] getCurrentUser] andKey:CACHE_USER_MSG_READ_STATUS];
    [self setNotificationsShowStatus:NO];
        _mineVC.tabBarItem.badgeValue = nil;
    NSString *gData = [[SCCacheTool shareInstance] getGdata];
    NSDictionary *params =  @{@"gData":[JsonTool dictionaryFromString:gData]};
    [[SCAppManager shareInstance] pushRNViewController:RN_PAGE_NOTIFICATION animated:YES parameter:[JsonTool stringFromDictionary:params]];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGB(128, 128, 128);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = RGB(59, 186, 200);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //childVc.view.backgroundColor = HWRandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    SCBaseNavigationController *nav = [[SCBaseNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

- (void)showBadgeAtIndex:(NSInteger *)index badgeValue:(NSString *)value{
    if(index == 0){
        _storyVC.tabBarItem.badgeValue = value;
        _storyVC.tabBarItem.badgeColor = [UIColor redColor];
    }else if (index == 1){
        _chatVC.tabBarItem.badgeValue = value;
        _chatVC.tabBarItem.badgeColor = [UIColor redColor];
    }else if (index == 2){
        _squareVC.tabBarItem.badgeValue = value;
        _squareVC.tabBarItem.badgeColor = [UIColor redColor];
    }else if (index == 3){
        _mineVC.tabBarItem.badgeValue = value;
        _mineVC.tabBarItem.badgeColor = [UIColor redColor];
        
    }
}

- (void)setNotificationsShowStatus:(BOOL)status{
    if (status) {
    _mineVC.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(openNotificationPage) image:@"mine_btn_notification_default" highImage:@"mine_btn_notification_default"];
    }else{
    _mineVC.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(openNotificationPage) image:@"mine_btn_news_default" highImage:@"mine_btn_news_default"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
