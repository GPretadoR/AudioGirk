//
//  BookToCViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 2/21/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZipArchive.h"

#import <QuartzCore/QuartzCore.h>
#import "XMLHandler.h"
#import "EpubContent.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SQLiteManager.h"
#import "ReaderViewController.h"

#import "EPub.h"
#import "Chapter.h"

#import "BookObjectFromDB.h"

@interface BookToCViewController : UIViewController <XMLHandlerDelegate,UITableViewDataSource,UITableViewDelegate>{

    XMLHandler *_xmlHandler;
	EpubContent *_ePubContent;
	NSString *_pagesPath;
	NSString *_rootPath;
	NSString *_strFileName;
    int _pageNumber;
    
    SQLiteManager *dbManager;
    
    EPub *loadedEpub;
    
    ReaderViewController *readerViewController;
}

@property (nonatomic, strong)EpubContent *_ePubContent;
@property (nonatomic, strong)NSString *_rootPath;
@property (nonatomic, strong)NSString *_strFileName;
@property (nonatomic) MPMoviePlayerController *audioPlayer;

@property (nonatomic, strong) NSString *bookID;
@property (nonatomic, strong) NSString *bookFormat;
@property (nonatomic, strong) BookObjectFromDB *bookObjDB;

@property (weak, nonatomic) IBOutlet UITableView *chapterTableView;


@end
