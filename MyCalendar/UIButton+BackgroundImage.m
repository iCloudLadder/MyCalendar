//
//  UIButton+BackgroundImage.m
//  MyCalendar
//
//  Created by syweic on 15/3/6.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "UIButton+BackgroundImage.h"

@implementation UIButton (BackgroundImage)

-(void)setBackgroundImageWith:(NSString*)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setBackgroundImage:[self getHighLightImageWith:imageName] forState:UIControlStateHighlighted];

}

-(UIImage*)getHighLightImageWith:(NSString*)imageName
{
    return [UIImage imageNamed:[imageName stringByAppendingString:@"_highlight"]];
}

@end
