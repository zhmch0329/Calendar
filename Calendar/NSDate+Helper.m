//
//  NSDate+Helper.m
//  CalendarView
//
//  Created by zhmch0329 on 13-11-8.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

- (NSInteger)year
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [components year];
}

- (NSInteger)month
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    return [components month];
}

- (NSInteger)day
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    return [components day];
}

- (NSDate *)previousMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [components setMonth:[self month] - 1];
    return [gregorian dateFromComponents:components];
}

- (NSDate *)nextMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [components setMonth:[self month] + 1];
    return [gregorian dateFromComponents:components];
}

- (NSDate *)previousYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [components setYear:[self year] - 1];
    return [gregorian dateFromComponents:components];
}

- (NSDate *)nextYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [components setYear:[self year] + 1];
    return [gregorian dateFromComponents:components];
}

- (BOOL)isSameDate:(NSDate *)date
{
    if ([self year]==[date year] && [self month]==[date month] && [self day]==[date day]) {
        return YES;
    }
    return NO;
}

// 一个月有多少天
- (NSInteger)numberDaysInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

// 一个月的第一天是星期几
- (NSInteger)firstWeekdaysInMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    [gregorian setFirstWeekday:2];
    NSDateComponents *component = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [component setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:component];
    return [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:newDate];
}

// 一个月的最后一天是星期几
- (NSInteger)lastWeekdaysInMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [components setMonth:[components month] + 1];
    NSDate *nextMonth = [gregorian dateFromComponents:components];
    return [nextMonth firstWeekdaysInMonth]-1 == 0 ? 7:[nextMonth firstWeekdaysInMonth]-1;
}

// 一个月在日历中显示多少行
- (NSInteger)numberRowsInCalendar
{
    return ([self numberDaysInMonth] - (8 - [self firstWeekdaysInMonth]) - [self lastWeekdaysInMonth])/7 + 2;
}


@end
