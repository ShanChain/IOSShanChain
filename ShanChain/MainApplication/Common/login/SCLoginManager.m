//
//  SCLoginManager.m
//  ShanChain
//
//  Created by flyye on 2017/12/15.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLoginManager.h"
#import <ShareSDK/ShareSDK.h>


@implementation SCLoginManager

+(void)bindOtherAccount:(NSString *)userType{
    SSDKPlatformType platformType ;
    if([userType isEqualToString:@"USER_TYPE_QQ"]){
        platformType = SSDKPlatformTypeQQ;
    }else if([userType isEqualToString:@"USER_TYPE_WEIXIN"]){
        platformType = SSDKPlatformTypeWechat;
    }else if([userType isEqualToString:@"USER_TYPE_WEIBO"]){
        platformType = SSDKPlatformTypeSinaWeibo;
    }
    
    [ShareSDK getUserInfo:platformType onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error){
        if (state == SSDKResponseStateSuccess) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[[SCCacheTool shareInstance] getCurrentUser] forKey:@"userId"];
            [params setObject:userType forKey:@"userType"];
            [params setObject:user.uid forKey:@"otherAccount"];
            [[SCNetwork shareInstance]postWithUrl:BIND_OTHER_ACCOUNT parameters:params success:^(id responseObject) {
                if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
                     [SYProgressHUD showSuccess:@"绑定成功"];
                }
            } failure:nil];
        } else {
            SCLog(@"%@",error);
        }
    }];
}
@end
