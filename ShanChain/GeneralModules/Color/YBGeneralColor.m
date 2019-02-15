//
//  YBGeneralColor.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "YBGeneralColor.h"

@implementation YBGeneralColor

+ (UIColor *)themeColor {
    return RGB(172, 129, 233);
}

+ (UIColor *)navigationBarColor {
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBarTitleColor {
    return [UIColor darkTextColor];
}

+ (UIColor *)tabBarTitleNormalColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)tabBarTitleSelectedColor {
    return RGB(172, 129, 233);
}

+ (UIColor *)seperaterColor {
    return [UIColor groupTableViewBackgroundColor];
}

@end
