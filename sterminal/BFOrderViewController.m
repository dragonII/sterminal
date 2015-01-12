//
//  BFOrderViewController.m
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFOrderViewController.h"
#import "BFOrderItemCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "BFMyOrderItemCollectionCell.h"
#import "BFOrderCheckoutViewController.h"
#import "BFUserLoginViewController.h"

@interface BFOrderViewController ()

@property (strong, nonatomic) NSMutableArray *catagoryList;
@property (strong, nonatomic) NSMutableArray *inventoryList;
@property (strong, nonatomic) NSMutableArray *orderList;
@property (strong, nonatomic) NSMutableArray *currentList;

@property (strong, nonatomic) UICollectionView *productsCollView;

@property int currentMenu;
@property int listMode;
@property float buyCount;

@end

static NSString *BasicCellIdentifier = @"myOrderItemBasicCell";
static NSString *ImageCellIdentifier = @"myOrderItemImgCell";
static NSString *TableCellIdentifier = @"MyOrderCell";

static int ListModeBasic = 0;
static int ListModeImage = 1;

static const int MenuLevelCategory = 0;
static const int MenuLevelInventory = 1;

@implementation BFOrderViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UICollectionView *)productsCollectionView
{
    if(!self.productsCollView)
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.minimumColumnSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        
        /*
        CGRect rect = CGRectMake(self.view.bounds.origin.x,
                                 self.view.bounds.origin.y + 288,
                                 self.view.bounds.size.width - 128,
                                 self.view.bounds.size.height - 588);
         */
        CGRect rect = CGRectMake(self.view.bounds.origin.x,
                                 self.view.bounds.origin.y + 288,
                                 self.view.bounds.size.width - 385,
                                 self.view.bounds.size.height - 334);
        
        self.productsCollView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        self.productsCollView.backgroundColor = [UIColor blackColor];
        self.productsCollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.productsCollView.dataSource = self;
        self.productsCollView.delegate = self;
        self.productsCollView.backgroundColor = [UIColor whiteColor];
        
        [self.productsCollView registerClass:[BFMyOrderItemCollectionCell class] forCellWithReuseIdentifier:BasicCellIdentifier];
        
        UINib *basicNib = [UINib nibWithNibName:@"MyOrderCollCellBasic" bundle:nil];
        [self.productsCollView registerNib:basicNib forCellWithReuseIdentifier:BasicCellIdentifier];
        
        UINib *imageNib = [UINib nibWithNibName:@"MyOrderCollCellImage" bundle:nil];
        [self.productsCollView registerNib:imageNib forCellWithReuseIdentifier:ImageCellIdentifier];
    }
    
    return self.productsCollView;
}

- (UIView *)makeTestView
{
    NSLog(@"width: %f", self.view.bounds.size.width);
    NSLog(@"height: %f", self.view.bounds.size.height);
    CGRect rect = CGRectMake(self.view.bounds.origin.x,
                             self.view.bounds.origin.y + 288,
                             self.view.bounds.size.width - 128,
                             self.view.bounds.size.height - 588);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    NSLog(@"width: %f, height: %f", view.frame.size.width, view.frame.size.height);
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.2f;
    
    return view;
}

- (void)initializeValues
{
    self.currentMenu = MenuLevelCategory;
    self.listMode = ListModeImage;
    self.buyCount = 0.0f;
    
    NSString *pathCategory = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
    NSString *pathIventory = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"plist"];
    self.catagoryList = [NSMutableArray arrayWithContentsOfFile:pathCategory];
    self.inventoryList = [NSMutableArray arrayWithContentsOfFile:pathIventory];
    
    [self.catalogButton setHidden:YES];
    self.totalLabel.text = @"0.00";
    self.taxLabel.text = @"0.00";
    self.discountLabel.text = @"0.00";
    
    self.orderList = [[NSMutableArray alloc] init];
}

- (void)switchToNormal:(id)sender
{
    self.checkoutButton.image = [UIImage imageNamed:@"orderNormalBtn"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"orderCheckoutSegue"])
    {
        BFOrderCheckoutViewController *checkoutVC = (BFOrderCheckoutViewController *)segue.destinationViewController;
        checkoutVC.totalAmountString = [NSString stringWithFormat:@"%@", self.currentAmount.text];
    }
}

