//
//  BFActiveViewController.h
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFActiveViewController : UIViewController
- (IBAction)activateClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *storeTextField;
@property (weak, nonatomic) IBOutlet UITextField *managerTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *activateButton;

- (IBAction)click1:(id)sender;
- (IBAction)click2:(id)sender;
- (IBAction)click3:(id)sender;
- (IBAction)click4:(id)sender;
- (IBAction)click5:(id)sender;
- (IBAction)click6:(id)sender;
- (IBAction)click7:(id)sender;
- (IBAction)click8:(id)sender;
- (IBAction)click9:(id)sender;
- (IBAction)click0:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *storeFieldBG;
@property (weak, nonatomic) IBOutlet UIImageView *managerFieldBG;
@property (weak, nonatomic) IBOutlet UIImageView *passwordFieldBG;

@end
