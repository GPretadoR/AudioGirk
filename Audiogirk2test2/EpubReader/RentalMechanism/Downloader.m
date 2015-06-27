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
#import "SQLiteManager.h"
#import "Utils.h"


@implementation Downloader {
    
    SQLiteManager *dbManager;
}

@synthesize downloadBookFormat,downloadedDictionary;

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (void) downloadFileAtPath:(NSString*)path withBookItemsObject:(BookItemsObject*) bookItemsObject {

    __block float progress = 0.0f;
    __block float totalBytesToRead = 0.0f;

//    path=@"http://109.68.124.16/mixed/1.zip";
    [SVProgressHUD dismiss];
    NSString* filename = [path lastPathComponent];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [SVProgressHUD showProgress:0.0f status:@"Downloading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputPath = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", bookItemsObject.format,filename]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath: outputPath append:NO];
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
            if ([Utils unzipAndSaveFile:[outputPath lastPathComponent] atPath:[outputPath stringByDeletingLastPathComponent]]) {
                //TODO: Trigger RentalLogic [Post Notification download complete]
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didCompleteDownloadNotification" object:nil userInfo:@{@"bookObject" : bookItemsObject}];
            }
            [self performSelectorInBackground:@selector(dismissSuccess) withObject:nil];
//        }else{
//            [NSThread sleepForTimeInterval:0.3];
//            [SVProgressHUD showErrorWithStatus:@"Error downloading the book"];
//        }
        
    }];
    [operation start];

}
+ (void)dismissSuccess {
    [SVProgressHUD showSuccessWithStatus:@"Download Completed"];
}


@end
