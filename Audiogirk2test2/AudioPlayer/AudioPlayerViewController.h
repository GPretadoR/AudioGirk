//
//  AudioPlayerViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/2/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BookObjectFromDB.h"

#import "YMCAudioPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AudioPlayerViewController : UIViewController <AVAudioSessionDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) BookObjectFromDB *bookObjDB;
@end
