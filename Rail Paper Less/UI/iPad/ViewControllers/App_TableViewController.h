//
//  App_TableViewController.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VZAnimatedView.h"
#import "SettingsVC.h"
#import "DefaultTableCell.h"

@interface App_TableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
   
    IBOutlet UITableView* defaultTableView;
    IBOutlet UINavigationBar* header;
    IBOutlet UILabel* userDetailsLabel;
    IBOutlet UIButton* commitButton;
    IBOutlet UILabel* countLabel;
    IBOutlet UILabel* priorityHeading;
    
        
    VZAnimatedView *hudAnimatedView;
    
    NSMutableArray* dataSourceArray;
}

@property(nonatomic,retain)UITableView* defaultTableView;
@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UILabel* userDetailsLabel;
@property(nonatomic,retain)UIButton* commitButton;
@property(nonatomic,retain)UILabel* countLabel;
@property(nonatomic,retain)UILabel* priorityHeading;

- (void)showHUD:(NSString *)message;
- (void)dismissHUD;

-(IBAction)onCommitClicked:(id)sender;

@end
