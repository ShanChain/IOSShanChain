//
//  SCDatePicker.h
//  ShanChain
//
//  Created by flyye on 2017/12/14.
//  Copyright © 2017年 ShanChain. All rights reserved.
//



#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface SCDatePicker : NSObject

- (void)showDatePicker:(NSString *)initDate  success:(void (^)(id result))success error:(void (^)(id err))error;

@end
