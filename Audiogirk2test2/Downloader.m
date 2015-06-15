//
//  Downloader.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/5/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "Downloader.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "SQLiteManager/SQLiteManager.h"
#import "Utils.h"

@implementation Downloader {
    
    SQLiteManager *dbManager;
    NSString *bookPath;
 
}

@synthesize downloadBookFormat,downloadedDictionary;
@synthesize bookItemsObject;
- (id)init
{
    self = [super init];
    if (self) {
        dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"audioBooks1.sqlite"];
        [dbManager createEditableCopyOfDatabaseIfNeeded:@"audioBooks1.sqlite"];
        NSError *error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS myBooks ( id integer primary key autoincrement, bookID integer, bookImageName text, bookName text, bookAuthor text, audioDuration integer, audioNarrator text, bookFileName text, format text, expireDate TIMESTAMP);"];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
    return self;
}

- (void) downloadFileAtPath:(NSString*)path {

    __block float progress = 0.0f;
    __block float totalBytesToRead = 0.0f;
    bookPath = path;
//    path=@"http://109.68.124.16/mixed/1.zip";
    [SVProgressHUD dismiss];
    NSString* filename = [path lastPathComponent];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [SVProgressHUD showProgress:0.0f status:@"Downloading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", bookItemsObject.format,filename]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath: filePath append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead,long long totalBytesExpectedToRead) {
        progress = (float)totalBytesRead / totalBytesExpectedToRead;
//        NSLog(@"BYTES:%f :%lld , %lld",progress, totalBytesRead, totalBytesExpectedToRead);
        totalBytesToRead = totalBytesExpectedToRead;
        if (totalBytesExpectedToRead > 300) {
            [SVProgressHUD showProgress:progress status:@"Downloading..." maskType:SVProgressHUDMaskTypeBlack];
        }
    }];

    [operation setCompletionBlock:^{
        NSLog(@"downloadComplete!");
        
//        if (totalBytesToRead > 300.0) {
            [NSThread sleepForTimeInterval:0.3];
            if ([Utils unzipAndSaveFile:[filePath lastPathComponent] atPath:[filePath stringByDeletingLastPathComponent]]) {
                [self addRecordToDB];
            }
            [self performSelectorInBackground:@selector(dismissSuccess) withObject:nil];
//        }else{
//            [NSThread sleepForTimeInterval:0.3];
//            [SVProgressHUD showErrorWithStatus:@"Error downloading the book"];
//        }
        
    }];
    [operation start];

}
- (void)dismissSuccess {
    [SVProgressHUD showSuccessWithStatus:@"Download Completed"];
}

- (void) addRecordToDB {
    
    NSString *bookID = bookItemsObject.id;
    NSString *bookName = bookItemsObject.b_name;
    NSString *bookImageName = bookItemsObject.b_image;
    NSString *bookAuthor = bookItemsObject.b_author;
    NSString *audioDuration = @"To BE DONE";// bookItemsObject.duration
    NSString *audioNarrator = @"TBD";//[downloadedDictionary objectForKey:@"narrator"];
    NSString *bookFileName = [bookPath lastPathComponent];
    NSString *bookFormat = bookItemsObject.format;//[downloadedDictionary objectForKey:@"format"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *expireDate = [dateFormat stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*10]];
    
    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO myBooks ( bookID,bookImageName, bookName ,bookAuthor, audioDuration, audioNarrator, bookFileName , format , expireDate) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@');",bookID, bookImageName,bookName, bookAuthor, audioDuration,audioNarrator,bookFileName,bookFormat,expireDate];
    NSError *error = [dbManager doQuery:sqlString];
    if (error != nil) {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
}

@end
