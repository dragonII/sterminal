//
//  BFOrderCheckoutViewController.h
//  sterminal
//
//  Created by Wang Long on 1/10/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFOrderCheckoutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivedAmountLabel;


- (IBAction)click1:(id)sender;
- (IBAction)click2:(id)sender;
- (IBAction)click3:(id)sender;
- (IBAction)click4:(id)sender;
- (IBAction)click5:(id)sender;
- (IBAction)click6:(id)sender;
- (IBAction)click7:(id)sender;
- (IBAction)click8:(id)sender;
- (IBAction)click9:(id)sender;
- (IBAction)clickClear:(id)sender;
- (IBAction)clickPay:(id)sender;
- (IBAction)click0:(id)sender;

@property (copy, nonatomic) NSString *totalAmountString;
@property (copy, nonatomic) NSString *receivedAmountString;
@property (strong, nonatomic) NSMutableString *rString;

- (IBAction)closeConfirmView:(UIStoryboardSegue *)segue;

@end
