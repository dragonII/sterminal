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

//static NSString *baseURLString = @"http://demo.syslive.cn/";
static NSString *baseURLString = @"http://mixmb.syslive.cn/";
static NSString *WrongUserOrPassword = @"<rest name=\"rest\">2</rest>";
static NSString *NoSuchUser = @"<rest name=\"rest\">0</rest>";
static NSString *LoginOK = @"<rest name=\"rest\">1</rest>";
static NSString *LockedAccount = @"<rest name=\"rest\">3</rest>";


static NSString *GarbageString = @"Thread was being aborted.";


@interface BFActiveViewController () <UITextFieldDelegate>

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

@property dispatch_group_t globalGroup;

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
    
    NSURL *url = [NSURL URLWithString:baseURLString];
    self.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    self.httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.httpSessionManager.responseSerializer.acceptableContentTypes = [self.httpSessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"html/text"];
    
    self.loginStatusDict = @{LoginOK: @0,
                             WrongUserOrPassword: @1,
                             NoSuchUser: @2,
                             LockedAccount: @3};
    self.loginStatusCode = -2;
    
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
                              NSLog(@"responseString; %@", responseString);
                              [self getResultByString:responseString];
                              if(_loginStatusCode == 0)
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
    
    dispatch_group_enter(_globalGroup);
    
    [self.httpSessionManager POST:@"mblogin/mblogin.ds"
                       parameters:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                              NSLog(@"responseString: %@", responseString);
                              [self getResultByString:responseString];
                              NSLog(@"Login Status Code: %ld", (long)_loginStatusCode);
                              if(_loginStatusCode == 0)
                              {
                                  [self.appDelegate updateLastOperationTimeStamp];
                                  //[self getStoreInformation];
                                  //[self getGoodsInformation];
                                  //[self getStaffInformation];
                                  
                                  dispatch_group_leave(_globalGroup);
                              }
                          }failure:^(NSURLSessionDataTask *task, NSError *error) {
                              NSLog(@"Error: %@", [error localizedDescription]);
                              dispatch_group_leave(_globalGroup);
                          }];
}

- (void)getStoreInformation
{
    dispatch_group_enter(_globalGroup);
    
    [self.httpSessionManager GET:@"shop/listshop_json.ds"
                      parameters:nil
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             [self.appDelegate updateLastOperationTimeStamp];
                             [self parseStoreJson:responseObject];
                             dispatch_group_leave(_globalGroup);
                         }failure:^(NSURLSessionDataTask *task, NSError *error) {
                             NSLog(@"Error: %@", [error localizedDescription]);
                             dispatch_group_leave(_globalGroup);
                         }];
}

- (void)getGoodsInformation
{
    dispatch_group_enter(_globalGroup);
    
    [self.httpSessionManager GET:@"lsproduct/product.ds"
                      parameters:nil
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             [self parseGoodsJson:responseObject];
                             dispatch_group_leave(_globalGroup);
                         }failure:^(NSURLSessionDataTask *task, NSError *error) {
                             NSLog(@"Error: %@", [error localizedDescription]);
                             dispatch_group_leave(_globalGroup);
                         }];
    
}

