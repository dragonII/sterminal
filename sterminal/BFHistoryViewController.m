//
//  BFHistoryViewController.m
//  sterminal
//
//  Created by Wang Long on 1/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFHistoryViewController.h"
#import "HistoryIndexTableCell.h"

static int ListModeBasic = 0;
static int ListModeImage = 1;

static const int MenuLevelCategory = 0;
static const int MenuLevelInventory = 1;

static NSString *HistoryIndexCellIdentifier = @"HistoryIndexCell";
static NSString *HistoryItemCellIdentifer = @"HistoryItemCell";

@interface BFHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *totalOrderList;

@property int currentList;
@property int currentMenu;
@property int listMode;

@end


@implementation BFHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *orderFilePath = [documentDirectory stringByAppendingPathComponent:@"order.plist"];
    
    self.totalOrderList = [NSMutableArray arrayWithContentsOfFile:orderFilePath];
    if(self.totalOrderList == nil)
    {
        self.totalOrderList = [[NSMutableArray alloc] init];
    }
    
    [self.orderIndexTable registerClass:[HistoryIndexTableCell class] forCellReuseIdentifier:HistoryIndexCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"HistoryIndexTableCell" bundle:nil];
    [self.orderIndexTable registerNib:nib forCellReuseIdentifier:HistoryIndexCellIdentifier];
    self.orderIndexTable.dataSource = self;
    self.orderIndexTable.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
