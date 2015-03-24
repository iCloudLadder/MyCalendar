//
//  CalendarCollectinViewCell.m
//  MyCalendar
//
//  Created by syweic on 14/11/24.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "CalendarCollectinViewCell.h"

#define kSubViewsSpace 2.0

#define kChineseDayLabelHeight 20.0
#define kDayLableLength 30.0

#define kDayLableFontOfSize 15
#define kChineseDayLableFontOfSize 10

#define kSubViewsInitBackgroundColor [UIColor clearColor]

#define kDayLableTextColor [UIColor blackColor]
#define kDayLableHighlightTextColor [UIColor whiteColor]

#define kChineseDayLableTextColor [UIColor grayColor]
#define kChineseDayLableMonthTextCorlor [UIColor cyanColor]

#define kPerOrNextMonthDayTextColor [UIColor lightGrayColor]
#define kHolidayTextColor [UIColor orangeColor]
#define kWeekEndTextColor [UIColor redColor]

@interface CalendarCollectinViewCell ()

@property (nonatomic, assign) CGFloat sigleHeight;

@end

@implementation CalendarCollectinViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
        // 耗时间
//        [self addObserver:self
//               forKeyPath:@"selected"
//                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                  context:nil];
        [self addBottomLineLayer];
    }
    return self;
}


-(void)setSelfBackgroundView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor orangeColor];
    backgroundView.layer.cornerRadius = CGRectGetWidth(backgroundView.frame)/2;
    self.selectedBackgroundView = backgroundView;
}

#pragma mark - creatSubviews
-(void)creatSubViews
{
    CGFloat length = CGRectGetWidth(self.bounds);
    [self creatDayLableWith:length];
    [self creatChineseDayLabelWith:length];
}

#pragma mark - 公历 日期标签
-(void)creatDayLableWith:(CGFloat)selfWidth
{
    CGRect frame = CGRectMake(0, 0, kDayLableLength, kDayLableLength);
    _dayLabel = [[UILabel alloc] initWithFrame:frame];
    _dayLabel.center = CGPointMake(selfWidth/2, kDayLableLength/2+kSubViewsSpace);
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.layer.cornerRadius = kDayLableLength/2;
    _dayLabel.layer.masksToBounds = YES;
    _dayLabel.font = [UIFont systemFontOfSize:kDayLableFontOfSize];
    _dayLabel.backgroundColor =  kSubViewsInitBackgroundColor;
    _dayLabel.highlightedTextColor = kDayLableHighlightTextColor;
    [self.contentView addSubview:_dayLabel];
}

#pragma mark - 农历 日期标签

-(void)creatChineseDayLabelWith:(CGFloat)selfWidth
{
    // 事先计算好的 最多显示两行，运行中计算高度太耗时间
    CGFloat chineseDayLabelHeight = 24.0;
    CGRect frame = CGRectMake(kSubViewsSpace/2, CGRectGetMaxY(_dayLabel.frame), selfWidth-kSubViewsSpace, chineseDayLabelHeight);
    
    _chineseDayLabel = [[UILabel alloc] initWithFrame:frame];
    _chineseDayLabel.textAlignment = NSTextAlignmentCenter;
    _chineseDayLabel.backgroundColor = kSubViewsInitBackgroundColor;
    _chineseDayLabel.textColor = kChineseDayLableTextColor;
    _chineseDayLabel.font = [UIFont systemFontOfSize:kChineseDayLableFontOfSize];
    _chineseDayLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _chineseDayLabel.numberOfLines = 0;
    [self.contentView addSubview:_chineseDayLabel];

//    // 设置显示最多两行
//    if (_sigleHeight == 0.0) {
//        _sigleHeight = [self getTextSizeWith:@"*"];
//    }
//    frame.size.height = _sigleHeight*2;
//    _chineseDayLabel.frame = frame;
    
}


#pragma mark - set someData

-(void)setDayModel:(MyCalendarDayModel *)dayModel
{
    if (_dayModel) {
        _dayModel = nil;
    }
    _dayModel = dayModel;
    _dayLabel.text = dayModel.day;
    // 非当前月日期，不可点击
    self.userInteractionEnabled = dayModel.dayOfMonth == DayOfMonthCurrentMonth;
    // 设置文本色
    [self setLabelTextColorWith:dayModel];
    [self setChineseDayLabelTextWith:dayModel];
    
    // 如果日期 是今天
    _dayLabel.backgroundColor = [self dateIsTodayWith:dayModel]?[UIColor greenColor]:[UIColor clearColor];
}


-(void)setChineseDayLabelTextWith:(MyCalendarDayModel*)dayModel
{
    NSString *text;
    if ([dayModel.holiday length] && [dayModel.chineseHoliday length]) {
        text = [NSString stringWithFormat:@"%@ %@",dayModel.chineseHoliday,dayModel.holiday];
    }else if ([dayModel.holiday length]) {
        text = dayModel.holiday;
    }else if ([dayModel.chineseHoliday length]) {
        text = dayModel.chineseHoliday;
    }else if ([dayModel.chineseDay isEqualToString:@"初一"]) {
        text = dayModel.chineseMonth;
    }else{
        text = dayModel.chineseDay;
    }
    _chineseDayLabel.text = text;
    // [self resetChineseDayLabelTextWith:text];
}


