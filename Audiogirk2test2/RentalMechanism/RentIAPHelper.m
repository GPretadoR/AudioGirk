//
//  RentIAPHelper.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/13/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "RentIAPHelper.h"



@implementation RentIAPHelper{

    
}
// Obj-C Singleton pattern
+ (RentIAPHelper *)sharedInstance {
    static RentIAPHelper *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


@end
