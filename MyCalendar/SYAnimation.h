//
//  SYAnimation.h
//  MyCalendar
//
//  Created by syweic on 15/3/9.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SYAnimation : NSObject

#pragma mark - 添加在view上的动画


#pragma mark - 添加在layer上的动画
// 默认动画时间0.25秒
+(void)addAnimationWith:(id)target;
// 设置动画时间
+(void)addLayerAnimationWith:(NSTimeInterval)duration layer:(CALayer*)layer;



@end