- (void)getStaffInformation
{
    dispatch_group_enter(_globalGroup);
    
    [self.httpSessionManager GET:@"employee/listemployee_json.ds"
                      parameters:nil
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             [self parseStaffJson:responseObject];
                             dispatch_group_leave(_globalGroup);
                         }failure:^(NSURLSessionDataTask *task, NSError *error) {
                             NSLog(@"Error: %@", [error localizedDescription]);
                             dispatch_group_leave(_globalGroup);
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
    NSLog(@"cleanString: %@", cleanString);
    
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
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *goodsArray;
    
    for(NSArray *innerArray in outerArray)
    {
        goodsArray = [[NSMutableArray alloc] init];
        
        [goodsArray addObject:@{@"ID": (NSString *)[innerArray objectAtIndex:0]}];
        [goodsArray addObject:@{@"name": (NSString *)[innerArray objectAtIndex:1]}];
        [goodsArray addObject:@{@"category": (NSString *)[innerArray objectAtIndex:2]}];
        [goodsArray addObject:@{@"place": (NSString *)[innerArray objectAtIndex:3]}];
        [goodsArray addObject:@{@"time": (NSString *)[innerArray objectAtIndex:4]}];
        [goodsArray addObject:@{@"price": (NSString *)[innerArray objectAtIndex:5]}];
        [goodsArray addObject:@{@"description": (NSString *)[innerArray objectAtIndex:6]}];
        //NSString *imgURLString = (NSString *)[baseURLString stringByAppendingString:[innerArray objectAtIndex:7]
        //[goodsArray addObject:@{@"image": (NSString *)[innerArray objectAtIndex:7]}];
        [goodsArray addObject:@{@"image": [baseURLString stringByAppendingString:(NSString *)[innerArray objectAtIndex:7]]}];
        
        [dict setObject:goodsArray forKey:(NSString *)[innerArray objectAtIndex:0]];
        /*
        for(NSString *itemString in innerArray)
        {
            NSLog(@"itemString: %@", itemString);
        }
         */
    }
    [BFPreferenceData saveProductsPreferenceDict:dict];
}

- (void)parseStoreJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    
    for(NSArray *innerArray in outerArray)
    {
        for(NSString *itemString in innerArray)
        {
            NSLog(@"itemString: %@", itemString);
        }
    }
}

- (void)parseStaffJson:(id)responseObject
{
    NSArray *outerArray = [self prepareForParse:responseObject];
    
    NSMutableDictionary *dict = [BFPreferenceData getStaffPreferenceDict];
    NSMutableArray *staffArray;
    
    for(NSArray *innerArray in outerArray)
    {
        staffArray = [[NSMutableArray alloc] init];
        
        [staffArray addObject:@{@"ID": (NSString *)[innerArray objectAtIndex:0]}];
        [staffArray addObject:@{@"name": (NSString *)[innerArray objectAtIndex:1]}];
        [staffArray addObject:@{@"sex": (NSString *)[innerArray objectAtIndex:2]}];
        //[staffArray addObject:@{@"image": (NSString *)[innerArray objectAtIndex:3]}];
        [staffArray addObject:@{@"tel": (NSString *)[innerArray objectAtIndex:3]}];
        [staffArray addObject:@{@"image": (NSString *)[innerArray objectAtIndex:4]}];
        
        [dict setObject:staffArray forKey:(NSString *)[innerArray objectAtIndex:0]];
        /*
        for(NSString *itemString in innerArray)
        {
            NSLog(@"itemString: %@", itemString);
        }
         */
    }
    
    NSLog(@"staff dict: %@", dict);
    
    [BFPreferenceData saveStaffPreferenceDict:dict];
}

- (void)getResultByString:(NSString *)responseString
{
    //NSLog(@"---------------------------------------");
    //NSLog(@"%@", responseString);
    NSString *keyString;
    for( keyString in [self.loginStatusDict allKeys])
    {
        if([responseString rangeOfString:keyString].location != NSNotFound)
        {
            _loginStatusCode = [self.loginStatusDict[keyString] intValue];
            return;
        }
    }
    _loginStatusCode = -1;
}

- (void)batchTasks
{
    // Create a dispatch group
    _globalGroup = dispatch_group_create();

    [self performLoginWithUsername:self.managerID Password:self.managerPWD];
    //[self getStoreInformation];
    //[self getGoodsInformation];
    [self getStaffInformation];
    
    // Here we wait for all the requests to finish
    dispatch_group_notify(_globalGroup, dispatch_get_main_queue(), ^{
        // Do whatever you need to do when all requests are finished
        if(_loginStatusCode == 0)
        {
            NSLog(@"Status Code: %ld", (long)_loginStatusCode);
            //[self dismissViewControllerAnimated:YES completion:nil];
            //[self performSegueWithIdentifier:@"activateProcessSegue" sender:self.parentViewController];
        }
    });
}

- (IBAction)activateClick:(id)sender
{
    //NSString *storeID = [self.storeTextField.text copy];
    self.managerID = [self.managerTextField.text copy];
    self.managerPWD = [self.passwordTextField.text copy];
    
    [self batchTasks];
    
    //[self performLoginWithUsername:self.managerID Password:self.managerPWD];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self performSegueWithIdentifier:@"activateProcessSegue" sender:self.parentViewController];
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
