//
//  NSDate+Calendar.h
//  MyCalendar
//
//  Created by syweic on 14/11/24.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCalendarDayModel.h"

@interface NSDate (Calendar)


/*
 * 获取 日期 所在月份的 日历数据
 */

-(NSMutableArray*)getDayModelsInCurrentMonth;

// 年 月 日 日历单元
-(NSCalendarUnit)getYMDWCalendarUnit;

// 根据日期获取 NSDateComponents
-(NSDateComponents*)getDateComponestsWith:(NSCalendarUnit)unit;

// self 所在月份的天数
-(NSUInteger)getNumberOfDaysInCurrentMonth;

// 根据年，月 返回与日期相差的月份
-(NSInteger)getMonthsWith:(NSInteger)year month:(NSInteger)month;

// self相差month个月的日期
-(NSDate*)getDateOfOtherMonthFrom:(NSInteger)month;

// 获取 self 日期的 字符串
-(NSString*)getStringOfToday;

// 根据年，月 返回当月与今天相同的日期
+(NSDate*)getDateOfFirstDayWith:(NSInteger)year month:(NSInteger)month;

// 比较两个人日期是否为同一天
-(BOOL)isTheSameDay:(NSDate*)date;

// 比较日期是否是今天
-(BOOL)isToday;

@end
