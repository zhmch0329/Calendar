//
//  ZMCCalendarView.h
//  ZMCCalendarView
//
//  Created by zhmch0329 on 13-11-8.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZMCCalendarViewDelegate;
@interface ZMCCalendarView : UIView
{
    NSDate *selectDate;
    BOOL isAnimating;
    NSMutableArray *records;
}

@property (strong, nonatomic) id<ZMCCalendarViewDelegate> delegate;
@property (strong, nonatomic) UILabel *currentMonthLabel;
@property (strong, nonatomic) NSDate *currentMonth;

- (id)initWithDelegate:(id<ZMCCalendarViewDelegate>)delegate;
- (void)showToday;

- (BOOL)isRecord:(NSDate *)date;
- (void)makeRecord:(NSDate *)date;
- (void)makeRecords:(NSArray *)dates;
- (void)deleteRecord:(NSDate *)date;
- (void)deleteRecords:(NSArray *)dates;

@end

@protocol ZMCCalendarViewDelegate <NSObject>

@optional
- (void)calendarView:(ZMCCalendarView *)calendarView selectedDate:(NSDate *)date;

@end