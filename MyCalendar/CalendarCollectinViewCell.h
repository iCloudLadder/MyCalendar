//
//  CalendarCollectinViewCell.h
//  MyCalendar
//
//  Created by syweic on 14/11/24.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCalendarDayModel.h"
#import "NSDate+Calendar.h"

@interface CalendarCollectinViewCell : UICollectionViewCell

@property (nonatomic, strong) MyCalendarDayModel *dayModel;

@property (nonatomic ,strong) UILabel *dayLabel;

@property (nonatomic ,strong) UILabel *chineseDayLabel;

@property (nonatomic, strong) UILabel *holidayLabel;

//@property (nonatomic, assign) BOOL hiddenPerAndNextMonthDay;
-(void)setHiddenPerAndNextMonthDay:(BOOL)hiddenPerAndNextMonthDay;

// 日期 是否是 今天
-(BOOL)dateIsTodayWith:(MyCalendarDayModel*)dayModel;

@end
