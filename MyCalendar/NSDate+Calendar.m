//
//  NSDate+Calendar.m
//  MyCalendar
//
//  Created by syweic on 14/11/24.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "NSDate+Calendar.h"
#import "MyCalendarObject.h"

typedef NSCalendar* (^CalendarBlock)(NSString *calendarIdentifier);

#define kCurrentCalendar [NSCalendar currentCalendar]
#define kCalendar(calendarIdentifier) [NSCalendar calendarWithIdentifier:calendarIdentifier]
// 公历
#define kGregorianCalendar kCalendar(NSCalendarIdentifierGregorian)
// 农历
#define kChineseCalendar kCalendar(NSCalendarIdentifierChinese)




@implementation NSDate (Calendar)

static NSCalendar *myCalendar = nil;


/*
 * 获取 日期 所在月份的 日历数据
 */

-(NSMutableArray*)getDayModelsInCurrentMonth
{
    // 获取 公历
    if (!myCalendar) {
        myCalendar = kGregorianCalendar;
    }
    
    NSMutableArray *dayModels = [[NSMutableArray alloc] init];
    
    // 创建 上个月 在当前月的 天 的 日历数据
    [dayModels addObjectsFromArray:[self creatDayModelsInPerMonthWith:[[self getFirstDayInCurrentMonth] getFristDayIsWeekDayInCurrentMonth]-1]];
    // 创建 当月 和(下个月在当前月的 天) 日历数据
    [self creatDayModelsInCurrentMonthAndNextMonthWith:dayModels];
    
    return dayModels;
}

/*
 * 创建当月 日历数据
 */
-(void)creatDayModelsInCurrentMonthAndNextMonthWith:(NSMutableArray*)dayModels
{
    // 天数
    NSInteger numberOfDays = [self getNumberOfDaysInCurrentMonth];
    NSDateComponents *components = [myCalendar components:[self getYMDWCalendarUnit] fromDate:self];
    // 当月 日历 数据
    for (NSInteger day = 1; day <= numberOfDays; day++) {
        // 设置 day 后 新的 日历结构
        NSDateComponents *newComponents = [self getNewComponentsAfterSetDayWith:components with:day];
        [dayModels addObject:[self getDayModelWith:newComponents day:day dayOfMonth:DayOfMonthCurrentMonth]];
    }
    
    NSUInteger lastDayInWeekDay = [self getLastDayIsWeekDayInCurrentMonthWith:numberOfDays];
    // 下个月 在 当月中的 天 的日历周期
    [dayModels addObjectsFromArray:[self creatDayModelsInNextMonthWith:lastDayInWeekDay]];
}

// 从新设置 天 后，获取新的components
-(NSDateComponents*)getNewComponentsAfterSetDayWith:(NSDateComponents*)com with:(NSUInteger)day
{
    [com setDay:day];
    NSDate *newDate = [myCalendar dateFromComponents:com];
    return [myCalendar components:[self getYMDWCalendarUnit] fromDate:newDate];
}


#pragma mark - 本月上个月在 本月的日期数据

-(NSMutableArray*)creatDayModelsInPerMonthWith:(NSUInteger)daysOfPerMonthInCureentMonth
{
    NSDate *perMonthDay = [self getDateOfOtherMonthFrom:-1];
    // 上个月天数
    NSUInteger daysPerMonth = [perMonthDay getNumberOfDaysInCurrentMonth];
    
    NSMutableArray *dayModels = [[NSMutableArray alloc] init];
    NSDateComponents *components = [myCalendar components:[self getYMDWCalendarUnit] fromDate:perMonthDay];
    // 上个月 在 当前月的天 的日历数据
    for (NSInteger day = daysPerMonth - daysOfPerMonthInCureentMonth + 1; day <= daysPerMonth; ++day) {
        NSDateComponents *newComponents = [self getNewComponentsAfterSetDayWith:components with:day];
        [dayModels addObject:[self getDayModelWith:newComponents day:day dayOfMonth:DayOfMonthPerMonth]];
    }
    return dayModels;

}

#pragma mark - 本月下个月在 本月内的日期数据
-(NSMutableArray*)creatDayModelsInNextMonthWith:(NSUInteger)weekDayOfLastDay
{
    // self 对应的 上月的 日期
    NSDate *perMonthDay = [self getDateOfOtherMonthFrom:1];
    
    NSMutableArray *dayModels = [[NSMutableArray alloc] init];
    // 当前 perMonthDay 所在月份的 日历结构
    NSDateComponents *components = [myCalendar components:[self getYMDWCalendarUnit] fromDate:perMonthDay];
    //
    for (NSInteger day = 1; day <= 7 - weekDayOfLastDay; ++day) {
        [components setDay:day];
        [dayModels addObject:[self getDayModelWith:components day:day dayOfMonth:DayOfMonthPerMonth]];
    }
    
    return dayModels;
}



