//

//
//  Created by xc on 15/3/6.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
#pragma mark 计算字符串大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}

- (CGSize)sizeWithDictionary:(NSMutableDictionary *)dictionary maxSize:(CGSize)maxSize
{
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dictionary context:nil].size;
    return textSize;
}

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isBlankString:(NSString *)str{
    if (!str) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}



#pragma mark - 是否是有效邮箱

- (BOOL)isValidEmail {
    
    NSString *emailRegular =@"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
    return [self isValidStringWithPredicate:emailRegular];
}

- (BOOL)isNotEmpty {
    
    if (self && ![self isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}



#pragma mark 判断字符串是否为空，null，nil等...（YES：为空）
- (BOOL)valString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([self isEqualToString:@""]) {
        return YES;
    }
    
    if ([self isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([self isEqualToString:@"null"]) {
        return YES;
    }
    
    if ([self isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([self stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 是否是有效电话号码

- (BOOL)isValidPhoneNumber {
    if (self == nil || self.length!=11) {
        return NO;
    }
    
    NSString *pattern =@"^1+[3578]+\\d{9}$";
    
    return [self isValidStringWithPredicate:pattern];
    
}



//判断是否是电话号码
- (BOOL)isValidPhoneNumberOrFixedTelephone
{
    //验证输入的固话中不带 "-"符号
    
    NSString * strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    //验证输入的固话中带 "-"符号
    
    NSString * horizontalLineStr = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    return [self isValidStringWithPredicate:strNum] || [self isValidStringWithPredicate:horizontalLineStr];
    
}

- (BOOL)isValidVerifyCode {
    
    NSString *code = @"[0-9]{4}";
    return [self isValidStringWithPredicate:code];
    
}

- (BOOL)isValidOrderSN {
    
    NSString *code = @"^([F|f])([Y|y])\\d{10}$";
    return [self isValidStringWithPredicate:code];
    
}


/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[➋➌➍➎➏➐➑➒\a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 * 字母、数字、中文正则判断（包括空格）【注意3】
 */
+ (BOOL)isInputRuleAndBlank:(NSString *)str{
    
    //九宫格无法输入解决需要加上正则 \➋➌➍➎➏➐➑➒
    NSString *pattern = @"^[➋➌➍➎➏➐➑➒\a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

#pragma  - mark 只能为大写
- (BOOL)onlyInputACapital{
    
      NSString *regex =@"[A-Z]*";
    
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
      BOOL inputString = [predicate evaluateWithObject:self];
      return inputString;
    
}

#pragma  - mark 允许大小写

- (BOOL)InputCapitalAndLowercaseLetter:(NSString*)string{
    
      NSString *regex =@"[a-zA-Z]*";
    
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
      BOOL  inputString = [predicate evaluateWithObject:string];
    
      return inputString;
    
}


#pragma mark - 是否是有效的身份证件

- (BOOL)isValidIdentifiedCard {
    return [NSString CheckIsIdentityCard:self];
}

#pragma mark - 是否是有效的西部航空票号

- (BOOL)isValidTicketNumber {
    
    NSString *regularInfo = @"^847-\\d{10}$";
    
    return [self isValidStringWithPredicate:regularInfo];
    
}




#pragma mark - 是否是有效的护照

- (BOOL)isValidPassportCard {
    
    NSString *re1 = @"^[a-zA-Z]{4,44}$";
    NSString *re2 = @"^[a-zA-Z0-9]{4,44}$";
    
    if ([self isValidStringWithPredicate:re1]) {
        return YES;
    }
    return [self isValidStringWithPredicate:re2];
    
}

- (BOOL)isValidStringWithPredicate:(NSString *)predicateInfo {
    if ([self isEqualToString:@""]) {
        return NO;
    }
    
    if (predicateInfo == nil) {
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateInfo];
    if ([predicate evaluateWithObject:self] ) {
        return YES;
    }
    return NO;
}


//身份证号
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}


//是纯数字
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isValidatePassword
{
    if (self.length < 8 || self.length > 20 || [self mj_isPureInt] || [self isPureLetters] || [self isPureSymbol]  ) {
        return NO;
    }
    return YES;
}

- (BOOL)isContainSerialCharacters{
    
    NSString *regx = @"^.*(.)\\1{2}.*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isPureLetters {
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:@"^[A-Za-z]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    return [regx numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}

- (BOOL)isPureSymbol {
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:@"^\\S[^A-Z^a-z^0-9]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    return [regx numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}


+ (NSMutableAttributedString *)setAttrFirstString:(NSString *)string1 color:(UIColor *)color1 font:(UIFont *)font1 secendString:(NSString *)string2 color:(UIColor *)color2 font:(UIFont *)font2
{
    NSString *oneString = ![string1 isNotEmpty]?@" ":string1;
    NSString *twoString = ![string2 isNotEmpty]?@" ":string2;
    
    NSString *needString = [NSString stringWithFormat:@"%@%@",oneString,twoString];
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:needString];
    [resultString addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, oneString.length)];
    [resultString addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, oneString.length)];
    
    [resultString addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(oneString.length, twoString.length)];
    [resultString addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(oneString.length, twoString.length)];
    
    return resultString;
}


+ (NSMutableAttributedString *)setAttrFirstString:(NSString *)string1 color:(UIColor *)color1 font:(UIFont *)font1 secendString:(NSString *)string2 color:(UIColor *)color2 font:(UIFont *)font2 threeString:(NSString *)string3 color:(UIColor *)color3 font:(UIFont *)font3
{
    NSString *oneString = ![string1 isNotEmpty]?@" ":string1;
    NSString *twoString = ![string2 isNotEmpty]?@" ":string2;
    NSString *threeString = ![string3 isNotEmpty]?@" ":string3;
    
    NSString *needString = [NSString stringWithFormat:@"%@%@%@",oneString,twoString,threeString];
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:needString];
    [resultString addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, oneString.length)];
    [resultString addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, oneString.length)];
    
    [resultString addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(oneString.length, twoString.length)];
    [resultString addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(oneString.length, twoString.length)];
    
    [resultString addAttribute:NSFontAttributeName value:font3 range:NSMakeRange(oneString.length + twoString.length, threeString.length)];
    [resultString addAttribute:NSForegroundColorAttributeName value:color3 range:NSMakeRange(oneString.length + twoString.length, threeString.length)];
    
    return resultString;
}


//在当前日期，获取用户类型 comparedDateString:乘机时间
- (BOOL)isBabyWithComparedDateString:(NSString *)comparedDateString {
    
    MCDate *birthDay = [MCDate dateWithString:self formatString:@"yyyy-MM-dd"];
    
    MCDate *babyDate = [birthDay dateByAddYears:2];
    
    MCDate *comparedDate = [MCDate dateWithString:comparedDateString formatString:@"yyyy-MM-dd"];
    
    
    if ([comparedDate isEarlierThan:babyDate]) {
        return YES;
    }
    return NO;
    
}

//在当前日期，获取用户类型 comparedDateString:乘机时间

- (BOOL)isChildrenComparedDateString:(NSString *)comparedDateString {
    
    
    MCDate *birthDay = [MCDate dateWithString:self formatString:@"yyyy-MM-dd"];
    
    
    MCDate *childrenDate = [birthDay dateByAddYears:12];
    
    MCDate *comparedDate = [MCDate dateWithString:comparedDateString formatString:@"yyyy-MM-dd"];
    
    if ([comparedDate isEarlierThan:childrenDate]) {
        
        return YES;
    }
    
    return NO;
    
}

//判断护照日期是否有效
- (BOOL)isInternationalPassportComparedDateString:(NSString *)comparedDateString{
    
    MCDate *passportDate = [MCDate dateWithString:self formatString:@"yyyy-MM-dd"];
    MCDate *comparedDate = [MCDate dateWithString:comparedDateString formatString:@"yyyy-MM-dd"];
    if ([comparedDate isEarlierThan:passportDate]) {
        return YES;
    }
    
    return NO;
    
}

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

//获取身份证上生日
-(NSString *)birthdayStrFromIdentityCard

{
    
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    
    NSString *year = nil;
    
    NSString *month = nil;
    
    NSString *day = nil;
    
    if ([self length] == 18) {
        
        year = [self substringWithRange:NSMakeRange(6, 4)];
        month = [self substringWithRange:NSMakeRange(10, 2)];
        day = [self substringWithRange:NSMakeRange(12, 2)];
        
        [result appendString:year];
        [result appendString:@"-"];
        
        [result appendString:month];
        [result appendString:@"-"];
        
        [result appendString:day];
        
        
    } else {
        
        year = [self substringWithRange:NSMakeRange(6, 2)];
        month = [self substringWithRange:NSMakeRange(8, 2)];
        day = [self substringWithRange:NSMakeRange(10, 2)];
        [result appendString:@"19"];
        
        [result appendString:year];
        [result appendString:@"-"];
        
        [result appendString:month];
        [result appendString:@"-"];
        
        [result appendString:day];
        
    }
    
    
    return result;
    
    
    
}



- (BOOL)isValidPassengerName {
    
    if ([self textLength] <24) {
        return YES;
    }
    
    return NO;
}

-(NSUInteger)textLength {
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        
        
        unichar uc = [self characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}



- (BOOL)isValidStringWithPredicateIsChinese:(NSString *)predicateInfo{
    if ([self isEqualToString:@""]) {
        return NO;
    }
    
    if (predicateInfo == nil) {
        return NO;
    }
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateInfo];
    if ([predicate evaluateWithObject:self] ) {
        return YES;
    }
    return NO;
}

/**
 *  判断名称是否合法
 *  @return yes / no
 */
-(BOOL)isNameValid
{
    BOOL isValid = NO;
    if (self.length > 0)
    {
        for (NSInteger i=0; i<self.length; i++)
        {
            unichar chr = [self characterAtIndex:i];
            
            if (chr < 0x80)
            { //字符
                if (chr >= 'a' && chr <= 'z')
                {
                    isValid = YES;
                }
                else if (chr >= 'A' && chr <= 'Z')
                {
                    isValid = YES;
                }
                else if (chr >= '0' && chr <= '9')
                {
                    isValid = NO;
                }
                else
                {
                    isValid = NO;
                }
            }
            else if (chr >= 0x4e00 && chr < 0x9fa5)
            { //中文
                isValid = YES;
            }
            else
            { //无效字符
                isValid = NO;
            }
            
            if (!isValid)
            {
                break;
            }
        }
    }
    
    return isValid;
}



// 身份证或手机号中间*号
- (NSString*)getEncryptPhoneNumberOrIDCard{
    NSMutableString *mStr = [NSMutableString string];
    for (int i = 0; i < self.length; i++) {
        NSString *a = [self substringWithRange:NSMakeRange(i, 1)];
        if (i > 2 && i < self.length - 4) {
            [mStr appendString:@"*"];
        }else{
            [mStr appendString:a];
        }
        
    }
    return mStr.copy;
}

- (BOOL)isValidUrl
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

- (BOOL)hasChinese{
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

- (NSString*)getImageUrlWithPath{
    NSString  *imageUrl;
    if ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) {
        imageUrl = self;
    }else{
        imageUrl = [NSString stringWithFormat:@"%@%@",Base_url,self];
    }
    return imageUrl;
}


+(BOOL)compareVersion:(NSString *)nowVersion withServerVersion:(NSString *)serverVersion{
    if (![NSString isBlankString:nowVersion] && ![NSString isBlankString:serverVersion]) {
        NSArray *nowVersions = [nowVersion componentsSeparatedByString:@"."];
        NSArray *serverVersions = [serverVersion componentsSeparatedByString:@"."];
        if (nowVersions != nil && serverVersions != nil && nowVersions.count > 1 && serverVersions.count > 1) {
            int nowVersionsFirst = [nowVersions[0] integerValue];
            int serverVersionFirst = [serverVersions[0] integerValue];
            int nowVersionsSecond = [nowVersions[1] integerValue];
            int serverVersionSecond = [serverVersions[1] integerValue];
            int nowVersionsThird = [nowVersions[2] integerValue];
            int serverVersionThird = [serverVersions[2] integerValue];
            if (nowVersionsFirst < serverVersionFirst) {
                return YES;
            } else if (nowVersionsFirst == serverVersionFirst && nowVersionsSecond < serverVersionSecond) {
                return YES;
            } else if (nowVersionsFirst == serverVersionFirst && nowVersionsSecond == serverVersionSecond && nowVersionsThird < serverVersionThird) {
                return YES;
            }
        }
    }
    return NO;
}

BOOL notEmpty(NSString *str) {
    if (!str) return NO;
    static NSSet *emptySet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emptySet = [NSSet setWithObjects:@"", @"(null)", @"null", @"<null>", @"NULL", nil];
    });
    if ([emptySet containsObject:str]) return NO;
    if ([str isKindOfClass:NSNull.class]) return NO;
    return YES;
}

- (BOOL)_notEmpty{
    return notEmpty(self);
}

@end
