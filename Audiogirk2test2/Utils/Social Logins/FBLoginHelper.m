//
//  FBLoginHelper.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/27/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "FBLoginHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FBLoginHelper() <FBSDKLoginButtonDelegate>

@end


@implementation FBLoginHelper

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
#pragma mark FBLogin Button UI
+ (UIImage*) fbProfilePicForId:(NSString*) userId{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", userId]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

+ (UIView*) fbProfilePicWithPictureViewForId:(NSString *) userId withFrame:(CGRect) frame{
    FBSDKProfilePictureView *pictureView = [[FBSDKProfilePictureView alloc] initWithFrame:frame];
    pictureView.profileID = userId;
    return pictureView;
}

- (void) showFBDefaultLoginButtonOnView:(UIView*) view atPoint:(CGPoint) point withPermissions:(NSArray*) permissions{
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    loginButton.center = point;
    loginButton.readPermissions = permissions;
    [view addSubview:loginButton];
}


+ (void) customButtonLoginHandler{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];;
    if (![FBSDKAccessToken currentAccessToken]) {
        
        [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                // Process error
            } else if (result.isCancelled) {
                // Handle cancellations
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:@"email"]) {
                    // Do work
                    [FBLoginHelper fetchUserInfo];
                }
            }
        }];
    }else{
        [login logOut];
        [FBLoginHelper delegateLogOut];
    }
}

+ (void) delegateLogOut{
    [[FBLoginHelper sharedHelper].delegate fbDidLogOut];
}
#pragma mark FBLogin Delegates
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    [FBLoginHelper fetchUserInfo];
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    [FBLoginHelper delegateLogOut];
}


+(void)fetchUserInfo {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available");
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Fetched User Information:%@", result);
                 [[FBLoginHelper sharedHelper].delegate fbDidLoginWithUserInfo:result];
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
    } else {
        NSLog(@"User is not Logged in");
    }
}



@end
