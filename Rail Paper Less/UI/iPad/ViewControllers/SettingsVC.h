//
//  SettingsVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "inputParamVC.h"
#import "userInputVC.h"
#import "userInputCWVC.h"
#import "helpViewController.h"

#import <FastPdfKit/FastPdfKit.h>
@class MFDocumentManager;

@interface SettingsVC : UIViewController<UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>
{
    IBOutlet UINavigationBar* header;
    
    IBOutlet UIButton* switchUserButton;
    IBOutlet UIButton* logOutButton;
    IBOutlet UIButton* prioritizeOrdersButton;
    IBOutlet UIButton* pickAndConfirmButton;
    IBOutlet UIButton* completeOperationsButton;
    IBOutlet UIButton* helpButton;
    
    UIAlertView* switchAlert;
}

@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UIButton* switchUserButton;
@property(nonatomic,retain)UIButton* logOutButton;
@property(nonatomic,retain)UIButton* prioritizeOrdersButton;
@property(nonatomic,retain)UIButton* pickAndConfirmButton;
@property(nonatomic,retain)UIButton* completeOperationsButton;
@property(nonatomic,retain)UIButton* helpButton;
@property(nonatomic,retain)UIAlertView* switchAlert;


-(IBAction)prioritizeOrdersClicked:(id)sender;
-(IBAction)onPickAndConfirmClicked:(id)sender;
-(IBAction)onCompleteOperationsClicked:(id)sender;
-(IBAction)onLogoutClicked:(id)sender;
-(IBAction)onSwitchUserClicked:(id)sender;
-(IBAction)onHelpClicked:(id)sender;

@end
