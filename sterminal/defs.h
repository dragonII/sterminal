//
//  defs.h
//  sterminal
//
//  Created by Wang Long on 1/27/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#ifndef sterminal_defs_h
#define sterminal_defs_h

static NSString *baseURLString = @"http://mixmb.syslive.cn/";

static NSString *ShowWizardKey = @"ShowWizard";

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
static NSString *ProductImagePathKey = @"image";
static NSString *ProductThumbnailPathKey = @"thumbnail";

static NSString *OrderProductIDKey = @"ID";
static NSString *OrderProductNameKey = @"name";
static NSString *OrderProductPriceKey = @"price";
static NSString *OrderProductQuantityKey = @"quantity";
static NSString *OrderProductImagePathKey = @"image";
static NSString *OrderProductThumbnailPathKey = @"thumbnail";

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

static NSString *OrderRecordNumberKey = @"orderNumber";
static NSString *OrderRecordDateKey = @"orderDate";
static NSString *OrderRecordAmountKey = @"orderAmount";
static NSString *OrderRecordItemKey = @"orderItem";

typedef enum
{
    HistoryTypeOnline = 1,
    HistoryTypeOffline
} HistoryEnumType;

#endif
