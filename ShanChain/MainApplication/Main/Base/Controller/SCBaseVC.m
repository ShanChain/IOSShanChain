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

- (void)popToViewControllerClass:(Class)viewControllerClass withAnimation:(BOOL)animated {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:viewControllerClass]) {
            [self.navigationController popToViewController:vc animated:animated];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
