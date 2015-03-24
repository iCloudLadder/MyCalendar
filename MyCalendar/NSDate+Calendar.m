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

#define kShareCalendar [NSDate shareCalendar]

+(NSCalendar*)shareCalendar
{
    static NSCalendar *myCalendar = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        myCalendar = kGregorianCalendar;
    });
    return myCalendar;
}

/*
 * 获取 日期 所在月份的 日历数据
 */

-(NSMutableArray*)getDayModelsInCurrentMonth
{
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
    NSDateComponents *components = [self getDateComponestsWith:[self getYMDWCalendarUnit]];// [kShareCalendar components:[self getYMDWCalendarUnit] fromDate:self];
    // 当月 日历 数据
    for (NSInteger day = 1; day <= numberOfDays; day++) {
        // 设置 day 后 新的 日历结构
        NSDateComponents *newComponents = [self getNewComponentsAfterSetDayWith:components day:day];
        [dayModels addObject:[self getDayModelWith:newComponents day:day dayOfMonth:DayOfMonthCurrentMonth]];
    }
    
    NSUInteger lastDayInWeekDay = [self getLastDayIsWeekDayInCurrentMonthWith:numberOfDays];
    // 下个月 在 当月中的 天 的日历周期
    [dayModels addObjectsFromArray:[self creatDayModelsInNextMonthWith:lastDayInWeekDay]];
}

// 从新设置 天 后，获取新的components
-(NSDateComponents*)getNewComponentsAfterSetDayWith:(NSDateComponents*)com day:(NSUInteger)day
{
    [com setDay:day];
    NSDate *newDate = [kShareCalendar dateFromComponents:com];
    return [kShareCalendar components:[self getYMDWCalendarUnit] fromDate:newDate];
}


#pragma mark - 本月上个月在 本月的日期数据

