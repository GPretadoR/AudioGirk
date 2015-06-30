//
//  RentalLogic.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/11/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookItemsModel.h"
@protocol RentalLogicManagerDelegate <NSObject>

@optional - (void) didRecieveLocalNotification;

@end

@interface RentalLogicManager : NSObject



@property (nonatomic)id delegate;

+ (void) deleteExpiredBooks;
+ (void) checkUpdateOrDownload:(BookItemsObject*) bookItemObject;
@end
