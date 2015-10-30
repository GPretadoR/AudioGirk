//
//  DecriptionViewController.m
//  A2Test2
//
//  Created by Garnik Ghazaryan on 8/30/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "DecriptionViewController.h"
#import "AppDelegate.h"

#import "SQLiteManager.h"

#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RentIAPHelper.h"

@interface DecriptionViewController ()

@end

@implementation DecriptionViewController {

    NSString* downloadURL;
    SQLiteManager *dbManager;
    NSMutableArray *myBooksItems;
    UITapGestureRecognizer *tapBehindGesture;
    UIPopoverController *shareViewPopover;
    IBOutlet UIProgressView *line;
    
    BookItemsObject *bookItemObject;
    NSInteger buttonTag;
    
    MPMoviePlayerController *streamPlayer;
    
    BOOL didLayout;
}

@synthesize descrImageView,bookName,authorName,timeLabel,description;
@synthesize bookID,bookFormat,bookDictionary;
@synthesize downloadButton,sampleButton;
@synthesize bookItemObject;
@synthesize bannerItemObject;
@synthesize delegate;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark View LifeCycle
-(void)viewWillAppear:(BOOL)animated{
    [self checkBookAvailability];
    [self configureView];
    [self.view setNeedsLayout];

}
-(void)viewDidDisappear:(BOOL)animated{

    bookItemObject = nil;
    bannerItemObject = nil;
    [streamPlayer stop];
    streamPlayer = nil;
}


- (void)viewDidUnload {
    [self setDescrImageView:nil];
    [self setBookName:nil];
    [self setAuthorName:nil];
    [self setTimeLabel:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager=[SQLiteManager sharedDBManager];
    [dbManager getDatabaseDump];
    [downloadButton addTarget:self action:@selector(getTheBook) forControlEvents:UIControlEventTouchUpInside];
    
    if(!tapBehindGesture) {
        tapBehindGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBehindDetected:)];
        [tapBehindGesture setNumberOfTapsRequired:1];
        [tapBehindGesture setCancelsTouchesInView:NO]; //So the user can still interact with controls in the modal view
    }
    
    [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:tapBehindGesture];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self layout];
}
- (void) layout{
    self.view.superview.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.view.superview.layer.cornerRadius = 8.0;
    self.view.superview.layer.masksToBounds = YES;
    
    CGRect screen = self.view.superview.bounds;
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    float x = (screen.size.width - frame.size.width)*.5f;
    float y = (screen.size.height - frame.size.height)*.5f;
    frame = CGRectMake(x, y, frame.size.width, frame.size.height);
    
    self.view.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}
#pragma mark Methods

