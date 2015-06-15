//
//  AudioPlayerViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/2/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioPlayerViewController : UIViewController <AVAudioSessionDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong)NSString *bookID;
@property (nonatomic, strong)NSString *bookFormat;
@end
