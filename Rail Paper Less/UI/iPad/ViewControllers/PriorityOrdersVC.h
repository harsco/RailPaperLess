//
//  PriorityOrdersVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App_TableViewController.h"
#import "priorityOrderDetailsVC.h"

@interface PriorityOrdersVC : App_TableViewController<dataSourceDelegate>
{
    NSMutableArray* dataArray;
    
    UIAlertView* inputAlert;
    IBOutlet UIView* priorityInputView;
    
    IBOutlet UIButton* doneButton;
    IBOutlet UIButton* cancelButton;
    IBOutlet UITextField* priorityTextBox;
    
    int index;
}

@property(nonatomic,retain)UIView* priorityInputView;
@property(nonatomic,retain)UIButton* doneButton;
@property(nonatomic,retain)UIButton* cancelButton;
@property(nonatomic,retain)UITextField* priorityTextBox;

-(IBAction)onCommitClicked:(id)sender;

-(IBAction)onDoneClicked:(id)sender;
-(IBAction)onCancelClicked:(id)sender;

@end