-(NSMutableArray*)creatDayModelsInPerMonthWith:(NSUInteger)daysOfPerMonthInCureentMonth
{
    NSDate *perMonthDay = [self getDateOfOtherMonthFrom:-1];
    // 上个月天数
    NSUInteger daysPerMonth = [perMonthDay getNumberOfDaysInCurrentMonth];
    
    NSMutableArray *dayModels = [[NSMutableArray alloc] init];
    NSDateComponents *components = [perMonthDay getDateComponestsWith:[perMonthDay getYMDWCalendarUnit]];// [kShareCalendar components:[self getYMDWCalendarUnit] fromDate:perMonthDay];
    // 上个月 在 当前月的天 的日历数据
    for (NSInteger day = daysPerMonth - daysOfPerMonthInCureentMonth + 1; day <= daysPerMonth; ++day) {
        NSDateComponents *newComponents = [self getNewComponentsAfterSetDayWith:components day:day];
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
    NSDateComponents *components =  [perMonthDay getDateComponestsWith:[perMonthDay getYMDWCalendarUnit]];// [kShareCalendar components:[self getYMDWCalendarUnit] fromDate:perMonthDay];
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
   return [kShareCalendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark - 获取 day model
-(MyCalendarDayModel*)getDayModelWith:(NSDateComponents*)components day:(NSUInteger)day dayOfMonth:(DayOfMonth)dayOfMonth
{
    MyCalendarDayModel *dayModel = [[MyCalendarDayModel alloc] init];
    dayModel.date = [kShareCalendar dateFromComponents:components];
    dayModel.year = [NSString stringWithFormat:@"%ld",(long)components.year];
    dayModel.month = [NSString stringWithFormat:@"%ld",(long)components.month];
    dayModel.day = [NSString stringWithFormat:@"%ld",(long)components.day];
    dayModel.weekDay = components.weekday;// [self getDateWeekDayWith:components];

    dayModel.holiday = [MyCalendarObject getGregorianHolidayWith:[components copy]];
    dayModel.dayOfMonth = dayOfMonth;
    
    [self getChineseCalendarInfoWith:components dayModel:dayModel];
    
    return dayModel;
}

#pragma mark - 获取 农历 日历信息
-(void)getChineseCalendarInfoWith:(NSDateComponents*)gregorianComponents dayModel:(MyCalendarDayModel*)dayModel
{
    // 获取 阳历日期
    NSDate *date = [kShareCalendar dateFromComponents:gregorianComponents];
    // 计算 农历 日期
    NSDateComponents *chineseComponents = [kChineseCalendar components:[self getYMDWCalendarUnit] fromDate:date];
    // NSLog(@"year = %@",chineseComponents);
    // 获得 汉字 日期
    NSMutableDictionary *chineseCalendar = [NSMutableDictionary dictionaryWithDictionary:[MyCalendarObject getChineseCalendarWith:chineseComponents]];
    // 计算 农历 年份
    NSInteger chineseYear = gregorianComponents.month < chineseComponents.month?gregorianComponents.year-1:gregorianComponents.year;
    
    dayModel.chineseYearNumber = [NSString stringWithFormat:@"%ld",(long)chineseYear];
    dayModel.chineseMonthNumber = [NSString stringWithFormat:@"%ld",(long)chineseComponents.month];
    dayModel.chineseDayNumber = [NSString stringWithFormat:@"%ld",(long)chineseComponents.day];
    dayModel.chineseMonth = chineseCalendar[@"month"];
    dayModel.chineseDay = chineseCalendar[@"day"];
    dayModel.chineseHoliday = chineseCalendar[@"holiday"];
    dayModel.chineseLeap = chineseComponents.isLeapMonth?@"闰":@"";
    
}


#pragma mark - handle 日期转换

// 根据日期获取 NSDateComponents
-(NSDateComponents*)getDateComponestsWith:(NSCalendarUnit)unit
{
    return [kShareCalendar components:unit fromDate:self];
}


// 年 月 日 周 月份第几周
-(NSCalendarUnit)getYMDWCalendarUnit
{
    return NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth;
}


// self 所在月份的天数
-(NSUInteger)getNumberOfDaysInCurrentMonth
{
    NSRange range = [kShareCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}


/*
 * 当月 第一天
 */
-(NSDate*)getFirstDayInCurrentMonth
{
    NSDate *startDate;
    [kShareCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:nil forDate:self];
    return startDate;
}

/*
 * 当月 第一天 是周几
 */

-(NSInteger)getFristDayIsWeekDayInCurrentMonth
{
    NSInteger weekDay = [kShareCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
    return weekDay;
}

/*
 * 当月 最后一天 是周几
 */

-(NSUInteger)getLastDayIsWeekDayInCurrentMonthWith:(NSUInteger)daysInCurrentMonth
{
    // NSCalendarUnit YMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ;
    NSDateComponents *components = [self getDateComponestsWith:[self getYMDWCalendarUnit]];// [kShareCalendar components:[self getYMDWCalendarUnit] fromDate:self];
    components.day = daysInCurrentMonth;
    NSDate *date = [kShareCalendar dateFromComponents:components];
    return [kShareCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
}

/*
 * self 是 周几
 */

-(NSInteger)getDateWeekDayWith:(NSDateComponents*)components
{
    NSDate *date = [kShareCalendar dateFromComponents:components];
    return [kShareCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
}



// 获取 self 日期的 字符串
-(NSString*)getStringOfToday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    return [formatter stringFromDate:self];
}


// 根据年，月 返回当月与今天相同的日期
+(NSDate*)getDateOfFirstDayWith:(NSInteger)year month:(NSInteger)month
{
    NSDate *nowDate = [NSDate date];
    NSInteger numMonths = [nowDate getMonthsWith:year month:month];
    return [nowDate getDateOfOtherMonthFrom:numMonths];
}

// 根据年，月 返回与日期相差的月份
-(NSInteger)getMonthsWith:(NSInteger)year month:(NSInteger)month
{
    NSDateComponents *nowComponents = [self getDateComponestsWith:[self getYMDWCalendarUnit]]; // [kShareCalendar components:[self getYMDWCalendarUnit] fromDate:self];
    return (year - nowComponents.year)*12 + month - nowComponents.month;
}



// 比较日期是否是今天
-(BOOL)isToday{
    return [self isTheSameDay:[NSDate date]];
}

// 比较两个日期是否为同一天
-(BOOL)isTheSameDay:(NSDate*)date
{
    return [[self getEraYearMonthDayDate] isEqualToDate:[date getEraYearMonthDayDate]];
}

-(NSDate*)getEraYearMonthDayDate
{
    NSDateComponents *components = [kShareCalendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    return [kShareCalendar dateFromComponents:components];
}









@end
