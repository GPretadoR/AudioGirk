//
//  GoogleLoginHelper.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/27/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoogleLoginHelperDelegate <NSObject>

@optional - (void) googleDidLoggedInWithUserInfo:(NSDictionary*) userInfo;
@optional - (void) googleDidFailedToLoginWithError:(NSError*) error;
@optional - (void) googleDidSignOut;

@end

@interface GoogleLoginHelper : NSObject

@property (nonatomic) id delegate;
@property (nonatomic) id target;

//Inctance Methods
- (void) showDefaultGoogleLoginButtonOnView:(UIView*) view atPoint:(CGPoint) origin;

//Class Methods
+ (instancetype) sharedHelper;
+ (void) logOut;
+ (UIImage*) getGoogleAccountAvatar;
@end