#pragma mark - 计算 月份差 日期

-(NSDate*)getDateOfOtherMonthFrom:(NSInteger)month
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = month;
    // 返回 与 self 相差 month个月的日期
    return [self getDateOfOtherMonthWith:components];
}

-(NSDate*)getDateOfOtherMonthWith:(NSDateComponents*)components
{
    // 计算  toDate 相差 components（年月日时分秒，当前只用到 月） 的时间 的 日期
   return [myCalendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark - 获取 day model
-(MyCalendarDayModel*)getDayModelWith:(NSDateComponents*)components day:(NSUInteger)day dayOfMonth:(DayOfMonth)dayOfMonth
{
    MyCalendarDayModel *dayModel = [[MyCalendarDayModel alloc] init];
    dayModel.year = [NSString stringWithFormat:@"%ld",components.year];
    dayModel.month = [NSString stringWithFormat:@"%ld",components.month];
    dayModel.day = [NSString stringWithFormat:@"%ld",components.day];
    dayModel.weekDay = [self getDateWeekDayWith:components];

    dayModel.holiday = [MyCalendarObject getGregorianHolidayWith:[components copy]];
    dayModel.dayOfMonth = dayOfMonth;
    
    [self getChineseCalendarInfoWith:components dayModel:dayModel];
    
    return dayModel;
}

#pragma mark - 获取 农历 日历信息
-(void)getChineseCalendarInfoWith:(NSDateComponents*)gregorianComponents dayModel:(MyCalendarDayModel*)dayModel
{
    // 获取 阳历日期
    NSDate *date = [kGregorianCalendar dateFromComponents:gregorianComponents];
    // 计算 农历 日期
    NSDateComponents *chineseComponents = [kChineseCalendar components:[self getYMDWCalendarUnit] fromDate:date];
    // NSLog(@"year = %@",chineseComponents);
    // 获得 汉字 日期
    NSMutableDictionary *chineseCalendar = [NSMutableDictionary dictionaryWithDictionary:[MyCalendarObject getChineseCalendarWith:chineseComponents]];
    // 计算 农历 年份
    NSInteger chineseYear = gregorianComponents.month < chineseComponents.month?gregorianComponents.year-1:gregorianComponents.year;
    
    dayModel.chineseYearNumber = [NSString stringWithFormat:@"%ld",chineseYear];
    dayModel.chineseMonthNumber = [NSString stringWithFormat:@"%ld",chineseComponents.month];
    dayModel.chineseDayNumber = [NSString stringWithFormat:@"%ld",chineseComponents.day];
    dayModel.chineseMonth = chineseCalendar[@"month"];
    dayModel.chineseDay = chineseCalendar[@"day"];
    dayModel.chineseHoliday = chineseCalendar[@"holiday"];
    dayModel.chineseLeap = chineseComponents.isLeapMonth?@"闰":@"";
    
}


#pragma mark - handle 日期转换


// 年 月 日 周 月份第几周
-(NSCalendarUnit)getYMDWCalendarUnit
{
    return NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth;
}


// self 所在月份的天数
-(NSUInteger)getNumberOfDaysInCurrentMonth
{
    NSRange range = [myCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}


/*
 * 当月 第一天
 */
-(NSDate*)getFirstDayInCurrentMonth
{
    NSDate *startDate;
    [myCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:nil forDate:self];
    return startDate;
}

/*
 * 当月 第一天 是周几
 */

-(NSInteger)getFristDayIsWeekDayInCurrentMonth
{
    NSInteger weekDay = [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
    return weekDay;
}

/*
 * 当月 最后一天 是周几
 */

-(NSUInteger)getLastDayIsWeekDayInCurrentMonthWith:(NSUInteger)daysInCurrentMonth
{
    NSCalendarUnit YMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ;
    NSDateComponents *components = [myCalendar components:YMD fromDate:self];
    components.day = daysInCurrentMonth;
    NSDate *date = [myCalendar dateFromComponents:components];
    return [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
}

/*
 * self 是 周几
 */

-(NSInteger)getDateWeekDayWith:(NSDateComponents*)components
{
    NSDate *date = [myCalendar dateFromComponents:components];
    return [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
}



// 获取 当天的 日期的 字符串
-(NSString*)getStringOfToday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:self];
}
















@end
