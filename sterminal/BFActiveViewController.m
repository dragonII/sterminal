//
//  BFActiveViewController.m
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFActiveViewController.h"
#import "AFNetworking.h"
#import "BFAppDelegate.h"
#import "BFPreferenceData.h"
#import "defs.h"

static NSString *WrongUserOrPassword = @"<rest name=\"rest\">2</rest>";
static NSString *NoSuchUser = @"<rest name=\"rest\">0</rest>";
static NSString *LoginOK = @"<rest name=\"rest\">1</rest>";
static NSString *LockedAccount = @"<rest name=\"rest\">3</rest>";


static NSString *GarbageString = @"Thread was being aborted.";


@interface BFActiveViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UIView *waitingIndicatorView;

@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) NSArray *inputFields;
@property (strong, nonatomic) NSMutableString *rString;

@property int activeLabelIndex;
@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;
@property (strong, nonatomic) NSDictionary *loginStatusDict;

@property (strong, nonatomic) BFAppDelegate *appDelegate;

@property (nonatomic) NSInteger loginStatusCode;

@property (copy, nonatomic) NSString *storeID;
@property (copy, nonatomic) NSString *managerID;
@property (copy, nonatomic) NSString *managerPWD;

@property dispatch_group_t retrieveGroup;
@property dispatch_group_t loginGroup;

@end

@implementation BFActiveViewController

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
	
    self.activeLabelIndex = 0;
    self.textFields = @[self.storeTextField, self.managerTextField, self.passwordTextField];
    self.inputFields = @[self.storeFieldBG, self.managerFieldBG, self.passwordFieldBG];
    
    for(int i = 0; i < [self.inputFields count]; i++)
    {
        [[self.inputFields objectAtIndex:i] setHidden:YES];
    }
    
    /*
    NSURL *url = [NSURL URLWithString:baseURLString];
    self.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    self.httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.httpSessionManager.responseSerializer.acceptableContentTypes = [self.httpSessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"html/text"];
     */
    self.httpSessionManager = [BFAppDelegate sharedHttpSessionManager];
    
    self.loginStatusDict = @{LoginOK: [NSNumber numberWithInteger:LoginOKValue],
                             WrongUserOrPassword: [NSNumber numberWithInteger:LoginWrongUserOrPasswordValue],
                             NoSuchUser: [NSNumber numberWithInteger:LoginNoSuchUser],
                             LockedAccount: [NSNumber numberWithInteger:LoginUserLocked]};
    self.loginStatusCode = LoginInitValue;
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)setLastOperationTimeStamp
{
    NSTimeInterval lastTimeStamp = self.appDelegate.lastOperationTimeStamp;
    NSTimeInterval currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    
    if(currentTimeStamp - lastTimeStamp > 600)
    {
        [self.appDelegate setLastOperationTimeStamp:currentTimeStamp];
        NSLog(@"Setting timestamp done: %f", currentTimeStamp);
    } else {
        // Login again
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.rString = [[NSMutableString alloc] init];
    //[textField resignFirstResponder];
    self.activeLabelIndex = textField.tag - 2000;
    self.currentTextField = (UITextField *)[self.textFields objectAtIndex:self.activeLabelIndex];
    
    NSLog(@"Active Index: %d", self.activeLabelIndex);
    
    for(int i = 0; i < [self.inputFields count]; i++)
    {
        if(i == self.activeLabelIndex)
        {
            [[self.inputFields objectAtIndex:i] setHidden:NO];
        } else {
            [[self.inputFields objectAtIndex:i] setHidden:YES];
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

- (void)loginWithUsername:(NSString *)username Password:(NSString *)password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"user"] = username;
    params[@"password"] = password;
    
    [self.httpSessionManager POST:@"login.ds"
                       parameters:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                              //NSLog(@"responseString; %@", responseString);
                              [self getResultByString:responseString];
                              if(_loginStatusCode == LoginOKValue)
                              {
                                  [self.appDelegate setLastOperationTimeStamp:[[NSDate date] timeIntervalSince1970]];
                              }
                          }failure:^(NSURLSessionDataTask *task, NSError *error) {
                              NSLog(@"Error: %@", [error localizedDescription]);
                          }];
}

- (void)performLoginWithUsername:(NSString *)username Password:(NSString *)password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"user"] = username;
    params[@"password"] = password;
    
    dispatch_group_enter(_loginGroup);
    
    if([username length] == 0 || [password length] == 0)
    {
        _loginStatusCode = LoginNoUserOrPassword;
        dispatch_group_leave(_loginGroup);
        return;
    }
    
    [self.httpSessionManager POST:@"mblogin/mblogin.ds"
                       parameters:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                              //NSLog(@"responseString: %@", responseString);
                              [self getResultByString:responseString];
                              NSLog(@"Login Status Code: %ld", (long)_loginStatusCode);
                              if(_loginStatusCode == LoginOKValue)
                              {
                                  [self.appDelegate updateLastOperationTimeStamp];
                              }
                              dispatch_group_leave(_loginGroup);
                          }failure:^(NSURLSessionDataTask *task, NSError *error) {
                              NSLog(@"Error: %@", [error localizedDescription]);
                              dispatch_group_leave(_loginGroup);
                          }];
}

