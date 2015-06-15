//
//  EPub.m
//  AePubReader
//
//  Created by Federico Frappi on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EPub.h"
#import "ZipArchive.h"
#import "Chapter.h"
#import "Utils.h"

@interface EPub()

- (void) parseEpub;
- (NSString*) parseManifestFile;
- (void) parseOPF:(NSString*)opfPath;

@end

@implementation EPub {
    
    NSString *documentsDirectory;
    
}

@synthesize spineArray;

- (id) initWithEPubPath:(NSString *)path{
	if((self=[super init])){
		epubFilePath = [path retain];
		spineArray = [[NSMutableArray alloc] init];
        documentsDirectory = [Utils applicationDocumentsDirectory];
		[self parseEpub];
	}
	return self;
}

- (void) parseEpub{
    [Utils unzipAndSaveFile:[epubFilePath lastPathComponent] atPath:[epubFilePath stringByDeletingLastPathComponent]];
    NSString* opfPath = [self parseManifestFile];
	[self parseOPF:opfPath];
}



- (NSString*) parseManifestFile{
	NSString* manifestFilePath = [NSString stringWithFormat:@"%@/META-INF/container.xml", [epubFilePath stringByDeletingPathExtension]];
//	NSLog(@"%@", manifestFilePath);
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if ([fileManager fileExistsAtPath:manifestFilePath]) {
//		NSLog(@"Valid epub");
		CXMLDocument* manifestFile = [[[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil] autorelease];
		CXMLNode* opfPath = [manifestFile nodeForXPath:@"//@full-path[1]" error:nil];
//		NSLog(@"%@", [NSString stringWithFormat:@"%@/%@", [epubFilePath stringByDeletingPathExtension], [opfPath stringValue]]);
		return [NSString stringWithFormat:@"%@/%@", [epubFilePath stringByDeletingPathExtension], [opfPath stringValue]];
	} else {
		NSLog(@"ERROR: ePub not Valid");
		return nil;
	}
	[fileManager release];
}

- (void) parseOPF:(NSString*)opfPath{
    
    int i=0;
    NSString* dictStoreValue=[NSString stringWithFormat:@"valueDict%d",i];
	CXMLDocument* opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
	NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//	NSLog(@"itemsArray size: %d", [itemsArray count]);
    
    NSString* ncxFileName;
	
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
	for (CXMLElement* element in itemsArray) {
		[itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFileName = [[element attributeForName:@"href"] stringValue];
//          NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }
        
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/html+xml"]){
            ncxFileName = [[element attributeForName:@"href"] stringValue];
//          NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }
	}
	
    unsigned long lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
	NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
    CXMLDocument* ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
//    for (CXMLElement* element in itemsArray) {
//        
//        NSString* href = [[element attributeForName:@"href"] stringValue];
//        
        NSString* attrOfContent=@"//ncx:content[@src]";
        NSArray* tmpNavPoints = [ncxToc nodesForXPath:attrOfContent namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
    NSString *valueOfContent=nil;
        for (CXMLElement *element in tmpNavPoints) {
            valueOfContent=[[element attributeForName:@"src"]stringValue];
//            NSLog(@"elements:%@",valueOfContent);
        
        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", valueOfContent];
        NSArray* navPoints = [ncxToc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
        if([navPoints count]!=0){
            CXMLElement* titleElement = [navPoints objectAtIndex:0];
//            NSLog(@"Title:%@",[titleElement stringValue]);
            dictStoreValue=[NSString stringWithFormat:@"valueDict%d",i];
            [titleDictionary setValue:[titleElement stringValue] forKey:dictStoreValue];
            i++;
        }
    }
    i=0;
	
	NSArray* itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//	NSLog(@"itemRefsArray size: %d", [itemRefsArray count]);
	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    int count = 0;
	for (CXMLElement* element in itemRefsArray) {
        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];
        dictStoreValue=[NSString stringWithFormat:@"valueDict%d",i];
       Chapter* tmpChapter = [[Chapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, chapHref]
                                                     title:[titleDictionary valueForKey:dictStoreValue ]
                                              chapterIndex:count++];
        
		[tmpArray addObject:tmpChapter];
		
		[tmpChapter release];
        i++;
        
	}
	
	self.spineArray = [NSArray arrayWithArray:tmpArray]; 
	
	[opfFile release];
	[tmpArray release];
	[ncxToc release];
	[itemDictionary release];
	[titleDictionary release];
}

- (void)dealloc {
    [spineArray release];
	[epubFilePath release];
    [super dealloc];
}

@end
