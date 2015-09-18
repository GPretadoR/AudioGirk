//
//  AudioPlayerViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/2/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "AudioView.h"

@interface AudioPlayerViewController ()

@end

@implementation AudioPlayerViewController {
    AudioView *audioPlayer;
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
    
    [self.view setBackgroundColor:[UIColor redColor]];
////    audioPlayer = [[AudioView alloc] initWithFrame:CGRectMake(0, 100, 481, 115)];
//    audioPlayer =  [[[NSBundle mainBundle] loadNibNamed:@"AudioView" owner:nil options:nil] objectAtIndex:0];
//    audioPlayer.bookObjDB = bookObjDB;
//    [audioPlayer startPlaying];
//    [self.view addSubview:audioPlayer];

    UIViewController *controller=[[UIViewController alloc] initWithNibName:@"AudioView" bundle:nil];
    audioPlayer = (AudioView*)controller.view;
    audioPlayer.frame = CGRectMake(50, 100, audioPlayer.frame.size.width, audioPlayer.frame.size.height);
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
