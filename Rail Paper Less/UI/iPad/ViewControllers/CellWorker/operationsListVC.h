//
//  operationsListVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App_ViewController.h"
#import "GridCell.h"
#import "quartzcore/QuartzCore.h"
#import "CWOrder.h"
#import "App_Storage.h"
#import "DataSource.h"
#import "operationsDetailsVC.h"
#import "DefaultGridCell.h"

@interface operationsListVC : App_ViewController<dataSourceDelegate>
{
    IBOutlet UITableView* lineTable;
    IBOutlet UINavigationBar* header;
    IBOutlet UIView* holderView;
    
    IBOutlet UILabel* orderNumber;
    IBOutlet UILabel* planner;
    IBOutlet UILabel* item;
    IBOutlet UILabel* desc;
    IBOutlet UILabel* quantity;
    IBOutlet UILabel* uom;
    IBOutlet UILabel* revision;
    IBOutlet UILabel* status;
    
    IBOutlet UIButton* completeOrderButton;
    IBOutlet UIButton* cancelOrderButton;
    
    NSInteger locationOfEditObject;
    NSInteger countOfUncompletedOperations;
    
    CWOrder* orderPos;
    
    NSMutableArray* dataArray;
    
    UIAlertView* operationAlert;
    
    BOOL isOrderCompleted;
}

@property(nonatomic,retain)UITableView* lineTable;
@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UIView* holderView;

@property(nonatomic,retain)UILabel* orderNumber;
@property(nonatomic,retain)UILabel* planner;
@property(nonatomic,retain)UILabel* item;
@property(nonatomic,retain)UILabel* desc;
@property(nonatomic,retain)UILabel* quantity;
@property(nonatomic,retain)UILabel* uom;
@property(nonatomic,retain)UILabel* revision;
@property(nonatomic,retain)UILabel* status;
@property(nonatomic,retain)UIButton* completeOrderButton;
@property(nonatomic,retain)UIButton* cancelOrderButton;
@property(nonatomic)BOOL isOrderCompleted;




-(id)initWithOrder:(CWOrder*)order;
-(IBAction)onCompleteOrderClicked:(id)sender;
-(IBAction)onCancelOrderClicked:(id)sender;

@end
