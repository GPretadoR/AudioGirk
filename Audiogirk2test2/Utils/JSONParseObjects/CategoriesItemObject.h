//
//  CategoriesItemObject.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 2/12/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "JSONModel.h"
@protocol CategoriesItemObject
@end
@interface CategoriesItemObject : JSONModel

@property (nonatomic)        int category_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageURL;
@end
