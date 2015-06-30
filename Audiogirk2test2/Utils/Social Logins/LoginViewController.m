//
//  LoginViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/26/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "LoginViewController.h"
#import "FBLoginHelper.h"
#import "GoogleLoginHelper.h"
#import "TwitterLoginHelper.h"

@interface LoginViewController () <FBLoginHelperDelegate, GoogleLoginHelperDelegate, TwitterLoginHelperDelegate>

@end

@implementation LoginViewController {

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[FBLoginHelper sharedHelper] showFBDefaultLoginButtonOnView:self.view atPoint:CGPointMake(500, 100) withPermissions:@[@"email"]];
    [FBLoginHelper sharedHelper].delegate = self;
    
    [self createButtonInRect:CGRectMake(100, 100, 80, 30) title:@"Login" action:@selector(logOut) backGroundImage:nil highlightImage:nil];
    
    [[GoogleLoginHelper sharedHelper] showDefaultGoogleLoginButtonOnView:self.view atPoint:CGPointMake(100, 200)];
    [GoogleLoginHelper sharedHelper].delegate = self;
    
    [[TwitterLoginHelper sharedHelper] addTwitterLoginButtonOnView:self.view withOrigin:CGPointMake(350, 400)];
    [TwitterLoginHelper sharedHelper].delegate = self;
}

- (UIButton*)createButtonInRect:(CGRect)rect title:(NSString*)title action:(SEL)action backGroundImage:(UIImage*)backgroundImage highlightImage:(UIImage*)highlightImage{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = rect;
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    // Pressed state background
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [self.view addSubview:button]; //invisible is a selector see below
    
    return button;
}
- (UIImageView*) createImageViewWithRect:(CGRect)rect image:(UIImage*)image{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.image = image;
    [self.view addSubview:imageView];
    return imageView;
}


#pragma FBLoginDelegates
-(void)fbDidLoginWithUserInfo:(id)result{
    NSLog(@"Delegate Results: %@",result);
}
-(void)fbDidLogOut{
    NSLog(@"logout");
}

#pragma GOOGLE Login delegates

-(void)googleDidLoggedInWithUserInfo:(NSDictionary *)userInfo{
    [self createImageViewWithRect:CGRectMake(300, 300, 100, 100) image:[GoogleLoginHelper getGoogleAccountAvatar]];
}
-(void)googleDidSignOut{


}

#pragma mark

-(void)twitterDidLoginWithDictionary:(NSDictionary *)userInfo{

    NSLog(@"Success login %@", [userInfo objectForKey:@"name"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logOut{
    [[TwitterLoginHelper sharedHelper] twitterGuestLogin];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
