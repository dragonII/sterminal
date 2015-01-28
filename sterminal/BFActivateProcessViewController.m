//
//  BFActivateProcessViewController.m
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFActivateProcessViewController.h"

@interface BFActivateProcessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImageView;
@end

@implementation BFActivateProcessViewController

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

- (IBAction)activateClicked:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"userLoginSegue" sender:self];
}
@end
