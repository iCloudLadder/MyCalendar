//
//  ShowYearAndMonthView.h
//  MyCalendar
//
//  Created by syweic on 15/3/13.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SYPlusOrMinMonthBlock)(NSInteger months);

@interface ShowYearAndMonthView : UIView

@property (nonatomic, copy) SYPlusOrMinMonthBlock plusOrMinMonth;

@property (nonatomic, strong) NSString *perButtonImageName;
@property (nonatomic, strong) NSString *nextButtonImageName;

@end
