//
//  orderLineDetailsVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "quartzcore/QuartzCore.h"
#import "GridCell.h"
#import "App_Storage.h"
#import "DataSource.h"
#import "dummyLoginView.h"
#import "App_ViewController.h"
#import "DefaultGridCell.h"

@interface orderLineDetailsVC : App_ViewController<UITextFieldDelegate,UIAlertViewDelegate,dataSourceDelegate>
{
    IBOutlet UITableView* lineTable;
    IBOutlet UINavigationBar* header;
    IBOutlet UILabel* orderNumber;
    IBOutlet UILabel* orderStatus;
    IBOutlet UILabel* wcNumber;
    IBOutlet UILabel* wcDesc;
    
    IBOutlet UIView* inputView;
    
    //Fields for edit
    IBOutlet UITextField* pno;
    IBOutlet UITextField* item;
    IBOutlet UITextField* desc;
    IBOutlet UITextField* pkLocation;
    IBOutlet UITextField* pkQty;
    IBOutlet UITextField* uom;
    IBOutlet UITextField* pkdLocation;
    IBOutlet UITextField* pkdQty;
    
    IBOutlet UIButton* doneButton;
    IBOutlet UIButton* cancelButton;
    
    IBOutlet UIButton* addNewButton;
    IBOutlet UIButton* saveButton;
    IBOutlet UIButton* confirmPicking;
    
    
    NSMutableArray* dataArray;
    
    POOrder* orderPos;
    
    dummyLoginView* dummy;
    
    UIAlertView* errorAlert;
    
    
    UITextField* pickedLocation;
    UITextField* pickedQty;
    
    NSInteger locationOfEditObject;
    
    BOOL isPickingConfirmed;
}

@property(nonatomic,retain)UITableView* lineTable;
@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UILabel* orderNumber;
@property(nonatomic,retain)UILabel* orderStatus;
@property(nonatomic,retain)UILabel* wcNumber;
@property(nonatomic,retain)UILabel* wcDesc;

@property(nonatomic,retain)UIView* inputView;

@property(nonatomic,retain)UIButton* doneButton;
@property(nonatomic,retain)UIButton* cancelButton;
@property(nonatomic,retain)UIButton* saveButton;
@property(nonatomic,retain)UIButton* addNewButton;
@property(nonatomic,retain)UIButton* confirmPicking;

@property(nonatomic,retain)UITextField* pno;
@property(nonatomic,retain)UITextField* item;
@property(nonatomic,retain)UITextField* desc;
@property(nonatomic,retain)UITextField* pkLocation;
@property(nonatomic,retain)UITextField* pkQty;
@property(nonatomic,retain)UITextField* uom;
@property(nonatomic,retain)UITextField* pkdLocation;
@property(nonatomic,retain)UITextField* pkdQty;

@property(nonatomic)BOOL isPickingConfirmed;

-(id)initWithOrder:(POOrder*)order;

-(IBAction)addNewClicked:(id)sender;
-(IBAction)doneClicked:(id)sender;
-(IBAction)cancelClicked:(id)sender;
-(IBAction)saveClicked:(id)sender;
-(IBAction)confirmPickingClicked:(id)sender;

@end
