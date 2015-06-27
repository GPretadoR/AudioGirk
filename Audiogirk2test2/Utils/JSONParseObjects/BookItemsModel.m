//
//  BookItemsModel.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/30/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "BookItemsModel.h"

@implementation BookItemsModel

+(BookItemsModel*)sharedModelWithDictionary:(NSDictionary*)dict{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[BookItemsModel alloc]initWithDictionary:dict error:nil];
    });
    
    return _sharedObject;
}
+(BookItemsModel*) sharedModel {
    __strong static id _sharedObject = nil;
    _sharedObject = [BookItemsModel sharedModelWithDictionary:nil];
    return _sharedObject;
}
@end
