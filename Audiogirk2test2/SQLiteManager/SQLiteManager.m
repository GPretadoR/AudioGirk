//
//  SQLiteManager.m
//  collections
//
//  Created by Ester Sanchez on 10/03/11.
//  Copyright 2011 Dinamica Studios. All rights reserved.
//

#import "SQLiteManager.h"


// Private methods
@interface SQLiteManager (Private)

@property (NS_NONATOMIC_IOSONLY, getter=getDatabasePath, readonly, copy) NSString *databasePath;
- (NSError *)createDBErrorWithDescription:(NSString*)description andCode:(int)code;

@end

static dispatch_once_t predicate;
static SQLiteManager *dbManager;

@implementation SQLiteManager

#pragma mark Init & Dealloc

/**
 * Init method.
 * Use this method to initialise the object, instead of just "init".
 *
 * @param name the name of the database to manage.
 *
 * @return the SQLiteManager object initialised.
 */

- (instancetype)initWithDatabaseNamed:(NSString *)name {
	self = [super init];
	if (self != nil) {
		databaseName = [[NSString alloc] initWithString:name];
		db = nil;
	}
	return self;
}

+ (SQLiteManager*) sharedDBManager{
    dispatch_once(&predicate, ^{
        dbManager = [[self alloc] initWithDatabaseNamed:@"audioBooks1.sqlite"];
        [dbManager createEditableCopyOfDatabaseIfNeeded:@"audioBooks1.sqlite"];
    });
    return dbManager;
}

#pragma mark SQLite Operations

/**
 * Open or create a SQLite3 database.
 *
 * If the db exists, then is opened and ready to use. If not exists then is created and opened.
 *
 * @return nil if everything was ok, an NSError in other case.
 *
 */

- (NSError *) openDatabase {
	
	NSError *error = nil;
	
	NSString *databasePath = [self getDatabasePath];
    
	const char *dbpath = [databasePath UTF8String];
	int result = sqlite3_open(dbpath, &db);
	if (result != SQLITE_OK) {
        const char *errorMsg = sqlite3_errmsg(db);
        NSString *errorStr = [NSString stringWithFormat:@"The database could not be opened: %@",@(errorMsg)];
        error = [self createDBErrorWithDescription:errorStr	andCode:kDBFailAtOpen];
	}
	
	return error;
}


/**
 * Does an SQL query.
 *
 * You should use this method for everything but SELECT statements.
 *
 * @param sql the sql statement.
 *
 * @return nil if everything was ok, NSError in other case.
 */

- (NSError *)doQuery:(NSString *)sql {
	
	NSError *openError = nil;
	NSError *errorQuery = nil;
	
	//Check if database is open and ready.
	if (db == nil) {
		openError = [self openDatabase];
	}
	
	if (openError == nil) {
		sqlite3_stmt *statement;
		const char *query = [sql UTF8String];
		sqlite3_prepare_v2(db, query, -1, &statement, NULL);
		
		if (sqlite3_step(statement) == SQLITE_ERROR) {
			const char *errorMsg = sqlite3_errmsg(db);
			errorQuery = [self createDBErrorWithDescription:@(errorMsg)
													andCode:kDBErrorQuery];
		}
		sqlite3_finalize(statement);
		errorQuery = [self closeDatabase];
	}
	else {
		errorQuery = openError;
	}
    
	return errorQuery;
}

/**
 * Does an SQL parameterized query.
 *
 * You should use this method for parameterized INSERT or UPDATE statements.
 *
 * @param sql the sql statement using ? for params.
 *
 * @param params NSArray of params type (id), in CORRECT order please.
 *
 * @return nil if everything was ok, NSError in other case.
 */

- (NSError *)doUpdateQuery:(NSString *)sql withParams:(NSArray *)params {
	
	NSError *openError = nil;
	NSError *errorQuery = nil;
	
	//Check if database is open and ready.
	if (db == nil) {
		openError = [self openDatabase];
	}
	
	if (openError == nil) {
		sqlite3_stmt *statement;
		const char *query = [sql UTF8String];
		sqlite3_prepare_v2(db, query, -1, &statement, NULL);
        
        //BIND the params!
        int count =0;
        for (id param in params ) {
            count++;
            if ([param isKindOfClass:[NSString class]] )
                sqlite3_bind_text(statement, count, [param UTF8String], -1, SQLITE_TRANSIENT);
            if ([param isKindOfClass:[NSNumber class]] ) {
                if (!strcmp([param objCType], @encode(float)))
                    sqlite3_bind_double(statement, count, [param doubleValue]);
                else if (!strcmp([param objCType], @encode(int)))
                    sqlite3_bind_int(statement, count, [param intValue]);
                else if (!strcmp([param objCType], @encode(BOOL)))
                    sqlite3_bind_int(statement, count, [param intValue]);
                else
                    NSLog(@"unknown NSNumber");
            }
            if ([param isKindOfClass:[NSDate class]]) {
               sqlite3_bind_double(statement, count, [param timeIntervalSince1970]);
            }
            if ([param isKindOfClass:[NSData class]] ) {
                sqlite3_bind_blob(statement, count, [param bytes], [param length], SQLITE_STATIC);
            }
        }
		
		if (sqlite3_step(statement) == SQLITE_ERROR) {
			const char *errorMsg = sqlite3_errmsg(db);
			errorQuery = [self createDBErrorWithDescription:@(errorMsg)
													andCode:kDBErrorQuery];
		}
		sqlite3_finalize(statement);
		errorQuery = [self closeDatabase];
	}
	else {
		errorQuery = openError;
	}
    
	return errorQuery;
}

