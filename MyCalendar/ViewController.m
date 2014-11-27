//
//  ViewController.m
//  MyCalendar
//
//  Created by syweic on 14/11/21.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "ViewController.h"
#import "CalendarCollectionViewController.h"
#import "CalendarLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSCalendarUnit unit = NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitQuarter|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitYearForWeekOfYear|NSCalendarUnitNanosecond|NSCalendarUnitCalendar|NSCalendarUnitTimeZone;
//    
//    NSDate *nowDate = [NSDate date];
//    
//    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//    
//    NSLog(@"%ld",[calendar component:NSCalendarUnitWeekOfMonth fromDate:nowDate]);
//    
//    NSDateComponents *components = [calendar components:unit fromDate:nowDate];
//    
//    NSLog(@"%@",components);
    
    
    
    
    
    
    
    
    

}
- (IBAction)buttonClicked:(UIButton *)sender {
    
    CalendarLayout *layout = [[CalendarLayout alloc] init];
    
    CalendarCollectionViewController *ccvc = [[CalendarCollectionViewController alloc] initWithCollectionViewLayout:layout];
    [self presentViewController:ccvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
