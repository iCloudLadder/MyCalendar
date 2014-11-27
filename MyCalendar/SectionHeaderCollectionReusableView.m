//
//  SectionHeaderCollectionReusableView.m
//  MyCalendar
//
//  Created by syweic on 14/11/21.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "SectionHeaderCollectionReusableView.h"

@interface SectionHeaderCollectionReusableView ()

@property (nonatomic, strong) UILabel *dateLable;

@property (nonatomic, strong) NSDate *monthDate;


@end

typedef NS_ENUM(NSInteger, ChangeMonthButtonsTag) {
    MinusChangeMonthButtonsTag = 1201,
    PlusChangeMonthButtonsTag
};

@implementation SectionHeaderCollectionReusableView

// 周几 标签高度
#define kWeekLabelHeight (30.0)
// 加减月份 按钮快读
#define kChangeMonthButtonsWidth (55.0)
// 状态栏 高度
#define kTopSubViewsOriginY ((([UIDevice currentDevice].systemVersion.floatValue) >= (7.0))?(20.0):(0.0))
// 加减月份 和 日期（年月）标签 高度
#define kTopSubViewsHeight ((CGRectGetHeight(self.frame))-(kWeekLabelHeight)-(kTopSubViewsOriginY))

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 日历 默认显示 当日所在月份 日历
        _monthDate = [NSDate date];
        // 周 标签
        [self creatWeekDayLable];
        // 年月 标签
        [self creatDateLable];
        // 加减月份 按钮
        [self creatChangeMonthButtons];
    }
    return self;
}


#pragma mark - date change button


-(void)creatChangeMonthButtons
{
    NSArray *buttonsTitle = @[@"-",@"+"];
    __weak SectionHeaderCollectionReusableView *weakSelf = self;
    [buttonsTitle enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat originX = idx?CGRectGetWidth(weakSelf.frame)-kChangeMonthButtonsWidth:0.0;
        [weakSelf creatButtonWith:CGRectMake(originX, kTopSubViewsOriginY, kChangeMonthButtonsWidth, kTopSubViewsHeight) title:obj tag:idx+MinusChangeMonthButtonsTag];
    }];
}

-(void)creatButtonWith:(CGRect)frame title:(NSString*)title tag:(ChangeMonthButtonsTag)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pluAndMinMonthEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)pluAndMinMonthEvent:(UIButton*)sender
{
    [self getDatePerOrNextMonthWith:(sender.tag == MinusChangeMonthButtonsTag)?-1:1];
}

-(void)getDatePerOrNextMonthWith:(NSInteger)number
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:number];
    _monthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:_monthDate options:0];
    
    _dateLable.text = [self getDateLableTextWith:_monthDate];
    _plusOrMinusMonthBlock(_monthDate);
}



#pragma mark - date lable (year,month)

-(void)creatDateLable
{
    CGRect frame = CGRectMake(0, kTopSubViewsOriginY, CGRectGetWidth(self.frame), kTopSubViewsHeight);
    _dateLable = [self creatWeekDayLabelWithFrame:frame text:[self getDateLableTextWith:_monthDate] textColor:[UIColor magentaColor]];
    [self addSubview:_dateLable];
}

-(NSString*)getDateLableTextWith:(NSDate*)date
{
    if (!date) {
        date = [NSDate date];
    }
    return [[self getDateFormatter] stringFromDate:date];
}

-(NSDateFormatter*)getDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月";
    return formatter;
}



#pragma mark - weekDay label


-(void)creatWeekDayLable
{
    NSArray *weekDay = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    __weak SectionHeaderCollectionReusableView *weakSelf = self;
    [weekDay enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *weekDayLable = [weakSelf creatWeekDayLabelWithFrame:[weakSelf getFrameWith:idx]
                                        text:obj
                                   textColor:[weakSelf getTextColorWith:obj]];
        [weakSelf addSubview:weekDayLable];
    }];
    
}

-(CGRect)getFrameWith:(NSInteger)index
{

    CGFloat collectionWidth = CGRectGetWidth(self.frame);
    CGFloat hSpace = ((int)collectionWidth%7)/2.0;
    CGFloat labelWidth = (collectionWidth-hSpace*2)/7;
    CGFloat originX = hSpace+index*labelWidth;
    CGFloat originY = CGRectGetHeight(self.frame)-kWeekLabelHeight;
    
    return  CGRectMake(originX, originY, labelWidth, kWeekLabelHeight);
}

-(UIColor*)getTextColorWith:(NSString*)title
{
    return ([title isEqualToString:@"日"] || [title isEqualToString:@"六"])?[UIColor redColor]:[UIColor blackColor];
}

-(UILabel*)creatWeekDayLabelWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
















@end
