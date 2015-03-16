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


@interface CalendarCollectionView ()<UICollectionViewDelegate, UIGestureRecognizerDelegate>



@property (nonatomic, strong) SYCollectionView *mainCollectionView;
@property (nonatomic, strong) SYCollectionView *otherCollectionView;
@property (nonatomic, strong) NSDate *otherBaseDate;

@property (nonatomic, strong) CalendarHeaderView *headerView;

@property (nonatomic, assign) CGFloat panDistance;

@end

@implementation CalendarCollectionView

#define kHeaderViewHeight (70.0)

#define kTopSubViewsOriginY ((([UIDevice currentDevice].systemVersion.floatValue) >= (7.0))?(64.0):(0.0))

#define kPanMinDistance (50.0)

static NSString * const reuseIdentifier = @"Cell";
static NSString * const sectionHeaderReuseIdentifier = @"SectionHeaderView";

#pragma mark - 初始化

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化headerView
        [self initHeaderView];
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


#pragma mark - 初始化 部分数据
-(void)initHeaderView
{
    CGRect frame = CGRectMake(0, kTopSubViewsOriginY, CGRectGetWidth(self.frame), kHeaderViewHeight);
    _headerView = [[CalendarHeaderView alloc] initWithFrame:frame];
    // 上下月份 事件
    __weak CalendarCollectionView *weakSelf = self;
    _headerView.plusOrMinusMonthBlock = ^(NSInteger months){
        [weakSelf creatOtherCalendarWith:months];
        weakSelf.panDistance = -months*kPanMinDistance;
        [weakSelf panFinished];
    };
    [self addSubview:_headerView];
}


-(void)initCollectionView
{
    _mainCollectionView = [self creatCalendarCollectionView];
    [self addSubview:_mainCollectionView];
}

#pragma mark -设置数据

-(void)setBaseDate:(NSDate *)baseDate
{
    _baseDate = baseDate;
    if (_headerView.baseDate == nil) {
        _headerView.baseDate = _baseDate;
    }
    if (self.mainCollectionView.dayModels == nil) {
        self.mainCollectionView.dayModels = [_baseDate getDayModelsInCurrentMonth];
    }
}

-(SYCollectionView*)creatCalendarCollectionView //With:(NSDate*)baseDate
{
    CalendarLayout *layout = [[CalendarLayout alloc] init];
    CGRect frame = self.bounds;
    frame.origin.y = kHeaderViewHeight + kTopSubViewsOriginY;
    frame.size.height -= kHeaderViewHeight;
    SYCollectionView *cv = [[SYCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    // cv.delegate = self;
    return cv;
}







#pragma mark - a

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
        if (temDistance*_panDistance < 0 || _otherCollectionView == nil) {
            [self creatOtherCalendarWith:_panDistance>0?1:-1];
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
    frame.origin.x = CGRectGetWidth(self.frame)*month;
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
            weakSelf.headerView.baseDate = weakSelf.otherBaseDate;
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
