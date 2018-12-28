//
//  SYUIFactory.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/8.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SYUIFactory : NSObject

+ (UITextField *)textFieldWithPlacehold:(NSString *)title withFont:(UIFont *)font withColor:(UIColor *)color;


+ (UIView *)emptyViewWithTitle:(NSString *)title withColor:(UIColor *)color withBackgroundColor:(UIColor *)bgColor;

@end
