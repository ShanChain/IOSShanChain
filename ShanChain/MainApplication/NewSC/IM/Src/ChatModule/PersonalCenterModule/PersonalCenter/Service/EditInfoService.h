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

// 更新头像
+ (void)sc_uploadImage:(UIImage *)image withCompressionQuality:(CGFloat)cq callBlock:(void (^)(BOOL))callBlock;

// 请求当前汇率
+(void)sc_requstWalletCurrency;

// 加入聊天室
+(void)enterChatRoomWithId:(NSString*)roomId callBlock:(void (^)(id resultObject, NSError *error))callBlock;

@end



@interface WalletCurrencyModel : NSObject

@property  (nonatomic,strong)  NSNumber  *rate;
@property  (nonatomic,copy)  NSString  *currency;

@end
