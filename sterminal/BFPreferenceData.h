//
//  BFPreferenceData.h
//  sterminal
//
//  Created by Wang Long on 1/23/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFPreferenceData : NSObject

+ (NSMutableDictionary *)getPreferenceDict;
+ (NSMutableDictionary *)getManagerPreferenceDict;
+ (NSMutableDictionary *)getStaffPreferenceDict;
+ (NSMutableDictionary *)getStorePreferenceDict;
+ (NSMutableDictionary *)getProductsPreferenceDict;

@end
