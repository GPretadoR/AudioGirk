//
//  AlreadyDownloadedViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/22/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "AlreadyDownloadedViewController.h"
#import "AGBarButtonItem.h"

@interface AlreadyDownloadedViewController ()

@end

@implementation AlreadyDownloadedViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[[AGBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ShowMenu.png"] target:self action:@selector(goBack)]];
    }
    return self;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
