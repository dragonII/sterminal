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
//#import "BFUserLoginViewController.h"
#import "BFPreferenceData.h"
//#import "UUChart.h"

#import "StatisticViewController.h"


//static const int MenuLevelCategory = 0;
//static const int MenuLevelInventory = 1;

static NSString *HistoryIndexCellIdentifier = @"HistoryIndexCell";
static NSString *HistoryItemCellIdentifer = @"HistoryItemCell";


@interface BFHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *totalOrderList;
@property (strong, nonatomic) NSMutableArray *orderList;

@property (weak, nonatomic) IBOutlet UIButton *onlineSwitchButton;
@property (weak, nonatomic) IBOutlet UIButton *orderSwitchButton;
@property (weak, nonatomic) IBOutlet UIButton *offlineSwitchButton;

@property (weak, nonatomic) IBOutlet UIButton *statisticButton;

@property (strong, nonatomic) UIView *statsBackgroundView;
//@property (strong, nonatomic) UUChart *chartView;

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    switch (self.selectedHistoryType)
    {
        case HistoryTypeOffline:
            [self.offlineSwitchButton setBackgroundImage:[UIImage imageNamed:@"bottomButtonFrameBoder"]
                                                forState:UIControlStateNormal];
            break;
        case HistoryTypeOnline:
            [self.onlineSwitchButton setBackgroundImage:[UIImage imageNamed:@"bottomButtonFrameBoder"]
                                               forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.statisticButton setHidden:YES];
	
    if(self.selectedHistoryType == HistoryTypeOffline)
    {
        self.totalOrderList = [BFPreferenceData loadOrderRecordsArray];
    
        if(self.totalOrderList == nil)
        {
            self.totalOrderList = [[NSMutableArray alloc] init];
        }
    }
    
    self.orderList = nil;
    
    [self calculateAmountOfToday];
    
    // orderIndexTable
    self.orderIndexTable.rowHeight = 47;
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

- (void)calculateAmountOfToday
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger today_day = [components day];
    NSInteger today_month = [components month];
    NSInteger today_year = [components year];
    //NSLog(@"year: %d, month:%d, day:%d", today_day, today_month, today_year);
    
    float todayTotalAmount = 0.0f;

    
    if([self.totalOrderList count] > 0)
    {
        for(NSDictionary *dict in self.totalOrderList)
        {
            NSDateComponents *dateComponentsFromOrder = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[dict objectForKey:OrderRecordDateKey]];
            NSInteger order_day = [dateComponentsFromOrder day];
            NSInteger order_month = [dateComponentsFromOrder month];
            NSInteger order_year = [dateComponentsFromOrder year];
            
            if(today_year == order_year &&
               today_month == order_month &&
               today_day == order_day)
            {
                todayTotalAmount += [[dict objectForKey:OrderRecordAmountKey] floatValue];
            }
        }
        
    }
    self.todayAmountLabel.text = [NSString stringWithFormat:@"今天: %.2f", todayTotalAmount];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.orderIndexTable])
    {
        //self.todayAmountLabel.text = @"今天: 0.00";
        if([self.totalOrderList count])
        {
            NSArray *mutableQueryStringComponents;// = [NSMutableArray array];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:OrderRecordDateKey ascending:NO selector:@selector(compare:)];
            mutableQueryStringComponents = [self.totalOrderList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            self.totalOrderList = [NSMutableArray arrayWithArray:mutableQueryStringComponents];
        }
        float totalAmountValue = 0.0f;
        int i;
        for(i = 0; i < [self.totalOrderList count]; i++)
        {
            totalAmountValue += [[[self.totalOrderList objectAtIndex:i] objectForKey:OrderRecordAmountKey] floatValue];
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
        cell.orderAmountString = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:OrderRecordAmountKey] floatValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        [formatter setDateFormat:@"MM-dd HH:mm aaa"];
        
        cell.orderDateString = [formatter stringFromDate:[dict objectForKey:OrderRecordDateKey]];
        cell.orderNumberString = [dict objectForKey:OrderRecordNumberKey];
        
        return cell;
    } else {
        BFOrderItemCell *cell = (BFOrderItemCell *)[tableView dequeueReusableCellWithIdentifier:HistoryItemCellIdentifer forIndexPath:indexPath];
        NSMutableDictionary *dict = [self.orderList objectAtIndex:indexPath.row];
        if(dict)
        {
            cell.productDescriptionStr = [dict objectForKey:OrderProductNameKey];
            cell.productSNStr = [dict objectForKey:OrderProductIDKey];
            cell.productQuantityStr = [dict objectForKey:OrderProductQuantityKey];
            cell.productAmountStr = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:OrderProductPriceKey] floatValue]];
            cell.productImgStr = [dict objectForKey:OrderProductThumbnailPathKey];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.orderIndexTable])
    {
        self.orderList = [[self.totalOrderList objectAtIndex:indexPath.row] objectForKey:OrderRecordItemKey];
        self.subDiscountLabel.text = @"0.00";
        self.subTotalLabel.text = [NSString stringWithFormat:@"%.2f", [[[self.totalOrderList objectAtIndex:indexPath.row] objectForKey:OrderRecordAmountKey] floatValue]];
        self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.subTotalLabel.text floatValue]];
        
        [self.orderListTable reloadData];
    } else {
        float amount = [[[self.orderList objectAtIndex:indexPath.row] objectForKey:OrderProductPriceKey] floatValue];
        int count = [[[self.orderList objectAtIndex:indexPath.row] objectForKey:OrderProductQuantityKey] intValue];
        self.subTotalLabel.text = [NSString stringWithFormat:@"%.2f", amount * count];
        self.subDiscountLabel.text = @"0.00";
    }
}

- (IBAction)switchToOnline:(id)sender
{
    [self.offlineSwitchButton setBackgroundImage:nil
                                        forState:UIControlStateNormal];
    [self.onlineSwitchButton setBackgroundImage:[UIImage imageNamed:@"bottomButtonFrameBoder"]
                                       forState:UIControlStateNormal];
    
    self.totalOrderList = nil;
    self.orderList = nil;
    
    [self.orderIndexTable reloadData];
    [self.orderListTable reloadData];
    [self calculateAmountOfToday];
}

- (IBAction)switchToOffline:(id)sender
{
    [self.onlineSwitchButton setBackgroundImage:nil
                                       forState:UIControlStateNormal];
    [self.offlineSwitchButton setBackgroundImage:[UIImage imageNamed:@"bottomButtonFrameBoder"]
                                        forState:UIControlStateNormal];
    
    self.totalOrderList = [BFPreferenceData loadOrderRecordsArray];
        
    if(self.totalOrderList == nil)
    {
        self.totalOrderList = [[NSMutableArray alloc] init];
    }
    
    self.orderList = nil;
    
    [self.orderIndexTable reloadData];
    [self.orderListTable reloadData];
    [self calculateAmountOfToday];
}

/*
- (IBAction)switchToOrder:(id)sender
{
    BFUserLoginViewController *loginVC = (BFUserLoginViewController *)self.presentingViewController;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [loginVC switchToOrder];
}
 */
- (IBAction)statClicked:(id)sender
{
    //[self showStatsView];
    
    StatisticViewController *statController = [[StatisticViewController alloc] initWithNibName:@"StatisticViewController" bundle:nil];
    
    [statController presentInParentViewController:self];
}


- (IBAction)unwindToHistoryView:(UIStoryboardSegue *)segue
{
    
}

@end
