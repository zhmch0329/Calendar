//
//  NSDate+Helper.h
//  CalendarView
//
//  Created by zhmch0329 on 13-11-8.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;

- (NSInteger)numberDaysInMonth;
- (NSInteger)firstWeekdaysInMonth;
- (NSInteger)lastWeekdaysInMonth;
- (NSInteger)numberRowsInCalendar;

- (NSDate *)previousMonth;
- (NSDate *)nextMonth;
- (NSDate *)previousYear;
- (NSDate *)nextYear;

- (BOOL)isSameDate:(NSDate *)date;

@end
