//
//  EditInfoService.h
//  ShanChain
//
//  Created by 千千世界 on 2018/11/20.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WalletCurrencyModel;

@interface EditInfoService : NSObject

+(void)sc_editPersonalInfo:(NSDictionary *)params callBlock:(void (^)(BOOL  isSuccess))callBlock;

// 请求当前汇率
+(void)sc_requstWalletCurrency;

@end



@interface WalletCurrencyModel : NSObject

@property  (nonatomic,strong)  NSNumber  *rate;
@property  (nonatomic,copy)  NSString  *currency;

@end
