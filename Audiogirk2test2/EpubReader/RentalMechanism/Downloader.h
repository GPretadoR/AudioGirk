//
//  Downloader.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/5/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookItemsModel.h"

UIKIT_EXTERN NSString *const didCompleteDownloadNotification;

@interface Downloader : NSObject



@property (nonatomic, retain) NSString *downloadBookFormat;
@property (nonatomic, retain) NSDictionary *downloadedDictionary;


+ (void) downloadFileAtPath:(NSString*)path withBookItemsObject:(BookItemsObject*) bookItemsObject;
@end
