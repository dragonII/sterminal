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
#import "BFPreferenceData.h"
#import "defs.h"

@interface BFOrderViewController ()

@property (strong, nonatomic) NSMutableArray *catagoryList;
@property (strong, nonatomic) NSMutableArray *inventoryList;
@property (strong, nonatomic) NSMutableArray *orderList;
@property (strong, nonatomic) NSMutableArray *currentList;

@property (strong, nonatomic) NSArray *productsArray;

@property (strong, nonatomic) NSMutableDictionary *inventoryDict;

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


- (void)initializeValues
{
    // No CATEGORY MENU, ARRAY AT ALL!
    //self.currentMenu = MenuLevelCategory;
    self.currentMenu = MenuLevelInventory;
    self.listMode = ListModeImage;
    self.buyCount = 0.0f;
    
    NSString *pathCategory = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
    NSString *pathIventory = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"plist"];
    self.catagoryList = [NSMutableArray arrayWithContentsOfFile:pathCategory];
    self.inventoryList = [NSMutableArray arrayWithContentsOfFile:pathIventory];
    
    self.productsArray = [BFPreferenceData loadProductsArray];
    
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
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
        cell.productDescriptionStr = [dict objectForKey:OrderProductNameKey];
        cell.productSNStr = [dict objectForKey:OrderProductIDKey];
        cell.productQuantityStr = [dict objectForKey:OrderProductQuantityKey];
        cell.productAmountStr = [dict objectForKey:OrderProductPriceKey];
        //cell.productImgStr = [dict objectForKey:OrderProductImagePathKey];
        cell.productImgStr = [dict objectForKey:OrderProductThumbnailPathKey];
    }
    int i;
    float tAmount = 0.00f;
    
    for(i = 0; i < [self.orderList count]; i++)
    {
        dict = [self.orderList objectAtIndex:i];
        tAmount += [[dict objectForKey:OrderProductPriceKey] floatValue];
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f", tAmount];
    self.taxLabel.text = @"0.00";
    self.currentAmount.text = [NSString stringWithFormat:@"%.2f", tAmount * 1.00f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.orderList objectAtIndex:indexPath.row];
    NSMutableDictionary *inDict;
    float price = 1.00f;
    
    
    for(int i = 0; i < [self.productsArray count]; i++)
    {
        inDict = [self.productsArray objectAtIndex:i];
        if([[dict objectForKey:OrderProductNameKey] isEqualToString:[inDict objectForKey:ProductNameKey]])
        {
            //price = [[[self.currentList objectAtIndex:i] objectForKey:@"description"] floatValue];
            //price = [[[self.productsArray objectAtIndex:i] objectForKey:@"price"] floatValue];
            price = [[inDict objectForKey:ProductPriceKey] floatValue];
            break;
        }
    }
     
    
    if(dict)
    {
        int count = 1;
        float amount = 1.00f;
        amount = [[dict objectForKey:OrderProductPriceKey] floatValue];
        count = [[dict objectForKey:OrderProductQuantityKey] intValue];
        if(count == 1)
        {
            [self.orderList removeObjectAtIndex:indexPath.row];
        } else {
            [dict setObject:[NSString stringWithFormat:@"%d", count - 1] forKey:OrderProductQuantityKey];
            [dict setObject:[NSString stringWithFormat:@"%.2f", (count - 1) * price] forKey:OrderProductPriceKey];
        }
        //count = [[inDict objectForKey:@"quantity"] intValue] + 1;
        //[inDict setObject:[NSString stringWithFormat:@"%d", count] forKey:@"quantity"];
    }
    // We don't have quantity in productCollView, so no need to update
    //[self.productsCollView reloadData];
    
    [self.orderListTable reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.productsCollView.collectionViewLayout;
    
    [self.catalogButton setHidden:YES];
    
    if(self.listMode == ListModeBasic) // No big image
    {
        layout.columnCount = 1;
        return [self.productsArray count];
    } else {
        layout.columnCount = 3;
        return [self.productsArray count];
    }
    /*
     // No category List at all
    NSLog(@"currentMenu = %d", self.currentMenu);
    if(self.currentMenu == MenuLevelInventory)
    {
        // from fullhouse
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
     */

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
    
    NSDictionary *dict = [self.productsArray objectAtIndex:indexPath.row];
    
    if(self.listMode == ListModeImage)
    {
        // Get product image
        cell.imgPath = [NSString stringWithFormat:@"%@", [dict objectForKey:ProductImagePathKey]];
    }
#warning 暂缺产品说明，产品库存

    cell.descriptionStr = [NSString stringWithFormat:@"%@", [dict objectForKey:ProductNameKey]]; //此字段实际为产品名称
    cell.categoryStr = @"";
    if([dict objectForKey:ProductIDKey])
    {
        cell.snStr = [NSString stringWithFormat:@"%@", [dict objectForKey:ProductIDKey]];
    } else {
        cell.snStr = @"";
    }
    cell.quantityStr = @"";
    
    return cell;
    
    /*
     // NO CATEGORY LIST AT ALL! //
     
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
     */
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSMutableArray *array = [[NSMutableArray alloc] init];
    //NSString *catelogString;
    BOOL replace = NO;
    float amount = 0.0f;
    int index;
    
    NSDictionary *dict = [self.productsArray objectAtIndex:indexPath.row];
    
    int count = 1;
    
    NSMutableDictionary *orderItemDict = nil;
    for(int i = 0; i < [self.orderList count]; i++)
    {
        if([[dict objectForKey:ProductNameKey] isEqualToString:[[self.orderList objectAtIndex:i] objectForKey:ProductNameKey]])
        {
            orderItemDict = [self.orderList objectAtIndex:i];
            replace = YES;
            index = i;
            NSLog(@"Ordered before");
            break;
        }
    }
    
    if(orderItemDict)
    {
        count = [[orderItemDict objectForKey:OrderProductQuantityKey] intValue] + 1;
        amount = [[dict objectForKey:ProductPriceKey] floatValue] * count;
    } else {
        orderItemDict = [[NSMutableDictionary alloc] init];
        amount = [[dict objectForKey:ProductPriceKey] floatValue];
    }
    
    [orderItemDict setObject:[dict objectForKey:ProductNameKey] forKey:OrderProductNameKey];
    [orderItemDict setObject:[dict objectForKey:ProductIDKey] forKey:OrderProductIDKey];
    [orderItemDict setObject:[NSString stringWithFormat:@"%.2f", amount] forKey:OrderProductPriceKey];
    [orderItemDict setObject:[NSString stringWithFormat:@"%d", count] forKey:OrderProductQuantityKey];
    [orderItemDict setObject:[dict objectForKey:ProductImagePathKey] forKey:OrderProductImagePathKey];
    [orderItemDict setObject:[dict objectForKey:ProductThumbnailPathKey] forKey:OrderProductThumbnailPathKey];
    
    if([self.orderList count] && replace)
    {
        [self.orderList replaceObjectAtIndex:index withObject:orderItemDict];
    } else {
        [self.orderList addObject:orderItemDict];
    }
    
    [self.orderListTable reloadData];
}

    /*
     // NO CATEGORY MENU, LEVEL, ARRAY AT ALL! //
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
     */

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
    [self.checkoutButton setImage:[UIImage imageNamed:@"orderNormalBtn"]];
}

