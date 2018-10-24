//
//  UIColor+Extention.m
//  MLLCustomer
//
//  Created by sihuan on 15/5/8.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "UIColor+Extention.h"

@implementation UIColor (Extentions)

+ colorWithString:(NSString *)hexString {
    unsigned long colorLong = strtoul(hexString.UTF8String, 0, 16);
    int R = (colorLong & 0xFF0000) >> 16;
    int G = (colorLong & 0x00FF00) >> 8;
    int B = colorLong & 0x0000FF;
    
    return [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1.f];
}

- (UIImage *)imageWithColor
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
