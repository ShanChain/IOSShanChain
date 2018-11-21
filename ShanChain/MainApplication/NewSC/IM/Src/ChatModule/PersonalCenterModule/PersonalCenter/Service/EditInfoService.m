//
//  EditInfoService.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/20.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "EditInfoService.h"

@implementation EditInfoService

+(void)sc_editPersonalInfo:(NSDictionary *)params callBlock:(void (^)(BOOL))callBlock{
    [[SCNetwork shareInstance]v1_postWithUrl:CHANGE_USER_CHARACTER params:params.copy showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
        if (!error) {
            [HHTool showSucess:baseModel.message];
            if (baseModel.data[@"characterInfo"] && [baseModel.data[@"characterInfo"] isKindOfClass:[NSDictionary class]]) {
                SCCharacterModel_characterInfo *info = [SCCharacterModel_characterInfo mj_objectWithKeyValues:baseModel.data[@"characterInfo"]];
                [SCCacheTool shareInstance].characterModel.characterInfo = info;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"kUpdateUserInfo" object:nil];
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

@end


@implementation WalletCurrencyModel



@end
