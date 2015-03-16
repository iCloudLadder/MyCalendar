//
//  SYAnimation.m
//  MyCalendar
//
//  Created by syweic on 15/3/9.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "SYAnimation.h"

@implementation SYAnimation

#define kDefaultDuration (0.25)

+(void)addAnimationWith:(id)target
{
    if ([target isKindOfClass:[UIView class]]) {
        
    }else if ([target isKindOfClass:[CALayer class]]){
        [SYAnimation addLayerAnimationWith:kDefaultDuration layer:(CALayer*)target];
    }
}

+(void)addLayerAnimationWith:(NSTimeInterval)duration layer:(CALayer*)layer
{
    [SYAnimation addLayerAnimationWith:duration layer:layer keyPath:@"transform.scale"];
}

+(void)addLayerAnimationWith:(NSTimeInterval)duration layer:(CALayer*)layer keyPath:(NSString*)keyPath
{
    [SYAnimation addLayerAnimationWith:duration layer:layer keyPath:keyPath fromValue:@(0.5) toValue:@(1.4                )];
}

+(void)addLayerAnimationWith:(NSTimeInterval)duration layer:(CALayer*)layer keyPath:(NSString*)keyPath fromValue:(NSValue*)fromValue toValue:(NSValue*)toValue
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = duration;
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    [layer addAnimation:animation forKey:nil];
}







@end
