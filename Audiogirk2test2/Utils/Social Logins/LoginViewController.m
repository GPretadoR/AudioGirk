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
#import "Utils.h"
#import "ServerRequest.h"
#import "SVProgressHUD.h"

@interface LoginViewController () <FBLoginHelperDelegate, GoogleLoginHelperDelegate, TwitterLoginHelperDelegate>

@end

@implementation LoginViewController {

    UITextField *emailField;
    UITextField *passwordField;
    
    UIButton *submitButton;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = rgba(200, 200, 100, 1);
    
    [Utils setViewToAddOn:self.view];
    
    [[FBLoginHelper sharedHelper] showFBDefaultLoginButtonOnView:self.view atPoint:CGPointMake(self.view.center.x - 100, 80) withPermissions:@[@"email"]];
    [FBLoginHelper sharedHelper].delegate = self;
//
//    [[GoogleLoginHelper sharedHelper] showDefaultGoogleLoginButtonOnView:self.view atPoint:CGPointMake(self.view.center.x - 100, 150)];
//    [GoogleLoginHelper sharedHelper].delegate = self;

//    [[TwitterLoginHelper sharedHelper] addTwitterLoginButtonOnView:self.view withOrigin:CGPointMake(self.view.center.x - 100, 220)];
//    [TwitterLoginHelper sharedHelper].delegate = self;
    
    emailField = [Utils createTextFieldWithRect:CGRectMake(self.view.center.x - 100, 300, 200, 50) title:@"" placeHolderText:@"Email"];
    passwordField = [Utils createTextFieldWithRect:CGRectMake(self.view.center.x - 100, 360, 200, 50) title:@"" placeHolderText:@"Password"];
    passwordField.secureTextEntry = YES;
    
    submitButton = [Utils createButtonInRect:CGRectMake(self.view.center.x - 100, passwordField.frame.origin.y + passwordField.frame.size.height + 10, 200, 50) title:@"Submit" target:self action:@selector(submitButtonPressed) backGroundImage:[UIImage imageNamed:@"gh.png"] highlightImage:nil];
    
}

#pragma mark Helper methods
- (void) submitButtonPressed{
    if (![@"" isEqualToString:emailField.text] && ![@"" isEqualToString:passwordField.text]) {
        [self postWithParams:@{@"email" : emailField.text, @"password" : passwordField.text}];
    }else{
        [SVProgressHUD showErrorWithStatus:@"Both fields are required"];
    }

}
- (void) postWithParams:(NSDictionary *)params{
    [ServerRequest makePostRequestWithURL:@"http://109.68.124.16/api/v1/register" params:params success:^(id responseObj) {
        NSString *token = [[responseObj objectForKey:@"auth"] objectForKey:@"access_token"];
        NSString *message = [responseObj objectForKey:@"message"];
        NSString *success = [responseObj objectForKey:@"success"];
        if ([success intValue] == 1 && success != nil ) {
            NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
            [userDefs setObject:token forKey:@"token"];
            [userDefs synchronize];
            [SVProgressHUD showSuccessWithStatus:message];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [SVProgressHUD setStatus:message];
        }
    } failure:^(NSError *error) {
        NSLog(@"Error login: %@", [error localizedDescription]);
        [SVProgressHUD showErrorWithStatus:@"Registration Error!!!"];
    }];
    
}
#pragma FBLoginDelegates
-(void)fbDidLoginWithUserInfo:(id)result{
    NSLog(@"Delegate Results: %@",result);
    [self postWithParams:@{emailField.text : @"username", passwordField.text : @"password"}];
}
-(void)fbDidLogOut{
    NSLog(@"logout");
}

#pragma GOOGLE Login delegates

-(void)googleDidLoggedInWithUserInfo:(NSDictionary *)userInfo{
    NSLog(@"Delegate Results: %@",userInfo);
}
-(void)googleDidSignOut{


}

#pragma mark Twitter Login

-(void)twitterDidLoginWithDictionary:(NSDictionary *)userInfo{

    NSLog(@"Success login %@", userInfo);
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
