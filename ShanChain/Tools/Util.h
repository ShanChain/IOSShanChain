//
//  Util.h
//  smartapc-ios
//
//  Created by list on 16/5/23.
//  Copyright © 2016年 list. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//强引用
#define strongify(object) __typeof__(object) object = weak##_##object;

// 系统字体快捷使用
#define Font(size) [UIFont systemFontOfSize:(size)]

// 数值转颜色(0, 0, 0)
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1)]

#define RGB_Hex(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

// 数值转颜色(0, 0, 0, 1) 加透明度
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 16进制转颜色(0x067AB5)
#define RGB_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
