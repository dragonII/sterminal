//
//  BFOrderCheckoutViewController.m
//  sterminal
//
//  Created by Wang Long on 1/10/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFOrderCheckoutViewController.h"

@interface BFOrderCheckoutViewController ()

@end

@implementation BFOrderCheckoutViewController

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
    
    self.totalAmountLabel.text = self.totalAmountString;
    self.receivedAmountString = @"0.00";
    self.receivedAmountLabel.text = self.receivedAmountString;
    
    self.rString = [NSMutableString stringWithString:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTotalAmountString:(NSString *)totalAmountString
{
    if(![_totalAmountString isEqualToString:totalAmountString])
    {
        _totalAmountString = [totalAmountString copy];
        _totalAmountLabel.text = _totalAmountString;
    }
}

- (void)setReceivedAmountString:(NSString *)receivedAmountString
{
    if(![_receivedAmountString isEqualToString:receivedAmountString])
    {
        _receivedAmountString = [receivedAmountString copy];
        _receivedAmountLabel.text = _receivedAmountString;
    }
}


- (IBAction)click1:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"1"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)click2:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"2"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)click3:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"3"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)click4:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"4"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)click5:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"5"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)click6:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"6"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)click7:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"7"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)click8:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"8"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)click9:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"9"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (IBAction)clickClear:(id)sender
{
    self.rString = [NSMutableString stringWithString:@""];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue]];
}

- (IBAction)clickPay:(id)sender
{
    [self performSegueWithIdentifier:@"orderConfirmSegue" sender:self];
}

- (IBAction)click0:(id)sender
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"0"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}


- (IBAction)closeConfirmView:(UIStoryboardSegue *)segue
{
    
}

@end
