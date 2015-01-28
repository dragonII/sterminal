//
//  BFActivateProcessViewController.m
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFActivateProcessViewController.h"
#import "BFPreferenceData.h"
#import "defs.h"
#import "UIImageView+AFNetworking.h"

@interface BFActivateProcessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImageView;
@end

@implementation BFActivateProcessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)testLogoLoading
{
    NSArray *productsList = [BFPreferenceData loadProductsArray];
    NSDictionary *productDict = [productsList objectAtIndex:0];
    
    //NSString *imgPath = [productDict objectForKey:ProductImagePathKey];
    NSString *thumbnailPath = [productDict objectForKey:ProductThumbnailPathKey];
    
    [self.storeLogoImageView setImageWithURL:[NSURL URLWithString:thumbnailPath]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self testLogoLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activateClicked:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"userLoginSegue" sender:self];
}
@end
