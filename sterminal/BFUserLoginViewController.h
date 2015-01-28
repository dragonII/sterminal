//
//  BFUserLoginViewController.h
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defs.h"

@interface BFUserLoginViewController : UIViewController
- (IBAction)userLogin:(id)sender;
- (IBAction)userSwitch:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property HistoryEnumType selectedHistoryType;

- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue;

- (void)switchToHistory;
- (void)switchToOrder;

@end
