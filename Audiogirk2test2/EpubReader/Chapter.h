//
//  Chapter.h
//  AePubReader
//
//  Created by Federico Frappi on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Chapter;

@protocol ChapterDelegate <NSObject>
@required
- (void) chapterDidFinishLoad:(Chapter*)chapter;
@end

@interface Chapter : NSObject <UIWebViewDelegate>{
    NSString* spinePath;
    NSString* title;
	NSString* text;
    __unsafe_unretained id <ChapterDelegate> delegate;
    int pageCount;
    int chapterIndex;
    CGRect windowSize;
    int fontPercentSize;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) int pageCount, chapterIndex, fontPercentSize;
@property (nonatomic, readonly) NSString *spinePath, *title, *text;
@property (nonatomic, readonly) CGRect windowSize;

- (instancetype) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex NS_DESIGNATED_INITIALIZER;

- (void) loadChapterWithWindowSize:(CGRect)theWindowSize fontPercentSize:(int) theFontPercentSize;

@end
