//
//  SettingsViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/22/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "SettingsViewController.h"
#import "RentIAPHelper.h"
#import "AGBarButtonItem.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[[AGBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ShowMenu.png"] target:self action:@selector(goBack)]];
    }
    return self;
}

- (void)viewDidLoad
{
    self.title=@"Settings";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)restorPurchases:(id)sender {
    
    [[RentIAPHelper sharedInstance] restoreCompletedTransactions];
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
