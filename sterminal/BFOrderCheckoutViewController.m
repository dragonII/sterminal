//
//  BFOrderCheckoutViewController.m
//  sterminal
//
//  Created by Wang Long on 1/10/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFOrderCheckoutViewController.h"
#import "BFOrderFinalConfirmViewController.h"

@interface BFOrderCheckoutViewController ()

@property BOOL canPay;

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.totalAmountLabel.text = self.totalAmountString;
    self.receivedAmountString = @"0.00";
    self.receivedAmountLabel.text = self.receivedAmountString;
    
    self.rString = [NSMutableString stringWithString:@""];
    self.canPay = NO;
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

- (void)updateReceivedTextWithNumber:(NSString *)number
{
    if([self.rString length] >= 7) return;
    [self.rString appendString:number];
    [self setReceivedTextColor];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
}

- (void)setReceivedTextColor
{
    UIColor *normalColor = [UIColor colorWithRed:90/255.0f
                                           green:180/255.0f
                                            blue:181/255.0f
                                           alpha:1.0f];
    UIColor *warningColor = [UIColor redColor];
    
    float shouldReceive = [self.totalAmountString floatValue];
    float didReceive = [self.rString floatValue] /100;
    
    NSLog(@"should: %f, did: %f", shouldReceive, didReceive);
    
    if(didReceive >= shouldReceive)
    {
        self.receivedAmountLabel.textColor = normalColor;
        self.canPay = YES;
    } else {
        self.receivedAmountLabel.textColor = warningColor;
        self.canPay = NO;
    }
}


- (IBAction)click1:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"1"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"1"];
}

- (IBAction)click2:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"2"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"2"];
}

- (IBAction)click3:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"3"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"3"];
}

- (IBAction)click4:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"4"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"4"];
}

- (IBAction)click5:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"5"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"5"];
}

- (IBAction)click6:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"6"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"6"];
}

- (IBAction)click7:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"7"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"7"];
}

- (IBAction)click8:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"8"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"8"];
}

- (IBAction)click9:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"9"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"9"];
}

- (IBAction)clickClear:(id)sender
{
    self.rString = [NSMutableString stringWithString:@""];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"orderConfirmSegue"])
    {
        BFOrderFinalConfirmViewController *finalConfirmVC = (BFOrderFinalConfirmViewController *)segue.destinationViewController;
        finalConfirmVC.shouldReceiveString = self.totalAmountString;
        finalConfirmVC.didReceiveString = self.receivedAmountLabel.text;
    }
}

- (IBAction)clickPay:(id)sender
{
    if(self.canPay)
    {
        [self performSegueWithIdentifier:@"orderConfirmSegue" sender:self];
    }
}

- (IBAction)click0:(id)sender
{
    if([self.rString length] == 0)
        return;
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"0"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"0"];
}

- (IBAction)click50:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"50"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"50"];
}

- (IBAction)click20:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"20"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"20"];
}

- (IBAction)click100:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"100"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"100"];
}

- (IBAction)click10:(id)sender
{
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"10"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"10"];
}

- (IBAction)click00:(id)sender
{
    if([self.rString length] == 0)
        return;
    /*
    if([self.rString length] >= 7) return;
    [self.rString appendString:@"00"];
    self.receivedAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.rString floatValue] / 100];
     */
    [self updateReceivedTextWithNumber:@"00"];
}


- (IBAction)closeConfirmView:(UIStoryboardSegue *)segue
{
    
}



@end