- (void)getStoreInformation
{
    dispatch_group_enter(_retrieveGroup);
    
    [self.httpSessionManager GET:@"myinfo/shopinfolist.ds"
                      parameters:nil
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             [self.appDelegate updateLastOperationTimeStamp];
                             [self parseStoreJson:responseObject];
                             dispatch_group_leave(_retrieveGroup);
                         }failure:^(NSURLSessionDataTask *task, NSError *error) {
                             NSLog(@"Error: %@", [error localizedDescription]);
                             dispatch_group_leave(_retrieveGroup);
                         }];
}

- (void)getGoodsInformation
{
    dispatch_group_enter(_retrieveGroup);
    
    [self.httpSessionManager GET:@"lsproduct/product.ds"
                      parameters:nil
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             [self parseGoodsJson:responseObject];
                             dispatch_group_leave(_retrieveGroup);
                         }failure:^(NSURLSessionDataTask *task, NSError *error) {
                             NSLog(@"Error: %@", [error localizedDescription]);
                             dispatch_group_leave(_retrieveGroup);
                         }];
    
}

- (void)getStaffInformation
{
    dispatch_group_enter(_retrieveGroup);
    
    [self.httpSessionManager GET:@"employee/listemployee_json.ds"
                      parameters:nil
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             [self parseStaffJson:responseObject];
                             dispatch_group_leave(_retrieveGroup);
                         }failure:^(NSURLSessionDataTask *task, NSError *error) {
                             NSLog(@"Error: %@", [error localizedDescription]);
                             dispatch_group_leave(_retrieveGroup);
                         }];
}

- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}

- (NSArray *)prepareForParse:(id)responseObject
{
    NSString *rawString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSString *noEscapedString = [self stringByRemovingControlCharacters:rawString];
    
    NSString *cleanString = [noEscapedString stringByReplacingOccurrencesOfString:GarbageString withString:@""];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
    //NSLog(@"cleanString: %@", cleanString);
    
    NSData *data = [cleanString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error)
    {
        NSLog(@"Error: %@", error);
    }
    
    NSArray *outerArray = [json objectForKey:@"data"];
    return outerArray;
}

- (void)parseGoodsJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    
    NSMutableDictionary *dict;
    NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
    
    for(NSArray *innerArray in outerArray)
    {
        dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[innerArray objectAtIndex:0] forKey:ProductIDKey];
        [dict setObject:[innerArray objectAtIndex:1] forKey:ProductNameKey];
        [dict setObject:[innerArray objectAtIndex:2] forKey:ProductBrandKey];
        [dict setObject:[innerArray objectAtIndex:3] forKey:ProductCategoryKey];
        [dict setObject:[innerArray objectAtIndex:4] forKey:ProductPriceKey];
        [dict setObject:[baseURLString stringByAppendingPathComponent:[innerArray objectAtIndex:5]] forKey:ProductThumbnailPathKey];
        [dict setObject:[baseURLString stringByAppendingPathComponent:[innerArray objectAtIndex:6]] forKey:ProductImagePathKey];
        
        [goodsArray addObject:dict];
    }
    
    [BFPreferenceData saveProductsPreferenceArray:goodsArray];
}

- (void)parseStoreJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    NSMutableDictionary *storeDict = [[NSMutableDictionary alloc] init];
    
    for(NSArray *innerArray in outerArray)
    {
        [storeDict setObject:[innerArray objectAtIndex:0] forKey:StoreIDKey];
        [storeDict setObject:[innerArray objectAtIndex:1] forKey:StoreNameKey];
        [storeDict setObject:[innerArray objectAtIndex:2] forKey:StoreSNameKey];
        [storeDict setObject:[innerArray objectAtIndex:3] forKey:StoreTypeKey];
        [storeDict setObject:[innerArray objectAtIndex:4] forKey:StoreAddrCountryKey];
        [storeDict setObject:[innerArray objectAtIndex:5] forKey:StoreAddrProviceKey];
        [storeDict setObject:[innerArray objectAtIndex:6] forKey:StoreAddrCityKey];
        [storeDict setObject:[innerArray objectAtIndex:7] forKey:StoreAddrStreetKey];
        [storeDict setObject:[innerArray objectAtIndex:8] forKey:StoreStatusKey];
    }
    
    [BFPreferenceData saveStorePreferenceDict:storeDict];
}

- (void)parseStaffJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    
    NSMutableDictionary *dict;
    NSMutableArray *staffArray = [[NSMutableArray alloc] init];
    
    for(NSArray *innerArray in outerArray)
    {
        dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[innerArray objectAtIndex:0] forKey:StaffIDKey];
        [dict setObject:[innerArray objectAtIndex:1] forKey:StaffNameKey];
        [dict setObject:[innerArray objectAtIndex:2] forKey:StaffSexKey];
        [dict setObject:[innerArray objectAtIndex:3] forKey:StaffTelKey];
        [dict setObject:[innerArray objectAtIndex:4] forKey:StaffPhotoKey];
        
        [staffArray addObject:dict];
    }
    
    [BFPreferenceData saveStaffPreferenceArray:staffArray];
}

