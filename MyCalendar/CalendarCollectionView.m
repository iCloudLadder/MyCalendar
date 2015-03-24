//
//  CalendarCollectionView.m
//  MyCalendar
//
//  Created by syweic on 15/3/6.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "CalendarCollectionView.h"
#import "CalendarLayout.h"
#import "CalendarHeaderView.h"
#import "UIView+ResetFrame.h"
#import "ShowYearAndMonthView.h"


@interface CalendarCollectionView ()<UICollectionViewDelegate, UIGestureRecognizerDelegate>


@property (nonatomic, strong) SYCollectionView *mainCollectionView;
@property (nonatomic, strong) SYCollectionView *otherCollectionView;
@property (nonatomic, strong) NSDate *otherBaseDate;

@property (nonatomic, strong) CalendarHeaderView *headerView;

@property (nonatomic, assign) CGFloat headerViewHeight;


@property (nonatomic, assign) CGFloat panDistance;


@end

@implementation CalendarCollectionView

#define kHeaderViewBaseHeight (30.0)
#define kHeaderViewMaxHeight (70.0)

#define kTopSubViewsOriginY ((([UIDevice currentDevice].systemVersion.floatValue) >= (7.0))?(64.0):(0.0))
#define kPanMinDistance (50.0)

static NSString * const reuseIdentifier = @"Cell";
static NSString * const sectionHeaderReuseIdentifier = @"SectionHeaderView";

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化日期CollectionView
        [self initCollectionView];
        // 添加滑动手势
        [self addPanGestureRecognizer];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month
{
    self = [self initWithFrame:frame];
    if (self) {
        self.baseDate = [NSDate getDateOfFirstDayWith:year month:month];
    }
    return self;
}


-(void)showYearAndMonthWith:(SYShowYearAndMonthType)type
{
    self.headerViewHeight = (type == SYShowYearAndMonthTypeOnNavigation)?kHeaderViewBaseHeight:kHeaderViewMaxHeight;
    _headerView = [self creatHeaderViewWith:_headerViewHeight];
    if (type == SYShowYearAndMonthTypeOnHeader) {
        [_headerView addSubview:self.showYMView];
    }else{
        
    }
    [self addSubview:_headerView];
}

#pragma mark - 初始化 部分数据
-(CalendarHeaderView*)creatHeaderViewWith:(CGFloat)height
{
    CGRect frame = CGRectMake(0.0, kTopSubViewsOriginY, CGRectGetWidth(self.frame), height);
    CalendarHeaderView *headerView = [[CalendarHeaderView alloc] initWithFrame:frame];
    return headerView;
}

-(void)initCollectionView
{
    _mainCollectionView = [self creatCalendarCollectionView];
    [self addSubview:_mainCollectionView];
}

-(void)initYearAndMonthOfTheDate
{
    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame) - 180.0, kHeaderViewMaxHeight - kHeaderViewBaseHeight);
    _showYMView = [[ShowYearAndMonthView alloc] initWithFrame:frame];
    CalendarCollectionView __weak *weakSelf = self;
    _showYMView.plusOrMinMonth = ^(NSInteger months){
        [weakSelf showOtherCalendarViewWith:months];
    };
    [self addSubview:_showYMView];
}


-(void)showOtherCalendarViewWith:(NSInteger)months
{
    [self creatOtherCalendarWith:months];
    self.panDistance = -months*kPanMinDistance;
    [self panFinished];
}

#pragma mark - set & get

-(ShowYearAndMonthView *)showYMView
{
    if (_showYMView == nil) {
        [self initYearAndMonthOfTheDate];
    }
    return _showYMView;
}

-(void)setBaseDate:(NSDate *)baseDate
{
    _baseDate = baseDate;
    self.showYMView.currentDate = _baseDate;
    if (self.mainCollectionView.dayModels == nil) {
        self.mainCollectionView.dayModels = [_baseDate getDayModelsInCurrentMonth];
    }
}

-(void)setHeaderViewHeight:(CGFloat)headerViewHeight
{
    _headerViewHeight = headerViewHeight;
    _mainCollectionView.frame = CGRectMake( 0.0, _headerViewHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _headerViewHeight);
}

#pragma mark - SYCollectionView

