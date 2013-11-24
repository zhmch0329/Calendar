//
//  ZMCCalendarView.m
//  ZMCCalendarView
//
//  Created by zhmch0329 on 13-11-8.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import "ZMCCalendarView.h"
#import "NSDate+Helper.h"

#define kCalendarViewWidth [[UIScreen mainScreen] applicationFrame].size.width
#define kCalendarViewTopBarHeight 60

#define kCalendarViewDefaultDayWidth 44
#define kCalendarViewDefaultDayHeight 44

@implementation ZMCCalendarView

@synthesize delegate = _delegate;
@synthesize currentMonthLabel = _currentMonthLabel;
@synthesize currentMonth = _currentMonth;

- (id)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES;
        
        self.currentMonth = [NSDate date];
        records = [[NSMutableArray alloc] init];
        
        self.currentMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, kCalendarViewWidth - 68, 40)];
        _currentMonthLabel.backgroundColor = [UIColor whiteColor];
        _currentMonthLabel.font = [UIFont systemFontOfSize:17];
        _currentMonthLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.currentMonthLabel];
    }
    return self;
}

- (id)initWithDelegate:(id<ZMCCalendarViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.currentMonth = [NSDate date];
        records = [[NSMutableArray alloc] init];
        
        // 当view的bounds变化时view的变化方式
        self.contentMode = UIViewContentModeTop;
        // 设置裁剪子视图
        self.clipsToBounds = YES;
        
        // 初始化年份和月份的文字框
        self.currentMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, kCalendarViewWidth - 68, 40)];
        _currentMonthLabel.backgroundColor = [UIColor whiteColor];
        _currentMonthLabel.font = [UIFont systemFontOfSize:17];
        _currentMonthLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.currentMonthLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSelector:)];
        [self addGestureRecognizer:tapGesture];
        
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureSelector:)];
        [self addGestureRecognizer:swipeGestureRight];
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureSelector:)];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeGestureLeft];
        
        UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureSelector:)];
        swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeGestureUp];
        
        UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureSelector:)];
        swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeGestureDown];
        
        self.delegate = delegate;
    }
    return self;
}

- (BOOL)isRecord:(NSDate *)date
{
    for (NSDate *d in records) {
        if ([date isSameDate:d]) {
            return YES;
        }
    }
    return NO;
}

- (void)makeRecord:(NSDate *)date
{
    [records addObject:date];
    [self setNeedsDisplay];
}

- (void)makeRecords:(NSArray *)dates
{
    [records addObjectsFromArray:dates];
    [self setNeedsDisplay];
}

- (void)deleteRecord:(NSDate *)date
{
    for (NSDate *d in records) {
        if ([d isSameDate:date]) {
            [records removeObject:d];
            [self setNeedsDisplay];
            break;
        }
    }
}

