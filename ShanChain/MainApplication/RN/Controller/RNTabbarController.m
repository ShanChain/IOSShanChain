//
//  SCTabbarController.m
//  09-自定义TabbarController
//
//  Created by vera on 15/8/19.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "RNTabbarController.h"
#import "SCBaseNavigationController.h"
#import "SCTabBar.h"
#import  <React/RCTRootView.h>

@interface RNTabbarController ()

@end

@implementation RNTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
     NSURL *jsCodeLocation;
    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];

    // 1.初始化子控制器
    UIViewController *storyVc = [[UIViewController alloc] init];
    
    RCTRootView *storyRootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"StoryPage"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    storyVc.view = storyRootView;
    [self addChildVc:storyVc title:@"故事" image:@"tab_button_home_page_default" selectedImage:@"tab_button_home page_selected"];
    
    
    
    UIViewController *chatVc = [[UIViewController alloc] init];
    
    RCTRootView *chatRootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                             moduleName:@"ChatPage"
                                                      initialProperties:nil
                                                          launchOptions:nil];
    chatVc.view = chatRootView;
    [self addChildVc:chatVc title:@"对话" image:@"tab_button_dynamic_default" selectedImage:@"tab_button_dynamic_selected"];
    
    UIViewController *squareVc = [[UIViewController alloc] init];
    
    RCTRootView *squareRootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                            moduleName:@"SquarePage"
                                                     initialProperties:nil
                                                         launchOptions:nil];
    squareVc.view = squareRootView;
    [self addChildVc:squareVc title:@"广场" image:@"tab_button_dynamic_default" selectedImage:@"tab_button_dynamic_selected"];
    
    UIViewController *mineVc = [[UIViewController alloc] init];
    
    RCTRootView *mineRootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                              moduleName:@"MinePage"
                                                       initialProperties:nil
                                                           launchOptions:nil];
    mineVc.view = mineRootView;
    [self addChildVc:mineVc title:@"我的" image:@"tab_button_dynamic_default" selectedImage:@"tab_button_dynamic_selected"];
    /*
     系统tabbar高度是49  自定义tabbarController的原理：
     1.隐藏系统tabbar
     2.创建一个UIView，在view布局，然后添加到self.view
     */
    //1.隐藏系统tabbar
    SCTabBar *tabBar=[[SCTabBar alloc]init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置子控制器的文字
//    childVc.title = title; // 同时设置tabbar和navigationBar的文字
        childVc.tabBarItem.title = title; // 设置tabbar的文字
//        childVc.navigationItem.title = title; // 设置navigationBar的文字
//    
////    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    // 设置文字的样式
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = RGB(128, 128, 128);
//    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
//    selectTextAttrs[NSForegroundColorAttributeName] = RGB(59, 186, 200);
//    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //childVc.view.backgroundColor = HWRandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
//    SCBaseNavigationController *nav = [[SCBaseNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:childVc];
    //    self.tabBar.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
