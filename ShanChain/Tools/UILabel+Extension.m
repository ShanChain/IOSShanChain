//
//  UILabel+Extension.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/7.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (void) makeTextStyleWithTitle:(NSString *)title withColor:(UIColor *)color withFont:(UIFont *)font withAlignment:(UITextAlignment)alignment {
    self.text = title;
    self.textColor = color;
    self.font = font;
    self.textAlignment = alignment;
}

@end
