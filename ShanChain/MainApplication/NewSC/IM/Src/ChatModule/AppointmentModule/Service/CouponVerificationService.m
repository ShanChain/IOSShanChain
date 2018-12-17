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

+ (void)verificationCouponNameFid:(UITextField *)textFid{
    RAC(textFid,text) = [RACSignal combineLatest:@[textFid.rac_textSignal] reduce:^id _Nullable(NSString *name){
        if (name.length > 8) {
            return  [name substringToIndex:8];
        }
        
        if (![NSString isInputRuleAndBlank:name]) {
            [HHTool showError:@"只能输入文字，字母，数字，空格"];
            return  [name substringToIndex:name.length - 1];
        }
        
        return name;
    }];
}

+ (void)verificationCardFid:(UITextField *)textFid{
    
    RAC(textFid,text) = [RACSignal combineLatest:@[textFid.rac_textSignal] reduce:^id _Nullable(NSString *card){
        if (card.length > 3) {
            return  [card substringToIndex:3];
        }
        
        if (![card onlyInputACapital]) {
            [HHTool showError:@"字符非法"];
            return  [card substringToIndex:card.length - 1];
        }
        return card;
    }];
    
}

+(void)verificationIsCanCreate:(UIViewController *)vc{
    AppointmentCreateCardViewController  *createVC = (AppointmentCreateCardViewController*)vc;
    RAC(createVC.createBtn,enabled) = [RACSignal combineLatest:@[RACObserve(createVC, photoUrl),createVC.nameFid.rac_textSignal,createVC.cardFid.rac_textSignal,createVC.priceFid.rac_textSignal,createVC.numberFid.rac_textSignal,createVC.failureTimeFid.rac_textSignal,createVC.descriptionTextView.rac_textSignal] reduce:^id _Nullable(NSString *photoUrl, NSString *name, NSString *card, NSString *price, NSString *number, NSString *dealTime , NSString *des){
        return @(photoUrl.length > 0 && name.length > 0 && card.length > 0 && price.length > 0 && number.length > 0 && dealTime.length > 0 && des.length > 0);
    }];
    
    RAC(createVC.createBtn,backgroundColor) = [RACSignal combineLatest:@[RACObserve(createVC, photoUrl),createVC.nameFid.rac_textSignal,createVC.cardFid.rac_textSignal,createVC.priceFid.rac_textSignal,createVC.numberFid.rac_textSignal,createVC.failureTimeFid.rac_textSignal,createVC.descriptionTextView.rac_textSignal] reduce:^id _Nullable(NSString *photoUrl, NSString *name, NSString *card, NSString *price, NSString *number, NSString *dealTime , NSString *des){
         return createVC.createBtn.enabled ? Theme_MainThemeColor:[UIColor lightGrayColor];
    }];
    
    
}

@end