- (NSInteger)getLastInsertRowID {

    NSError *openError = nil;
	
    sqlite3_int64 rowid = 0;
	
	//Check if database is open and ready.
	if (db == nil) {
		openError = [self openDatabase];
	}
	
	if (openError == nil) {
        rowid = sqlite3_last_insert_rowid(db);
    }
    
    return (NSInteger)rowid;
}

/**
 * Does a SELECT query and gets the info from the db.
 *
 * The return array contains an NSDictionary for row, made as: key=columName value= columnValue.
 *
 * For example, if we have a table named "users" containing:
 * name | pass
 * -------------
 * admin| 1234
 * pepe | 5678
 *
 * it will return an array with 2 objects:
 * resultingArray[0] = name=admin, pass=1234;
 * resultingArray[1] = name=pepe, pass=5678;
 *
 * So to get the admin password:
 * [[resultingArray objectAtIndex:0] objectForKey:@"pass"];
 *
 * @param sql the sql query (remember to use only a SELECT statement!).
 *
 * @return an array containing the rows fetched.
 */

- (NSArray *)getRowsForQuery:(NSString *)sql {
	
	NSMutableArray *resultsArray = [[NSMutableArray alloc] initWithCapacity:1];
	
	if (db == nil) {
		[self openDatabase];
	}
	
	sqlite3_stmt *statement;
	const char *query = [sql UTF8String];
	int returnCode = sqlite3_prepare_v2(db, query, -1, &statement, NULL);
	
	if (returnCode == SQLITE_ERROR) {
		const char *errorMsg = sqlite3_errmsg(db);
		NSError *errorQuery = [self createDBErrorWithDescription:@(errorMsg)
                                                         andCode:kDBErrorQuery];
		NSLog(@"%@", errorQuery);
	}
	
	while (sqlite3_step(statement) == SQLITE_ROW) {
		int columns = sqlite3_column_count(statement);
		NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:columns];
        
		for (int i = 0; i<columns; i++) {
			const char *name = sqlite3_column_name(statement, i);
            
			NSString *columnName = @(name);
			
			int type = sqlite3_column_type(statement, i);
			
			switch (type) {
				case SQLITE_INTEGER:
				{
					int value = sqlite3_column_int(statement, i);
					result[columnName] = @(value);
					break;
				}
				case SQLITE_FLOAT:
				{
					float value = sqlite3_column_double(statement, i);
					result[columnName] = @(value);
					break;
				}
				case SQLITE_TEXT:
				{
					const char *value = (const char*)sqlite3_column_text(statement, i);
					result[columnName] = @(value);
					break;
				}
                    
				case SQLITE_BLOB:
                {
                    int bytes = sqlite3_column_bytes(statement, i);
                    if (bytes > 0) {
                        const void *blob = sqlite3_column_blob(statement, i);
                        if (blob != NULL) {
                            result[columnName] = [NSData dataWithBytes:blob length:bytes];
                        }
                    }
					break;
                }
                    
				case SQLITE_NULL:
					result[columnName] = [NSNull null];
					break;
                    
				default:
				{
					const char *value = (const char *)sqlite3_column_text(statement, i);
					result[columnName] = @(value);
					break;
				}
                    
			} //end switch
			
			
		} //end for
		
		[resultsArray addObject:result];
		
	} //end while
	sqlite3_finalize(statement);
	
	[self closeDatabase];
	
	return resultsArray;
	
}


/**
 * Closes the database.
 *
 * @return nil if everything was ok, NSError in other case.
 */

- (NSError *) closeDatabase {
	
	NSError *error = nil;
	
	
	if (db != nil) {
		if (sqlite3_close(db) != SQLITE_OK){
			const char *errorMsg = sqlite3_errmsg(db);
			NSString *errorStr = [NSString stringWithFormat:@"The database could not be closed: %@",@(errorMsg)];
			error = [self createDBErrorWithDescription:errorStr andCode:kDBFailAtClose];
		}
		
		db = nil;
	}
	
	return error;
}


