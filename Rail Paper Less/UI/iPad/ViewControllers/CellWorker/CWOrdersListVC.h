//
//  CWOrdersListVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App_ViewController.h"
#import "UserProfile.h"
#import "SettingsVC.h"
#import "DefaultTableCell.h"
#import "quartzcore/QuartzCore.h"
#import "operationsListVC.h"


@interface CWOrdersListVC : App_ViewController<dataSourceDelegate>
{
    IBOutlet UINavigationBar* header;
    IBOutlet UITableView* defaultTable;
    IBOutlet UILabel* userDetailsLabel;
    IBOutlet UIImageView* imageView;
    IBOutlet UIView* holderView;
    
    NSMutableArray* dataArray;
}

@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UITableView* defaultTable;
@property(nonatomic,retain)UILabel* userDetailsLabel;
@property(nonatomic,retain)UIImageView* imageView;
@property(nonatomic,retain)UIView* holderView;

@end
