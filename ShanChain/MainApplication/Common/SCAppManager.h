//
//  SCAppManager.h
//  ShanChain
//
//  Created by flyye on 2017/10/13.
//  Copyright © 2017年 ShanChain. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SCAppManager : NSObject

@property(nonatomic, strong) NSURL *jsCodeLocation;

+ (SCAppManager *)shareInstance;

- (void)openRootViewController;

- (UIViewController*)getRootViewController;

- (void)popViewControllerAnimated:(BOOL) animated;

- (void)pushViewController:(NSString *)viewController animated:(BOOL)animated parameter:(NSString *)jsonParam;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)pushRNViewController:(NSString *)pageName animated:(BOOL)animated parameter:(NSString *)jsonParam;

- (void)pushToTopClass:(NSString *)className withController:(UIViewController *)controller withNavigationController:(UIViewController *)navVc;

- (void)popToClass:(NSString *)className withNavigationController:(UINavigationController *)navVc animated:(BOOL)animated;

- (UIViewController*)visibleViewController;

- (BOOL)isLogin;


- (void)cacheLoginUserId:(NSString *)userId token:(NSString *)token spaceId:(NSString *)spaceId chatacterId:(NSString *)chatacterId hxUserName:(NSString *)hxUserName hxPassword:(NSString *)hxPassword channel:(NSString *)channel;

- (void)clearLoginCache;

- (void)switchRoleWithSpaceId:(NSString *)spaceId modelId:(NSString *)modelId;

- (void)logout;
- (void)selectLogout;
- (void)realNameAuthenticate;
- (void)configWalletInfo;
- (void)againUploadPasswordCallback:(void(^)(NSString * authCode))callback;
- (void)againUploadPasswordWithUrl:(NSString*)url parameters:(NSDictionary*)parameters Callback:(void(^)(NSString * authCode, NSString * _url, NSDictionary * _parameters))callback;



@end