/**
 * Creates an SQL dump of the database.
 *
 * This method could get a csv format dump with a few changes.
 * But i prefer working with sql dumps ;)
 *
 * @return an NSString containing the dump.
 */

- (NSString *)getDatabaseDump {
	
	NSMutableString *dump = [[NSMutableString alloc] initWithCapacity:256];
	
	// info string ;) please do not remove it
	[dump appendString:@";\n; Dump generated with SQLiteManager4iOS \n;\n; By Misato (2011)\n"];
	[dump appendString:[NSString stringWithFormat:@"; database %@;\n", [databaseName lastPathComponent]]];
	
	// first get all table information
	
	NSArray *rows = [self getRowsForQuery:@"SELECT * FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"];
	// last sql query returns something like:
	// {
	// name = users;
	// rootpage = 2;
	// sql = "CREATE TABLE users (id integer primary key autoincrement, user text, password text)";
	// "tbl_name" = users;
	// type = table;
	// }
	
	//loop through all tables
	for (int i = 0; i<[rows count]; i++) {
		
		NSDictionary *obj = rows[i];
		//get sql "create table" sentence
		NSString *sql = obj[@"sql"];
		[dump appendString:[NSString stringWithFormat:@"%@;\n",sql]];
        
		//get table name
		NSString *tableName = obj[@"name"];
        
		//get all table content
		NSArray *tableContent = [self getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
		
		for (int j = 0; j<[tableContent count]; j++) {
			NSDictionary *item = tableContent[j];
			
			//keys are column names
			NSArray *keys = [item allKeys];
			
			//values are column values
			NSArray *values = [item allValues];
			
			//start constructing insert statement for this item
			[dump appendString:[NSString stringWithFormat:@"insert into %@ (",tableName]];
			
			//loop through all keys (aka column names)
			NSEnumerator *enumerator = [keys objectEnumerator];
			id obj;
			while (obj = [enumerator nextObject]) {
				[dump appendString:[NSString stringWithFormat:@"%@,",obj]];
			}
			
			//delete last comma
			NSRange range;
			range.length = 1;
			range.location = [dump length]-1;
			[dump deleteCharactersInRange:range];
			[dump appendString:@") values ("];
			
			// loop through all values
			// value types could be:
			// NSNumber for integer and floats, NSNull for null or NSString for text.
			
			enumerator = [values objectEnumerator];
			while (obj = [enumerator nextObject]) {
				//if it's a number (integer or float)
				if ([obj isKindOfClass:[NSNumber class]]){
					[dump appendString:[NSString stringWithFormat:@"%@,",[obj stringValue]]];
				}
				//if it's a null
				else if ([obj isKindOfClass:[NSNull class]]){
					[dump appendString:@"null,"];
				}
				//else is a string ;)
				else{
					[dump appendString:[NSString stringWithFormat:@"'%@',",obj]];
				}
				
			}
			
			//delete last comma again
			range.length = 1;
			range.location = [dump length]-1;
			[dump deleteCharactersInRange:range];
			
			//finish our insert statement
			[dump appendString:@");\n"];
			
		}
		
	}
    
	return dump;
}

-(void)createEditableCopyOfDatabaseIfNeeded:(NSString*)dbNameToCopy {
    BOOL success;//test for existance
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbNameToCopy];
    //NSLog(@"writablePath = %@",writableDBPath);
    
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbNameToCopy];
    //NSLog(@"defaultDBPath = %@", defaultDBPath);
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    //NSLog(@"creating writableDBPath: %@", writableDBPath);
    
    if (!success)
    {
//        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//        NSLog(@"DBWrite Error:%@",[error description]);
//        NSLog(@"Error description-%@ \n", [error localizedDescription]);
//        NSLog(@"Error reason-%@", [error localizedFailureReason]);
        
    }
    //    dbPath = writableDBPath;
    //NSLog(@"dbPath in createEditableCopyOfDatabaseIfNeeded (not exist): %@", dbPath);
    
}


@end


#pragma mark -
@implementation SQLiteManager (Private)

/**
 * Gets the database file path (in NSDocumentDirectory).
 *
 * @return the path to the db file.
 */

- (NSString *)getDatabasePath{
	
	if([[NSFileManager defaultManager] fileExistsAtPath:databaseName]){
		// Already Full Path
		return databaseName;
	} else {
        // Get the documents directory
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = dirPaths[0];
        
        return [docsDir stringByAppendingPathComponent:databaseName];
	}
}

/**
 * Creates an NSError.
 *
 * @param description the description wich can be queried with [error localizedDescription];
 * @param code the error code (code erors are defined as enum in the header file).
 *
 * @return the NSError just created.
 *
 */

- (NSError *)createDBErrorWithDescription:(NSString*)description andCode:(int)code {
	
	NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description};
	NSError *error = [NSError errorWithDomain:@"SQLite Error" code:code userInfo:userInfo];
	
	return error;
}



@end