- (void)switchToCheckOut:(id)sender
{
    [self performSegueWithIdentifier:@"orderCheckoutSegue" sender:self];
}

- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    self.checkoutButton.image = [UIImage imageNamed:@"checkOrderBtn"];
    
    switch(gestureRecognizer.state)
    {
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"UIGestureRecognizerStateEnded");
            if(self.orderList && [self.orderList count])
            {
                [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(switchToCheckOut:) userInfo:nil repeats:NO];
            } else {
                [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(switchToNormal:) userInfo:nil repeats:NO];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
        default:
            NSLog(@"Unknown Gesture");
            break;
    }
}

- (void)initializeOrderTable
{
    self.orderListTable.rowHeight = 60;
    
    [self.orderListTable registerClass:[BFOrderItemCell class] forCellReuseIdentifier:TableCellIdentifier];
    UINib *nib = [UINib nibWithNibName:@"CustomOrderCell" bundle:nil];
    [self.orderListTable registerNib:nib forCellReuseIdentifier:TableCellIdentifier];
    self.orderListTable.dataSource = self;
    self.orderListTable.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.checkoutButton addGestureRecognizer:tapGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initializeValues];
    
    [self initializeOrderTable];
    
    self.productsCollView = [self productsCollectionView];
    [self.view addSubview:self.productsCollView];
    //UIView *testView = [self makeTestView];
    //[self.view addSubview:testView];
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
    if([self.orderList count] < 1)
    {
        self.totalLabel.text = @"0.00";
        self.taxLabel.text = @"0.00";
        self.discountLabel.text = @"0.00";
        self.currentAmount.text = @"0.00";
    }
    return [self.orderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFOrderItemCell *cell = (BFOrderItemCell *)[self.orderListTable dequeueReusableCellWithIdentifier:TableCellIdentifier forIndexPath:indexPath];
    NSMutableDictionary *dict = [self.orderList objectAtIndex:indexPath.row];
    if(dict)
    {
        cell.productDescriptionStr = [dict objectForKey:@"description"];
        cell.productSNStr = [dict objectForKey:@"sn"];
        cell.productQuantityStr = [dict objectForKey:@"quantity"];
        cell.productAmountStr = [dict objectForKey:@"price"];
        cell.productQuantityStr = [NSString stringWithFormat:@"%@.jpg", [dict objectForKey:@"description"]];
    }
    int i;
    float tAmount = 0.00f;
    
    for(i = 0; i < [self.orderList count]; i++)
    {
        dict = [self.orderList objectAtIndex:i];
        tAmount += [[dict objectForKey:@"price"] floatValue];
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f", tAmount];
    self.taxLabel.text = @"0.00";
    self.currentAmount.text = [NSString stringWithFormat:@"%.2f", tAmount * 1.00f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.orderList objectAtIndex:indexPath.row];
    int i;
    NSMutableDictionary *inDict;
    float price = 1.00f;
    
    for(i = 0; i < [self.currentList count]; i++)
    {
        inDict = [self.currentList objectAtIndex:i];
        if([[dict objectForKey:@"description"] isEqualToString:[inDict objectForKey:@"description"]])
        {
            //price = [[[self.currentList objectAtIndex:i] objectForKey:@"description"] floatValue];
            price = [[[self.currentList objectAtIndex:i] objectForKey:@"price"] floatValue];
            break;
        }
    }
    if(dict)
    {
        int count = 1;
        float amount = 1.00f;
        amount = [[dict objectForKey:@"price"] floatValue];
        count = [[dict objectForKey:@"quantity"] intValue];
        if(count == 1)
        {
            [self.orderList removeObjectAtIndex:indexPath.row];
        } else {
            [dict setObject:[NSString stringWithFormat:@"%d", count - 1] forKey:@"quantity"];
            [dict setObject:[NSString stringWithFormat:@"%.2f", (count - 1) * price] forKey:@"price"];
        }
        count = [[inDict objectForKey:@"quantity"] intValue] + 1;
        [inDict setObject:[NSString stringWithFormat:@"%d", count] forKey:@"quantity"];
    }
    [self.productsCollView reloadData];
    [self.orderListTable reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.productsCollView.collectionViewLayout;
    NSLog(@"currentMenu = %d", self.currentMenu);
    if(self.currentMenu == MenuLevelInventory)
    {
        self.currentList = self.inventoryList;
        [self.catalogButton setHidden:NO];
    } else {
        self.currentList = self.catagoryList;
        [self.catalogButton setHidden:YES];
    }
    
    if(self.listMode == ListModeBasic)
    {
        layout.columnCount = 1;
        return [self.currentList count];
    } else {
        layout.columnCount = 3;
        return [self.currentList count];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0, 0, 0, 0};
    return top;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listMode == ListModeImage)
    {
        return CGSizeMake(100, 110);
    }
    
    return CGSizeMake(self.productsCollView.bounds.size.width, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BFMyOrderItemCollectionCell *cell;
    //NSLog(@"listMode = %d", self.listMode);
    if(self.listMode == ListModeBasic)
    {
        cell = (BFMyOrderItemCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:BasicCellIdentifier forIndexPath:indexPath];
    } else {
        cell = (BFMyOrderItemCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier forIndexPath:indexPath];
    }
    
    if((indexPath.row + 1) % 2)
    {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        if(self.listMode == ListModeBasic)
        {
            cell.backgroundColor = [UIColor colorWithRed:30/255.0f
                                                   green:20/255.0f
                                                    blue:50/255.0f
                                                   alpha:0.05f];
        }
    }
    
    NSMutableDictionary *dict = [self.currentList objectAtIndex:indexPath.row];
    //NSLog(@"dict: %@", dict);
    //NSLog(@"Description: %@", [NSString stringWithFormat:@"%@", [dict objectForKey:@"description"]]);
    //NSLog(@"ImagePath: %@", [NSString stringWithFormat:@"%@.jpg", [dict objectForKey:@"description"]]);
    
    //NSString *testString = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"description"]] copy];
    //NSLog(@"Test String: %@", testString);
    
    if(self.listMode == ListModeImage)
    {
        NSString *path = [NSString stringWithFormat:@"%@.jpg", [dict objectForKey:@"description"]];
        cell.imgPath = path;
    }
    
    switch(self.currentMenu)
    {
        case (MenuLevelCategory):
        {
            NSString *descStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"description"]];
            //cell.descriptionStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"description"]];
            cell.descriptionStr = descStr;
            //cell.descriptionLabel.text = cell.descriptionStr;
            cell.categoryStr = @"";
            cell.quantityStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"quantity"]];
            cell.snStr = @"";
            break;
        }
        case (MenuLevelInventory):
        {
            //dict = [self.currentList objectAtIndex:indexPath.row];
            [self.catalogButton setTitle:[NSString stringWithFormat:@"%@", [dict objectForKey:@"categories"]] forState:UIControlStateNormal];
            cell.descriptionStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"description"]];
            cell.categoryStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"categories"]];
            if([dict objectForKey:@"sn"])
            {
                cell.snStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"sn"]];
            } else {
                cell.snStr = @"";
            }
            cell.quantityStr = [NSString stringWithFormat:@"%@", [dict objectForKey:@"quantity"]];
            break;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *catelogString;
    NSMutableDictionary *dict;
    int i;
    
    switch(self.currentMenu)
    {
        case(MenuLevelCategory):
        {
            catelogString = [[self.catagoryList objectAtIndex:indexPath.row] objectForKey:@"description"];
            
            for(i = 0; i < [self.inventoryList count]; i++)
            {
                dict = [self.inventoryList objectAtIndex:i];
                if([catelogString isEqualToString:[dict objectForKey:@"categories"]])
                {
                    [array addObject:dict];
                }
            }
            self.inventoryList = [NSMutableArray arrayWithArray:array];
            
            self.currentMenu = MenuLevelInventory;
            
            break;
        }
        case(MenuLevelInventory):
        {
            dict = [self.currentList objectAtIndex:indexPath.row];
            int count = 1;
            int index = 0;
            float amount = 1.0f;
            int i;
            BOOL replace = NO;
            
            count = [[dict objectForKey:@"quantity"] intValue];
            if(count == 0) break;
            
            [dict setObject:[NSString stringWithFormat:@"%d", count - 1] forKey:@"quantity"];
            [self.currentList replaceObjectAtIndex:indexPath.row withObject:dict];
            
            count = 1;
            
            NSMutableDictionary *orderItemDict = nil;
            for(i = 0; i < [self.orderList count]; i++)
            {
                if([[dict objectForKey:@"description"] isEqualToString:[[self.orderList objectAtIndex:i] objectForKey:@"description"]])
                {
                    orderItemDict = [self.orderList objectAtIndex:i];
                    index = i;
                    replace = YES;
                    NSLog(@"Yes, ordered before");
                    break;
                }
            }
            
            if(orderItemDict)
            {
                count = [[orderItemDict objectForKey:@"quantity"] intValue] + 1;
                amount = count * [[dict objectForKey:@"price"] floatValue];
            } else {
                orderItemDict = [[NSMutableDictionary alloc] init];
                amount = [[dict objectForKey:@"price"] floatValue];
            }
            
            [orderItemDict setObject:[dict objectForKey:@"description"] forKey:@"description"];
            [orderItemDict setObject:[dict objectForKey:@"sn"] forKey:@"sn"];
            [orderItemDict setObject:[dict objectForKey:@"categories"] forKey:@"categories"];
            [orderItemDict setObject:[NSString stringWithFormat:@"%.2f", amount] forKey:@"price"];
            [orderItemDict setObject:[NSString stringWithFormat:@"%d", count] forKey:@"quantity"];
            if([self.orderList count] && replace)
            {
                NSLog(@"replaced");
                [self.orderList replaceObjectAtIndex:index withObject:orderItemDict];
            } else {
                [self.orderList addObject:orderItemDict];
            }
            
            [self.orderListTable reloadData];
            
            break;
        }
        default:
            break;
    }
    
    [collectionView reloadData];
}

