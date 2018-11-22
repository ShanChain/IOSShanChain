//

//
//  Created by xc on 15/3/6.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeWithDictionary:(NSMutableDictionary *)dictionary maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (NSString *)stringByTrim;

- (BOOL)isNotBlank;

+ (BOOL)isBlankString:(NSString *)str;


#pragma mark - 是否是有效邮箱
- (BOOL)isValidEmail;

#pragma mark - 是否是有效电话号码

- (BOOL)isValidPhoneNumber;

- (BOOL)isValidPhoneNumberOrFixedTelephone;

#pragma mark - 是否是有效的身份证件

- (BOOL)isValidIdentifiedCard;

#pragma mark - 是否是有效的护照

- (BOOL)isValidPassportCard;

#pragma mark - 是否是有效的西部航空票号

- (BOOL)isValidTicketNumber;

- (BOOL)isValidVerifyCode;

- (BOOL)isValidOrderSN;
//是纯数字
- (BOOL)isPureInt;


- (BOOL)isPureFloat;
//检验字符串是否是 6-20位的字母和数字的组合
- (BOOL)isValidatePassword;

- (BOOL)isContainSerialCharacters;

- (BOOL)isNotEmpty;


- (BOOL)valString;

#pragma makr -- 富文本 给一段字符串设置两种不同的字体和颜色
+ (NSMutableAttributedString *)setAttrFirstString:(NSString *)string1 color:(UIColor *)color1 font:(UIFont *)font1 secendString:(NSString *)string2 color:(UIColor *)color2 font:(UIFont *)font2;
#pragma makr -- 富文本 给一段字符串设置三种不同的字体和颜色
+ (NSMutableAttributedString *)setAttrFirstString:(NSString *)string1 color:(UIColor *)color1 font:(UIFont *)font1 secendString:(NSString *)string2 color:(UIColor *)color2 font:(UIFont *)font2 threeString:(NSString *)string3 color:(UIColor *)color3 font:(UIFont *)font3;


//在当前日期，获取用户类型
- (BOOL)isBabyWithComparedDateString:(NSString *)comparedDate;

//在当前日期，获取用户类型

- (BOOL)isChildrenComparedDateString:(NSString *)comparedDate;

// 判断护照日期是否有效
- (BOOL)isInternationalPassportComparedDateString:(NSString *)comparedDateString;

//是否含有中文
- (BOOL)isChinese;

- (BOOL)includeChinese;


//有效乘机人姓名
- (BOOL)isValidPassengerName;

//获取身份证上的生日
-(NSString *)birthdayStrFromIdentityCard;

// 判断名称是否合法
-(BOOL)isNameValid;



// 身份证或手机号中间*号
- (NSString*)getEncryptPhoneNumberOrIDCard;
// 是否是一个合法的网页
- (BOOL)isValidUrl;

- (BOOL)hasChinese;

- (NSString*)getImageUrlWithPath;

@end
