//
//  MCDate.m
//  Quiz
//
//  Created by cjw on 15/10/14.
//  Copyright © 2015年 hjg. All rights reserved.
//

#import "MCDate.h"

static const unsigned int allCalendarUnitFlags=NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitQuarter|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitYearForWeekOfYear|NSCalendarUnitNanosecond|NSCalendarUnitCalendar|NSCalendarUnitTimeZone;

const NSInteger SECONDS_IN_WEEK = 604800;
const NSInteger SECONDS_IN_DAY = 86400;
const NSInteger SECONDS_IN_HOUR = 3600;
const NSInteger SECONDS_IN_MINUTE = 60;

@interface MCDate ()

@property(nonatomic,strong)NSDateComponents *dateComponent;

@end

@implementation MCDate

MJCodingImplementation;


+ (NSArray *)mj_ignoredCodingPropertyNames{
    return @[@"daysInMonth",@"weeksInMonth",@"daysInYear",@"dayOfYear",@"isLeapYear"];
}

#pragma mark - Create
-(instancetype)initWithDateComponent:(NSDateComponents *)dateComponent{
    self=[super init];
    if (self) {
        self.dateComponent=dateComponent;
        
    }
    return self;
}
-(instancetype)initWithDate:(NSDate *)date calendar:(NSCalendar *)calendar{
    self=[super init];
    if (self) {
        self.dateComponent=[calendar components:allCalendarUnitFlags fromDate:date];
    }
    return self;
}
-(instancetype)initWithMCDate:(MCDate *)date{
    self=[super init];
    if (self) {
        self.dateComponent=[date.dateComponent copy];
    }
    return self;
}
-(instancetype)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    self=[super init];
    if (self) {
        self.date=[self.calendar dateWithEra:1 year:year month:month day:day hour:hour minute:minute second:second nanosecond:0];
    }
    return self;
}
-(instancetype)initWithString:(NSString *)dateString formatString:(NSString *)formatString{
    self=[super init];
    if (self) {
        static NSDateFormatter *formatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [[NSDateFormatter alloc] init];
        });
        [formatter setDateFormat:formatString];
        NSDate *lDate= [formatter dateFromString:dateString];
        self.date=lDate;
    }
    return self;
}
+(MCDate *)date{
    return [MCDate dateWithDate:[NSDate date]];
}
+(MCDate *)dateWithInterval:(NSTimeInterval)timestamp{
    if (timestamp > 9999999999) {
        timestamp = timestamp/1000;
    }
    return [[MCDate alloc]initWithDate:[NSDate dateWithTimeIntervalSince1970:timestamp] calendar:[NSCalendar currentCalendar]];
}
+(MCDate *)dateWithDateComponent:(NSDateComponents *)dateComponent{
    return [[MCDate alloc]initWithDateComponent:dateComponent];
}
+(MCDate *)dateWithDate:(NSDate *)date{
    return [[MCDate alloc]initWithDate:date calendar:[NSCalendar currentCalendar]];
}
+(MCDate *)dateWithDate:(NSDate *)date calendar:(NSCalendar *)calendar{
    return [[MCDate alloc]initWithDate:date calendar:calendar];
}
+(MCDate *)dateWithMCDate:(MCDate *)date{
    return [[MCDate alloc]initWithMCDate:date];
}
+(MCDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    return [[MCDate alloc]initWithYear:year month:month day:day hour:0 minute:0 second:0];
}
+(MCDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    return [[MCDate alloc]initWithYear:year month:month day:day hour:hour minute:minute second:second];
}
+(MCDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString{
    return [[MCDate alloc]initWithString:dateString formatString:formatString];
}


#pragma mark - Setter And Getter
-(NSInteger)era{
    return self.dateComponent.era;
}
-(void)setEra:(NSInteger)era{
    self.dateComponent.era=era;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)year{
    return self.dateComponent.year;
}
-(void)setYear:(NSInteger)year{
    self.dateComponent.year=year;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)month{
    return self.dateComponent.month;
}
-(void)setMonth:(NSInteger)month{
    self.dateComponent.month=month;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)day{
    return self.dateComponent.day;
}
-(void)setDay:(NSInteger)day{
    self.dateComponent.day=day;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)hour{
    return self.dateComponent.hour;
}
-(void)setHour:(NSInteger)hour{
    self.dateComponent.hour=hour;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)minute{
    return self.dateComponent.minute;
}
-(void)setMinute:(NSInteger)minute{
    self.dateComponent.minute=minute;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)second{
    return self.dateComponent.second;
}
-(void)setSecond:(NSInteger)second{
    self.dateComponent.second=second;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)weekday{
    return self.dateComponent.weekday;
}
-(void)setWeekday:(NSInteger)weekday{
    self.dateComponent.weekday=weekday;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)weekdayOrdinal{
    return self.dateComponent.weekdayOrdinal;
}
-(void)setWeekdayOrdinal:(NSInteger)weekdayOrdinal{
    self.dateComponent.weekdayOrdinal=weekdayOrdinal;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)weekOfMonth{
    return self.dateComponent.weekOfMonth;
}
-(void)setWeekOfMonth:(NSInteger)weekOfMonth{
    self.dateComponent.weekOfMonth=weekOfMonth;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)weekOfYear{
    return self.dateComponent.weekOfYear;
}
-(void)setWeekOfYear:(NSInteger)weekOfYear{
    self.dateComponent.weekOfYear=weekOfYear;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(NSInteger)yearForWeekOfYear{
    return self.dateComponent.yearForWeekOfYear;
}
-(void)setYearForWeekOfYear:(NSInteger)yearForWeekOfYear{
    self.dateComponent.yearForWeekOfYear=yearForWeekOfYear;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}
-(BOOL)isLeapMonth{
    return self.dateComponent.isLeapMonth;
}
-(void)setIsLeapMonth:(BOOL)isLeapMonth{
    self.dateComponent.leapMonth=isLeapMonth;
    self.date=[self.calendar dateFromComponents:self.dateComponent];
}

-(NSInteger)daysInMonth{
    NSRange days = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date];
    return days.length;
}
-(NSInteger)weeksInMonth{
    NSRange weeks = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self.date];
    return weeks.length;
}
-(NSInteger)daysInYear{
    if (self.isLeapYear) {
        return 366;
    }else{
        return 365;
    }
}

