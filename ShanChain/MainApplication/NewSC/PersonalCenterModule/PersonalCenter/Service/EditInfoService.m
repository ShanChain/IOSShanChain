//
//  EditInfoService.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/20.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "EditInfoService.h"
#import "SCAliyunUploadMananger.h"

@implementation EditInfoService

+ (void)sc_uploadImage:(UIImage *)image withCompressionQuality:(CGFloat)cq callBlock:(void (^)(BOOL))callBlock{
    [SCAliyunUploadMananger uploadImage:image withCompressionQuality:cq withCallBack:^(NSString *url) {
        if (!NULLString(url)) {
            [EditInfoService sc_editPersonalInfo:@{@"headImg":url} callBlock:callBlock];
        }
    } withErrorCallBack:^(NSError *error) {
        [HHTool showError:error.localizedDescription];
    }];
}

+(void)sc_editPersonalInfo:(NSDictionary *)params callBlock:(void (^)(BOOL))callBlock{
    [[SCNetwork shareInstance]v1_postWithUrl:CHANGE_USER_CHARACTER params:params.copy showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
        if (!error) {
            [HHTool showSucess:baseModel.message];
            if (baseModel.data[@"characterInfo"] && [baseModel.data[@"characterInfo"] isKindOfClass:[NSDictionary class]]) {
                SCCharacterModel_characterInfo *info = [SCCharacterModel_characterInfo mj_objectWithKeyValues:baseModel.data[@"characterInfo"]];
                [SCCacheTool shareInstance].characterModel.characterInfo = info;
                 [[SCCacheTool shareInstance] cacheCharacterInfo:baseModel.data[@"characterInfo"] withUserId:[SCCacheTool shareInstance].getCurrentUser];
                [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateUserInfo object:nil];
                 [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateAvatarSuccess object:nil];
//                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:params[@"headImg"]]];
//                NSData  *data = [NSKeyedArchiver archivedDataWithRootObject:imageData];
//                [[NSUserDefaults standardUserDefaults]setObject:data forKey:kLastUserAvator];
//                [[NSUserDefaults standardUserDefaults]synchronize];
   
            }
            BLOCK_EXEC(callBlock,YES);
        }else{
            [HHTool showError:error.localizedDescription];
            BLOCK_EXEC(callBlock,NO);
        }
    }];
}

+(void)sc_requstWalletCurrency{
    [[SCNetwork shareInstance]getWithUrl:@"/web/api/wallet/seat/currency" parameters:@{} success:^(id responseObject) {
        
        NSDictionary  *dataDic = responseObject[@"data"];
        if (dataDic.allValues.count > 0) {
            WalletCurrencyModel *model = [WalletCurrencyModel yy_modelWithDictionary:dataDic];
            [SCCacheTool shareInstance].currencyModel = model;
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

// 加入聊天室
+(void)enterChatRoomWithId:(NSString *)roomId showString:(NSString *)showString callBlock:(void (^)(id, NSError *))callBlock{
    [HHTool show:showString];
    [JMSGChatRoom enterChatRoomWithRoomId:roomId completionHandler:^(JMSGConversation * resultObject, NSError *error) {
        if (!error) {
            BLOCK_EXEC(callBlock,resultObject,error)
            // 加入聊天室成功 进入聊天室页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HHTool immediatelyDismiss];
            });
            
        }else{
            if (error.code == 851003) {
                // 已经在聊天室了，先退出，再进入
                [JMSGChatRoom leaveChatRoomWithRoomId:roomId completionHandler:^(id resultObject, NSError *error) {
                    [HHTool dismiss];
                    if (!error) {
                        [EditInfoService enterChatRoomWithId:roomId showString:showString callBlock:callBlock];
                    }else{
                        [HHTool showError:error.localizedDescription];
                    }
                }];
            }else if (error.code == 6002){
                // [HHTool showError:NSLocalizedString(@"sc_NetworkIsNot", nil)];
            }else if (error.code == 800016){
                // 设备不匹配，重新登录
                [HHTool immediatelyDismiss];
                [[SCAppManager shareInstance]logout];
            } else{
                [HHTool immediatelyDismiss];
                [HHTool showError:error.localizedDescription];
            }
        }
        
    }];
}



@end


@implementation WalletCurrencyModel

-(NSNumber *)rate{
    if (!_rate) {
        return @(10);
    }
    return _rate;
}


@end
