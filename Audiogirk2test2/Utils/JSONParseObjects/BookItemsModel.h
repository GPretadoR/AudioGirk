//
//  BookItemsModel.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/30/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "JSONModel.h"
#import "BookItemsObject.h"
#import "BannerItemObject.h"
#import "CategoriesItemObject.h"

@interface BookItemsModel : JSONModel

@property (strong, nonatomic) NSArray<BookItemsObject> *bookItemsArray;
@property (strong, nonatomic) NSArray<BannerItemObject> *bannerItemsArray;
@property (strong, nonatomic) NSArray<CategoriesItemObject> *categoryItemsArray;
+(BookItemsModel*)sharedModelWithDictionary:(NSDictionary*)dict;
+(BookItemsModel*) sharedModel;
@end
