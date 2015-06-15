//
//  AppDelegate.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreViewController.h"

@class LeftViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{


}

- (void) showSolidStatusBar:(BOOL) solidStatusBar;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftViewController *leftViewController;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) UIViewController *centerController;
@property (nonatomic, strong) UIView *statusBarBackground;
@property (nonatomic, strong) StoreViewController* storeView;

@end
