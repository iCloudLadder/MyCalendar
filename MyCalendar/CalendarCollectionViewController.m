//
//  CalendarCollectionViewController.m
//  MyCalendar
//
//  Created by syweic on 14/11/21.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "CalendarCollectionViewController.h"
#import "CalendarLayout.h"
#import "SectionHeaderCollectionReusableView.h"
#import "NSDate+Calendar.h"
#import "CalendarCollectinViewCell.h"
#import "MyCalendarObject.h"

@interface CalendarCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *dayModels;

@end

@implementation CalendarCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const sectionHeaderReuseIdentifier = @"SectionHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    _dayModels = [[NSDate date] getDayModelsInCurrentMonth];
    
    // Register cell classes
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[CalendarCollectinViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[SectionHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderReuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

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
    cell.dayLabel.backgroundColor = [UIColor clearColor];
    cell.hiddenPerAndNextMonthDay = YES;
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SectionHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHeaderReuseIdentifier forIndexPath:indexPath];
        // 上下月份 事件
        __weak CalendarCollectionViewController *weakSelf = self;
        headerView.PlusOrMinusMonthBlock = ^(NSDate *otherMonthDate){
            [weakSelf.dayModels removeAllObjects];
            weakSelf.dayModels = [otherMonthDate getDayModelsInCurrentMonth];
            [weakSelf.collectionView reloadData];
        };
        
        return headerView;
    }
    return nil;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCollectinViewCell *cell = (CalendarCollectinViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"%@ - %@ - %@",cell.dayModel.year,cell.dayModel.month,cell.dayModel.day);
}



#pragma mark <UICollectionViewDelegate>


#pragma mark - item highlight

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
/*
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did highlight");
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did unhighlight");
}
*/
#pragma mark - item selected


// Uncomment this method to specify if the specified item should be selected
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}



//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//}




/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




















@end
