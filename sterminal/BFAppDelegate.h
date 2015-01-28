//
//  BFAppDelegate.h
//  sterminal
//
//  Created by Wang Long on 1/6/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFHTTPSessionManager;

@interface BFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (assign, nonatomic) NSString *lastOperationTimeStamp;
@property NSTimeInterval lastOperationTimeStamp;

- (void)updateLastOperationTimeStamp;

+ (AFHTTPSessionManager *)sharedHttpSessionManager;

@end