-(NSInteger)dayOfYear{
    NSInteger day=[self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self.date];
    return day;
}
-(BOOL)isLeapYear{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:allCalendarUnitFlags fromDate:self.date];
    
    if (dateComponents.year%400 == 0){
        return YES;
    }
    else if (dateComponents.year%100 == 0){
        return NO;
    }
    else if (dateComponents.year%4 == 0){
        return YES;
    }
    
    return NO;
}
#pragma mark - Importance Property
-(NSDate *)date{
    return [self.calendar dateFromComponents:self.dateComponent];
}
-(void)setDate:(NSDate *)date{
    self.dateComponent=[self.calendar components:allCalendarUnitFlags fromDate:date];
}
-(NSCalendar *)calendar{
    return self.dateComponent.calendar;
}
-(void)setCalendar:(NSCalendar *)calendar{
    self.dateComponent=[calendar components:allCalendarUnitFlags fromDate:self.date];
}
-(NSTimeZone *)timeZone{
    return self.calendar.timeZone;
}
-(void)setTimeZone:(NSTimeZone *)timeZone{
    self.calendar.timeZone=timeZone;
    self.dateComponent=[self.calendar components:allCalendarUnitFlags fromDate:self.date];
}
-(NSLocale *)locale{
    return self.calendar.locale;
}
-(void)setLocale:(NSLocale *)locale{
    self.calendar.locale=locale;
    self.dateComponent=[self.calendar components:allCalendarUnitFlags fromDate:self.date];
}
-(NSDateComponents *)dateComponent{
    if (_dateComponent==nil) {
        _dateComponent=[[NSCalendar currentCalendar] components:allCalendarUnitFlags fromDate:[NSDate date]];
    }
    return _dateComponent;
}

#pragma mark - 
-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.dateComponent];
}
@end

