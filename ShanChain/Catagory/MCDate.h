//
//  MCDate.h
//  Quiz
//
//  Created by cjw on 15/10/14.
//  Copyright © 2015年 hjg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCDate : NSObject
@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)NSCalendar *calendar;
@property(nonatomic,strong)NSTimeZone *timeZone;
@property(nonatomic,strong)NSLocale *locale;

@property(nonatomic,assign)NSInteger era;
@property(nonatomic,assign)NSInteger year;
@property(nonatomic,assign)NSInteger month;
@property(nonatomic,assign)NSInteger day;
@property(nonatomic,assign)NSInteger hour;
@property(nonatomic,assign)NSInteger minute;
@property(nonatomic,assign)NSInteger second;
@property(nonatomic,assign)NSInteger weekday;
@property(nonatomic,assign)NSInteger weekdayOrdinal;
@property(nonatomic,assign)NSInteger weekOfMonth;
@property(nonatomic,assign)NSInteger weekOfYear;
@property(nonatomic,assign)NSInteger yearForWeekOfYear;
@property(nonatomic,assign)BOOL isLeapMonth;//是否是闰月，只针对阴历有效

@property(nonatomic,assign,readonly)NSInteger daysInMonth;
@property(nonatomic,assign,readonly)NSInteger weeksInMonth;//一月有多少周
@property(nonatomic,assign,readonly)NSInteger daysInYear;//一年有多少天，只针对阳历有效
@property(nonatomic,assign,readonly)NSInteger dayOfYear;
@property(nonatomic,assign,readonly)BOOL isLeapYear;//是否是闰年，只针对阳历有效

#pragma mark - Ceate Date
+(MCDate *)date;
+(MCDate *)dateWithInterval:(NSTimeInterval)timestamp;
+(MCDate *)dateWithDateComponent:(NSDateComponents *)dateComponent;
+(MCDate *)dateWithDate:(NSDate *)date;
+(MCDate *)dateWithDate:(NSDate *)date calendar:(NSCalendar *)calendar;
+(MCDate *)dateWithMCDate:(MCDate *)date;
+(MCDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+(MCDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+(MCDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString;
@end

#pragma mark - Date Compare
@interface MCDate (Compare)
-(BOOL)isSameYear:(MCDate *)date;
-(BOOL)isSameMonth:(MCDate *)date;
-(BOOL)isSameDay:(MCDate *)date;

-(BOOL)isEarlierThan:(MCDate *)date;
-(BOOL)isLaterThan:(MCDate *)date;
-(BOOL)isEarlierThanOrEqualTo:(MCDate *)date;
-(BOOL)isLaterThanOrEqualTo:(MCDate *)date;

-(NSInteger)yearsFrom:(MCDate *)date;
-(NSInteger)monthsFrom:(MCDate *)date;
-(NSInteger)weeksFrom:(MCDate *)date;
-(NSInteger)daysFrom:(MCDate *)date;
-(double)hoursFrom:(MCDate *)date;
-(double)minutesFrom:(MCDate *)date;
-(double)secondsFrom:(MCDate *)date;

@end


#pragma mark - Date Editing
@interface MCDate (Editing)
#pragma mark Date By Adding
//日期加法
- (MCDate *)dateByAddYears:(NSInteger)years;
- (MCDate *)dateByAddMonths:(NSInteger)months;
- (MCDate *)dateByAddWeeks:(NSInteger)weeks;
- (MCDate *)dateByAddDays:(NSInteger)days;
- (MCDate *)dateByAddHours:(NSInteger)hours;
- (MCDate *)dateByAddMinutes:(NSInteger)minutes;
- (MCDate *)dateByAddSeconds:(NSInteger)seconds;
#pragma mark Date By Subtracting
//日期减法
- (MCDate *)dateBySubYears:(NSInteger)years;
- (MCDate *)dateBySubMonths:(NSInteger)months;
- (MCDate *)dateBySubWeeks:(NSInteger)weeks;
- (MCDate *)dateBySubDays:(NSInteger)days;
- (MCDate *)dateBySubHours:(NSInteger)hours;
- (MCDate *)dateBySubMinutes:(NSInteger)minutes;
- (MCDate *)dateBySubSeconds:(NSInteger)seconds;
@end

#pragma mark - Date Formatter
@interface MCDate (Formatter)
-(NSString *)formattedDateWithFormat:(NSString *)format;
-(NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;
-(NSString *)formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale;
-(NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
@end