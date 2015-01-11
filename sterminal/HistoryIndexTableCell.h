//
//  HistoryIndexTableCell.h
//  sterminal
//
//  Created by Wang Long on 1/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryIndexTableCell : UITableViewCell

@property (copy, nonatomic) NSString *orderAmountString;
@property (copy, nonatomic) NSString *orderDateString;
@property (copy, nonatomic) NSString *orderPayModeString;
@property (copy, nonatomic) NSString *orderNumberString;

@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@end
