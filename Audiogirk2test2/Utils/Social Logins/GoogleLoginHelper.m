//
//  GoogleLoginHelper.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/27/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "GoogleLoginHelper.h"
#import <GoogleSignIn/GoogleSignIn.h>

static NSString * const kClientID = @"308320484366-mvhto43q6dk4sjf27eomss74fto702m2.apps.googleusercontent.com";

@interface GoogleLoginHelper () <GIDSignInDelegate, GIDSignInUIDelegate>

@end

@implementation GoogleLoginHelper {
    
    GIDSignInButton *signInButton;
}

@synthesize target;
@synthesize delegate;

+ (instancetype) sharedHelper
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [GIDSignIn sharedInstance].clientID = kClientID;
        [GIDSignIn sharedInstance].uiDelegate = self;
        [GIDSignIn sharedInstance].delegate = self;
        [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    }
    return self;
}

- (void) showDefaultGoogleLoginButtonOnView:(UIView*) view atPoint:(CGPoint) origin{
    signInButton = [[GIDSignInButton alloc] initWithFrame:CGRectMake(origin.x, origin.y, 200, 50)];
    [view addSubview:signInButton];
    [self updateButtonUI];
}

+ (void) logOut {
    [[GIDSignIn sharedInstance] disconnect];
}

+ (UIImage*) getGoogleAccountAvatar{
    UIImage *avatarImage = nil;
    NSUInteger dimension = round(100 * [[UIScreen mainScreen] scale]);
    NSURL *imageURL = [[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:dimension];
    NSData *avatarData = [NSData dataWithContentsOfURL:imageURL];
    avatarImage = [UIImage imageWithData:avatarData];
    return avatarImage;
}

- (void) updateButtonUI{
    BOOL authenticated = ([GIDSignIn sharedInstance].currentUser.authentication != nil);
    signInButton.enabled = !authenticated;
    if (authenticated) {
        signInButton.alpha = 0.5;
    } else {
        signInButton.alpha = 1.0;
    }
}

#pragma mark GOOGLE SIGN IN DELEGATES
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    NSDictionary *userDictionary = @{@"userID" : userId, @"idToken" : idToken, @"name" : name, @"email" : email};
    
    [self updateButtonUI];
    [delegate googleDidLoggedInWithUserInfo:userDictionary];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.

    [[GIDSignIn sharedInstance] signOut];
    [delegate googleDidSignOut];
    [self updateButtonUI];
}

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {

}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [target presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn  dismissViewController:(UIViewController *)viewController {
    [target dismissViewControllerAnimated:YES completion:nil];
}
@end
