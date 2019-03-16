//
//  SCLoginDataController.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/12.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "SCLoginDataController.h"
#import "BMKTestLocationViewController.h"
#import "ShanChain-Swift.h"
#import "SCAES.h"
#import "SCDynamicLoginViewController.h"

@implementation SCLoginDataController

+ (void)successLoginedWithContent:(NSDictionary *)content{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [content[@"userId"] stringValue];
    NSString  *tk;
    if ([content[@"token"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary  *tkDic = content[@"token"];
        tk = tkDic[@"token"];
    }else{
        tk = content[@"token"];
    }
    NSString *token = [[userId stringByAppendingString:@"_"] stringByAppendingString:tk];
    [params setObject:token  forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    [[SCNetwork shareInstance]v1_postWithUrl:STORYCHARACTERGETCURRENT params:params showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
        NSDictionary *data = baseModel.data;
        SCCharacterModel *characterModel = [SCCharacterModel yy_modelWithDictionary:data];
        [SCCacheTool shareInstance].characterModel = characterModel;
        if (data  && data[@"characterInfo"]) {
            NSDictionary *characterInfo = data[@"characterInfo"];
            if (characterInfo[@"characterId"]) {
                //  NSString *spaceId = [characterInfo[@"spaceId"] stringValue];
                NSString *spaceId = @"";
                NSString *characterId = [characterInfo[@"characterId"] stringValue];
                NSDictionary *hxInfo = data[@"hxAccount"];
                NSString *hxUserName = hxInfo[@"hxUserName"];
                NSString *hxPassword = hxInfo[@"hxPassword"];
                [[SCAppManager shareInstance] cacheLoginUserId:userId token:token spaceId:spaceId chatacterId:characterId hxUserName:hxUserName hxPassword:hxPassword channel:SC_APP_CHANNEL];
                [[SCCacheTool shareInstance] cacheCharacterInfo:characterInfo withUserId:userId];
                NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
                [params1 setObject:spaceId forKey:@"spaceId"];
                [params1 setObject:token forKey:@"token"];
                [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccess object:nil];
                [JGUserLoginService jg_userLoginWithUsername:characterModel.hxAccount.hxUserName password:characterModel.hxAccount.hxPassword loginComplete:^(id _Nonnull result, NSError * _Nonnull error) {
                    [SYProgressHUD hideHUD];
                    if (!error) {
                        // 登录成功
                        UIViewController *rootVc = nil;
//                        BMKTestLocationViewController  *locationVC = [[BMKTestLocationViewController alloc]init];
                        PopularCommunityViewController *locationVC = [[PopularCommunityViewController alloc]init];
                        rootVc = [[JCNavigationController alloc]initWithRootViewController:locationVC];
                        //                    SCTabbarController *tabbarC=[[SCTabbarController alloc]init];
                        [HHTool mainWindow].rootViewController=rootVc;
                    }
                }];
                
                
                //                [[SCNetwork shareInstance]postWithUrl:GET_SPACE_BY_ID parameters:params1 success:^(id responseObject) {
                //                    NSDictionary *data = responseObject[@"data"];
                //                    NSString *spaceInfo = @"";
                //                    NSString *spaceName = @"";
                //                    spaceName = data[@"name"];
                //                    spaceInfo = [JsonTool stringFromDictionary:data];
                //                    if(![spaceInfo isEqualToString:@""]){
                //                        [[SCCacheTool shareInstance] setCacheValue:spaceName withUserID:userId andKey:CACHE_SPACE_NAME];
                //                        [[SCCacheTool shareInstance] setCacheValue:spaceInfo withUserID:userId andKey:CACHE_SPACE_INFO];
                //                    }
                //                    [SYProgressHUD hideHUD];
                //
                //                } failure:^(NSError *error) {
                //                    SCLog(@"%@",error);
                //                    [SYProgressHUD hideHUD];
                //                    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                //                    SCTabbarController *tabbarC=[[SCTabbarController alloc]init];
                //                    keyWindow.rootViewController=tabbarC;
                //                }];
            } else {
                [SYProgressHUD hideHUD];
            }
        } else {
            [HHTool showError:@"登录出错..."];
            //            [[SCAppManager shareInstance] cacheLoginUserId:userId token:token spaceId:@"" chatacterId:@"" hxUserName:@"" hxPassword:@""];
            //            UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
            //            SYStoryMarkController *vc=[[SYStoryMarkController alloc] init];
            //            SCBaseNavigationController *nav = [[SCBaseNavigationController alloc] initWithRootViewController: vc];
            //            keyWindow.rootViewController = nav;
        }
    }];
    
}

// 三方平台唯一标识
+ (void)otherLoginWithPlatfrom:(JSHAREPlatform)platfrom bindPhoneNumberCallBack:(void (^)(NSString *encryptOpenId))callBack{
    
    [JSHAREService getSocialUserInfo:platfrom handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
        if (error) {
            [HHTool showError:error.localizedDescription];
            return ;
        }
        NSString *pwd = [userInfo.accessToken substringToIndex:16];
        NSString *pwdMD5 = [SCMD5Tool MD5ForLower32Bate:pwd];
        NSString *loginTypeStr = @"USER_TYPE_QQ";
        switch (platfrom) {
            case JSHAREPlatformQQ:
                loginTypeStr = @"USER_TYPE_QQ";
                break;
            case JSHAREPlatformWechatSession:
                loginTypeStr = @"USER_TYPE_WEIXIN";
                break;
            case JSHAREPlatformSinaWeibo:
                loginTypeStr = @"USER_TYPE_WEIBO";
                break;
            case JSHAREPlatformFacebook:
                loginTypeStr = @"USER_TYPE_FB";
                break;
            default: ;
        }
        
        NSTimeInterval time =(long long) [[NSDate date] timeIntervalSince1970];
        NSString *typeAppend = [loginTypeStr stringByAppendingString:[NSString stringWithFormat:@"%.0f",time]];
        NSString *encryptAccount = [SCAES encryptShanChainWithPaddingString:typeAppend withContent:userInfo.openid ?:userInfo.uid];
        NSString *encryptPassword = [SCAES encryptShanChainWithPaddingString:[typeAppend stringByAppendingString:userInfo.openid ?:userInfo.uid] withContent:pwdMD5];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:userInfo.name forKey:@"nickName"];
        [params setObject:loginTypeStr forKey:@"userType"];
        [params setObject:userInfo.iconurl forKey:@"headIcon"];
        
        [params setObject:[NSString stringWithFormat:@"%ld",(long)userInfo.gender - 1] forKey:@"sex"];
        [params setObject:[NSString stringWithFormat:@"%0.f",time] forKey:@"Timestamp"];
        [params setObject:encryptAccount forKey:@"encryptOpenId"];
        [params setObject:encryptPassword forKey:@"encryptToken16"];
        [params setObject:SC_APP_CHANNEL forKey:@"channel"];
        NSString  *deviceToken = [JPUSHService registrationID];
        if (!NULLString(deviceToken)) {
            [params setValue:deviceToken forKey:@"deviceToken"];
        }
        
        [[SCNetwork shareInstance]v1_postWithUrl:Third_login_URL params:params showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
            if ([baseModel.code isEqualToString:SC_PHONENUMBER_NOBIND]) {
                // 该账号还未绑定手机（马甲）账号，请绑定！
                BLOCK_EXEC(callBack,encryptAccount)
            }else{
                if (baseModel.data && [baseModel.data isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:baseModel.data[@"userInfo"]];
                    [userInfo setObject:baseModel.data[@"token"] forKey:@"token"];
                    [SCLoginDataController successLoginedWithContent:userInfo];
                }
              
            }
        }];

    }];
}

@end






