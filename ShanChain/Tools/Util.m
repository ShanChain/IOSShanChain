//
//  Util.m
//  smartapc-ios
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 list. All rights reserved.
//

#import "Util.h"

@implementation Util

#warning 这是有所得的
+ (CGSize)sizeWithString:(NSString *)value font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [value boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

NS_INLINE void tipWithMessage(NSString *message){
    dispatch_async(dispatch_get_main_queue(), ^{
     UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil]; [alerView show]; [alerView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@0, @1] afterDelay:0.9];
    });
}

+ (UIWindow *)topWindow
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]]
            && window.windowLevel == UIWindowLevelNormal
            && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)
            && !window.isHidden
            && window.alpha != 0)
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

// 获取设备的当前时间戳
+ (long long)getSystemTime {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    long long locaTime = [dat timeIntervalSince1970]*1000;
    return locaTime;
}

// 2分钟前 | 20小时前 | 20天前 | 4月5日 | 2001年4月5日
+ (NSString *)dynamicDisplayTime:(NSString *)longTime {
    long long lTime = [longTime longLongValue];
    long long delta = [Util getSystemTime] - lTime;
    
    NSDateComponents *dateComponents = [Util timeToDateComponents:lTime];
    
    delta = delta / 1000; // 转换成秒
    
    NSString *r = @"";
    if (delta <= 60) {// 小于等于1分钟显示 “刚刚”
        r = @"刚刚";
    } else if (delta <= 60 * 60) {// 大于1分钟小于等于1小时 显示  “N分钟前”
        r = [NSString stringWithFormat:@"%lld分钟前", delta / 60];
    } else if (delta <= (60 * 60 * 24)) {// 大于1小时小于等于24小时 显示 “N小时前”
        r = [NSString stringWithFormat:@"%ld:%ld",(long)dateComponents.hour, (long)dateComponents.minute];
    } /*else if (delta <= (60 * 60 * 24 * 7)) {// 大于24小时小于等于1周 显示 “N天前”
        r = [NSString stringWithFormat:@"%lld天前", delta / (60 * 60 * 24)];
    } */else if (delta <= (60 * 60 * 24 * 365)) {// 大于1周小于等于1年 显示    “N月N日”
        r = [NSString stringWithFormat:@"%ld月%ld日", (long)dateComponents.month, (long)dateComponents.day];
    } else {// 跨年
        r = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    }
    return r;
}

+ (NSString *)dynamicDisplayMessageTime:(NSString *)longTime {
    long long lTime = [longTime longLongValue];
    long long delta = [Util getSystemTime] - lTime;
    
    NSDateComponents *dateComponents = [Util timeToDateComponents:lTime];
    
    delta = delta / 1000; // 转换成秒
    
    NSString *r = @"";
    if (delta <= (60 * 60 * 24)) {// 大于1小时小于等于24小时 显示 “N小时前”
        r = [NSString stringWithFormat:@"%ld:%ld",(long)dateComponents.hour, (long)dateComponents.minute];
    } else if (delta <= (60 * 60 * 24 * 365)) {// 大于1周小于等于1年 显示    “N月N日”
       r = [NSString stringWithFormat:@"%ld月%ld日", (long)dateComponents.month, (long)dateComponents.day];
    } else {// 跨年
       r = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    }
    return r;
}

+ (NSDateComponents *)timeToDateComponents:(long long)longTime {
    NSDate *date            = [NSDate dateWithTimeIntervalSince1970:(longTime/1000)];
    NSCalendar *calendar    = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags    = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    return dateComponents;
}

+ (NSString *)displayTime2:(long long)longTime {
    if (longTime && longTime != 0) {
        long long delta = [Util getSystemTime] - longTime;
        delta = delta / 1000; // 转换成秒
        NSString *r = @"";
        
        NSDateComponents *dateComponents = [Util timeToDateComponents:longTime];
        NSString *month = [NSString stringWithFormat:((long)dateComponents.month > 9 ? @"%ld" : @"0%ld"),(long)dateComponents.month];
        
        NSString *day = [NSString stringWithFormat:((long)dateComponents.day > 9 ? @"%ld" : @"0%ld"),(long)dateComponents.day];

        NSString *hour = [NSString stringWithFormat:((long)dateComponents.hour > 9 ? @"%ld" : @"0%ld"),(long)dateComponents.hour];

        NSString *minute = [NSString stringWithFormat:((long)dateComponents.minute > 9 ? @"%ld" : @"0%ld"),(long)dateComponents.minute];

        NSString *second = [NSString stringWithFormat:((long)dateComponents.second > 9 ? @"%ld" : @"0%ld"),(long)dateComponents.second];

        r = [NSString stringWithFormat:@"%@月%@日 %@:%@:%@", month, day, hour, minute, second];
        return r;
    }
    return @"";
}

