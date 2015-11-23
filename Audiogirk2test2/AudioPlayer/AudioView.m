//
//  AudioViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 8/28/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "AudioView.h"
#import "SQLiteManager.h"
#import "PCSEQVisualizer.h"

@interface AudioView ()

@end

@implementation AudioView {
    PCSEQVisualizer* eq;
    
}

@synthesize bookObjDB;

-(instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
    }
    return self;

}
- (void) playerSetup{
    [self sliderViewConfigs];
    [self configurePlayerView];
    [self visualizerSetup];
}
- (void) configurePlayerView{
    
    self.audioPlayer = [[YMCAudioPlayer alloc] init];

    NSError *setCategoryError = nil;
    NSError *activationError = nil;
    
    [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationError];
    NSLog(@"Errors with audiosession : Cat: %@ active: %@",[setCategoryError localizedDescription],[activationError localizedDescription]);
}

- (void) prepareToPlay{
    
    NSString *strFileName = [[NSString stringWithFormat:@"%@",bookObjDB.bookSourceID ] stringByDeletingPathExtension];
    NSString *audioFilePath = [NSString stringWithFormat:@"%@_%@", bookObjDB.format,strFileName ];
    
    [self setupAudioPlayer:[NSString stringWithFormat:@"%@/%@",audioFilePath,strFileName]];

}

-(void)viewDidAppear:(BOOL)animated{
    [self setNowPlayingInfo];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{

    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

#pragma mark Visualizer setup

- (void) visualizerSetup{
    eq = [[PCSEQVisualizer alloc]initWithNumberOfBars:47];
    
    eq.barColor = [UIColor redColor];
    //position eq in the middle of the view
    CGRect frame = eq.frame;
    frame.origin.x = self.currentTimeSlider.frame.origin.x;
    frame.origin.y = self.currentTimeSlider.frame.origin.x - eq.frame.size.height - 20;
    eq.frame = frame;
    
    [self addSubview:eq];

}

#pragma mark Audioplayer setup

- (void) sliderViewConfigs{
    
    UIImage* sliderCenterImage = [UIImage imageNamed:@"sliderCenter.png"];
    [self.currentTimeSlider setThumbImage:sliderCenterImage forState:UIControlStateNormal];
    UIImage *leftStretch2 = [[UIImage imageNamed:@"minTrackImage.png"]
                             stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    [self.currentTimeSlider setMinimumTrackImage:leftStretch2 forState:UIControlStateNormal];
    UIImage *rightStretch = [[UIImage imageNamed:@"maxTrackImage.png"]
                             stretchableImageWithLeftCapWidth:1.0 topCapHeight:0.0];
    [self.currentTimeSlider setMaximumTrackImage:rightStretch forState:UIControlStateNormal];
    
}

/*
 * Set nowplaying info for control center
 */
- (void) setNowPlayingInfo{
    
    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
    
    NSString *bookName = bookObjDB.bookName;
    NSString *authorName = bookObjDB.bookAuthorName;
    
    songInfo[MPMediaItemPropertyTitle] = bookName;
    songInfo[MPMediaItemPropertyArtist] = authorName;
    songInfo[MPMediaItemPropertyPlaybackDuration] = @([self.audioPlayer getAudioDuration]);
    songInfo[MPMediaItemPropertyReleaseDate] = @"1950";
    [songInfo setValue:@1.0 forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [songInfo setValue:[NSNumber numberWithFloat:[self.audioPlayer getCurrentAudioTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
}
/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer:(NSString*)fileName
{
    //insert Filename & FileExtension
    NSString *fileExtension = @"mp3";
    
    //init the Player to get file properties to set the time labels
    [self.audioPlayer initPlayer:fileName fileExtension:fileExtension];
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    self.timeElapsed.text = @"0:00";
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
}
/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    [self play];
}
- (void) play {

    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_pause.png"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        [eq start];
        [self.audioPlayer playAudio];
        self.isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                   forState:UIControlStateNormal];
        [eq stop];
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
    [self setNowPlayingInfo];
}
/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self.audioPlayer getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
    [self setNowPlayingInfo];
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}


- (void) interruption:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSNumber* interuptionTypeValue = [interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey];
    NSUInteger interuptionType = [interuptionTypeValue intValue];
    
    if (interuptionType == AVAudioSessionInterruptionTypeBegan)
        [self beginInterruption];
#if __CC_PLATFORM_IOS >= 40000
    else if (interuptionType == AVAudioSessionInterruptionTypeEnded)
        [self endInterruptionWithFlags:(NSUInteger)[interuptionDict valueForKey:AVAudioSessionInterruptionOptionKey]];
#else
    else if (interuptionType == AVAudioSessionInterruptionTypeEnded)
        [self endInterruption];
#endif
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self play];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (self.audioPlayer.isPlaying == MPMoviePlaybackStatePlaying) {
                    [self play];
                }
                else {
                    [self play];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                break;
            default:
                break;
        }
    }
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