// 设置 标签 文本的颜色
-(void)setLabelTextColorWith:(MyCalendarDayModel*)dayModel
{
    UIColor *chineseDayLabelTextColor;
    if (([dayModel.holiday length] || [dayModel.chineseHoliday length]) && (dayModel.dayOfMonth == DayOfMonthCurrentMonth)) {
        chineseDayLabelTextColor = kHolidayTextColor;
    }else if ([dayModel.chineseDay isEqualToString:@"初一"]) {
        chineseDayLabelTextColor = kChineseDayLableMonthTextCorlor;
    }else{
        chineseDayLabelTextColor = kChineseDayLableTextColor;
    }
    _chineseDayLabel.textColor = chineseDayLabelTextColor;


    // 本月中显示的 前一个月 或 后一个月 的日期 颜色
    if (dayModel.dayOfMonth != DayOfMonthCurrentMonth) {
        _dayLabel.textColor = _chineseDayLabel.textColor =  kPerOrNextMonthDayTextColor;
    }else if (dayModel.weekDay == 1 || dayModel.weekDay == 7){
        // 周日 周六
        _dayLabel.textColor = kWeekEndTextColor;
    }else{
        _dayLabel.textColor = kDayLableTextColor;
    }
    
}

// 是否 隐藏 前一个月 或 后一个月 在本月的 日期
-(void)setHiddenPerAndNextMonthDay:(BOOL)hiddenPerAndNextMonthDay
{

    self.hidden = (_dayModel.dayOfMonth != DayOfMonthCurrentMonth)?hiddenPerAndNextMonthDay:NO;
    /*
    _hiddenPerAndNextMonthDay = hiddenPerAndNextMonthDay;
    if (_dayModel.dayOfMonth != DayOfMonthCurrentMonth && _hiddenPerAndNextMonthDay) {
        self.hidden = _hiddenPerAndNextMonthDay;
    }else{
        self.hidden = NO;
    }*/
}

// 日期 是否是 今天
-(BOOL)dateIsTodayWith:(MyCalendarDayModel*)dayModel
{
    return [dayModel.date isToday];
}

-(BOOL)isChineseCalendarFirstDayWith:(NSString*)dayStr
{
    return [dayStr isEqualToString:@"初一"];
}


-(void)addBottomLineLayer
{
    CALayer *bottomLineLayer = [CALayer layer];
    
    CGFloat colorValue = 0.8;
    bottomLineLayer.backgroundColor = [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1].CGColor;
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat layerHeight = 0.5;
    bottomLineLayer.frame = CGRectMake(0.0, height-layerHeight/2, width, layerHeight);
    
    [self.contentView.layer addSublayer:bottomLineLayer];
}



// 耗时间
/*
 // 设置 中国日历 标签
 -(void)resetChineseDayLabelTextWith:(NSString*)text
 {
 CGFloat maxHeight = _sigleHeight*2;
 CGFloat height = [self getTextSizeWith:text];
 CGRect frame = _chineseDayLabel.frame;
 frame.size.height = MIN(maxHeight, height);
 _chineseDayLabel.frame = frame;
 _chineseDayLabel.text = text;
 }
 
 // 获得 文本 高度
 -(CGFloat)getTextSizeWith:(NSString*)text
 {
 NSDictionary * tdic = [NSDictionary dictionaryWithObject:_chineseDayLabel.font forKey:NSFontAttributeName];
 return [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_chineseDayLabel.frame), MAXFLOAT)
 options:NSStringDrawingUsesLineFragmentOrigin
 attributes:tdic
 context:nil].size.height;
 }
 */


#pragma mark - draw
// 耗内存
//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetRGBFillColor(context, 0.9, 0.9, 0.9, 1);
//    CGContextSetLineWidth(context, 0.2);
//    CGContextMoveToPoint(context, 0, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
//    CGContextStrokePath(context);
//    
//}


//#pragma mark - selected
//
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    BOOL new = [change[@"new"] boolValue];
//    BOOL old = [change[@"old"] boolValue];
//    if (new != old) {
//        CalendarCollectinViewCell *cell = object;
//        cell.dayLabel.backgroundColor = new?[UIColor orangeColor]:[self dateIsTodayWith:_dayModel]?[UIColor greenColor]:[UIColor clearColor];
//        if (![cell.dayModel.holiday length] && ![cell.dayModel.chineseHoliday length]) {
//            cell.chineseDayLabel.text = new?[NSString stringWithFormat:@"%@%@/%@",cell.dayModel.chineseLeap,cell.dayModel.chineseMonthNumber,cell.dayModel.chineseDayNumber]:
//            ([cell.dayModel.chineseDay isEqualToString:@"初一"]?cell.dayModel.chineseMonth:cell.dayModel.chineseDay);
//        }
//    }
//}
//
//-(void)dealloc
//{
//    [self removeObserver:self forKeyPath:@"selected"];
//}
//

@end