- (IBAction)setListModeBasic:(id)sender
{
    self.listMode = ListModeBasic;
    [self.imageSwitchButton setImage:[UIImage imageNamed:@"imgBtn"] forState:UIControlStateNormal];
    [self.listSwitchButton setImage:[UIImage imageNamed:@"listBtnHot"] forState:UIControlStateNormal];
    
    [self.productsCollView reloadData];
}

- (IBAction)setListModeImage:(id)sender
{
    self.listMode = ListModeImage;
    [self.imageSwitchButton setImage:[UIImage imageNamed:@"imgBtnHot"] forState:UIControlStateNormal];
    [self.listSwitchButton setImage:[UIImage imageNamed:@"listBtn"] forState:UIControlStateNormal];
    
    [self.productsCollView reloadData];
}

- (IBAction)reloadCatalogs:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
    self.catagoryList = [NSMutableArray arrayWithContentsOfFile:path];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"plist"];
    self.inventoryList = [NSMutableArray arrayWithContentsOfFile:path1];
    
    self.currentMenu = MenuLevelCategory;
    
    [self.productsCollView reloadData];
}

- (IBAction)closeCheckoutView:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)closeFinalConfirmation:(UIStoryboardSegue *)segue
{
    //NSLog(@"Final stage confirmed");
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedOrderRecordPath = [documentDirectory stringByAppendingPathComponent:@"OrderRecords.plist"];
    NSMutableArray *savedOrderList = [NSMutableArray arrayWithContentsOfFile:savedOrderRecordPath];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *now = [NSDate date];
    
    if(savedOrderList == nil)
    {
        savedOrderList = [[NSMutableArray alloc] init];
    }
    NSLog(@"order description: %@", [self.orderList description]);
    
    NSMutableDictionary *savedOrderItemDict = [[NSMutableDictionary alloc] init];
    [savedOrderItemDict setObject:[NSString stringWithFormat:@"01%@%02d", [formatter stringFromDate:now], 1] forKey:@"orderNumber"];
    [savedOrderItemDict setObject:[NSDate date] forKey:@"orderDate"];
    [savedOrderItemDict setObject:self.totalLabel.text forKey:@"orderAmount"];
    // TODO: add user who handles this order in dict
    
    [savedOrderItemDict setObject:self.orderList forKey:@"orderItem"];
    
    [savedOrderList addObject:savedOrderItemDict];
    [savedOrderList writeToFile:savedOrderRecordPath atomically:YES];
    NSLog(@"Writing to %@", savedOrderRecordPath);
    [self.orderList removeAllObjects];
    [self.orderListTable reloadData];
}

- (IBAction)cancelFinalConfirmation:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)switchToHistory:(id)sender
{
    BFUserLoginViewController *loginVC = (BFUserLoginViewController *)self.presentingViewController;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [loginVC switchToHistory];
}


@end
