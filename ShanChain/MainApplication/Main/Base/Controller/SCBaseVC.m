//
//  SCBaseVC.m
//  ShanChain
//
//  Created by krew on 2017/5/15.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCBaseVC.h"

@interface SCBaseVC ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SCBaseVC

- (void)showLoading {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]
                                  initWithFrame:CGRectMake((SCREEN_WIDTH-30)/2,(SCREEN_HEIGHT-kNavStatusBarHeight-30)/2,30.0,30.0)];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_activityIndicatorView];
    }
    self.activityIndicatorView.hidden = NO;
    self.view.userInteractionEnabled = NO;
    [self.activityIndicatorView startAnimating];
}


- (void)hideLoading {
    if (self.activityIndicatorView) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
        self.view.userInteractionEnabled = YES;
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听器的注册
    [self registerNotification];
    // 静态布局
    [self layoutUI];
    [self showNavigationBarWhiteColor];
   // [self showNavigationBarWithNormalColor];
}

- (void)layoutUI {
}

- (void)registerNotification {
}

- (void)setKeyBoardAutoHidden {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapDismissKeyboard:)];
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    //UIKeyboardWillShowNotification
    [notificationCenter addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
        [self.view addGestureRecognizer:singleTapGesture];
    }];
    
    //UIKeyboardWillHideNotification
    [notificationCenter addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
        [self.view removeGestureRecognizer:singleTapGesture];
    }];
}

#pragma mark ------------------- add left edge swipe back -------------------------------------

- (void)addLeftEdgeSwipeBack {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToPoppedController)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)backgroundTapDismissKeyboard:(UITapGestureRecognizer *) gestureRecognizer {
    //将self.view里所有的subview的first responder 都resign掉
    [self.view endEditing:YES];
}


- (void)pushPage:(UIViewController *)viewController Animated:(BOOL)animated{
    if (self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
    [self.navigationController pushViewController:viewController animated:animated];
}


- (void)showNavigationBarWhiteColor{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:nil  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    // self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//    if (self.navigationItem.titleView && [self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
//        UILabel *textLabel = (UILabel *)self.navigationItem.titleView;
//        textLabel.textColor = [UIColor blackColor];
//
//    }
    
    if (![self.navigationController.viewControllers.firstObject isEqual:self]) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"nav_btn_back_default"] forState:UIControlStateNormal];
        //        [button setBackgroundImage:[UIImage imageNamed:@"arrowLeft.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)showNavigationBarWithNormalColor {
    
    self.navigationController.navigationBar.barTintColor = Theme_MainThemeColor;
    [self.navigationController.navigationBar setBackgroundImage:nil  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
   // self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    if (self.navigationItem.titleView && [self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
//        UILabel *textLabel = (UILabel *)self.navigationItem.titleView;
//        textLabel.textColor = [UIColor whiteColor];
//
//    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    if (![self.navigationController.viewControllers.firstObject isEqual:self]) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"sc_com_icon_back"] forState:UIControlStateNormal];
        //        [button setBackgroundImage:[UIImage imageNamed:@"arrowLeft.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)_back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//返回到上一层，直到dismiss
- (UIViewController *)backViewController{
    if (self.navigationController) {
        NSInteger index=[self.navigationController.viewControllers indexOfObject:self];
        if (index>0) {  //不是root，就返回到上一级
            UIViewController *presentViewController=[self.navigationController.viewControllers objectAtIndex:MAX(index-1, 0)];
            [self.navigationController popViewControllerAnimated:YES];
            return presentViewController;
        }else{
            [self dismissPrestingViewController];
            return self.presentingViewController;
        }
    }else{
        [self dismissPrestingViewController];
        return  self.presentingViewController;
    }
}

- (void)dismissPrestingViewController{
    if (self.presentingViewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        });
        
    }
}


@end
