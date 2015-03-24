//
//  ShowYearAndMonthView.m
//  MyCalendar
//
//  Created by syweic on 15/3/13.
//  Copyright (c) 2015年 ___iSoftStone___. All rights reserved.
//

#import "ShowYearAndMonthView.h"
#import "UIButton+BackgroundImage.h"
#import "UIView+SYLayerShadowAttribute.h"


typedef NS_ENUM(NSInteger, ShowYearAndMonthViewSubViewTags) {
    kMinusChangeMonthButtonsTag = 1201,
    kPlusChangeMonthButtonsTag,
    kInputYearTextFieldTag ,
    kInputMonthTextFieldTag
};

@interface ShowYearAndMonthView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *showYearAndMonthButton;


@property(nonatomic, strong) UITextField *inputYearTF;
@property(nonatomic, strong) UITextField *inputMonthTF;

@property(nonatomic, strong) UILabel *yearLable;
@property(nonatomic, strong) UILabel *monthLable;

@end


@implementation ShowYearAndMonthView

#define kSubViewsHeight (30.0)

#define kInputTextFieldWidth_4 (12.0)
#define kLableWidth (15.0)

#define kChangeMonthButtonsWidth (50.0)
#define kTopSubViewsOriginY (0.0)



#define kShowYearAndMonthTextColor [UIColor magentaColor]

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 创建显示年月份的视图
        [self creatShowYearAndMonthSubviews];
        // 创建按钮
        [self creatChangeMonthButtons];
    }
    return self;
}


#pragma mark - 

-(void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    NSDateComponents *com = [_currentDate getDateComponestsWith:NSCalendarUnitMonth | NSCalendarUnitYear];
    _inputMonthTF.text = [NSString stringWithFormat:@"%ld",(long)com.month];
    _inputYearTF.text = [NSString stringWithFormat:@"%ld",(long)com.year];
    
    [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = YES;

}

#pragma mark - showYearAndMonthButton

-(void)creatShowYearAndMonthSubviews
{
    
    CGFloat originY = (CGRectGetHeight(self.frame) - kSubViewsHeight)/2;
    CGFloat centerX = CGRectGetWidth(self.frame)/2;
    CGFloat height = kSubViewsHeight;
    CGFloat offSet = centerX - (kInputTextFieldWidth_4*6 + kLableWidth*2)/2;
    
    CGRect  inputYearRect = CGRectMake(offSet, originY, kInputTextFieldWidth_4*4, height);
    CGRect  yearLableRect = CGRectMake(offSet + kInputTextFieldWidth_4*4, originY, kLableWidth, height);
    CGRect  inputMonthRect = CGRectMake(offSet + kInputTextFieldWidth_4*4 + kLableWidth, originY, kInputTextFieldWidth_4*2, height);
    CGRect  monthLableRect = CGRectMake(offSet + kInputTextFieldWidth_4*6 + kLableWidth, originY, kLableWidth, height);

    _inputYearTF = [self creatInputTextFieldWith:inputYearRect tag:kInputYearTextFieldTag];
    _inputMonthTF = [self creatInputTextFieldWith:inputMonthRect tag:kInputMonthTextFieldTag];
    
    _yearLable = [self creatLableWith:yearLableRect text:@"年"];
    _monthLable = [self creatLableWith:monthLableRect text:@"月"];

    [self addSubview:_inputYearTF];
    [self addSubview:_inputMonthTF];
    [self addSubview:_yearLable];
    [self addSubview:_monthLable];
    
}



#pragma mark - inputTextField

-(UITextField*)creatInputTextFieldWith:(CGRect)frame tag:(ShowYearAndMonthViewSubViewTags)tag
{
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.tag = tag;
    tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    tf.textColor = kShowYearAndMonthTextColor;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.delegate = self;
    tf.returnKeyType = tag == kInputYearTextFieldTag?UIReturnKeyNext:UIReturnKeyDone;
    return tf;
}

-(UILabel*)creatLableWith:(CGRect)frame text:(NSString*)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = kShowYearAndMonthTextColor;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}


#pragma mark - handle input date

-(void)handleInputDate
{
    // 处理输入日期
    NSInteger months = [self.currentDate getMonthsWith:_inputYearTF.text.integerValue month:_inputMonthTF.text.integerValue];
    NSDate *date = [self.currentDate getDateOfOtherMonthFrom:months];
    if (![self.currentDate isEqualToDate:date]) {
        _plusOrMinMonth(months);
        self.currentDate = date;
    }

}




#pragma mark - changeMonthButtons

-(void)creatChangeMonthButtons
{
    NSArray *buttonsTitle = @[@"-",@"+"];
    __weak ShowYearAndMonthView *weakSelf = self;
    [buttonsTitle enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat originX = idx?CGRectGetWidth(weakSelf.frame)-kChangeMonthButtonsWidth:0.0;
        [weakSelf creatButtonWith:CGRectMake(originX, kTopSubViewsOriginY, kChangeMonthButtonsWidth, CGRectGetHeight(self.frame)) title:obj tag:idx + kMinusChangeMonthButtonsTag];
    }];
}

-(void)creatButtonWith:(CGRect)frame title:(NSString*)title tag:(ShowYearAndMonthViewSubViewTags)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImageWith:title];
    [button addTarget:self action:@selector(pluAndMinMonthEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}



-(void)pluAndMinMonthEvent:(UIButton*)sender
{
    [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = NO;
    
    NSInteger months = (sender.tag == kMinusChangeMonthButtonsTag)?-1:1;
    _plusOrMinMonth(months);
    
}



#pragma mark - textField delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger maxLength = textField.tag == kInputYearTextFieldTag ? 4 : 2;    
    if (range.length) {
        return YES;
    }else if ([@"0123456789" rangeOfString:string].location != NSNotFound){
        if (textField.tag == kInputMonthTextFieldTag && range.location == 1) {
            NSInteger month = [textField.text stringByAppendingString:string].integerValue;
            return month >= 1 && month <=12;
        }
        return textField.text.length < maxLength;
    }
    return NO;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == kInputYearTextFieldTag) {
        // 限制年份
//        if (textField.text.integerValue >= 1900) {
//        }
        [_inputMonthTF becomeFirstResponder];
    }else if (textField.tag == kInputMonthTextFieldTag){
        if (textField.text.integerValue == 0) {
            return NO;
        }
        [self handleInputDate];
        [textField resignFirstResponder];
    }
    

    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resetLayerShadowAttributeWith:YES];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resetLayerShadowAttributeWith:NO];
}


-(void)setInputTFLayerWith:(BOOL)editing
{
    [_inputYearTF resetLayerShadowAttributeWith:editing];
    [_inputMonthTF resetLayerShadowAttributeWith:editing];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
