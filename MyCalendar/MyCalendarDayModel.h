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

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSString *year,*month,*day,*holiday;

@property (nonatomic, assign) NSInteger weekDay;
// 数字
@property (nonatomic, strong) NSString *chineseYearNumber,*chineseMonthNumber,*chineseDayNumber;

@property (nonatomic, strong) NSString *chineseLeap,*chineseHoliday;
// 阴历 汉文 
@property (nonatomic, strong) NSString *chineseMonth,*chineseDay;

// 在那个月
@property (nonatomic, assign) DayOfMonth dayOfMonth;


@end
