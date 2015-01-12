//
//  BFHistoryViewController.m
//  sterminal
//
//  Created by Wang Long on 1/11/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFHistoryViewController.h"
#import "HistoryIndexTableCell.h"
#import "BFOrderItemCell.h"
#import "BFUserLoginViewController.h"

static int ListModeBasic = 0;
static int ListModeImage = 1;

static const int MenuLevelCategory = 0;
static const int MenuLevelInventory = 1;

static NSString *HistoryIndexCellIdentifier = @"HistoryIndexCell";
static NSString *HistoryItemCellIdentifer = @"HistoryItemCell";

@interface BFHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *totalOrderList;
@property (strong, nonatomic) NSMutableArray *orderList;
@property (strong, nonatomic) NSMutableArray *currentList;

//@property int currentList;
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
    NSString *orderFilePath = [documentDirectory stringByAppendingPathComponent:@"OrderRecords.plist"];
    
    self.totalOrderList = [NSMutableArray arrayWithContentsOfFile:orderFilePath];
    if(self.totalOrderList == nil)
    {
        self.totalOrderList = [[NSMutableArray alloc] init];
    }
    
    // orderIndexTable
    [self.orderIndexTable registerClass:[HistoryIndexTableCell class] forCellReuseIdentifier:HistoryIndexCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"HistoryIndexTableCell" bundle:nil];
    [self.orderIndexTable registerNib:nib forCellReuseIdentifier:HistoryIndexCellIdentifier];
    self.orderIndexTable.dataSource = self;
    self.orderIndexTable.delegate = self;
    
    // orderListTable
    self.orderListTable.rowHeight = 80;
    [self.orderListTable registerClass:[BFOrderItemCell class] forCellReuseIdentifier:HistoryItemCellIdentifer];
    nib = [UINib nibWithNibName:@"OrderItemHistoryCell" bundle:nil];
    [self.orderListTable registerNib:nib forCellReuseIdentifier:HistoryItemCellIdentifer];
    self.orderListTable.dataSource = self;
    self.orderListTable.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.orderIndexTable])
    {
        self.todayAmountLabel.text = @"Today: 0.00";
        if([self.totalOrderList count])
        {
            NSArray *mutableQueryStringComponents = [NSMutableArray array];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderDate" ascending:NO selector:@selector(compare:)];
            mutableQueryStringComponents = [self.totalOrderList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            self.totalOrderList = [NSMutableArray arrayWithArray:mutableQueryStringComponents];
        }
        float totalAmountValue = 0.0f;
        int i;
        for(i = 0; i < [self.totalOrderList count]; i++)
        {
            totalAmountValue += [[[self.totalOrderList objectAtIndex:i] objectForKey:@"orderAmount"] floatValue];
        }
        
        self.subTotalLabel.text = [NSString stringWithFormat:@"%.2f", totalAmountValue];
        self.subDiscountLabel.text = @"0.00";
        self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.subTotalLabel.text floatValue]];
        
        return [self.totalOrderList count];
    } else {
        if(self.orderList)
        {
            return [self.orderList count];
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.orderIndexTable])
    {
        HistoryIndexTableCell *cell;
        cell = (HistoryIndexTableCell *)[tableView dequeueReusableCellWithIdentifier:HistoryIndexCellIdentifier forIndexPath:indexPath];
        NSMutableDictionary *dict = [self.totalOrderList objectAtIndex:indexPath.row];
        cell.orderAmountString = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"orderAmount"] floatValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        [formatter setDateFormat:@"HH:mm aaa"];
        
        cell.orderDateString = [formatter stringFromDate:[dict objectForKey:@"orderDate"]];
        cell.orderNumberString = [dict objectForKey:@"orderNumber"];
        
        return cell;
    } else {
        BFOrderItemCell *cell = (BFOrderItemCell *)[tableView dequeueReusableCellWithIdentifier:HistoryItemCellIdentifer forIndexPath:indexPath];
        NSMutableDictionary *dict = [self.orderList objectAtIndex:indexPath.row];
        if(dict)
        {
            cell.productDescriptionStr = [dict objectForKey:@"description"];
            cell.productSNStr = [dict objectForKey:@"sn"];
            cell.productQuantityStr = [dict objectForKey:@"quantity"];
            cell.productAmountStr = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"price"] floatValue]];
            cell.productImgStr = [NSString stringWithFormat:@"%@.jpg", [dict objectForKey:@"description"]];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.orderIndexTable])
    {
        self.orderList = [[self.totalOrderList objectAtIndex:indexPath.row] objectForKey:@"orderItem"];
        self.subDiscountLabel.text = @"0.00";
        self.subTotalLabel.text = [NSString stringWithFormat:@"%.2f", [[[self.totalOrderList objectAtIndex:indexPath.row] objectForKey:@"orderAmount"] floatValue]];
        self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.subTotalLabel.text floatValue]];
        
        [self.orderListTable reloadData];
    } else {
        float amount = [[[self.orderList objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue];
        int count = [[[self.orderList objectAtIndex:indexPath.row] objectForKey:@"quantity"] intValue];
        self.subTotalLabel.text = [NSString stringWithFormat:@"%.2f", amount * count];
        //self.subTotalLabel.text = [NSString stringWithFormat:@"%.2f", amount * count];
        self.subDiscountLabel.text = @"0.00";
    }
}

- (IBAction)switchToOrder:(id)sender
{
    BFUserLoginViewController *loginVC = (BFUserLoginViewController *)self.presentingViewController;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [loginVC switchToOrder];
}
@end
