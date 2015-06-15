//
//  BookObjectFromDB.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/27/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookObjectFromDB : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *bookID;
@property (nonatomic, strong) NSString *bookImageName;
@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSString *bookAuthor;
@property (nonatomic, strong) NSString *audioDuration;
@property (nonatomic, strong) NSString *audioNarrator;
@property (nonatomic, strong) NSString *bookFileName;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *expireDate;


+ (BookObjectFromDB*) sharedObjectFromArray:(NSArray*)arrayOfDictionary;
+ (BookObjectFromDB*) getBookObjectForDictionary:(NSDictionary*) dictionary;
- (instancetype)initWithArray:(NSArray*)arrayDict;
@end
