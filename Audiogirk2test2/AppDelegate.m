//
//  AppDelegate.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "LeftViewController.h"

#import "AGNavBar.h"
#import "IIWrapController.h"
#import "RentalLogicManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

#import "LoginViewController.h"

#import "ServerJSONRequest.h"

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE

@implementation AppDelegate {

    RentalLogicManager *rentalLogic;
}

BOOL isCreated=FALSE;

@synthesize leftViewController,navigationController,centerController;
@synthesize storeView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        [application setStatusBarStyle:UIStatusBarStyleDefault];
//        self.window.clipsToBounds =YES;
//        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
//        
//        //Added on 19th Sep 2013
//        self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
//    }
    if (iOSVersion7) {
        // Add a status bar background
        if ([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait) {
            self.statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, 20.0f)];
        }else if ([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown){
            self.statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0,self.window.bounds.size.height-20.0f , self.window.bounds.size.width, 20.0f)];
        }

        self.statusBarBackground.backgroundColor = [UIColor colorWithRed:235/255.0f green:200/255.0f blue:94/255.0f alpha:1.0f];
        self.statusBarBackground.alpha = 1.0;
        self.statusBarBackground.userInteractionEnabled = NO;
        self.statusBarBackground.layer.zPosition = 999; // Position its layer over all other views
        [self.window addSubview:self.statusBarBackground];
        
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDidChangeStatusBarOrientationNotification:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    leftViewController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    [leftViewController.view setBackgroundColor:[UIColor colorWithRed:243/255.0f green:119/255.0f blue:75/255.0f alpha:1.0f]];
  
    storeView = [[StoreViewController alloc]init];
//    navigationController=[[UINavigationController alloc]initWithRootViewController:storeView];
    navigationController=[[UINavigationController alloc]initWithNavigationBarClass:[AGNavBar class] toolbarClass:nil];
    [navigationController setViewControllers:@[storeView]];

    storeView.nav=navigationController;
    self.centerController=storeView;
    storeView.behavior=IIViewDeckNavigationControllerIntegrated;
    IIViewDeckController* deckController = [[IIViewDeckController alloc] initWithCenterViewController:navigationController leftViewController:leftViewController];
    
    deckController.maxSize = 462;
    self.window.rootViewController = [[IIWrapController alloc] initWithViewController:deckController];
    [self.window makeKeyAndVisible];

//    [Fabric with:@[TwitterKit]];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"token = %@",[FBSDKAccessToken currentAccessToken].userID);
    }

//    [self checkLoginState];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void) showSolidStatusBar:(BOOL) solidStatusBar
{
    [UIView animateWithDuration:0.3f animations:^{
        if(solidStatusBar)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            self.statusBarBackground.alpha = 1.0f;
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            self.statusBarBackground.alpha = 0.0f;
        }
    }];
}

- (void)handleDidChangeStatusBarOrientationNotification:(NSNotification *)notification;
{
    // Do something interesting
//    NSLog(@"The orientation is %@", [notification.userInfo objectForKey: UIApplicationStatusBarOrientationUserInfoKey]);
    
    
    if ([(notification.userInfo)[UIApplicationStatusBarOrientationUserInfoKey] integerValue]==1) {
        [self.statusBarBackground removeFromSuperview];
        self.statusBarBackground.frame=CGRectMake(0,self.window.bounds.size.height-20.0f , self.window.bounds.size.width, 20.0f);
        [self.window addSubview:self.statusBarBackground];
    }else if ([(notification.userInfo)[UIApplicationStatusBarOrientationUserInfoKey] integerValue]==2){
        [self.statusBarBackground removeFromSuperview];
        self.statusBarBackground.frame=CGRectMake(0, 0, self.window.bounds.size.width, 20.0f);
        [self.window addSubview:self.statusBarBackground];
    }
}

- (void) checkLoginState{
    NSUserDefaults *userdefs = [NSUserDefaults standardUserDefaults];
    [userdefs removeObjectForKey:@"token"];
    [userdefs synchronize];
    if ([@"" isEqualToString:[userdefs objectForKey:@"token"]] || [userdefs objectForKey:@"token"] == nil) {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        [self.navigationController presentViewController:loginView animated:NO completion:nil];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [RentalLogicManager deleteExpiredBooks];
    ServerJSONRequest *serverJSONRequest = [[ServerJSONRequest alloc] init];
 
    [serverJSONRequest checkInternetConnection:^(BOOL isReachable){
        if (isReachable) {
            return;
        }else{
        
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL shouldOpen = FALSE;
    
    if ([url.scheme hasPrefix:@"fb"]) {
        shouldOpen = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                    openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
    }else if ([url.scheme hasPrefix:@"com.google"]){
        shouldOpen = [[GIDSignIn sharedInstance] handleURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
    
    }
    
    return shouldOpen;
}


@end
