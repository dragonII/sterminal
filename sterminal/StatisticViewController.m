//
//  StatisticViewController.m
//  sterminal
//
//  Created by Wang Long on 1/30/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "StatisticViewController.h"
#import "GradientView.h"

@interface StatisticViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) GradientView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *chartContainerView;

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
    
    /*
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [self.gradientView removeFromSuperview];
     */
}

@end
