//
//  BFOrderFinalConfirmViewController.m
//  sterminal
//
//  Created by Wang Long on 1/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFOrderFinalConfirmViewController.h"

@interface BFOrderFinalConfirmViewController ()

@end

@implementation BFOrderFinalConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"Should: %@, Did: %@", self.shouldReceiveString, self.didReceiveString);
    self.shouldReceiveTotalLabel.text = self.shouldReceiveString;
    self.didReceiveTotalLabel.text = self.didReceiveString;
    
    float changeGiven = [self.didReceiveString floatValue] - [self.shouldReceiveString floatValue];
    self.GivenChangeLabel.text = [NSString stringWithFormat:@"%.2f", changeGiven];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShouldReceiveString:(NSString *)shouldReceiveString
{
    //NSLog(@"Should: %@", shouldReceiveString);
    if(![_shouldReceiveString isEqualToString:shouldReceiveString])
    {
        _shouldReceiveString = [shouldReceiveString copy];
        _shouldReceiveTotalLabel.text = _shouldReceiveString;
    }
}

- (void)setDidReceiveString:(NSString *)didReceiveString
{
    //NSLog(@"Did: %@", didReceiveString);
    if(![_didReceiveString isEqualToString:didReceiveString])
    {
        _didReceiveString = [didReceiveString copy];
        _didReceiveTotalLabel.text = _didReceiveString;
    }
}

@end
