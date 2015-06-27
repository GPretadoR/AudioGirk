//
//  FBLoginHelper.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/27/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FBLoginHelperDelegate <NSObject>

@optional - (void) fbDidLoginWithUserInfo:(id)result;
@optional - (void) fbDidLogOut;

@end

@interface FBLoginHelper : NSObject

@property (nonatomic) id delegate;
//Instance Methods
- (void) showFBDefaultLoginButtonOnView:(UIView*) view atPoint:(CGPoint) point withPermissions:(NSArray*) permissions;

//Class Methods
+ (instancetype) sharedHelper;

+ (UIImage*) fbProfilePicForId:(NSString*) userId;
+ (UIView*) fbProfilePicWithPictureViewForId:(NSString *) userId withFrame:(CGRect) frame;
+ (void) customButtonLoginHandler;


@end
