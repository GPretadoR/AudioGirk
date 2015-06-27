//
//  AudioPlayerViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/2/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "AudioViewController.h"

@interface AudioPlayerViewController ()

@end

@implementation AudioPlayerViewController {
    AudioViewController *audioPlayer;
}
@synthesize bookID;
@synthesize bookFormat;

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
    audioPlayer = [[AudioViewController alloc] initWithNibName:@"AudioViewController" bundle:nil];
    audioPlayer.bookID = bookID;
    audioPlayer.bookFormat = bookFormat;
    audioPlayer.view.frame = CGRectMake(0, 100, audioPlayer.view.frame.size.width, audioPlayer.view.frame.size.height);
    [self.view addSubview:audioPlayer.view];
    

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [audioPlayer viewDidAppear:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [audioPlayer viewDidDisappear:YES];
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
