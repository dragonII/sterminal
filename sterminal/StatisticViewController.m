//
//  StatisticViewController.m
//  sterminal
//
//  Created by Wang Long on 1/30/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "StatisticViewController.h"

@interface StatisticViewController ()

@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
