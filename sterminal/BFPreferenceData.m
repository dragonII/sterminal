//
//  BFPreferenceData.m
//  sterminal
//
//  Created by Wang Long on 1/23/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "BFPreferenceData.h"

static NSString *GlobalPreferenceFileName = @"preference.plist";
static NSString *ManagerPreferenceFileName = @"manager_profile.plist";
static NSString *StaffPreferenceFileName = @"staff_profile.plist";
static NSString *StorePreferenceFileName = @"store_profile.plist";
static NSString *ProductsPreferenceFileName = @"products_profile.plist";

@implementation BFPreferenceData

+ (NSString *)getFilePathWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *prefereceFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    return prefereceFilePath;
}

+ (NSMutableDictionary *) getDictionaryFilePreferenceFile:(NSString *)fileName
{
    NSString *filePath = [self getFilePathWithName:fileName];
    
    NSMutableDictionary *dict;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    } else {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    return dict;
}

+ (NSMutableDictionary *)getPreferenceDict
{
    return [self getDictionaryFilePreferenceFile:GlobalPreferenceFileName];
}

+ (NSMutableDictionary *)getManagerPreferenceDict
{
    return [self getDictionaryFilePreferenceFile:ManagerPreferenceFileName];
}

+ (NSMutableDictionary *)getStorePreferenceDict
{
    return [self getDictionaryFilePreferenceFile:StorePreferenceFileName];
}

+ (NSMutableDictionary *)getStaffPreferenceDict
{
    return [self getDictionaryFilePreferenceFile:StaffPreferenceFileName];
}

+ (void)saveStaffPreferenceDict:(NSMutableDictionary *)dict
{
    NSString *filePath = [self getFilePathWithName:StaffPreferenceFileName];
    [dict writeToFile:filePath atomically:YES];
    
    NSLog(@"Saving Staff Done");
}

+ (NSMutableDictionary *)getProductsPreferenceDict
{
    return [self getDictionaryFilePreferenceFile:ProductsPreferenceFileName];
}

+ (void)saveProductsPreferenceDict:(NSMutableDictionary *)dict
{
    NSString *filePath = [self getFilePathWithName:ProductsPreferenceFileName];
    [dict writeToFile:filePath atomically:YES];
    
    NSLog(@"Saving Products Done");
}

@end