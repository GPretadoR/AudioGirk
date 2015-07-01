//
//  InfoViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 3/23/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "InfoViewController.h"
#import "Utils.h"

@interface InfoViewController ()

@end

@implementation InfoViewController{

    IBOutlet UITextView *informTextView;
    IBOutlet UIButton *closeButton;

    
    CGSize screenSize;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.view setNeedsLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 540, 620);
    screenSize = self.view.frame.size;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self layout];
}
- (void) layout{
    self.view.superview.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.view.superview.layer.cornerRadius = 8.0;
    self.view.superview.layer.masksToBounds = YES;
    
    CGRect screen = self.view.superview.bounds;
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    float x = (screen.size.width - frame.size.width)*.5f;
    float y = (screen.size.height - frame.size.height)*.5f;
    frame = CGRectMake(x, y, frame.size.width, frame.size.height);
    
    self.view.frame = frame;
}
#pragma mark Actions

- (IBAction) closeButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
