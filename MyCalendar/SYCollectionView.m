//
//  SYCollectionView.m
//  MyCalendar
//
//  Created by syweic on 15/3/9.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "SYCollectionView.h"

@implementation SYCollectionView

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[CalendarCollectinViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void)setDayModels:(NSArray *)dayModels
{
    _dayModels = nil;
    _dayModels = dayModels;
    [self reloadData];
}



#pragma mark - dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dayModels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCollectinViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.dayModel = [_dayModels objectAtIndex:indexPath.item];
    //cell.dayLabel.backgroundColor = [UIColor clearColor];
    cell.hiddenPerAndNextMonthDay = YES;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCollectinViewCell *cell = (CalendarCollectinViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [SYAnimation addAnimationWith:cell.dayLabel.layer];
    
    CalendarCollectionView *ccv = (CalendarCollectionView*)self.superview;
    
    if (ccv.selectDateBlock) {
        ccv.selectDateBlock(cell.dayModel);
    }else if (ccv.selectDateDelegate && [ccv.selectDateDelegate respondsToSelector:@selector(selectDateFinished:)]){
        [ccv.selectDateDelegate selectDateFinished:cell.dayModel];
    }
    
    cell.dayLabel.backgroundColor = [UIColor orangeColor];
    if (![cell.dayModel.holiday length] && ![cell.dayModel.chineseHoliday length]) {
        cell.chineseDayLabel.text = [NSString stringWithFormat:@"%@%@/%@",cell.dayModel.chineseLeap,cell.dayModel.chineseMonthNumber,cell.dayModel.chineseDayNumber];
    }

}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCollectinViewCell *cell = (CalendarCollectinViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.dayLabel.backgroundColor = [cell dateIsTodayWith:cell.dayModel]?[UIColor greenColor]:[UIColor clearColor];
    if (![cell.dayModel.holiday length] && ![cell.dayModel.chineseHoliday length]) {
        cell.chineseDayLabel.text = ([cell.dayModel.chineseDay isEqualToString:@"初一"]?cell.dayModel.chineseMonth:cell.dayModel.chineseDay);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
