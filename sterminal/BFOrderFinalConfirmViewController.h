//
//  BFOrderFinalConfirmViewController.h
//  sterminal
//
//  Created by Wang Long on 1/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFOrderFinalConfirmViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *shouldReceiveTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *didReceiveTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *GivenChangeLabel;

@property (copy, nonatomic) NSString *shouldReceiveString;
@property (copy, nonatomic) NSString *didReceiveString;

@end
