//
//  UIView+SYLayerShadowAttribute.m
//  MyCalendar
//
//  Created by syweic on 15/3/13.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "UIView+SYLayerShadowAttribute.h"

@implementation UIView (SYLayerShadowAttribute)

-(void)resetLayerShadowAttributeWith:(BOOL)editing
{
    editing?[self addLayerShadow]:[self clearLayerShadow];
}

-(void)addLayerShadow
{
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
}

-(void)clearLayerShadow
{
    self.layer.borderColor = [UIColor clearColor].CGColor;
}



@end
