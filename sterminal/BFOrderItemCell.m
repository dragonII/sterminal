//
//  BFOrderItemCell.m
//  sterminal
//
//  Created by Wang Long on 1/7/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFOrderItemCell.h"
#import "UIImageView+AFNetworking.h"

@interface orderItemCellBackground : UIView

@end

@implementation orderItemCellBackground

- (void)drawRect:(CGRect)rect
{
    // Draw a rounded rect bezier path filled with blue
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    [bezierPath setLineWidth:5.0f];
    [[UIColor whiteColor] setStroke];
    
    UIColor *fillColor = [UIColor colorWithRed:0.529f green:0.808f blue:0.922f alpha:1.0f]; //#87CEEB
    [fillColor setFill];
    
    [bezierPath stroke];
    [bezierPath fill];
    CGContextRestoreGState(aRef);
}

@end

@implementation BFOrderItemCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        // change to custom selected background view
        orderItemCellBackground *backgroundView = [[orderItemCellBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = backgroundView;
        self.backgroundColor = [UIColor whiteColor];
        
        for(id obj in self.subviews)
        {
            if([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *)obj;
                scroll.delaysContentTouches = NO;
                break;
            }
        }
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProductDescriptionStr:(NSString *)productDescriptionStr
{
    if(![_productDescriptionStr isEqualToString:productDescriptionStr])
    {
        _productDescriptionStr = [productDescriptionStr copy];
        _productDescriptionLabel.text = _productDescriptionStr;
    }
}

- (void)setProductAmountStr:(NSString *)productAmountStr
{
    if(![_productAmountStr isEqualToString: productAmountStr])
    {
        _productAmountStr = [productAmountStr copy];
        _productAmountLabel.text = _productAmountStr;
    }
}

- (void)setProductSNStr:(NSString *)productSNStr
{
    if(![_productSNStr isEqualToString:productSNStr])
    {
        _productSNStr = [productSNStr copy];
        _productSNLabel.text = _productSNStr;
    }
}

- (void)setProductQuantityStr:(NSString *)productQuantityStr
{
    if(![_productQuantityStr isEqualToString:productQuantityStr])
    {
        _productQuantityStr = [productQuantityStr copy];
        _productQuantityLabel.text = _productQuantityStr;
    }
}

- (void)setProductImgStr:(NSString *)productImgStr
{
    if(![_productImgStr isEqualToString:productImgStr])
    {
        _productImgStr = productImgStr;
        //_productImg.image = [UIImage imageNamed:_productImgStr];
        [_productImg setImageWithURL:[NSURL URLWithString:productImgStr]];
    }
}

@end
