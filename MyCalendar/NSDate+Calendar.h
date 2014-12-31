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

// self 所在月份的天数
-(NSUInteger)getNumberOfDaysInCurrentMonth;

// 获取 当天的 日期的 字符串
-(NSString*)getStringOfToday;


@end
