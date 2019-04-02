//
//  SCNetworkError.h
//  ShanChain
//
//  Created by flyye on 2017/10/23.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#ifndef SCNetworkError_h
#define SCNetworkError_h
#import <Foundation/Foundation.h>

static NSString * const SC_COMMON_SUC_CODE = @"000000";
static NSString * const SC_WALLET_COMMON_SUC_CODE = @"200";
static NSString * const SC_REQUEST_TOKEN_EXPIRE = @"999991";
static NSString * const SC_REALNAME_AUTHENTICATE = @"999970"; // 需要实名认证
static NSString * const SC_REALNAME_NOMATCH = @"999984"; // 身份证号码与姓名不匹配
static NSString * const SC_Token_Already_Exist = @"400"; // token已存在
static NSString * const SC_NOTENOUGH = @"10001"; // 余额不足
static NSString * const SC_ERROR_WalletAccountNotexist = @"10003"; // 钱包账户不存在
static NSString * const SC_ERROR_WalletPasswordNotexist = @"10024"; // 钱包密码不存在
static NSString * const SC_ERROR_WalletSavePasswordFail = @"10026"; // 保存密码失败
static NSString * const SC_ERROR_WalletPasswordInvalid = @"10004"; // 钱包无效

static NSString * const SC_PHONENUMBER_NOBIND = @"999993"; // 手机号未绑定
static NSString * const SC_LOGIN_ERR_CODE = @"999996";
static NSString * const SC_USER_REPEAT_ERR_CODE = @"999997";
static NSString * const SC_COMMON_ERR_CODE = @"999999";
static NSString * const SC_ACCOUNT_HAS_BINDED = @"999989";
static NSString * const SC_SHARE_NOOPEN = @"999987";


typedef enum : NSInteger {
    SC_REQUEST_NO_NETWORK = -00001,
    SC_REQUEST_NO_PARAMS = -00002,
    SC_REQUEST_METHOD_ERROR = -00003,
} SCErrorCodeType;


@interface SCNetworkError : NSObject

+ (NSError *)errorWithCode:(NSInteger)code msg:(NSString *)msg;


@end

#endif /* SCNetworkError_h */
