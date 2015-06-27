//
//  CreateDB.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/17/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "CreateDB.h"
#import "SQLiteManager.h"


@implementation CreateDB {

    
}

+ (void)initialize
{
    if (self == [CreateDB class]) {
        
        SQLiteManager   *dbManager = [SQLiteManager sharedDBManager];
       
        NSString *sqlString1 = @"CREATE TABLE IF NOT EXISTS myBooks ( id INTEGER PRIMARY KEY AUTOINCREMENT, bookSourceID INTEGER, bookImageName TEXT, bookName TEXT, audioDuration INTEGER, audioNarrator TEXT, bookFileName TEXT, format TEXT, expireDate TIMESTAMP, UNIQUE(bookName));";
        NSString *sqlString2 = @"CREATE TABLE IF NOT EXISTS author (authorId INTEGER PRIMARY KEY AUTOINCREMENT, bookAuthorName TEXT, UNIQUE(bookAuthorName));";
        NSString *sqlString3 = @"CREATE TABLE IF NOT EXISTS bookAuthor (bookAuthorId INTEGER PRIMARY KEY AUTOINCREMENT, bookId INTEGER, authorId INTEGER, FOREIGN KEY (bookId) REFERENCES myBooks(bookSourceID), FOREIGN KEY (authorId) REFERENCES author(authorId));";
        for (NSString *sqlstr in @[sqlString1, sqlString2, sqlString3]) {
            [CreateDB doSQLQuery:sqlstr withDBManager:dbManager];
        }

    }   
}


+ (NSError*) doSQLQuery:(NSString*)queryString withDBManager:(SQLiteManager*) dbManager{
    
    NSError *error = nil;
    error = [dbManager doQuery:queryString];
    if (error != nil) {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    
    return error;
}

@end