- (IBAction)closeFinalConfirmation:(UIStoryboardSegue *)segue
{
    //NSLog(@"Final stage confirmed");
    self.checkoutButton.image = [UIImage imageNamed:@"orderNormalBtn"];
    
    /*
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedOrderRecordPath = [documentDirectory stringByAppendingPathComponent:@"OrderRecords.plist"];
    NSMutableArray *savedOrderList = [NSMutableArray arrayWithContentsOfFile:savedOrderRecordPath];
     */
    NSMutableArray *savedOrderList = [BFPreferenceData loadOrderRecordsArray];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *now = [NSDate date];
    
    if(savedOrderList == nil)
    {
        savedOrderList = [[NSMutableArray alloc] init];
    }
    //NSLog(@"order description: %@", [self.orderList description]);
    
    NSMutableDictionary *savedOrderItemDict = [[NSMutableDictionary alloc] init];
    [savedOrderItemDict setObject:[NSString stringWithFormat:@"01%@%02d", [formatter stringFromDate:now], 1] forKey:OrderRecordNumberKey];
    [savedOrderItemDict setObject:[NSDate date] forKey:OrderRecordDateKey];
    [savedOrderItemDict setObject:self.totalLabel.text forKey:OrderRecordAmountKey];
    // TODO: add user who handles this order in dict
    
    [savedOrderItemDict setObject:self.orderList forKey:OrderRecordItemKey];
    
    [savedOrderList addObject:savedOrderItemDict];
    
    [BFPreferenceData saveOrderRecordsArray:savedOrderList];
    
    //[savedOrderList writeToFile:savedOrderRecordPath atomically:YES];
    //NSLog(@"Writing to %@", savedOrderRecordPath);
    [self.orderList removeAllObjects];
    [self.orderListTable reloadData];
}

- (IBAction)cancelFinalConfirmation:(UIStoryboardSegue *)segue
{
    [self.checkoutButton setImage:[UIImage imageNamed:@"orderNormalBtn"]];
}

- (IBAction)switchToHistory:(id)sender
{
    BFUserLoginViewController *loginVC = (BFUserLoginViewController *)self.presentingViewController;
    
    UIButton *button = (UIButton *)sender;
    if(button.tag == 31)
        loginVC.selectedHistoryType = HistoryTypeOnline;
    if(button.tag == 32)
        loginVC.selectedHistoryType = HistoryTypeOffline;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [loginVC switchToHistory];
}


@end
