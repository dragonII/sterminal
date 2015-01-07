//
//  BFMyOrderItemCollectionCell.m
//  sterminal
//
//  Created by Wang Long on 1/7/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFMyOrderItemCollectionCell.h"

@interface ItemCellBackground : UIView

@end

@interface ItemCellBackground2 : UIView

@end

@implementation ItemCellBackground

- (void)drawRect:(CGRect)rect
{
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    [bezierPath setLineWidth:5.0f];
    [[UIColor whiteColor] setStroke];
    
    UIColor *fillColor = [UIColor colorWithRed:0.529f
                                         green:0.808f
                                          blue:0.922f
                                         alpha:1.0f]; // #87CEEB
    [fillColor setFill];
    
    [bezierPath stroke];
    [bezierPath fill];
    
    CGContextRestoreGState(aRef);
}

@end

@implementation ItemCellBackground2

- (void)drawRect:(CGRect)rect
{
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    [bezierPath setLineWidth:10.0f];
    [[UIColor whiteColor] setStroke];
    
    UIColor *fillColor = [UIColor colorWithRed:248/255.0f
                                         green:248/255.0f
                                          blue:248/255.0f
                                         alpha:1.0f]; // #87CEEB
    [fillColor setFill];
    
    [bezierPath stroke];
    [bezierPath fill];
    
    CGContextRestoreGState(aRef);
}

@end

@implementation BFMyOrderItemCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
        ItemCellBackground *backgroundView = [[ItemCellBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = backgroundView;
        
        ItemCellBackground2 *backgroundView2 = [[ItemCellBackground2 alloc] initWithFrame:CGRectZero];
        self.backgroundView = backgroundView2;
        
        for(id obj in self.subviews)
        {
            if([NSStringFromClass([obj class]) isEqualToString:@"UICollectionViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *)obj;
                scroll.delaysContentTouches = NO;
                break;
            }
        }
    }
    return self;
}

- (void)setDescriptionStr:(NSString *)descriptionStr
{
    if(![_descriptionStr isEqualToString:descriptionStr])
    {
        _descriptionStr = [descriptionStr copy];
        _descriptionLabel.text = _descriptionStr;
    }
}

- (void)setCategoryStr:(NSString *)categoryStr
{
    if(![_categoryStr isEqualToString:categoryStr])
    {
        _categoryStr = [categoryStr copy];
        _categoryLabel.text = _categoryStr;
    }
}

- (void)setQuantityStr:(NSString *)quantityStr
{
    if(![_quantityStr isEqualToString:quantityStr])
    {
        _quantityStr = [quantityStr copy];
        _quantityLabel.text = _quantityStr;
    }
}

- (void)setSnStr:(NSString *)snStr
{
    if(![_snStr isEqualToString:snStr])
    {
        _snStr = [snStr copy];
        _snLabel.text = _snStr;
    }
}

- (void)setImgPath:(NSString *)imgPath
{
    if(![_imgPath isEqualToString:imgPath])
    {
        _imgPath = [imgPath copy];
        _imageView.image = [UIImage imageNamed:_imgPath];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
