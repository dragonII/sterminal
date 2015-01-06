//
//  BFUserLoginViewController.m
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFUserLoginViewController.h"

@interface BFUserLoginViewController ()

@end

@implementation BFUserLoginViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userLogin:(id)sender
{
    [self performSegueWithIdentifier:@"orderSegue" sender:self];
}

- (IBAction)userSwitch:(id)sender
{
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"switchUserSegue" sender:self];
}
@end
