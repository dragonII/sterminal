//
//  BFOrderViewController.h
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface BFOrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *listSwitchButton;
@property (weak, nonatomic) IBOutlet UIButton *imageSwitchButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *inventoryButton;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIImageView *checkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet id catalogButton;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentAmount;

@property (weak, nonatomic) IBOutlet UITableView *orderListTable;
- (IBAction)setListModeBasic:(id)sender;
- (IBAction)setListModeImage:(id)sender;
- (IBAction)reloadCatalogs:(id)sender;

- (IBAction)closeCheckoutView:(UIStoryboardSegue *)segue;
- (IBAction)closeFinalConfirmation:(UIStoryboardSegue *)segue;
- (IBAction)cancelFinalConfirmation:(UIStoryboardSegue *)segue;

@end
