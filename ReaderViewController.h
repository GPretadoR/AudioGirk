//
//  ReaderViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 10/24/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZipArchive.h"

#import <QuartzCore/QuartzCore.h>
#import "XMLHandler.h"
#import "EpubContent.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SQLiteManager.h"

#import "EPub.h"
#import "Chapter.h"

#import "BookMarkViewController.h"
#import "ReaderSettingsViewController.h"

@class SearchResultsViewController;
@class SearchResult;


@interface ReaderViewController : UIViewController <UIWebViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, UIPopoverControllerDelegate,UIScrollViewDelegate, AVAudioSessionDelegate, AVAudioPlayerDelegate,UIPopoverControllerDelegate, BookMarkViewControllerDelegate, ReaderSettingDelegate>
{
    UIWebView *webView;
    BOOL isInverted;
    ReaderSettingsViewController *readerSettings;

 }


@property (nonatomic) MPMoviePlayerController *audioPlayer;
@property (nonatomic,retain) NSString *bookPathToLoad;
@property (nonatomic,retain) NSString *bookID;



- (NSInteger)stringHighlight:(NSString*)str;

-(void)day;
-(void)night;
-(void)plusA;
-(void)minusA;

@end
