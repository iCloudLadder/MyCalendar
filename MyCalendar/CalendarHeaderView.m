//
//  CalendarHeaderView.m
//  MyCalendar
//
//  Created by syweic on 15/3/9.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "CalendarHeaderView.h"


typedef NS_ENUM(NSInteger, ChangeMonthButtonsTag) {
    MinusChangeMonthButtonsTag = 1201,
    PlusChangeMonthButtonsTag
};

@implementation CalendarHeaderView


// 周几 标签高度
#define kWeekLabelHeight (30.0)
// 加减月份 按钮宽度
// #define kChangeMonthButtonsWidth (55.0)
// 顶部子视图 Y轴坐标
#define kTopSubViewsOriginY 0.0 
// 加减月份 和 日期（年月）标签 高度
#define kTopSubViewsHeight ((CGRectGetHeight(self.frame))-(kWeekLabelHeight)-(kTopSubViewsOriginY))

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatWeekDayLable];
    }
    return self;
}


#pragma mark - weekDay label


-(void)creatWeekDayLable
{
    NSArray *weekDay = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    __weak CalendarHeaderView *weakSelf = self;
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
    label.backgroundColor = [UIColor clearColor];
    return label;
}


#pragma mark -drawRect
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, rect);
    
    CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1);
    CGContextSetLineWidth(context, 0.2);
    CGContextMoveToPoint(context, 0, rect.size.height-kWeekLabelHeight+0.5);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-kWeekLabelHeight);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}*/
 
 /*
 // 加减月份 按钮
 [self creatChangeMonthButtons];
 
 #pragma mark - date change button
 
 
 -(void)creatChangeMonthButtons
 {
 NSArray *buttonsTitle = @[@"-",@"+"];
 __weak CalendarHeaderView *weakSelf = self;
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
 [button setBackgroundImageWith:title];
 [button addTarget:self action:@selector(pluAndMinMonthEvent:) forControlEvents:UIControlEventTouchUpInside];
 [self addSubview:button];
 }
 
 
 
 -(void)pluAndMinMonthEvent:(UIButton*)sender
 {
 NSInteger months = (sender.tag == MinusChangeMonthButtonsTag)?-1:1;
 _plusOrMinusMonthBlock(months);
 }
*/

@end
