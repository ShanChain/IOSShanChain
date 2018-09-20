//
//  CWAceColorUtility.h
//  XIXIN
//
//  Created by Ace on 16/8/22.
//  Copyright © 2016年 ciwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWAceColorUtility : NSObject

///MARK: 颜色渐变
- (instancetype)initWithStartHexColor:(NSString *)startHexColor endHexColor:(NSString *)endHexColor;

/// 根据变化比例返回color
- (UIColor *)colorWithRate:(CGFloat)rate;

@end