-(SYCollectionView*)creatCalendarCollectionView //With:(NSDate*)baseDate
{
    CalendarLayout *layout = [[CalendarLayout alloc] init];
    CGRect frame = self.bounds;
    frame.origin.y = self.headerViewHeight + kTopSubViewsOriginY;
    frame.size.height -= self.headerViewHeight;
    SYCollectionView *cv = [[SYCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    return cv;
}






/**
 **
 **
 **
 **
 **
 **
 **/
#pragma mark - PanGestureRecognizer

-(void)addPanGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    self.backgroundColor = [UIColor whiteColor];
}


#pragma mark - panEvent


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
    if (abs(velocity.x) <= abs(velocity.y)) {
        return NO;
    }
    return YES;
}

-(void)panEvent:(UIPanGestureRecognizer*)pgr
{
    CGPoint transPoint = [pgr translationInView:self];
    if (pgr.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [pgr velocityInView:self];
        [self creatOtherCalendarWith:velocity.x>0?-1:1];
    }else if (pgr.state == UIGestureRecognizerStateChanged){
        CGFloat temDistance = _panDistance + transPoint.x;
        if (temDistance*_panDistance <= 0 || _otherCollectionView == nil) {
            if (_panDistance) {
                [self creatOtherCalendarWith:_panDistance>0?1:-1];
            }else{
                [self creatOtherCalendarWith:transPoint.x<0?1:-1];
            }
        }
        _panDistance = temDistance;
        [self resetFrameWith:transPoint.x];
        [pgr setTranslation:CGPointZero inView:self];
    }else if (pgr.state == UIGestureRecognizerStateEnded){
        [self panFinished];
    }
}


-(void)resetFrameWith:(CGFloat)originX
{
    [_otherCollectionView resetFrameWith:originX];
    [_mainCollectionView resetFrameWith:originX];
}

-(void)creatOtherCalendarWith:(NSInteger)month
{
    if (_otherCollectionView) {
        [_otherCollectionView removeFromSuperview];
        _otherCollectionView = nil;
    }
    _otherCollectionView = [self creatCalendarCollectionView]; // With:[self getBaseDateWith:month]
    _otherBaseDate = [self getBaseDateWith:month];
    _otherCollectionView.dayModels = [_otherBaseDate getDayModelsInCurrentMonth];
    // 重新设置frame
    CGRect frame = _otherCollectionView.frame;
    frame.origin.x = CGRectGetWidth(self.frame)*month + _panDistance;
    _otherCollectionView.frame = frame;
    [_otherCollectionView setLayerShadow];
    [self addSubview:_otherCollectionView];
}

-(NSDate *)getBaseDateWith:(NSInteger)month
{
    NSDate *date = self.baseDate;
    if (date == nil) {
        date = [NSDate date];
    }
    return [date getDateOfOtherMonthFrom:month];
}


-(void)panFinished
{
    CGRect frame = _mainCollectionView.frame;
    CGRect otherFrame = _otherCollectionView.frame;
    BOOL isPaned = abs(_panDistance) >= 50.0;
    if (!isPaned) {
        frame.origin.x = 0.0;
        otherFrame.origin.x = self.frame.size.width*(_panDistance>0?-1:1);
    }else{
        frame.origin.x = self.frame.size.width*(_panDistance>0?1:-1);
        otherFrame.origin.x = 0.0;
    }
    self.userInteractionEnabled = NO;
    [self finishedAnimationWith:isPaned frame:frame otherFrame:otherFrame];
}

-(void)finishedAnimationWith:(BOOL)isPaned frame:(CGRect)frame otherFrame:(CGRect)otherFrame
{
    __weak CalendarCollectionView *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.otherCollectionView.frame = otherFrame;
        weakSelf.mainCollectionView.frame = frame;
    } completion:^(BOOL finished) {
        if (isPaned) {
            [weakSelf.mainCollectionView removeFromSuperview];
            weakSelf.mainCollectionView = weakSelf.otherCollectionView;
            weakSelf.baseDate = weakSelf.otherBaseDate;
        }else{
            [weakSelf.otherCollectionView removeFromSuperview];
        }
        weakSelf.otherCollectionView = nil;
        weakSelf.panDistance = 0;
        weakSelf.userInteractionEnabled = YES;
    }];

}

-(void)printFrameWith:(CGRect)frame
{
    NSLog(@"%f - %f - %f - %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}


#pragma mark - headerView plus & min callBack





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
