//
//  TwitterLoginHelper.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/29/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwitterLoginHelperDelegate <NSObject>

@optional - (void) twitterDidLoginWithDictionary:(NSDictionary*) userInfo;
@optional - (void) twitterDidFailedToLoginWithError:(NSError*) error;
@optional - (void) twitterDidLogout;

@end

@interface TwitterLoginHelper : NSObject

@property (nonatomic) id delegate;

+ (instancetype) sharedHelper;
- (void) addTwitterLoginButtonOnView:(UIView*) view withOrigin:(CGPoint) origin;
- (void) twitterCustomLogIn;
- (void) twitterGuestLogin;
- (void) logOut;
- (void) logOutGuest;

@end