#pragma mark - Date Editing
@implementation MCDate (Editing)
#pragma mark Date By Adding
- (MCDate *)dateByAddYears:(NSInteger)years{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitYear value:years toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateByAddMonths:(NSInteger)months{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitMonth value:months toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateByAddWeeks:(NSInteger)weeks{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitWeekday value:weeks toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateByAddDays:(NSInteger)days{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitDay value:days toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateByAddHours:(NSInteger)hours{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitHour value:hours toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateByAddMinutes:(NSInteger)minutes{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitMinute value:minutes toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateByAddSeconds:(NSInteger)seconds{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitSecond value:seconds toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
#pragma mark Date By Subtracting
- (MCDate *)dateBySubYears:(NSInteger)years{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitYear value:-1*years toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateBySubMonths:(NSInteger)months{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitMonth value:-1*months toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateBySubWeeks:(NSInteger)weeks{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitWeekday value:-1*weeks toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateBySubDays:(NSInteger)days{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1*days toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateBySubHours:(NSInteger)hours{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitHour value:-1*hours toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateBySubMinutes:(NSInteger)minutes{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitMinute value:-1*minutes toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}
- (MCDate *)dateBySubSeconds:(NSInteger)seconds{
    NSDate *lDate=[self.calendar dateByAddingUnit:NSCalendarUnitSecond value:-1*seconds toDate:self.date options:0];
    return [MCDate dateWithDate:lDate calendar:self.calendar];
}

@end

#pragma mark - Date Compare
@implementation MCDate (Compare)

-(BOOL)isSameYear:(MCDate *)date{
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear) fromDate:self.date];
    NSDate *dateOne = [self.calendar dateFromComponents:components];
    
    components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear) fromDate:date.date];
    NSDate *dateTwo = [self.calendar dateFromComponents:components];
    
    return [dateOne isEqualToDate:dateTwo];
    return YES;
}

-(BOOL)isSameMonth:(MCDate *)date{
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:self.date];
    NSDate *dateOne = [self.calendar dateFromComponents:components];
    
    components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:date.date];
    NSDate *dateTwo = [self.calendar dateFromComponents:components];
    
    return [dateOne isEqualToDate:dateTwo];
    return YES;
}

-(BOOL)isSameDay:(MCDate *)date{
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self.date];
    NSDate *dateOne = [self.calendar dateFromComponents:components];
    
    components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date.date];
    NSDate *dateTwo = [self.calendar dateFromComponents:components];
    
    return [dateOne isEqualToDate:dateTwo];
    return YES;
}

-(BOOL)isEarlierThan:(MCDate *)date{
    if(self.date.timeIntervalSince1970<date.date.timeIntervalSince1970){
        return YES;
    }
    return NO;
}
-(BOOL)isLaterThan:(MCDate *)date{
    if(self.date.timeIntervalSince1970>date.date.timeIntervalSince1970){
        return YES;
    }
    return NO;
}
-(BOOL)isEarlierThanOrEqualTo:(MCDate *)date{
    if(self.date.timeIntervalSince1970<=date.date.timeIntervalSince1970){
        return YES;
    }
    return NO;
}
-(BOOL)isLaterThanOrEqualTo:(MCDate *)date{
    if(self.date.timeIntervalSince1970>=date.date.timeIntervalSince1970){
        return YES;
    }
    return NO;
}

-(NSInteger)yearsFrom:(MCDate *)date{
    NSDate *earliest = [self.date earlierDate:date.date];
    NSDate *latest = (earliest == self.date) ? date.date : self.date;
    NSInteger multiplier = (earliest == self.date) ? -1 : 1;
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear fromDate:earliest toDate:latest options:0];
    return multiplier*components.year;
}
-(NSInteger)monthsFrom:(MCDate *)date{
    NSDate *earliest = [self.date earlierDate:date.date];
    NSDate *latest = (earliest == self.date) ? date.date : self.date;
    NSInteger multiplier = (earliest == self.date) ? -1 : 1;
    NSDateComponents *components = [self.calendar components:allCalendarUnitFlags fromDate:earliest toDate:latest options:0];
    return multiplier*(components.month + 12*components.year);
}
-(NSInteger)weeksFrom:(MCDate *)date{
    NSDate *earliest = [self.date earlierDate:date.date];
    NSDate *latest = (earliest == self.date) ? date.date : self.date;
    NSInteger multiplier = (earliest == self.date) ? -1 : 1;
    NSDateComponents *components = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:earliest toDate:latest options:0];
    return multiplier*components.weekOfYear;
}
-(NSInteger)daysFrom:(MCDate *)date{
    NSDate *earliest = [self.date earlierDate:date.date];
    NSDate *latest = (earliest == self.date) ? date.date : self.date;
    NSInteger multiplier = (earliest == self.date) ? -1 : 1;
    NSDateComponents *components = [self.calendar components:NSCalendarUnitDay fromDate:earliest toDate:latest options:0];
    return multiplier*components.day;
}
-(double)hoursFrom:(MCDate *)date{
    return [self.date timeIntervalSinceDate:date.date]/SECONDS_IN_HOUR;
}
-(double)minutesFrom:(MCDate *)date{
    return [self.date timeIntervalSinceDate:date.date]/SECONDS_IN_MINUTE;
}
-(double)secondsFrom:(MCDate *)date{
    return [self.date timeIntervalSinceDate:date.date];
}

@end

@implementation MCDate (Formatter)
-(NSString *)formattedDateWithFormat:(NSString *)format{
    return [self formattedDateWithFormat:format timeZone:self.timeZone locale:self.locale];
}
-(NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone{
    return [self formattedDateWithFormat:format timeZone:timeZone locale:self.locale];
}
-(NSString *)formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale{
    return [self formattedDateWithFormat:format timeZone:self.timeZone locale:locale];
}
-(NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self.date];
}

@end