+ (NSString *)displayTime3:(long long)longTime {
    if (longTime && longTime != 0) {
        long long delta = [Util getSystemTime] - longTime;
        delta = delta / 1000; // 转换成秒
        NSString *r = @"";
        NSDateComponents *dateComponents = [Util timeToDateComponents:longTime];
        r = [NSString stringWithFormat:@"%ld年", (long)dateComponents.year];
        return r;
    }
    return @"";
}

+ (NSString *)intToString:(float)aFloat {
    NSString *str = [NSString stringWithFormat:@"%.0f",aFloat];
    NSString *ret = str;
    if ([str rangeOfString:@"."].location != NSNotFound) {
        NSArray *strArr = [str componentsSeparatedByString:@"."];
        ret = strArr[0];
        
        NSString *str1 = strArr[1];
        if ([str1 isEqualToString:@"0"]) {
            ret = strArr[0];
        } else {
            if ([str1 isEqualToString:@"00"]) {
                ret = strArr[0];
            } else {
                NSString *str3 = [str1 substringToIndex:1];
                NSString *str4 = [str1 substringFromIndex:1];
                if ([str4 isEqualToString:@"0"]) {
                    ret = [NSString stringWithFormat:@"%@.%@",strArr[0],str3];
                } else {
                    ret = [NSString stringWithFormat:@"%@.%@%@",strArr[0],str3,str4];
                }
            }
        }
    }
    return ret;
}


+ (NSString *)floatToString:(float)aFloat {
    NSString *str = [NSString stringWithFormat:@"%.2f",aFloat];
    NSString *ret = str;
    if ([str rangeOfString:@"."].location != NSNotFound) {
        NSArray *strArr = [str componentsSeparatedByString:@"."];
        ret = strArr[0];
        
        NSString *str1 = strArr[1];
        if ([str1 isEqualToString:@"0"]) {
            ret = strArr[0];
        } else {
            if ([str1 isEqualToString:@"00"]) {
                ret = strArr[0];
            } else {
                NSString *str3 = [str1 substringToIndex:1];
                NSString *str4 = [str1 substringFromIndex:1];
                if ([str4 isEqualToString:@"0"]) {
                    ret = [NSString stringWithFormat:@"%@.%@",strArr[0],str3];
                } else {
                    ret = [NSString stringWithFormat:@"%@.%@%@",strArr[0],str3,str4];
                }
            }
        }
    }
    return ret;
}

+ (void)commonViewAnimation:(void(^)(void))animationCB completion:(void(^)(void))completionCB {
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        if (animationCB)
            animationCB();
    } completion:^(BOOL isFinished) {
        if (completionCB)
            completionCB();
    }];
}

+ (void)popAnimationWithView:(UIView *)popView animation:(void(^)(void))animationCB completion:(void(^)(void))completionCB {
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        if (animationCB)
            animationCB();
    } completion:^(BOOL isFinished) {
        CGFloat animationDuration = 0.55;
         CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
         opacityAnimation.fromValue = @0.5;
         opacityAnimation.toValue = @1.;
         opacityAnimation.duration = animationDuration * 0.5f;
        
         CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
         CATransform3D startingScale    = CATransform3DScale(popView.layer.transform, 0, 0, 0);
         CATransform3D overshootScale   = CATransform3DScale(popView.layer.transform, 1.05, 1.05, 1.0);
         CATransform3D undershootScale  = CATransform3DScale(popView.layer.transform, 0.98, 0.98, 1.0);
         CATransform3D endingScale      = popView.layer.transform;
        
         NSMutableArray *scaleValues = [NSMutableArray arrayWithObject:[NSValue valueWithCATransform3D:startingScale]];
         NSMutableArray *keyTimes = [NSMutableArray arrayWithObject:@0.0f];
         NSMutableArray *timingFunctions = [NSMutableArray arrayWithObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
         if (YES) {
             [scaleValues addObjectsFromArray:@[[NSValue valueWithCATransform3D:overshootScale], [NSValue valueWithCATransform3D:undershootScale]]];
             [keyTimes addObjectsFromArray:@[@0.5f, @0.85f]];
             [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
         }
        
         [scaleValues addObject:[NSValue valueWithCATransform3D:endingScale]];
         [keyTimes addObject:@1.0f];
         [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
         scaleAnimation.values          = scaleValues;
         scaleAnimation.keyTimes        = keyTimes;
         scaleAnimation.timingFunctions = timingFunctions;
         CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
         animationGroup.animations      = @[scaleAnimation, opacityAnimation];
         animationGroup.duration        = animationDuration;
        
         [popView.layer addAnimation:animationGroup forKey:nil];
        
         if (completionCB)
             completionCB();
    }];
}

+ (NSString *)uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    return result;
}

//将某个时间转化成 时间戳
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    SCLog(@"将某个时间转化成 时间戳timestamp:%ld",(long)timeSp); //时间戳的值
    return timeSp;
}

@end
