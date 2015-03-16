//
//  UIView+ResetFrame.m
//  MyCalendar
//
//  Created by syweic on 15/3/6.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "UIView+ResetFrame.h"

@implementation UIView (ResetFrame)

-(void)resetFrameWith:(CGFloat)originX
{
    CGRect frame = self.frame;
    frame.origin.x += originX;
    self.frame = frame;
}


-(void)setLayerShadow
{
    self.layer.shadowColor = [UIColor redColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 1;
    //self.layer.masksToBounds = YES;
    //self.layer.cornerRadius = 5.0;
}

@end
