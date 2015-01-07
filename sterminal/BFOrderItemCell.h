//
//  BFOrderItemCell.h
//  sterminal
//
//  Created by Wang Long on 1/7/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFOrderItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *productSNLabel;
@property (weak, nonatomic) IBOutlet UILabel *productQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *productAmountLabel;

@property (copy, nonatomic) NSString *productDescriptionStr;
@property (copy, nonatomic) NSString *productSNStr;
@property (copy, nonatomic) NSString *productQuantityStr;
@property (copy, nonatomic) NSString *productAmountStr;
@property (copy, nonatomic) NSString *productImgStr;

@end
