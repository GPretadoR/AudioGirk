//
//  BookObjectFromDB.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/27/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "BookObjectFromDB.h"

static dispatch_once_t predicate;
static BookObjectFromDB *bookObjectFromDB;

@implementation BookObjectFromDB{


}

//@synthesize id;
//@synthesize bookID;
//@synthesize bookImageName;
//@synthesize bookName;
//@synthesize bookAuthor;
//@synthesize bookFileName;
//@synthesize audioDuration;
//@synthesize audioNarrator;
//@synthesize format;
//@synthesize expireDate;

+ (BookObjectFromDB*) sharedObjectFromArray:(NSArray*)arrayOfDictionary{
    dispatch_once(&predicate, ^{
        bookObjectFromDB = [[BookObjectFromDB alloc] initWithArray:arrayOfDictionary];
    });
    return bookObjectFromDB;
}

- (instancetype)initWithArray:(NSArray*)arrayDict
{
    self = [super init];
    if (self) {
        [self dictionaryToObject:arrayDict];
    }
    return self;
}

+ (BookObjectFromDB*) getBookObjectForDictionary:(NSDictionary*) dictionary{

    [bookObjectFromDB dictionaryToObject:@[dictionary]];
    
    return bookObjectFromDB;
}

- (void) dictionaryToObject:(NSArray*) array{

    for (NSDictionary *dict in array) {
        self.id = dict[@"id"];
        _bookSourceID  = dict[@"bookSourceID"];
        _bookImageName = dict[@"bookImageName"];
        _bookName = dict[@"bookName"];
        _bookAuthorName = dict[@"bookAuthorName"];
        _audioDuration = dict[@"audioDuration"];
        _audioNarrator = dict[@"audioNarrator"];
        _bookFileName = dict[@"bookFileName"];
        _format = dict[@"format"];
        _expireDate = dict[@"expireDate"];
    }
}

@end

