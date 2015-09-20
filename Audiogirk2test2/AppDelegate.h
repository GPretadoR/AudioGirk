//
//  AppDelegate.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{


}
//Garnik-s.${PRODUCT_NAME:rfc1034identifier}

- (void) showSolidStatusBar:(BOOL) solidStatusBar;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIView *statusBarBackground;


@end
