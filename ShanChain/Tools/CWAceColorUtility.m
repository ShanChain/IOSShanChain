//
//  CWAceColorUtility.m
//  XIXIN
//
//  Created by Ace on 16/8/22.
//  Copyright © 2016年 ciwang. All rights reserved.
//

#import "CWAceColorUtility.h"

@interface CWAceColorUtility () {
    unsigned int startRedColor;
    unsigned int startGreenColor;
    unsigned int startBlueColor;
    unsigned int endRedColor;
    unsigned int endGreenColor;
    unsigned int endBlueColor;
}

@property (nonatomic, assign) NSInteger redDiff;
@property (nonatomic, assign) NSInteger greenDiff;
@property (nonatomic, assign) NSInteger blueDiff;

@end

@implementation CWAceColorUtility

- (instancetype)initWithStartHexColor:(NSString *)startHexColor endHexColor:(NSString *)endHexColor {
    if (self = [super init]) {
        BOOL startFlag = [self getFloatColor:startHexColor red:&startRedColor green:&startGreenColor blue:&startBlueColor];
        BOOL endFlag =[self getFloatColor:endHexColor red:&endRedColor green:&endGreenColor blue:&endBlueColor];
        if (!(startFlag && endFlag)) {
            return nil;
        }
        [self calcDiff];
    }
    return self;
}

/// 计算颜色差值
- (void)calcDiff {
    self.redDiff = endRedColor - startRedColor;
    self.greenDiff = endGreenColor - startGreenColor;
    self.blueDiff = endBlueColor - startBlueColor;
}

- (BOOL)getFloatColor:(NSString *)color red:(unsigned int *)redColor green:(unsigned int *)greenColor blue:(unsigned int *)blueColor {
    BOOL flag = YES;
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        flag = NO;
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        flag = NO;
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    [[NSScanner scannerWithString:rString] scanHexInt:redColor];
    [[NSScanner scannerWithString:gString] scanHexInt:greenColor];
    [[NSScanner scannerWithString:bString] scanHexInt:blueColor];

    return flag;
}

/// 根据变化比例返回color
- (UIColor *)colorWithRate:(CGFloat)rate {
    CGFloat red = startRedColor + self.redDiff * rate;
    CGFloat green = startGreenColor + self.greenDiff * rate;
    CGFloat blue = startBlueColor + self.blueDiff * rate;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}

@end
