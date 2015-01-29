//
//  BFUserLoginViewController.m
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFUserLoginViewController.h"
#import "BFUserListViewController.h"
//#import "BFHistoryViewController.h"

#import "AFNetworking.h"

@interface BFUserLoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableString *rString;
@property (weak, nonatomic) IBOutlet UIImageView *inputViewBG;

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
    
    [self.inputViewBG setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rString = [[NSMutableString alloc] init];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.rString = [[NSMutableString alloc] init];
    [textField resignFirstResponder];
    [self.inputViewBG setHidden:NO];
    return NO;
}

- (IBAction)click1:(id)sender
{
    [self.rString appendString:@"1"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click2:(id)sender
{
    [self.rString appendString:@"2"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click3:(id)sender
{
    [self.rString appendString:@"3"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click4:(id)sender
{
    [self.rString appendString:@"4"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click5:(id)sender
{
    [self.rString appendString:@"5"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click6:(id)sender
{
    [self.rString appendString:@"6"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click7:(id)sender
{
    [self.rString appendString:@"7"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click8:(id)sender
{
    [self.rString appendString:@"8"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click9:(id)sender
{
    [self.rString appendString:@"9"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click0:(id)sender
{
    [self.rString appendString:@"0"];
    self.passwordTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}


- (IBAction)userLogin:(id)sender
{
    /*
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
     */
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if([segue.identifier isEqualToString:@"historySegue"])
    {
        BFHistoryViewController *historyVC = (BFHistoryViewController *)segue.destinationViewController;
        historyVC.selectedHistoryType = self.selectedHistoryType;
    }
     */
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
