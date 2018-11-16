//
//  RNBaseViewController.m
//  ShanChain
//
//  Created by flyye on 2017/10/13.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNBaseViewController.h"
#import <React/RCTRootView.h>
#import "SCAppManager.h"

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface RNBaseViewController()

@property(nonatomic, strong) NSString *screenName;
@property(nonatomic, strong) NSDictionary *properties;

@end

@implementation RNBaseViewController


- (instancetype)initWithScreenName:(NSString *)screenName initProperties:(NSDictionary *) initProperties {

    self = [super init];
    if (self) {
        _screenName = screenName;
        _properties = initProperties;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.additionalSafeAreaInsets = self.view.safeAreaInsets;
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:[SCAppManager shareInstance].jsCodeLocation
                                                        moduleName:_screenName
                                                 initialProperties:_properties
                                                     launchOptions:nil];
    if (KIsiPhoneX) {
        rootView.frame  =  CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    } else {
        rootView.frame  =  CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
    }
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view addSubview:rootView];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <Rotate>


- (BOOL)shouldAutorotate
{
    //所有RNViewController 默认不旋转,有个别需求的,请在子类中重载这3个方法
    //fixed by Yangtsing.Zhang
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //所有ViewController 默认只支持竖屏朝上,有个别需求的,请在子类中重载这个方法
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
