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
#define kDayLableLength 35.0

#define kDayLableFontOfSize 15
#define kChineseDayLableFontOfSize 10

#define kSubViewsInitBackgroundColor [UIColor clearColor]

#define kDayLableTextColor [UIColor blackColor]
#define kDayLableHighlightTextColor [UIColor whiteColor]

#define kChineseDayLableTextColor [UIColor grayColor]

#define kPerOrNextMonthDayTextColor [UIColor lightGrayColor]
#define kHolidayTextColor [UIColor orangeColor]
#define kWeekEndTextColor [UIColor redColor]

@interface CalendarCollectinViewCell ()


@end

@implementation CalendarCollectinViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
        [self addObserver:self
               forKeyPath:@"selected"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
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
    _dayLabel.backgroundColor = kSubViewsInitBackgroundColor;
    _dayLabel.highlightedTextColor = kDayLableHighlightTextColor;
    [self.contentView addSubview:_dayLabel];
}

#pragma mark - 农历 日期标签

-(void)creatChineseDayLabelWith:(CGFloat)selfWidth
{
    CGRect frame = CGRectMake(kSubViewsSpace/2, CGRectGetMaxY(_dayLabel.frame), selfWidth-kSubViewsSpace, kChineseDayLabelHeight);
    
    _chineseDayLabel = [[UILabel alloc] initWithFrame:frame];
    _chineseDayLabel.textAlignment = NSTextAlignmentCenter;
    _chineseDayLabel.backgroundColor = kSubViewsInitBackgroundColor;
    _chineseDayLabel.textColor = kChineseDayLableTextColor;
    _chineseDayLabel.font = [UIFont systemFontOfSize:kChineseDayLableFontOfSize];
    _chineseDayLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _chineseDayLabel.numberOfLines = 0;
    
    [self.contentView addSubview:_chineseDayLabel];
}

#pragma mark - 节日 标签

-(void)creatHolidayLableWith:(CGFloat)selfWidth
{
    //CGFloat *c
}

#pragma mark - set someData

-(void)setDayModel:(MyCalendarDayModel *)dayModel
{
    if (_dayModel) {
        _dayModel = nil;
    }
    _dayModel = dayModel;
    _dayLabel.text = dayModel.day;
    
    [self setLabelTextColorWith:dayModel];
    [self setChineseDayLabelTextWith:dayModel];
    
    // 如果日期 是今天
    _dayLabel.backgroundColor = [self dateIsTodayWith:dayModel]?[UIColor greenColor]:[UIColor clearColor];
}


-(void)setChineseDayLabelTextWith:(MyCalendarDayModel*)dayModel
{
    NSString *text;
    if ([dayModel.holiday length] || [dayModel.chineseHoliday length]) {
        text = [NSString stringWithFormat:@"%@%@",dayModel.holiday,dayModel.chineseHoliday];
    }else if ([dayModel.chineseDay isEqualToString:@"初一"]) {
        text = dayModel.chineseMonth;
    }else{
        text = dayModel.chineseDay;
    }
    
    [self resetChineseDayLabelTextWith:text];
}

// 设置 中国日历 标签
-(void)resetChineseDayLabelTextWith:(NSString*)text
{
    CGFloat maxHeight = CGRectGetHeight(self.frame)-CGRectGetHeight(_dayLabel.frame);
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



// 设置 标签 文本的颜色
-(void)setLabelTextColorWith:(MyCalendarDayModel*)dayModel
{
    // 本月中显示的 前一个月 或 后一个月 的日期 颜色
    if (dayModel.dayOfMonth != DayOfMonthCurrentMonth) {
        _dayLabel.textColor = _chineseDayLabel.textColor = kPerOrNextMonthDayTextColor;
    }else if (dayModel.weekDay == 1 || dayModel.weekDay == 7){
        // 周日 周六
        _dayLabel.textColor = kWeekEndTextColor;
    }else{
        _dayLabel.textColor = kDayLableTextColor;
    }
    _chineseDayLabel.textColor = ([dayModel.holiday length] || [dayModel.chineseHoliday length])?kHolidayTextColor:kChineseDayLableTextColor;
}

// 是否 隐藏 前一个月 或 后一个月 在本月的 日期
-(void)setHiddenPerAndNextMonthDay:(BOOL)hiddenPerAndNextMonthDay
{
    _hiddenPerAndNextMonthDay = hiddenPerAndNextMonthDay;
    if (_dayModel.dayOfMonth != DayOfMonthCurrentMonth && _hiddenPerAndNextMonthDay) {
        self.hidden = _hiddenPerAndNextMonthDay;
    }else{
        self.hidden = NO;
    }
}

// 日期 是否是 今天
-(BOOL)dateIsTodayWith:(MyCalendarDayModel*)dayModel
{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:unit fromDate:[NSDate date]];
    
    return [dayModel.year integerValue] == components.year && [dayModel.month integerValue] == components.month && [dayModel.day integerValue] == components.day;
}


#pragma mark - selected

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL new = [change[@"new"] boolValue];
    BOOL old = [change[@"old"] boolValue];
    if (new != old) {
        CalendarCollectinViewCell *cell = object;
        cell.dayLabel.backgroundColor = new?[UIColor orangeColor]:[self dateIsTodayWith:_dayModel]?[UIColor greenColor]:[UIColor clearColor];
        if (![cell.dayModel.holiday length] && ![cell.dayModel.chineseHoliday length]) {
            cell.chineseDayLabel.text = new?[NSString stringWithFormat:@"%@%@/%@",cell.dayModel.chineseLeap,cell.dayModel.chineseMonthNumber,cell.dayModel.chineseDayNumber]:cell.dayModel.chineseDay;
        }
    }
}


#pragma mark - draw

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, rect);
    
    CGContextSetRGBFillColor(context, 0.9, 0.9, 0.9, 1);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
    
}




-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"selected"];
}


@end
