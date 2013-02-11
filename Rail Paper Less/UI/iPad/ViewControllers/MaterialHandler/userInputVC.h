//
//  userInputVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "DataSource.h"
//#import "SettingsVC.h"

@class SettingsVC;

@interface userInputVC : UIViewController
{
    IBOutlet UILabel* userDetailsLabel;
    
    IBOutlet UITextField* ordersFrom;
    IBOutlet UITextField* ordersTo;
    IBOutlet UITextField* workCenterFrom;
    IBOutlet UITextField* workCenterTo;
    IBOutlet UINavigationBar* header;
    IBOutlet UIButton* getOrdersButton;
    
    //root Tab which manages the navigation of entire app
    IBOutlet UITabBarController* rootTabMHController;

    
}

@property(nonatomic,retain)UILabel* userDetailsLabel;
@property(nonatomic,retain)UITextField* ordersFrom;
@property(nonatomic,retain)UITextField* ordersTo;
@property(nonatomic,retain)UITextField* workCenterFrom;
@property(nonatomic,retain)UITextField* workCenterTo;
@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UIButton* getOrdersButton;

@property(nonatomic,retain)UITabBarController* rootTabMHController;

-(IBAction)onGetPriorityOrdersClicked;

@end