- (void)deleteRecords:(NSArray *)dates
{
    for (NSDate *r in records) {
        for (NSDate *d in dates) {
            if ([r isSameDate:d]) {
                [records removeObject:r];
                break;
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // 设置当前的年份和月份
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    monthFormatter.dateFormat = @"yyyy年MM月";
    self.currentMonthLabel.text = [monthFormatter stringFromDate:self.currentMonth];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    // 设置背景颜色
    CGRect rectangle = CGRectMake(0, 0, kCalendarViewWidth, self.bounds.size.height);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    CGFloat arrowX = 20.0f;
    CGFloat arrowY = 20.0f;
    CGFloat arrowHeight = 16.0f;
    // 画左边的三角形
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, arrowX, arrowY);
    CGContextAddLineToPoint(context, arrowX + arrowHeight/2, arrowY - arrowHeight/2);
    CGContextAddLineToPoint(context, arrowX + arrowHeight/2, arrowY + arrowHeight/2);
    CGContextAddLineToPoint(context, arrowX, arrowY);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    // 画右边的三角形
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kCalendarViewWidth - arrowX, arrowY);
    CGContextAddLineToPoint(context, kCalendarViewWidth - (arrowX + arrowHeight/2), arrowY - arrowHeight/2);
    CGContextAddLineToPoint(context, kCalendarViewWidth - (arrowX + arrowHeight/2), arrowY + arrowHeight/2);
    CGContextAddLineToPoint(context, kCalendarViewWidth - arrowX, arrowY);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    // 画出星期的排列，星期日为一个星期的第一天
    NSArray *weekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    for (int i = 0; i < weekdays.count; i ++) {
        NSString *string = [weekdays objectAtIndex:i];
        CGRect weekdaysRect = CGRectMake(i * (kCalendarViewDefaultDayWidth + 2), 40, kCalendarViewDefaultDayWidth + 2, 20);
        [string drawInRect:weekdaysRect withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
//        [string drawInRect:weekdaysRect withAttributes:nil];
    }
    
    NSInteger rows = [self.currentMonth numberRowsInCalendar];
    // 画日期的边线
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.2);
    for (NSInteger i = 0; i <= rows; i ++) {
        CGContextMoveToPoint(context, 0, i * (kCalendarViewDefaultDayHeight + 1) + i + kCalendarViewTopBarHeight + 1);
        CGContextAddLineToPoint(context, kCalendarViewWidth, i * (kCalendarViewDefaultDayHeight + 1) + i + kCalendarViewTopBarHeight + 1);
    }
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.2);
    CGFloat gridHeight = rows * (kCalendarViewDefaultDayHeight + 2) + 1;
    for (NSInteger i = 1; i < 7; i ++) {
        CGContextMoveToPoint(context, i * (kCalendarViewDefaultDayWidth + 1) + i, kCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i * (kCalendarViewDefaultDayWidth + 1) + i, gridHeight + kCalendarViewTopBarHeight);
    }
    CGContextStrokePath(context);
    
    // 画出显示的日期
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.currentMonth];
    [components setMonth:[self.currentMonth month] - 1];
    NSDate *preMonth = [gregorian dateFromComponents:components];
    NSInteger preMonthNumDays = [preMonth numberDaysInMonth];
    for (NSInteger i = 0; i < rows * 7; i ++) {
        NSInteger firstWeekdays = [self.currentMonth firstWeekdaysInMonth];
        NSInteger numberDays = [self.currentMonth numberDaysInMonth];
        NSInteger targetDate = 0;
        CGRect dateRect = CGRectZero;
        CGColorRef dateColor;
        
        dateRect = CGRectMake(i%7*(kCalendarViewDefaultDayWidth + 2), kCalendarViewTopBarHeight + i/7*(kCalendarViewDefaultDayHeight + 2) + 15, kCalendarViewDefaultDayWidth, 20);
        
        // 设置字体颜色
        if (i < firstWeekdays - 1) {
            targetDate = preMonthNumDays - firstWeekdays + i + 2;
            [components setMonth:[self.currentMonth month] - 1];
            dateColor = [UIColor lightGrayColor].CGColor;
        }
        else if (i > numberDays + firstWeekdays - 2) {
            targetDate = i - (numberDays + firstWeekdays - 2);
            [components setMonth:[self.currentMonth month] + 1];
            dateColor = [UIColor lightGrayColor].CGColor;
        }
        else {
            [components setMonth:[self.currentMonth month]];
            targetDate = i - firstWeekdays + 2;
            dateColor = [UIColor blackColor].CGColor;
        }
        // 这个单元格的时间
        [components setDay:targetDate];
        NSDate *date = [gregorian dateFromComponents:components];
        
        // 判断是否被选择
        if ([selectDate isSameDate:date]) {
            dateColor = [UIColor whiteColor].CGColor;
            CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextAddRect(context, CGRectMake(i%7*(kCalendarViewDefaultDayWidth + 2) + 1, kCalendarViewTopBarHeight + i/7*(kCalendarViewDefaultDayHeight + 2) + 2, kCalendarViewDefaultDayWidth, kCalendarViewDefaultDayHeight));
            CGContextFillPath(context);
        }
        
        // 添加今天的标志
        if ([date isSameDate:[NSDate date]]) {
            CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
            CGContextBeginPath(context);
            CGContextAddRect(context, CGRectMake(i%7*(kCalendarViewDefaultDayWidth + 2) + 10, kCalendarViewTopBarHeight + i/7*(kCalendarViewDefaultDayHeight + 2) + 36, kCalendarViewDefaultDayWidth - 20, 6));
            CGContextFillPath(context);
            CGContextAddArc(context, i%7*(kCalendarViewDefaultDayWidth + 2) + kCalendarViewDefaultDayWidth - 10, kCalendarViewTopBarHeight + i/7*(kCalendarViewDefaultDayHeight + 2) + 39, 3, 0, 180, 0);
            CGContextAddArc(context, i%7*(kCalendarViewDefaultDayWidth + 2) + 10, kCalendarViewTopBarHeight + i/7*(kCalendarViewDefaultDayHeight + 2) + 39, 3, 180, 360, 0);
            CGContextFillPath(context);
        }
        
        // 判断是否有记录，并设置红色原点标记
        if ([self isRecord:date]) {
            
            CGContextAddEllipseInRect(context, CGRectMake(i%7*(kCalendarViewDefaultDayWidth + 2) + 5, kCalendarViewTopBarHeight + i/7*(kCalendarViewDefaultDayHeight + 2) + 5, 4, 4));
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextFillPath(context);
        }
        
        NSString *dateString = [NSString stringWithFormat:@"%d", targetDate];
        CGContextSetFillColorWithColor(context, dateColor);
        [dateString drawInRect:dateRect withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        
    }
}

