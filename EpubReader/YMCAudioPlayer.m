//
//  YMCAudioPlayer.m
//  AudioPlayerTemplate
//
//  Created by ymc-thzi on 13.08.13.
//  Copyright (c) 2013 ymc-thzi. All rights reserved.
//

#import "YMCAudioPlayer.h"
#import "Utils.h"
@implementation YMCAudioPlayer

/*
 * Get Application directory Path
 */

/*
 * Init the Player with Filename and FileExtension
 */
- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension
{
//    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:audioFile withExtension:fileExtension];
    NSString *applicationDir = [Utils applicationDocumentsDirectory];
    NSString *audioFilePath = [NSString stringWithFormat:@"%@/%@.%@",applicationDir,audioFile,fileExtension];
    NSURL *audioFileLocationURL = [NSURL fileURLWithPath:audioFilePath];
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];

    if (error) {
        NSLog(@"Error loading audio :%@",[error localizedDescription]);
    }
}

/*
 * Simply fire the play Event
 */
- (void)playAudio {
    [self.audioPlayer play];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [self.audioPlayer pause];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    long roundedSeconds = lroundf(seconds);
    long roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%ld:%02ld",
                      roundedMinutes, roundedSeconds];
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
- (void)setCurrentAudioTime:(float)value {
    [self.audioPlayer setCurrentTime:value];
}

/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime {
    return [self.audioPlayer currentTime];
}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration {
    return [self.audioPlayer duration];
}
- (BOOL)isPlaying{
    return  [self.audioPlayer isPlaying];
}

@end
