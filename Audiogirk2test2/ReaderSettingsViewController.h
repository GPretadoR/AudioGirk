//
//  ReaderSettingsViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 2/17/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReaderSettingDelegate <NSObject>

@optional
- (void) didBackgroundSwitchToDay:(BOOL)isDay;
- (void) didTextSizeIncrease:(BOOL)didIncrease sliderValue:(int)sliderValue;


@end

@interface ReaderSettingsViewController : UIViewController{


}

- (IBAction)backgroundSwitcher:(id)sender;

- (IBAction)fontSizeChanger:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) BOOL switcherState;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;

@property (nonatomic) id delegate;




@end
