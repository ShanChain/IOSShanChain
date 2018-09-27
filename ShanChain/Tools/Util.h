//
//  Util.h
//  smartapc-ios
//
//  Created by list on 16/5/23.
//  Copyright © 2016年 list. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface Util : NSObject


+ (CGSize)sizeWithString:(NSString *)value font:(UIFont *)font maxSize:(CGSize)maxSize;

// 获取设备的当前时间戳
+ (long long)getSystemTime;

// 2分钟前 | 20小时前 | 20天前 | 4月5日 | 2001年4月5日
+ (NSString *)dynamicDisplayTime:(NSString *)longTime;
+ (NSString *)dynamicDisplayMessageTime:(NSString *)longTime;

+ (NSString *)displayTime7:(long long)longTime;
+ (NSString *)displayTime:(long long)longTime;
+ (NSString *)displayTime8:(long long)longTime;
+ (NSString *)displayTime2:(long long)longTime;
+ (NSString *)displayTime5:(long long)longTime;
+ (NSString *)displayTime3:(long long)longTime;
+ (NSString *)displayTime6:(long long)longTime;
+ (NSString *)displayTime9:(long long)longTime;
+ (NSString *)displayTime10:(long long)longTime;
+ (NSString *)displayTime11:(long long)longTime;
+ (NSString *)displayTime13:(long long)longTime;
+ (NSString *)displayTime14:(long long)longTime;
+ (NSString *)floatToString:(float)aFloat;
+ (NSString *)displayTime4:(long long)longTime;
+ (NSString *)intToString:(float)aFloat;

+ (void)commonViewAnimation:(void(^)(void))animationCB completion:(void(^)(void))completionCB;

+ (void)popAnimationWithView:(UIView *)popView animation:(void(^)(void))animationCB completion:(void(^)(void))completionCB;

+ (NSString *)uuid;

#pragma mark - 将某个时间转化成 时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

@end
