//
//  inputParamVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "SettingsVC.h"

@interface inputParamVC : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UILabel* userDetailsLabel;
    
    IBOutlet UILabel* plannerFromLabel;
    IBOutlet UILabel* plannerToLabel;
    IBOutlet UILabel* workCenterFromLabel;
    IBOutlet UILabel* workCenterToLabel;
    IBOutlet UILabel* startDateFromLabel;
    IBOutlet UILabel* startDateToLabel;
    IBOutlet UILabel* endDateFromLabel;
    IBOutlet UILabel* endDateToLabel;
    
    IBOutlet UITextField* plannerFrom;
    IBOutlet UITextField* plannerTo;
    IBOutlet UITextField* workCenterFrom;
    IBOutlet UITextField* workCenterTo;
    IBOutlet UITextField* startDateFrom;
    IBOutlet UITextField* startDateTo;
    IBOutlet UITextField* endDateFrom;
    IBOutlet UITextField* endDateTo;
    
    IBOutlet UIButton* getOrderButton;
    
    IBOutlet UINavigationBar* header;
    
    UIDatePicker *datePicker;
    
    //root Tab which manages the navigation of entire app
    IBOutlet UITabBarController* rootTabController;
    
    NSInteger textFieldSelected;
}

@property(nonatomic,retain)UILabel* userDetailsLabel;

@property(nonatomic,retain)UILabel* plannerFromLabel;
@property(nonatomic,retain)UILabel* plannerToLabel;
@property(nonatomic,retain)UILabel* workCenterFromLabel;
@property(nonatomic,retain)UILabel* workCenterToLabel;
@property(nonatomic,retain)UILabel* startDateFromLabel;
@property(nonatomic,retain)UILabel* startDateToLabel;
@property(nonatomic,retain)UILabel* endDateFromLabel;
@property(nonatomic,retain)UILabel* endDateToLabel;

@property(nonatomic,retain)UITextField* plannerFrom;
@property(nonatomic,retain)UITextField* plannerTo;
@property(nonatomic,retain)UITextField* workCenterFrom;
@property(nonatomic,retain)UITextField* workCenterTo;
@property(nonatomic,retain)UITextField* startDateFrom;
@property(nonatomic,retain)UITextField* startDateTo;
@property(nonatomic,retain)UITextField* endDateFrom;
@property(nonatomic,retain)UITextField* endDateTo;

@property(nonatomic,retain)UIButton* getOrderButton;

@property(nonatomic,retain)UINavigationBar* header;


@property(nonatomic,retain)UITabBarController* rootTabController;


-(IBAction)onGetOrdersClicked:(id)sender;


@end
