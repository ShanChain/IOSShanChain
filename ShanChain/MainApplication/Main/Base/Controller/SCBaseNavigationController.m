//

//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "SCBaseNavigationController.h"
#import "RNBaseViewController.h"

@interface SCBaseNavigationController ()

@end

@implementation SCBaseNavigationController

#pragma mark -系统方法
+ (void)initialize{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(102, 102, 102),NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg_image_disabled"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark -重写方法
/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        [backButton setImage:[UIImage imageNamed:@"nav_btn_back_default"]  forState:UIControlStateNormal];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
        [backButton addTarget:self action:@selector(backToPoppedController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action: nil];
        flexItem.width = -15;
        viewController.navigationItem.leftBarButtonItems = @[flexItem, barItem];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController isHideNavBar:(BOOL)isHide animated:(BOOL)animated{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        /* 隐藏导航栏 */
        [viewController.navigationController setNavigationBarHidden:YES];
    }
    [super pushViewController:viewController animated:animated];
}


#pragma mark -构造方法
- (void)backToPoppedController:(UIButton *)button  {
    [self popViewControllerAnimated:YES];
}

@end
