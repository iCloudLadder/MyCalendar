//
//  CalendarViewController.m
//  MyCalendar
//
//  Created by syweic on 15/3/6.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCollectionView.h"
#import "UIView+ResetFrame.h"

#import "ShowYearAndMonthView.h"

@interface CalendarViewController ()<SelectDateProtocol>

@property (nonatomic, strong) CalendarCollectionView *mainCalendar;

@end

@implementation CalendarViewController

-(instancetype)initWithYear:(NSInteger)year month:(NSInteger)month
{
    self = [super init];
    if (self) {
        self.year = year;
        self.month = month;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    _mainCalendar = [self creatCalendarCollectionViewWith:[NSDate getDateOfFirstDayWith:_year month:_month]];
    [self.view addSubview:_mainCalendar];
    
    self.navigationItem.titleView = _mainCalendar.showYMView;
    
}




-(CalendarCollectionView*)creatCalendarCollectionViewWith:(NSDate*)baseDate
{
    CalendarCollectionView *ccv = [[CalendarCollectionView alloc] initWithFrame:self.view.bounds];
    
    // SYShowYearAndMonthTypeOnHeader
    [ccv showYearAndMonthWith:SYShowYearAndMonthTypeOnNavigation];
    ccv.selectDateDelegate = self;
    ccv.baseDate = baseDate;
    return ccv;
}


#pragma mark -CalendarSelectDateDelegate


-(void)selectDateFinished:(MyCalendarDayModel *)dayModel
{
    NSLog(@"dayModel = %@",dayModel);
    [self callBackDataWith:dayModel];
    
}

#pragma mark - callBack

-(void)callBackDataWith:(MyCalendarDayModel*)dayModel
{
    if (_selectDateFinishedBlock) {
        _selectDateFinishedBlock(dayModel);
    }else if (_delegate && [_delegate respondsToSelector:@selector(selectDateFinished:)]){
        [_delegate selectDateFinished:dayModel];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*#pragma mark - panEvent
 
 -(void)panEvent:(UIPanGestureRecognizer*)pgr
 {
 CGPoint transPoint = [pgr translationInView:self.view];
 if (pgr.state == UIGestureRecognizerStateBegan) {
 CGPoint velocity = [pgr velocityInView:self.view];
 NSLog(@"vv = %f",velocity.x);
 [self creatOtherCalendarWith:velocity.x>0?-1:1];
 }else if (pgr.state == UIGestureRecognizerStateChanged){
 CGFloat temDistance = _panDistance + transPoint.x;
 if (temDistance*_panDistance < 0) {
 [self creatOtherCalendarWith:_panDistance>0?1:-1];
 }
 _panDistance = temDistance;
 [self resetFrameWith:transPoint.x];
 [pgr setTranslation:CGPointZero inView:self.view];
 }else if (pgr.state == UIGestureRecognizerStateEnded){
 [self finishedAnimation];
 }
 }
 
 -(void)finishedAnimation
 {
 CGRect frame = _mainCalendar.frame;
 CGRect otherFrame = _otherCalendar.frame;
 frame.origin.x = self.view.frame.size.width*(_panDistance>0?1:-1);
 otherFrame.origin.x = 0;
 
 [UIView animateWithDuration:0.25 animations:^{
 _otherCalendar.frame = otherFrame;
 _mainCalendar.frame = frame;
 } completion:^(BOOL finished) {
 [_mainCalendar removeFromSuperview];
 _mainCalendar = nil;
 _mainCalendar = _otherCalendar;
 _otherCalendar = nil;
 _panDistance = 0;
 }];
 
 }
 
 -(void)resetFrameWith:(CGFloat)originX
 {
 [_otherCalendar resetFrameWith:originX];
 [_mainCalendar resetFrameWith:originX];
 }
 
 -(void)creatOtherCalendarWith:(NSInteger)month
 {
 NSLog(@"month = %ld",month);
 if (_otherCalendar) {
 [_otherCalendar removeFromSuperview];
 _otherCalendar = nil;
 }
 _otherCalendar = [self creatCalendarCollectionViewWith:[self getBaseDateWith:month]];
 CGRect frame = _otherCalendar.frame;
 frame.origin.x = CGRectGetWidth(self.view.frame)*month;
 _otherCalendar.frame = frame;
 [self.view addSubview:_otherCalendar];
 }
 
 -(NSDate *)getBaseDateWith:(NSInteger)month
 {
 NSDate *date = _mainCalendar.baseDate;
 if (date == nil) {
 date = [NSDate date];
 }
 return [date getDateOfOtherMonthFrom:month];
 }
 */


@end
