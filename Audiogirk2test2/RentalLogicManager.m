//
//  RentalLogic.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/11/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "RentalLogicManager.h"
#import "SQLiteManager/SQLiteManager.h"

@implementation RentalLogicManager

@synthesize delegate;


+ (void) scheduleRemoveNotification{
    
    SQLiteManager *dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"audioBooks1.sqlite"];
    NSString *sqlQuery = @"SELECT bookName, expireDate FROM myBooks";
    NSArray *expireDateArray = [dbManager getRowsForQuery:sqlQuery];
    NSComparisonResult result;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (NSDictionary *dict in expireDateArray) {
        NSDate *expireDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"expireDate"]]];
        result = [expireDate compare:[NSDate date]];
        if (result == NSOrderedAscending) {
            sqlQuery = [NSString stringWithFormat:@"DELETE FROM myBooks WHERE expireDate = '%@'",[dateFormat stringFromDate:expireDate]];
            [dbManager doQuery:sqlQuery];
            NSString *message = [NSString stringWithFormat:@"Rental period of \"%@\" is expired. The item was removed.",[dict objectForKey:@"bookName"]];
            [RentalLogicManager scheduleNotificationOn:[NSDate date] text:message action:@"Show" sound:nil launchImage:nil andInfo:nil];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

+ (void) scheduleNotificationOn:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage
                        andInfo:(NSDictionary*) userInfo
{
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
	
	if(soundfileName == nil)
	{
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else
	{
		localNotification.soundName = soundfileName;
	}
    
	localNotification.alertLaunchImage = launchImage;
	
//    localNotification.applicationIconBadgeNumber = self.badgeCount;
    localNotification.userInfo = userInfo;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}


@end
