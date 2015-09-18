//
//  RentalLogic.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/11/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "RentalLogicManager.h"
#import "CreateDB.h"
#import "Downloader.h"

#import "AGDefines.h"

@implementation RentalLogicManager {

    Downloader *downloader;
}

@synthesize delegate;


+ (void) scheduleRemoveNotificationWithMessage:(NSString*) message{
    [RentalLogicManager scheduleNotificationOn:[NSDate date] text:message action:@"Show" sound:nil launchImage:nil andInfo:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
	
	if(soundfileName == nil){
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else{
		localNotification.soundName = soundfileName;
	}
	localNotification.alertLaunchImage = launchImage;
	
//    localNotification.applicationIconBadgeNumber = self.badgeCount;
    localNotification.userInfo = userInfo;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

+ (void) deleteExpiredBooks{
    [CreateDB initialize];
    NSString *sqlQuery = @"SELECT bookName, expireDate FROM myBooks";
    NSArray *expireDateArray = [[SQLiteManager sharedDBManager] getRowsForQuery:sqlQuery];
    NSComparisonResult result;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (NSDictionary *dict in expireDateArray) {
        NSDate *expireDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",dict[@"expireDate"]]];
        result = [expireDate compare:[NSDate date]];
        if (result == NSOrderedAscending) {
            sqlQuery = [NSString stringWithFormat:@"DELETE FROM myBooks WHERE expireDate = \"%@\"",[dateFormat stringFromDate:expireDate]];
            [RentalLogicManager doSQLQuery:sqlQuery];
            NSString *message = [NSString stringWithFormat:@"Rental period of \"%@\" is expired. The item was removed.",dict[@"bookName"]];
            [RentalLogicManager scheduleRemoveNotificationWithMessage:message];
        }
    }
}

+ (void) checkUpdateOrDownload:(BookItemsObject*) bookItemObject{
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT expireDate FROM myBooks WHERE bookName = \"%@\";", bookItemObject.b_name];
    NSArray *expireDateArray = [[SQLiteManager sharedDBManager] getRowsForQuery:sqlQuery];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if ([expireDateArray count] > 0) {
        NSDictionary *dict = expireDateArray[0];
        NSDate *expireDate = [dateFormat dateFromString:(NSString*)dict[@"expireDate"]];
        NSString *expireDateString = [dateFormat stringFromDate:[expireDate dateByAddingTimeInterval:60*60*24*10]];
        sqlQuery = [NSString stringWithFormat:@"UPDATE myBooks SET expireDate = \"%@\" WHERE bookName = \"%@\";", expireDateString, bookItemObject.b_name];
        [RentalLogicManager doSQLQuery:sqlQuery];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:didCompleteDownloadNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRecordToDB:) name:didCompleteDownloadNotification object:nil];
        [Downloader downloadFileAtPath:[NSString stringWithFormat:@"http://109.68.124.16/book_files/%@/%@.zip", bookItemObject.format, bookItemObject.id] withBookItemsObject:bookItemObject];
        //TODO: Perform download
    }
    
}

+ (void) addRecordToDB:(NSNotification*) notifObject{
    
    BookItemsObject *bookItemsObject = [[notifObject userInfo] valueForKey:@"bookObject"];
    
    NSString *bookID = bookItemsObject.id;
    NSString *bookName = bookItemsObject.b_name;
    NSString *bookImageName = bookItemsObject.b_image;
    NSString *bookAuthor = bookItemsObject.b_author;
    NSString *audioDuration = @"To BE DONE";// bookItemsObject.duration
    NSString *audioNarrator = @"TBD";//[downloadedDictionary objectForKey:@"narrator"];
    NSString *bookFileName = [NSString stringWithFormat:@"%@.zip", bookID];
    NSString *bookFormat = bookItemsObject.format;//[downloadedDictionary objectForKey:@"format"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *expireDate = [dateFormat stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*10]];
    
    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO myBooks (bookSourceID, bookImageName, bookName, audioDuration, audioNarrator, bookFileName , format, expireDate) VALUES (\"%@\",\"%@\" ,\"%@\" ,\"%@\" ,\"%@\" ,\"%@\" ,\"%@\" ,\"%@\");", bookID, bookImageName, bookName, audioDuration, audioNarrator, bookFileName, bookFormat, expireDate];
    [RentalLogicManager doSQLQuery:sqlString];
    
    sqlString = [NSString stringWithFormat:@"INSERT INTO author (bookAuthorName) VALUES (\"%@\");", bookAuthor];
    [RentalLogicManager doSQLQuery:sqlString];

    
    NSArray *idsArray = [RentalLogicManager getRowsForQuery:@"select seq from sqlite_sequence"];
    
    sqlString = [NSString stringWithFormat:@"INSERT INTO bookAuthor (bookId, authorId) VALUES (\"%@\", \"%@\")", (idsArray[0])[@"seq"], (idsArray[1])[@"seq"]];
    [RentalLogicManager doSQLQuery:sqlString];
    
}

+ (NSError*) doSQLQuery:(NSString*)queryString {
    SQLiteManager *dbManager = [SQLiteManager sharedDBManager];
    NSError *error = nil;
    error = [dbManager doQuery:queryString];
    if (error != nil) {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    return error;
}

+ (NSArray*) getRowsForQuery:(NSString*) queryString {
    return [[SQLiteManager sharedDBManager] getRowsForQuery:queryString];
}


@end
