//
//  CalendarLayout.m
//  MyCalendar
//
//  Created by syweic on 14/11/21.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "CalendarLayout.h"

#define kWeekDays 7
#define kItemBaseHeight 30.0
#define kSectionHeaderHeight 80.0

@implementation CalendarLayout


-(void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat collectionWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat hSpace = (((int)collectionWidth)%kWeekDays)/2.0;
    CGFloat itemWidth = (collectionWidth-hSpace*2)/kWeekDays;
    
    self.itemSize = CGSizeMake(itemWidth, itemWidth+kItemBaseHeight);
    self.minimumInteritemSpacing = 0.0;
    self.minimumLineSpacing = 0.0;
    self.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), kSectionHeaderHeight);
    self.sectionInset = UIEdgeInsetsMake(0, hSpace, 0, hSpace);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}


//-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
//    NSLog(@"%@",arr);
//    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        UICollectionViewLayoutAttributes *attr = obj;
//        if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader ]) {
//            attr.frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), 80.0);
//        }
//    }];
//    
//    return  arr;
//}

//-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
//        
//        attributes.frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), 80.0);
//        
//        
//        return attributes;
//    }
//    return nil;
//}


@end
