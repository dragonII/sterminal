//
//  BFActiveViewController.m
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFActiveViewController.h"

@interface BFActiveViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) NSMutableString *rString;

@property int activeLabelIndex;
@property (strong, nonatomic) UITextField *currentTextField;

@end

@implementation BFActiveViewController

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
	
    self.activeLabelIndex = 0;
    self.textFields = @[self.storeTextField, self.managerTextField, self.passwordTextField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.rString = [[NSMutableString alloc] init];
    [textField resignFirstResponder];
    self.activeLabelIndex = textField.tag - 2000;
    self.currentTextField = (UITextField *)[self.textFields objectAtIndex:self.activeLabelIndex];
    NSLog(@"Active Index: %d", self.activeLabelIndex);
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activateClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"activateProcesSegue" sender:self.parentViewController];
}

- (IBAction)click1:(id)sender
{
    //if([self.rString length] >= 7) return;
    [self.rString appendString:@"1"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click2:(id)sender
{
    [self.rString appendString:@"2"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click3:(id)sender
{
    [self.rString appendString:@"3"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click4:(id)sender
{
    [self.rString appendString:@"4"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click5:(id)sender
{
    [self.rString appendString:@"5"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click6:(id)sender
{
    [self.rString appendString:@"6"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click7:(id)sender
{
    [self.rString appendString:@"7"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click8:(id)sender
{
    [self.rString appendString:@"8"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click9:(id)sender
{
    [self.rString appendString:@"9"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click0:(id)sender
{
    [self.rString appendString:@"0"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}
@end
