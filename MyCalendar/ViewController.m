//
//  ViewController.m
//  MyCalendar
//
//  Created by syweic on 14/11/21.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "ViewController.h"
#import "CalendarAPI.h"
#import "ShowYearAndMonthView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)buttonClicked:(UIButton *)sender {
    
    CalendarViewController *ccvc = [[CalendarViewController alloc] initWithYear:2015 month:3];
    ccvc.selectDateFinishedBlock = ^(MyCalendarDayModel* dayModel){
        NSLog(@"select date = %@",dayModel.date);
    };
    [self.navigationController pushViewController:ccvc animated:YES];
    // [self presentViewController:ccvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
