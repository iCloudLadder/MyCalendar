//
//  MyCalendarDayModel.h
//  MyCalendar
//
//  Created by syweic on 14/11/24.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DayOfMonth) {
    DayOfMonthPerMonth,
    DayOfMonthCurrentMonth,
    DayOfMonthNextCurrentMonth
};

@interface MyCalendarDayModel : NSObject

@property (nonatomic, strong) NSString *year,*month,*day,*holiday;

@property (nonatomic, assign) NSInteger weekDay;

@property (nonatomic, strong) NSString *chineseYearNumber,*chineseMonthNumber,*chineseDayNumber;

@property (nonatomic, strong) NSString *chineseLeap,*chineseHoliday;

@property (nonatomic, strong) NSString *chineseMonth,*chineseDay;


@property (nonatomic, assign) DayOfMonth dayOfMonth;


@end
