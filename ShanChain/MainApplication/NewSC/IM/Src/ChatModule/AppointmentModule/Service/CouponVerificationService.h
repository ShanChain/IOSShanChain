//
//  CouponVerificationService.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/17.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CouponVerificationService : NSObject


+ (void)verificationCouponNameFid:(UITextField*)textFid tipLabel:(UILabel *)tipLb; //验证卡劵名
+ (void)verificationCardFid:(UITextField*)textFid tipLabel:(UILabel*)tipLb; // 验证代号
+ (void)dynamicCalculationMortgageFreeNumberFid:(UITextField*)numberFid PriceFid:(UITextField*)priceFid callBack:(void (^)(CGFloat mortgageFree))callBack;
+ (void)verificationIsCanCreate:(UIViewController*)vc;

@end
