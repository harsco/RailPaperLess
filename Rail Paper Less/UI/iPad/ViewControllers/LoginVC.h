//
//  LoginVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App_ViewController.h"
#import "AuthenticationService.h"
#import "UserProfile.h"
#import "inputParamVC.h"
#import "userInputVC.h"
#import "userInputCWVC.h"

@interface LoginVC : App_ViewController<UITextFieldDelegate,authenticationServiceDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField* userNameField;
    IBOutlet UITextField* passWordField;
    IBOutlet UIButton*    signInButton;
    IBOutlet UIButton* cancelButton;
    
    //root Tab which manages the navigation of entire app
    IBOutlet UITabBarController* rootTabController;
    
    
}

@property(nonatomic,retain)UITextField* userNameField;
@property(nonatomic,retain)UITextField* passWordField;
@property(nonatomic,retain)UIButton* signInButton;
@property(nonatomic,retain)UIButton* cancelButton;

@property(nonatomic,retain)UITabBarController* rootTabController;

-(IBAction)onSignInButtonClicked:(id)sender;

@end
