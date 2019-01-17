//
//  CouponVerificationService.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/17.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "CouponVerificationService.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ShanChain-Swift.h"

@implementation CouponVerificationService

+ (void)verificationCouponNameFid:(UITextField *)textFid tipLabel:(UILabel *)tipLb{
    RAC(textFid,text) = [RACSignal combineLatest:@[textFid.rac_textSignal] reduce:^id _Nullable(NSString *name){
        if (name.length > 16) {
            return  [name substringToIndex:16];
        }

        if (![NSString isInputRuleAndBlank:name]) {
            tipLb.text = @"文本有误";
            tipLb.textColor = [UIColor redColor];
            return  [name substringToIndex:name.length - 1];
        }else{
            tipLb.text = @"仅可输入文字、数字、字母、空格";
            tipLb.textColor = [UIColor lightGrayColor];
        }

        return name;
    }];
    
}


// 动态计算抵押费用
+ (void)dynamicCalculationMortgageFreeNumberFid:(UITextField*)numberFid PriceFid:(UITextField*)priceFid callBack:(void (^)(CGFloat mortgageFree))callBack{
    
  __block  NSString  *numberStr;
  __block  NSString  *priceStr;
    
    RAC(numberFid,text) = [RACSignal combineLatest:@[numberFid.rac_textSignal] reduce:^id _Nullable(NSString *number){
        numberStr = number;
        callBack(numberStr.integerValue * priceStr.integerValue * 0.01);
        return number;
    }];
    
    RAC(priceFid,text) = [RACSignal combineLatest:@[priceFid.rac_textSignal] reduce:^id _Nullable(NSString *price){
        priceStr = price;
        callBack(numberStr.integerValue * priceStr.integerValue * 0.01);
        return price;
    }];
    
}

+ (void)verificationCardFid:(UITextField *)textFid tipLabel:(UILabel *)tipLb{
    
    RAC(textFid,text) = [RACSignal combineLatest:@[textFid.rac_textSignal] reduce:^id _Nullable(NSString *card){
        if (card.length > 3) {
            return  [card substringToIndex:3];
        }
        
        if (![card onlyInputACapital]) {
            [HHTool showError:@"字符非法"];
            return  [card substringToIndex:card.length - 1];
        }
        
        if (card.length == 3) {
            // 判定当前卡券代号是否可用
            [[SCNetwork shareInstance]HH_GetWithUrl:@"/wallet/api/coupons/vendor/check" parameters:@{@"tokenSymbol":card} showLoading:NO callBlock:^(HHBaseModel *baseModel, NSError *error) {
                if (error.code == SC_Token_Already_Exist.integerValue) {
                    tipLb.text = @"已被占用";
                    tipLb.textColor = [UIColor redColor];
                }
            }];
        }else{
            tipLb.text = @"代号为三个大写英文字母";
            tipLb.textColor = [UIColor lightGrayColor];
        }
        
        return card;
    }];
    
}

+(void)verificationIsCanCreate:(UIViewController *)vc{
    AppointmentCreateCardViewController  *createVC = (AppointmentCreateCardViewController*)vc;
    RAC(createVC.createBtn,enabled) = [RACSignal combineLatest:@[createVC.nameFid.rac_textSignal,createVC.cardFid.rac_textSignal,createVC.priceFid.rac_textSignal,createVC.numberFid.rac_textSignal] reduce:^id _Nullable(NSString *name, NSString *card, NSString *price, NSString *number){
        return @(name.length > 0 && card.length > 0 && price.length > 0 && number.length > 0);
    }];

    RAC(createVC.createBtn,backgroundColor) = [RACSignal combineLatest:@[createVC.nameFid.rac_textSignal,createVC.cardFid.rac_textSignal,createVC.priceFid.rac_textSignal,createVC.numberFid.rac_textSignal] reduce:^id _Nullable(NSString *name, NSString *card, NSString *price, NSString *number){
        return createVC.createBtn.enabled ? Theme_MainThemeColor:[UIColor lightGrayColor];
    }];
    
    
//    RAC(createVC.createBtn,backgroundColor) = [RACSignal combineLatest:@[createVC.nameFid.rac_textSignal,createVC.cardFid.rac_textSignal,createVC.priceFid.rac_textSignal,createVC.numberFid.rac_textSignal,createVC.failureTimeFid.rac_textSignal,createVC.descriptionTextView.rac_textSignal] reduce:^id _Nullable(NSString *name, NSString *card, NSString *price, NSString *number, NSString *dealTime , NSString *des){
//
//    }];

}

@end






