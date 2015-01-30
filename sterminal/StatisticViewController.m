//
//  StatisticViewController.m
//  sterminal
//
//  Created by Wang Long on 1/30/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "StatisticViewController.h"
#import "GradientView.h"
#import "UUChart.h"

@interface StatisticViewController () <UIGestureRecognizerDelegate, UUChartDataSource>

@property (strong, nonatomic) GradientView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *chartContainerView;

@property (strong, nonatomic) UUChart *chartView;

@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.chartContainerView.layer.cornerRadius = 10.0f;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self showStatsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.view);
}

- (IBAction)close:(id)sender
{
    [self dismissFromParentViewController];
}

- (void)presentInParentViewController:(UIViewController *)parentViewController
{
    self.gradientView = [[GradientView alloc] initWithFrame:parentViewController.view.bounds];
    [parentViewController.view addSubview:self.gradientView];
    
    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    //[self didMoveToParentViewController:parentViewController];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
    bounceAnimation.values = @[ @0.7, @1.2, @0.9, @1.0];
    bounceAnimation.keyTimes = @[ @0.0, @0.334, @0.666, @1.0];
    
    bounceAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
        ];
     
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @1.0f;
    fadeAnimation.duration = 0.2f;
    [self.gradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self didMoveToParentViewController:self.parentViewController];
}

- (void)dismissFromParentViewController
{
    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect rect = self.view.bounds;
                         rect.origin.y += rect.size.height;
                         self.view.frame = rect;
                         self.gradientView.alpha = 0.0f;
                     }completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         
                         [self.gradientView removeFromSuperview];
                     }];
}

- (void)showStatsView
{
    /*
    self.statsBackgroundView = [[UIView alloc] init];
    [self.statsBackgroundView setFrame:self.view.bounds];
    
    self.statsBackgroundView.layer.cornerRadius = 10.0f;
    self.statsBackgroundView.layer.shadowOffset = CGSizeZero;
    self.statsBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.statsBackgroundView.layer.shadowOpacity = 0.5f;
    self.statsBackgroundView.layer.shadowRadius = 110;
    self.statsBackgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.view.bounds, -5, -5)].CGPath;
     */
    
    self.chartView = [[UUChart alloc] initwithUUChartDataFrame:self.chartContainerView.frame withSource:self withStyle:UUChartLineStyle];
    
    //[self.statsBackgroundView addSubview:self.chartView];
    //[self.view addSubview:self.statsBackgroundView];
    
    [self.chartView showInView:self.chartContainerView];
}

- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    return @[@"one", @"two", @"three", @"four", @"five", @"six"];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    return @[@[@"23", @"40", @"17", @"5", @"92", @"56"]];
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UURed];
}

- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}

@end
