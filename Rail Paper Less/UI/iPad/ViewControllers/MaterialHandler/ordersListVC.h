//
//  ordersListVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "DefaultTableCell.h"
#import "DataSource.h"
#import "App_ViewController.h"
#import "orderLineDetailsVC.h"
#import "SettingsVC.h"

@interface ordersListVC : App_ViewController<dataSourceDelegate>
{
    IBOutlet UILabel* userDetailsLabel;
    IBOutlet UITableView* defaultTableView;
    IBOutlet UINavigationBar* header;
    
    NSMutableArray* dataArray;
}

@property(nonatomic,retain)UILabel* userDetailsLabel;
@property(nonatomic,retain)UITableView* defaultTableView;
@property(nonatomic,retain)UINavigationBar* header;

@end
