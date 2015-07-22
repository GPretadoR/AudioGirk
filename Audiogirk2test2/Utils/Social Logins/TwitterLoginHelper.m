//
//  TwitterLoginHelper.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/29/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "TwitterLoginHelper.h"
#import <TwitterKit/TwitterKit.h>


@implementation TwitterLoginHelper {

    TWTRLogInButton *logInButton;
}

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

- (void) addTwitterLoginButtonOnView:(UIView*) view withOrigin:(CGPoint) origin{

    logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [delegate twitterDidLoginWithDictionary:[self sessionToDictionary:session]];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            [delegate twitterDidFailedToLoginWithError:error];
        }
        [self updateButtonUI];
    }];
    logInButton.center = origin;
    logInButton.frame = CGRectMake(origin.x, origin.y, 200, 50);
    [view addSubview:logInButton];
}

- (void) twitterCustomLogIn{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [delegate twitterDidLoginWithDictionary:[self sessionToDictionary:session]];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            [delegate twitterDidFailedToLoginWithError:error];
        }
        [self updateButtonUI];
    }];
}

- (void) twitterGuestLogin {
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if (guestSession) {
            NSLog(@"signed in as %@", guestSession);
            [delegate twitterDidLoginWithDictionary:[self guestSessionToDictionary:guestSession]];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            [delegate twitterDidFailedToLoginWithError:error];
        }
        [self updateButtonUI];
    }];
}

- (void) logOut{
    [[Twitter sharedInstance] logOut];
    [delegate twitterDidLogout];
    [self updateButtonUI];
}
- (void) logOutGuest{
    [[Twitter sharedInstance] logOutGuest];
    [delegate twitterDidLogout];
    [self updateButtonUI];    
}

#pragma mark Helper Method
- (void) updateButtonUI{
    BOOL authenticated = ([Twitter sharedInstance].session.userID != nil);
    logInButton.enabled = !authenticated;
    if (authenticated) {
        logInButton.alpha = 0.5;
    } else {
        logInButton.alpha = 1.0;
    }
}

- (NSDictionary*) sessionToDictionary:(TWTRSession*) session{
    
    NSString *userId = session.userID;                  // For client-side use only!
    NSString *name = session.userName;
    NSString *authToken = session.authToken;
    NSString *authTokenSecret = session.authTokenSecret;
    
    return @{@"userID" : userId, @"name" : name, @"authToken" : authToken, @"authTokenSecret" : authTokenSecret};
    
}
- (NSDictionary*) guestSessionToDictionary:(TWTRGuestSession*) session{
    
    NSString *guestToken = session.guestToken;                  // For client-side use only!
    NSString *accessToken = session.accessToken;
    
    return @{@"guestToken" : guestToken, @"accessToken" : accessToken};
    
}
@end
