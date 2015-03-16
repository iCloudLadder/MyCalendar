//
//  SelectDateProtocol.h
//  MyCalendar
//
//  Created by syweic on 15/3/6.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCalendarDayModel.h"

@protocol SelectDateProtocol <NSObject>

-(void)selectDateFinished:(MyCalendarDayModel*)dayModel;

@end
