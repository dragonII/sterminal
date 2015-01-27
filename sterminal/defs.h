//
//  defs.h
//  sterminal
//
//  Created by Wang Long on 1/27/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#ifndef sterminal_defs_h
#define sterminal_defs_h

static NSString *StoreIDKey = @"ID";
static NSString *StoreNameKey = @"name";
static NSString *StoreSNameKey = @"shortname";
static NSString *StoreTypeKey = @"type";
static NSString *StoreAddrCountryKey = @"country";
static NSString *StoreAddrProviceKey = @"province";
static NSString *StoreAddrCityKey = @"city";
static NSString *StoreAddrStreetKey = @"street";
static NSString *StoreStatusKey = @"status";

static NSString *ProductIDKey = @"ID";
static NSString *ProductNameKey = @"name";
static NSString *ProductBrandKey = @"brand";
static NSString *ProductCategoryKey = @"category";
static NSString *ProductPriceKey = @"price";

static NSString *StaffIDKey = @"ID";
static NSString *StaffNameKey = @"name";
static NSString *StaffSexKey = @"sex";
static NSString *StaffTelKey = @"tel";
static NSString *StaffPhotoKey = @"photo";

static const NSInteger  LoginInitValue = -2;
static const NSInteger LoginErrorUnknownValue = -1;
static const NSInteger LoginOKValue = 0;
static const NSInteger LoginWrongUserOrPasswordValue = 1;
static const NSInteger LoginNoSuchUser = 2;
static const NSInteger LoginUserLocked = 3;
static const NSInteger LoginNoUserOrPassword = 6;

#endif
