//
//  BFUserLoginViewController.m
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFUserLoginViewController.h"
#import "BFUserListViewController.h"

#import "AFNetworking.h"
#import "GDataXMLNode.h"

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)userLogin:(id)sender
{
    NSString *urlString = @"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Getting information...");
        NSLog(@"%@", (NSDictionary *)responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    
    [operation start];
    
    [self performSegueWithIdentifier:@"orderSegue" sender:self];
}

- (IBAction)userSwitch:(id)sender
{
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"switchUserSegue" sender:self];
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue
{
    //BFUserListViewController *userListVC = (BFUserListViewController *)segue.sourceViewController;
    //NSLog(@"From Source: %@", userListVC.str);
}

- (void)switchToHistory
{
    [self performSegueWithIdentifier:@"historySegue" sender:self];
}

- (void)switchToOrder
{
    [self performSegueWithIdentifier:@"orderSegue" sender:self];
}

@end
