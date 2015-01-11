//
//  HistoryIndexTableCell.m
//  sterminal
//
//  Created by Wang Long on 1/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "HistoryIndexTableCell.h"
#import "BFCellSelectedBackgroundView.h"

@implementation HistoryIndexTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        BFCellSelectedBackgroundView *backgroundView = [[BFCellSelectedBackgroundView alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = backgroundView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderAmountString:(NSString *)orderAmountString
{
    if(![_orderAmountString isEqualToString:orderAmountString])
    {
        _orderAmountString = [orderAmountString copy];
        _orderAmountLabel.text = _orderAmountString;
    }
}

- (void)setOrderNumberString:(NSString *)orderNumberString
{
    if(![_orderNumberString isEqualToString:orderNumberString])
    {
        _orderNumberString = [orderNumberString copy];
        _orderNumberLabel.text = _orderNumberString;
    }
}

- (void)setOrderDateString:(NSString *)orderDateString
{
    if(![_orderDateString isEqualToString:orderDateString])
    {
        _orderDateString = [orderDateString copy];
        _orderDateLabel.text = _orderDateString;
    }
}
@end
