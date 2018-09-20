//
//  SCAppManagerMd.m
//  ShanChain
//
//  Created by flyye on 2017/11/29.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SCTabbarController.h"
#import "SCAppManager.h"
#import <React/RCTRootView.h>
#import "RNBaseViewController.h"
#import "SCCacheTool.h"
#import <React/RCTBridgeModule.h>
#import "SCAppManagerMd.h"
#import "SCLoginManager.h"
#import "SYChatController.h"

@implementation SCAppManagerMd

RCT_EXPORT_MODULE(AppManagerModule);


RCT_EXPORT_METHOD(switchRole:(NSDictionary *) options){
    SCLog(@"switch role");
    dispatch_sync(dispatch_get_main_queue(), ^{
 [[SCAppManager shareInstance] switchRoleWithSpaceId:options[@"spaceId"] modelId:options[@"modelId"]];
    });
  
}

RCT_EXPORT_METHOD(bindOtherAccount:(NSString *) userType){
    dispatch_sync(dispatch_get_main_queue(), ^{
        [SCLoginManager bindOtherAccount:userType];
    });
    
}

RCT_EXPORT_METHOD(clearCache){
    [SYChatController removeAllConversationFromLocalDB];
}


@end