- (void) configureView{
    [Utils setViewToAddOn:self.view];
    if (bookItemObject != nil) {
        authorName.text = bookItemObject.b_author;
        bookName.text = bookItemObject.b_name;
        timeLabel.text = @"43:59";
        description.text = bookItemObject.b_desc;
        [descrImageView setImageWithURL:[NSURL URLWithString:bookItemObject.b_image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
    }else if (bannerItemObject != nil){
        authorName.text = bannerItemObject.b_author;
        bookName.text = bannerItemObject.b_name;
        timeLabel.text = @"43:59";
        description.text = bannerItemObject.b_desc;
        [descrImageView setImageWithURL:[NSURL URLWithString:bannerItemObject.b_image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    CGRect tmpRect = description.frame;
    if ([bookItemObject.format isEqualToString:@"audio"] || [bookItemObject.format isEqualToString:@"mixed"]) {
        [self setupAudioViewWithDirName:bookItemObject.id];
        tmpRect.origin.y = 300;
        tmpRect.size.height = 310;
    }else {
        tmpRect.origin.y = 260;
        tmpRect.size.height = 350;
    }
    description.frame = tmpRect;

}
- (void) setupAudioViewWithDirName:(NSString*)filename{
    
    NSString *path = [NSString stringWithFormat:@"http://109.68.124.16/book_files/sample_audio/%@/prog_index.m3u8",filename];
    NSURL *streamURL = [NSURL URLWithString:path];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loadStateDidChange:)
//                                                 name:MPMoviePlayerLoadStateDidChangeNotification
//                                               object:player];
//    if ([player respondsToSelector:@selector(loadState)])
//    {
//        [player prepareToPlay];
//        player.movieSourceType = MPMovieSourceTypeStreaming;
//    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieplayerDidFinish:) name:@"MPMoviePlayerPlaybackDidFinishNotification" object:nil];

    if (!streamPlayer) {
        streamPlayer = [[MPMoviePlayerController alloc] initWithContentURL:streamURL];
        // depending on your implementation your view may not have it's bounds set here
        // in that case consider calling the following 4 msgs later
        [streamPlayer.view setFrame: CGRectMake(20, line.frame.origin.y + 22, line.frame.size.width, 39)];
        streamPlayer.view.backgroundColor = [UIColor clearColor];
        
        [Utils createImageViewWithRect:streamPlayer.view.frame image:[UIImage imageNamed:@"playerBack.png"]];
        
        streamPlayer.controlStyle = MPMovieControlStyleDefault;
        streamPlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [self.view addSubview: streamPlayer.view];
        
        [streamPlayer prepareToPlay];
        streamPlayer.shouldAutoplay = NO;
    
    }

}
- (void) movieplayerDidFinish:(NSNotification*)notif{
    
    
}

- (void) checkBookAvailability{
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from 'myBooks'"];
    myBooksItems=[NSMutableArray  arrayWithArray:[dbManager getRowsForQuery:sqlStr]];
    
    if ([myBooksItems count] == 0) {
        return;
    }
    NSDictionary *bookDict;
    for (int i = 0; i < [myBooksItems count]; i++) {
        bookDict = myBooksItems[i];
        if ([bookDict[@"bookID"] intValue] == [bookItemObject.id intValue]) {
            [downloadButton setTitle:@"Open" forState:UIControlStateNormal];
            [downloadButton removeTarget:self action:@selector(getTheBook) forControlEvents:UIControlEventTouchUpInside];
            [downloadButton addTarget:self action:@selector(openBook) forControlEvents:UIControlEventTouchUpInside];
            [sampleButton removeFromSuperview];
        }else {
            [downloadButton setTitle:@"Rent" forState:UIControlStateNormal];
            [downloadButton removeTarget:self action:@selector(openBook) forControlEvents:UIControlEventTouchUpInside];
            [downloadButton addTarget:self action:@selector(getTheBook) forControlEvents:UIControlEventTouchUpInside];
            if (![sampleButton isDescendantOfView:self.view]) {
                [self.view addSubview:sampleButton];
            }
        }
    }
}

- (void) openBook {
    [self dismissViewControllerAnimated:NO completion:nil];
    [delegate openBookPressed];
    NSLog(@"Open book");
}

- (UILabel*) changeFrameOfLabel:(UILabel*)label  andText:(NSString*)text{

    CGRect rect = label.frame;
    rect = CGRectMake(rect.origin.x, rect.origin.y, [Utils getTextBoundsSize:text font:[UIFont systemFontOfSize:17]].width, [Utils getTextBoundsSize:text font:[UIFont systemFontOfSize:17]].height);
    label.text = text;
    label.frame = rect;

    return label;
}


- (IBAction)closeController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonPressed:(id)sender {
    NSString *textToShare = @"your text";
    UIImage *imageToShare = descrImageView.image;
    NSArray *itemsToShare = @[textToShare, imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed){
        self.navigationController.navigationBar.hidden = NO;
    }];
    
    if(shareViewPopover==nil){
        shareViewPopover = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [shareViewPopover setPopoverContentSize:CGSizeMake(300, 150)];
    }
    if (![shareViewPopover isPopoverVisible]) {
        [shareViewPopover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }else{
        [shareViewPopover dismissPopoverAnimated:YES];
        shareViewPopover = nil;
    }

}

- (IBAction)likeButtonPressed:(id)sender {
    NSLog(@"current time :%f", [streamPlayer currentPlaybackTime]);
}


- (void)getTheBook {

    [RentIAPHelper setBookItemsObject:bookItemObject];
    [[RentIAPHelper sharedInstance] rentProductWithIdentifier:@"com.book1.audio"];

}
- (void)tapBehindDetected:(UITapGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Convert tap location into the local view's coordinate system. If outside, dismiss the view.
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
//            if(self.presentedViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
//            }
        }
    }
}

@end
