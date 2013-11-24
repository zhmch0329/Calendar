//
//  ZMCViewController.h
//  Calendar
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMCCalendarView.h"

@interface ZMCViewController : UIViewController <ZMCCalendarViewDelegate>
{
    ZMCCalendarView *calendar;
}

@end
