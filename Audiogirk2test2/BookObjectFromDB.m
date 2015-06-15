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
        self.id = [dict objectForKey:@"id"];
        _bookID  = [dict objectForKey:@"bookID"];
        _bookImageName = [dict objectForKey:@"bookImageName"];
        _bookName = [dict objectForKey:@"bookName"];
        _bookAuthor = [dict objectForKey:@"bookAuthor"];
        _audioDuration = [dict objectForKey:@"audioDuration"];
        _audioNarrator = [dict objectForKey:@"audioNarrator"];
        _bookFileName = [dict objectForKey:@"bookFileName"];
        _format = [dict objectForKey:@"format"];
        _expireDate = [dict objectForKey:@"expireDate"];
    }
}

@end

