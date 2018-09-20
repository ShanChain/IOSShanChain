//
//  SCNavigatorModule.m
//  ShanChain
//
//  Created by flyye on 2017/10/12.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "SCNavigatorModule.h"
#import "SCAppManager.h"
#import "SYContactsController.h"


@implementation SCNavigatorModule

RCT_EXPORT_MODULE(SCPageNavigator);

RCT_EXPORT_METHOD(popViewControllerAnimated:(BOOL)animated)
{
  SCLog(@"pop VC");
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[SCAppManager shareInstance] popViewControllerAnimated:animated];
    });
}

RCT_EXPORT_METHOD(pushRNViewController:(NSString *)rnPageName animated:(BOOL)animated parameter:(NSString *)jsonParam)
{
    SCLog(@"push VC");
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[SCAppManager shareInstance] pushRNViewController:rnPageName animated:animated parameter:jsonParam];
    });
}
RCT_EXPORT_METHOD(pushViewController:(NSString *)viewController animated:(BOOL)animated parameter:(NSString *)jsonParam)
{
    SCLog(@"push VC");
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[SCAppManager shareInstance] pushViewController:viewController animated:animated parameter:jsonParam];
    });
}

RCT_EXPORT_METHOD(pushH5ViewControllerAnimated:(BOOL)animated)
{
    SCLog(@"push VC");
}

RCT_EXPORT_METHOD(chooseContact:(RCTResponseSenderBlock)successCallback errorCallBack
                  : (RCTResponseErrorBlock)errorCallBack)
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        SYContactsController *contactVC = [[SYContactsController alloc]init];
        contactVC.callback = ^(id array){
            successCallback(array);
        };
        [[SCAppManager shareInstance] pushViewController:contactVC animated:YES];;
    });

}

RCT_EXPORT_METHOD(logout){
    dispatch_sync(dispatch_get_main_queue(), ^{
         [[SCAppManager shareInstance] logout];
    });
}
@end
