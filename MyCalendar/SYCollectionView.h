//
//  SYCollectionView.h
//  MyCalendar
//
//  Created by syweic on 15/3/9.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarCollectinViewCell.h"
#import "SYAnimation.h"
#import "CalendarCollectionView.h"

@interface SYCollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *dayModels;

@end
