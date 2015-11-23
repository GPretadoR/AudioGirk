//
//  AudioPlayerViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/2/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "AudioView.h"
#import "Utils.h"

@interface AudioPlayerViewController ()

@end

@implementation AudioPlayerViewController {
    AudioView *audioPlayer;
    IBOutlet UIImageView *bookImageView;
    IBOutlet UILabel *bookNameLabel;
    IBOutlet UILabel *bookAuthorLabel;
    IBOutlet UILabel *bookGenreLabel;
}

@synthesize bookObjDB;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utils setViewToAddOn:self.view];
    [self.view setBackgroundColor:rgba(86, 84, 84, 1)];
////    audioPlayer = [[AudioView alloc] initWithFrame:CGRectMake(0, 100, 481, 115)];
//    audioPlayer =  [[[NSBundle mainBundle] loadNibNamed:@"AudioView" owner:nil options:nil] objectAtIndex:0];
//    audioPlayer.bookObjDB = bookObjDB;
//    [audioPlayer startPlaying];
//    [self.view addSubview:audioPlayer];

    UIViewController *controller=[[UIViewController alloc] initWithNibName:@"AudioView" bundle:nil];
    audioPlayer = (AudioView*)controller.view;
    audioPlayer.frame = CGRectMake(bookImageView.frame.origin.x, bookImageView.frame.origin.y + bookImageView.frame.size.height, audioPlayer.frame.size.width, audioPlayer.frame.size.height);
    audioPlayer.bookObjDB = bookObjDB;
    [audioPlayer playerSetup];
    [audioPlayer prepareToPlay];
    [self.view addSubview:audioPlayer];

    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) uiConfigurations{
    
//    UIImageView *bookImage = [Utils createImageViewWithRect:CGRectMake(20, 40, 180, 270) image:[UIImage imageNamed:@"HarryPotter.png"]];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
