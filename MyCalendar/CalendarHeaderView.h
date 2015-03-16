//
//  CalendarHeaderView.h
//  MyCalendar
//
//  Created by syweic on 15/3/9.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowYearAndMonthView.h"

@interface CalendarHeaderView : UIView

@property (nonatomic, strong) NSDate *baseDate;

@property (nonatomic, copy) SYPlusOrMinMonthBlock plusOrMinusMonthBlock;

@property (nonatomic, strong) NSString *perButtonImageName;
@property (nonatomic, strong) NSString *nextButtonImageName;

@end
