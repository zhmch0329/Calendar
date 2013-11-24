//
//  ZMCViewController.m
//  Calendar
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import "ZMCViewController.h"

@interface ZMCViewController ()

@property (weak, nonatomic) IBOutlet UIView *calendarView;

- (IBAction)today:(id)sender;

@end

@implementation ZMCViewController

@synthesize calendarView = _calendarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    calendar = [[ZMCCalendarView alloc] initWithDelegate:self];
    calendar.frame = CGRectMake(0, 0, self.calendarView.bounds.size.width, self.calendarView.bounds.size.height);
    [self.calendarView addSubview:calendar];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:20];
    for (NSInteger i = 0; i < 10; i ++) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *component = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
        [component setDay:i * 10];
        NSDate *newDate = [gregorian dateFromComponents:component];
        [array addObject:newDate];
    }
    [calendar makeRecords:array];
    
    [calendar makeRecord:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)today:(id)sender
{
    [calendar showToday];
}

#pragma mark - CalendarViewDelegate
- (void)calendarView:(ZMCCalendarView *)calendarView selectedDate:(NSDate *)date
{
    if ([calendarView isRecord:date]) {
        [calendarView deleteRecord:date];
    }
    else {
        [calendarView makeRecord:date];
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];
    NSLog(@"%@", components);
}

@end
