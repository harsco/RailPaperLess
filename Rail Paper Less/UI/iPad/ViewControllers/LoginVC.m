//
//  LoginVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

@synthesize userNameField;
@synthesize passWordField;
@synthesize signInButton;
@synthesize rootTabController;
@synthesize cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)dealloc
{
    
    RELEASE_TO_NIL(userNameField);
    RELEASE_TO_NIL(passWordField);
    RELEASE_TO_NIL(signInButton);
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userNameField.keyboardType = UIKeyboardTypeDefault;
    self.userNameField.returnKeyType = UIReturnKeyNext;
    [self.userNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.userNameField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    self.userNameField.delegate = self;
    
    self.passWordField.keyboardType = UIKeyboardTypeDefault;
    self.passWordField.returnKeyType = UIReturnKeyDone;
    [self.passWordField setSecureTextEntry:YES];
    [self.passWordField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.passWordField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    self.passWordField.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIInterfaceOrientationPortrait)
    return YES;
    
    return NO;
}

#pragma mark getter method for Tab
- (UITabBarController *)rootTabController {
	if (rootTabController == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"RootTab" owner:self options:nil];
        rootTabController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        rootTabController.modalPresentationStyle = UIModalPresentationFullScreen;
	}    
	return rootTabController;
}


-(void)launchUI
{
    //[self presentModalViewController:self.rootTabController animated:YES];
    inputParamVC* paramVC = [[inputParamVC alloc] init];
    
    [self presentModalViewController:paramVC animated:YES];
    
    [paramVC release];
}


-(void)launchUIforMaterialHandler
{
    
    userInputVC* inputMHVC = [[userInputVC alloc] init];
    
    [self presentModalViewController:inputMHVC animated:YES];
    
    [inputMHVC release];
}

-(void)launchUIforCellWorker
{
    userInputCWVC* inputCWVC = [[userInputCWVC alloc] init];
    [self presentModalViewController:inputCWVC animated:YES];
    [inputCWVC release];
    
}

#pragma mark Actions
//Sign In Clicked pick the user credentials and authenticate
-(IBAction)onSignInButtonClicked:(id)sender
{
    
#ifndef DEVELOPMENT   
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    
    
    if(([self.userNameField.text length]<1))
    {
        [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:@"User Name Can't be left Blank"];
        return;
    }
    
    if(([self.passWordField.text length]<1))
    {
        [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:@"Password Can't be left Blank"];
        return;
    }
    //    NSLog(@"Username is %@",self.userNameField.text);
    //    NSLog(@"passWordField is %@",self.passWordField.text);
   
    
    [self authenticateUser:self.userNameField.text Password:self.passWordField.text];
#endif
    
#ifdef DEVELOPMENT
    //[self launchUI];
   // [self.userNameField.text setTe
    [self authenticateUser:@"57020" Password:@"KNHN173"];
#endif
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	
	if (textField == self.userNameField )
	{
		[ self.passWordField  becomeFirstResponder];
		
	}
	else
	{
        
		[self.userNameField resignFirstResponder];
        [self.passWordField resignFirstResponder];
        
        
        if(([self.userNameField.text length]<1))
        {
            [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:@"User Name Can't be left Blank"];
            return NO;
        }
        
        if(([self.passWordField.text length]<1))
        {
            [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:@"Password Can't be left Blank"];
            return NO;
        }
        
        [self showHUD:@"Authenticating User"];
        [self authenticateUser:self.userNameField.text Password:self.passWordField.text];
    }
    
	return YES;
}

#pragma mark Authentication Methods
-(void)authenticateUser:(NSString*)userName Password:(NSString*)passWord
{
    [self showHUD:@"Authenticating User"];
    AuthenticationService* service = [[AuthenticationService alloc] init];
    service.delegate = self;
    [service authenticateUserWithUserName:userName Password:passWord];
}

#pragma mark Authentication Delegate
-(void)signInDidPass
{
    [self dismissHUD];
    
    
    NSLog(@"role is %@",[[UserProfile getInstance] privilegeLevel]);
    
    if([[[UserProfile getInstance] privilegeLevel] isEqualToString:SUPERUSER])
    {
        //[App_GeneralUtilities showAlertOKWithTitle:@"Success" withMessage:@"Valid User"]; 
        //[self launchUI];
        //[self launchUIforCellWorker];
        
        UIAlertView* inputAlert = [[UIAlertView alloc] initWithTitle:@"View Options" message:@"Please Choose Your Option for View" delegate:self cancelButtonTitle:@"Complete Operations" otherButtonTitles:@"Prioritize Orders",@"Pick and Confirm", nil];
        
        [inputAlert show];
        [inputAlert release];
    }
    else if([[[UserProfile getInstance] privilegeLevel] isEqualToString:MATERIALHANDLER])
    {
        [self launchUIforMaterialHandler];
    }
    
    else if([[[UserProfile getInstance] privilegeLevel] isEqualToString:CELLWORKER])
    {
        [self launchUIforCellWorker];
    }
    else if([[[UserProfile getInstance] privilegeLevel] isEqualToString:@"Planner"])
    {
        [self launchUI];
    }
  
    
    
}

-(void)signInDidFail:(NSError *)error
{
    [self dismissHUD];
    [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:[error localizedDescription]];
}


#pragma mark Alert View Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self launchUIforCellWorker];
    }
    else if (buttonIndex == 1)
    {
        [self launchUI];
    }
    else if(buttonIndex == 2)
    {
        [self launchUIforMaterialHandler];
    }
}




@end
