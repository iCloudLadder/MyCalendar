//
//  CalendarViewController.h
//  MyCalendar
//
//  Created by syweic on 15/3/6.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectDateProtocol.h"

@interface CalendarViewController : UIViewController

@property(nonatomic, assign) id<SelectDateProtocol> delegate;

@property(nonatomic, copy) void (^selectDateFinishedBlock)(MyCalendarDayModel* dayModel);

@property(nonatomic) NSInteger year,month;

-(instancetype)initWithYear:(NSInteger)year month:(NSInteger)month;


@end
