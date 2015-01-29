//
//  BFMyOrderItemCollectionCell.h
//  sterminal
//
//  Created by Wang Long on 1/7/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFMyOrderItemCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *snLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (copy, nonatomic) NSString *descriptionStr;
@property (copy, nonatomic) NSString *snStr;
@property (copy, nonatomic) NSString *quantityStr;
@property (copy, nonatomic) NSString *categoryStr;
@property (copy, nonatomic) NSString *imgPath;
@property (copy, nonatomic) NSString *priceStr;

@end
