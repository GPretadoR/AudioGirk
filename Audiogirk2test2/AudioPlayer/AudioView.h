//
//  AudioViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 8/28/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BookObjectFromDB.h"

@interface AudioView : UIView <AVAudioSessionDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) YMCAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *timeElapsed;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UISlider *currentTimeSlider;

@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;

@property (strong, nonatomic) BookObjectFromDB *bookObjDB;

- (void) prepareToPlay;
- (void) playerSetup;
@end
