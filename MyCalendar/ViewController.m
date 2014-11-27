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
