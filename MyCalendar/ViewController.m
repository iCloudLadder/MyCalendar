//
//  ViewController.m
//  MyCalendar
//
//  Created by syweic on 14/11/21.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "ViewController.h"
#import "CalendarAPI.h"
#import "ShowYearAndMonthView.h";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    ShowYearAndMonthView *syam = [[ShowYearAndMonthView alloc] initWithFrame:CGRectMake(20, 200, 300, 40)];
    
    [self.view addSubview:syam];
    
    
    
}


- (IBAction)buttonClicked:(UIButton *)sender {
    
    
    CalendarViewController *ccvc = [[CalendarViewController alloc] initWithYear:1989 month:1];
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
