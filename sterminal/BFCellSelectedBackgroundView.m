//
//  BFCellSelectedBackgroundView.m
//  sterminal
//
//  Created by Wang Long on 1/12/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFCellSelectedBackgroundView.h"

@implementation BFCellSelectedBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
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
                                         alpha:1.0f];
    [fillColor setFill];
    
    [bezierPath stroke];
    [bezierPath fill];
    
    CGContextRestoreGState(aRef);
}


@end
