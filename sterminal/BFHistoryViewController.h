//
//  BFHistoryViewController.h
//  sterminal
//
//  Created by Wang Long on 1/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defs.h"

@interface BFHistoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *orderIndexTable;
@property (weak, nonatomic) IBOutlet UITableView *orderListTable;

@property (weak, nonatomic) IBOutlet UILabel *todayAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *subDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property HistoryEnumType selectedHistoryType;

//- (IBAction)switchToOrder:(id)sender;


@end