- (void)getResultByString:(NSString *)responseString
{
    NSString *keyString;
    for( keyString in [self.loginStatusDict allKeys])
    {
        if([responseString rangeOfString:keyString].location != NSNotFound)
        {
            _loginStatusCode = [self.loginStatusDict[keyString] intValue];
            return;
        }
    }
    _loginStatusCode = LoginErrorUnknownValue;
}

- (void)showAlert
{
    NSString *message;
    switch (_loginStatusCode)
    {
        case LoginErrorUnknownValue:
            message = [NSString stringWithFormat:@"%@", @"未连接到服务器"];
            break;
        case LoginWrongUserOrPasswordValue:
            message = [NSString stringWithFormat:@"%@", @"密码错误"];
            break;
        case LoginNoSuchUser:
            message = [NSString stringWithFormat:@"%@", @"账户名不存在"];
            break;
        case LoginUserLocked:
            message = [NSString stringWithFormat:@"%@", @"账户已冻结"];
            break;
        case LoginNoUserOrPassword:
            message = [NSString stringWithFormat:@"%@", @"管理账号或密码不能为空"];
            break;
            
        default:
            message = nil;
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"登录失败"
                              message:message
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)loginTask
{
    _loginGroup = dispatch_group_create();
    
    [self performLoginWithUsername:self.managerID Password:self.managerPWD];
    
    dispatch_group_notify(_loginGroup, dispatch_get_main_queue(), ^{
        if(_loginStatusCode == LoginOKValue)
        {
            [self retrievingTask];
        } else {
            [self enableInput];
            [self showAlert];
        }
    });
}

- (void)retrievingTask
{
    // Create a dispatch group
    _retrieveGroup = dispatch_group_create();

    [self getStoreInformation];
    [self getGoodsInformation];
    [self getStaffInformation];
    
    // Here we wait for all the requests to finish
    dispatch_group_notify(_retrieveGroup, dispatch_get_main_queue(), ^{
        [self enableInput];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"activateProcessSegue" sender:self.parentViewController];
    });
}

- (void)showWaitingIndicator
{
    self.waitingIndicatorView = [[UIView alloc] init];
    [self.waitingIndicatorView setFrame:self.view.bounds];
    
    self.waitingIndicatorView.layer.cornerRadius = 10.0f;
    self.waitingIndicatorView.layer.shadowOffset = CGSizeZero;
    self.waitingIndicatorView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.waitingIndicatorView.layer.shadowOpacity = 0.5f;
    self.waitingIndicatorView.layer.shadowRadius = 110;
    self.waitingIndicatorView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.view.bounds, -5, -5)].CGPath;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //spinner.color = [UIColor grayColor];
    
    spinner.center = CGPointMake(CGRectGetMidX(self.view.bounds) + 0.5f, CGRectGetMidY(self.view.bounds) + 0.5);
    
    spinner.tag = 1001;
    [self.waitingIndicatorView addSubview:spinner];
    [self.view addSubview:self.waitingIndicatorView];
    
    [spinner startAnimating];
}

- (void)hideWaitingIndicator
{
    [self.waitingIndicatorView removeFromSuperview];
}

- (void)showSpinner
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color = [UIColor grayColor];
    
    spinner.center = CGPointMake(CGRectGetMidX(self.view.bounds) + 0.5f, CGRectGetMidY(self.view.bounds) + 0.5f);
    
    spinner.tag = 1000;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

- (void)hideSpinner
{
    [[self.view viewWithTag:1000] removeFromSuperview];
}

- (void)disableInput
{
    self.activateButton.enabled = NO;
    //[self showSpinner];
    [self showWaitingIndicator];
}

- (void)enableInput
{
    self.activateButton.enabled = YES;
    //[self hideSpinner];
    [self hideWaitingIndicator];
}

- (IBAction)activateClick:(id)sender
{
    //NSString *storeID = [self.storeTextField.text copy];
    self.managerID = [self.managerTextField.text copy];
    self.managerPWD = [self.passwordTextField.text copy];
    
    [self disableInput];
    
    [self loginTask];
}

- (IBAction)click1:(id)sender
{
    //if([self.rString length] >= 7) return;
    [self.rString appendString:@"1"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click2:(id)sender
{
    [self.rString appendString:@"2"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click3:(id)sender
{
    [self.rString appendString:@"3"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click4:(id)sender
{
    [self.rString appendString:@"4"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click5:(id)sender
{
    [self.rString appendString:@"5"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click6:(id)sender
{
    [self.rString appendString:@"6"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click7:(id)sender
{
    [self.rString appendString:@"7"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click8:(id)sender
{
    [self.rString appendString:@"8"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click9:(id)sender
{
    [self.rString appendString:@"9"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}

- (IBAction)click0:(id)sender
{
    [self.rString appendString:@"0"];
    self.currentTextField.text = [NSString stringWithFormat:@"%@", self.rString];
}
@end
