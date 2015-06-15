//
//  ReaderSettingsViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 2/17/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "ReaderSettingsViewController.h"

@interface ReaderSettingsViewController ()

@end

@implementation ReaderSettingsViewController{

    int prevValue;
    int currentValue;
    NSUserDefaults *userDefs;
}

@synthesize switcher,slider,switcherState;
@synthesize delegate;
@synthesize dayLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    prevValue=slider.value*100;
    currentValue=slider.value*100;
    userDefs = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (switcherState) {
        [switcher setOn:YES];
        dayLabel.text = @"Day Mode";
    }else{
        [switcher setOn:NO];
        dayLabel.text = @"Night Mode";
    }
    currentValue = [userDefs objectForKey:@"fontTextSize"]  ? [[userDefs objectForKey:@"fontTextSize"] integerValue]: 3;
    NSLog(@"slider value :%f",(currentValue * 10 + 15)/100.0);
    [slider setValue:(currentValue * 10 + 15)/100.0 animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundSwitcher:(id)sender {
    NSLog(@"Switcher Value:%hhd",switcher.isOn);
    [delegate didBackgroundSwitchToDay:switcher.isOn];
    
    if (switcher.isOn) {
        dayLabel.text = @"Day Mode";
    }else{
        dayLabel.text = @"Night Mode";
    }

}

- (int) slideStepChanger{
    int currentStep = 0;
    
    currentValue=slider.value*100;
    if (currentValue>=0 && currentValue<=15) {
        currentStep=0;
    }else{
        if (currentValue>=16 && currentValue<=30) {
            currentStep=1;
        }else{
            if (currentValue>=31 && currentValue<=45) {
                currentStep=2;
            }else{
                if (currentValue>=46 && currentValue<=60) {
                    currentStep=3;
                }else{
                    if (currentValue>=61 && currentValue<=76) {
                        currentStep=4;
                    }else{
                        if (currentValue>=77 && currentValue<=90) {
                            currentStep=5;
                        }else{
                            if (currentValue>=90 && currentValue<=100) {
                                currentStep=6;
                            }
                        }
                    }
                }
            }
        }
    }
    //===========

    return currentStep;
    
}



- (IBAction)fontSizeChanger:(id)sender {
    currentValue=slider.value*100;
//    NSLog(@"slider:%d",currentValue);
    
    int sliderValue=[self slideStepChanger];
    
//    currentValue=[self slideStepChanger];
    if (prevValue < sliderValue) {
        [delegate didTextSizeIncrease:YES sliderValue:sliderValue];
    }else if (prevValue > sliderValue){
        [delegate didTextSizeIncrease:NO sliderValue:sliderValue];
    }
    
    prevValue=sliderValue;
    NSLog(@"prev:%d",prevValue);
    
    
}
- (IBAction)plusA:(id)sender {
    [delegate didTextSizeIncrease:YES sliderValue:0];
}

- (IBAction)minusA:(id)sender {
    [delegate didTextSizeIncrease:NO sliderValue:0];
}
@end