- (void)tapGestureSelector:(UITapGestureRecognizer *)gesture
{
    CGRect dateRect = CGRectMake(0, kCalendarViewTopBarHeight, kCalendarViewWidth, [self.currentMonth numberRowsInCalendar] * (kCalendarViewDefaultDayHeight + 2) + 1);
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchX = touchPoint.x;
    CGFloat touchY = touchPoint.y;
    if (CGRectContainsPoint(dateRect, touchPoint)) {
        NSInteger column = floorf(touchX/(kCalendarViewDefaultDayWidth + 2));
        NSInteger row = floorf((touchY - kCalendarViewTopBarHeight)/(kCalendarViewDefaultDayHeight + 2));
        NSLog(@"%d, %d", column, row);
        NSInteger date = column + 1 + row*7;
        date -= [self.currentMonth firstWeekdaysInMonth] - 1;
        [self selectDate:date];
        
        NSLog(@"%@", selectDate);
        if ([_delegate respondsToSelector:@selector(calendarView:selectedDate:)]) {
            [_delegate calendarView:self selectedDate:selectDate];
        }
        
        return;
    }
    CGRect arrowLeftRect = CGRectMake(18, 10, 12, 20);
    CGRect arrowRightRect = CGRectMake(kCalendarViewWidth - 30, 10, 12, 20);
    if (CGRectContainsPoint(arrowLeftRect, touchPoint)) {
        [self showPreviousMonth];
        return;
    }
    if (CGRectContainsPoint(arrowRightRect, touchPoint)) {
        [self showNextMonth];
    }
}

- (void)swipeGestureSelector:(UISwipeGestureRecognizer *)gesture
{
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionRight:
        {
            [self showPreviousMonth];
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft:
        {
            [self showNextMonth];
            break;
        }
        case UISwipeGestureRecognizerDirectionDown:
        {
            [self showPreviousYear];
            break;
        }
        case UISwipeGestureRecognizerDirectionUp:
        {
            [self showNextYear];
            break;
        }
            
        default:
            break;
    }
}

- (void)selectDate:(NSInteger)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self.currentMonth];
    [components setDay:date];
    selectDate = [gregorian dateFromComponents:components];
    NSInteger selectDateYear = [selectDate year];
    NSInteger selectDateMonth = [selectDate month];
    NSInteger currentMonthYear = [self.currentMonth year];
    NSInteger currentMonthMonth = [self.currentMonth month];
    if (selectDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        [self setNeedsDisplay];
    }
}

- (void)showPreviousMonth
{
    if (isAnimating) {
        return;
    }
    isAnimating = YES;
    UIImage *currentState = [self drawCurrentState];
    CGRect currentRect = CGRectMake(0, 0, kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
    self.currentMonth = [self.currentMonth previousMonth];
    [self setNeedsDisplay];
    UIImage *newState = [self drawCurrentState];
    CGRect newRect = CGRectMake(-kCalendarViewWidth, 0, kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
    
    UIImageView *currentStateView = [[UIImageView alloc] initWithImage:currentState];
    currentStateView.frame = currentRect;
    UIImageView *newStateView = [[UIImageView alloc] initWithImage:newState];
    newStateView.frame = newRect;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kCalendarViewTopBarHeight, kCalendarViewWidth, (kCalendarViewDefaultDayHeight + 2) * 6)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:currentStateView];
    [view addSubview:newStateView];
    [self addSubview:view];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        currentStateView.frame = CGRectMake(kCalendarViewWidth, 0, kCalendarViewWidth, currentRect.size.height);
        newStateView.frame = CGRectMake(0, 0, kCalendarViewWidth, newRect.size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        isAnimating = NO;
    }];
}

