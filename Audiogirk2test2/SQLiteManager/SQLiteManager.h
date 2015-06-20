//
//  SQLiteManager.h
//  collections
//
//  Created by Ester Sanchez on 10/03/11.
//  Copyright 2011 Dinamica Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


enum errorCodes {
	kDBNotExists,
	kDBFailAtOpen, 
	kDBFailAtCreate,
	kDBErrorQuery,
	kDBFailAtClose
};

@interface SQLiteManager : NSObject {

	sqlite3 *db; // The SQLite db reference
	NSString *databaseName; // The database name
}
- (void)createEditableCopyOfDatabaseIfNeeded:(NSString*)dbNameToCopy;
- (instancetype)initWithDatabaseNamed:(NSString *)name NS_DESIGNATED_INITIALIZER;
+ (SQLiteManager*) sharedDBManager;

// SQLite Operations
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSError *openDatabase;
- (NSError *) doQuery:(NSString *)sql;
- (NSError *) doUpdateQuery:(NSString *)sql withParams:(NSArray *)params;
- (NSArray *) getRowsForQuery:(NSString *)sql;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSError *closeDatabase;
@property (NS_NONATOMIC_IOSONLY, getter=getLastInsertRowID, readonly) NSInteger lastInsertRowID;

@property (NS_NONATOMIC_IOSONLY, getter=getDatabaseDump, readonly, copy) NSString *databaseDump;

@end
