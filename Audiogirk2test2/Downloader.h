//
//  Downloader.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/5/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookItemsModel.h"

@interface Downloader : NSObject

@property (nonatomic, retain) NSString *downloadBookFormat;
@property (nonatomic, retain) NSDictionary *downloadedDictionary;
@property (nonatomic, strong) BookItemsObject *bookItemsObject;

- (void) downloadFileAtPath:(NSString*)path ;
@end