- (void)showNextMonth
{
    if (isAnimating) {
        return;
    }
    isAnimating = YES;
    UIImage *currentState = [self drawCurrentState];
    CGRect currentRect = CGRectMake(0, 0, kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
    self.currentMonth = [self.currentMonth nextMonth];
    [self setNeedsDisplay];
    UIImage *newState = [self drawCurrentState];
    CGRect newRect = CGRectMake(kCalendarViewWidth, 0, kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
    
    UIImageView *currentStateView = [[UIImageView alloc] initWithImage:currentState];
    currentStateView.frame = currentRect;
    UIImageView *newStateView = [[UIImageView alloc] initWithImage:newState];
    newStateView.frame = newRect;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kCalendarViewTopBarHeight, kCalendarViewWidth, (kCalendarViewDefaultDayHeight + 2) * 6)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:currentStateView];
    [view addSubview:newStateView];
    [self addSubview:view];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        currentStateView.frame = CGRectMake(-kCalendarViewWidth, 0, kCalendarViewWidth, currentRect.size.height);
        newStateView.frame = CGRectMake(0, 0, kCalendarViewWidth, newRect.size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        isAnimating = NO;
    }];
}

- (void)showPreviousYear
{
    if (isAnimating) {
        return;
    }
    isAnimating = YES;
    UIImage *currentState = [self drawCurrentState];
    CGRect currentRect = CGRectMake(0, 0, kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
    self.currentMonth = [self.currentMonth previousYear];
    [self setNeedsDisplay];
    UIImage *newState = [self drawCurrentState];
    CGRect newRect = CGRectMake(0, -(6 * (kCalendarViewDefaultDayHeight + 2) + 1), kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
    
    UIImageView *currentStateView = [[UIImageView alloc] initWithImage:currentState];
    currentStateView.frame = currentRect;
    UIImageView *newStateView = [[UIImageView alloc] initWithImage:newState];
    newStateView.frame = newRect;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kCalendarViewTopBarHeight, kCalendarViewWidth, (kCalendarViewDefaultDayHeight + 2) * 6)];
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    [view addSubview:currentStateView];
    [view addSubview:newStateView];
    [self addSubview:view];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        currentStateView.frame = CGRectMake(0, currentRect.size.height, kCalendarViewWidth, currentRect.size.height);
        newStateView.frame = CGRectMake(0, 0, kCalendarViewWidth, newRect.size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        isAnimating = NO;
    }];
}

- (void)showNextYear
{
    if (isAnimating) {
        return;
    }
    isAnimating = YES;
    UIImage *currentState = [self drawCurrentState];
    CGRect currentRect = CGRectMake(0, 0, kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
    self.currentMonth = [self.currentMonth nextYear];
    [self setNeedsDisplay];
    UIImage *newState = [self drawCurrentState];
    CGRect newRect = CGRectMake(0, 6 * (kCalendarViewDefaultDayHeight + 2) + 1, kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
    
    UIImageView *currentStateView = [[UIImageView alloc] initWithImage:currentState];
    currentStateView.frame = currentRect;
    UIImageView *newStateView = [[UIImageView alloc] initWithImage:newState];
    newStateView.frame = newRect;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kCalendarViewTopBarHeight, kCalendarViewWidth, (kCalendarViewDefaultDayHeight + 2) * 6)];
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    [view addSubview:currentStateView];
    [view addSubview:newStateView];
    [self addSubview:view];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        currentStateView.frame = CGRectMake(0, -currentRect.size.height, kCalendarViewWidth, currentRect.size.height);
        newStateView.frame = CGRectMake(0, 0, kCalendarViewWidth, newRect.size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        isAnimating = NO;
    }];
}

-(UIImage *)drawCurrentState {
    float targetHeight = kCalendarViewTopBarHeight + 6 * (kCalendarViewDefaultDayHeight+2)+1;
    
    UIGraphicsBeginImageContext(CGSizeMake(kCalendarViewWidth, targetHeight-kCalendarViewTopBarHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, -kCalendarViewTopBarHeight);
    [self.layer renderInContext:context];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)showToday
{
    if (isAnimating) {
        return;
    }
    NSDate *newDate = [NSDate date];
    if ([self.currentMonth year] != [newDate year] || [self.currentMonth month] != [newDate month]) {
        isAnimating = YES;
        UIImage *currentState = [self drawCurrentState];
        CGRect currentRect = CGRectMake(0, kCalendarViewTopBarHeight, kCalendarViewWidth, 6 * (kCalendarViewDefaultDayHeight + 2) + 1);
        self.currentMonth = [NSDate date];
        [self setNeedsDisplay];
        UIImageView *currentStateView = [[UIImageView alloc] initWithImage:currentState];
        currentStateView.frame = currentRect;
        [self addSubview:currentStateView];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            currentStateView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            currentStateView.alpha = 0;
        } completion:^(BOOL finished) {
            isAnimating = NO;
            [currentStateView removeFromSuperview];
        }];
    }
    else {
        self.currentMonth = newDate;
        [self selectDate:[newDate day]];
    }
}

@end

































