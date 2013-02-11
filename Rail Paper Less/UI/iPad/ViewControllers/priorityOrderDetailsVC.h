//
//  priorityOrderDetailsVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "DataSource.h"
#import "drawingVC.h"
#import "UserProfile.h"
#import "showDrawingVC.h"


@interface priorityOrderDetailsVC : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,dataSourceDelegate>
{
    IBOutlet UINavigationBar* header;
    IBOutlet UILabel* orderNumber;
    IBOutlet UILabel* item;
    IBOutlet UILabel* quantity;
    IBOutlet UILabel* workCenter;
    
    IBOutlet UIButton* showDrawingButton;
    IBOutlet UIButton* unprioritizeButton;
    IBOutlet UIButton* modifyWorkCenter;
    
    UIPickerView* customPicker;
    
    Order* order;
    
    NSMutableArray* pickerArray;


}

@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UILabel* orderNumber;
@property(nonatomic,retain)UILabel* item;
@property(nonatomic,retain)UILabel* quantity;
@property(nonatomic,retain)UILabel* workCenter;
@property(nonatomic,retain)UIButton* showDrawingButton;
@property(nonatomic,retain)UIButton* unprioritizeButton;
@property(nonatomic,retain)UIButton* modifyWorkCenter;


-(id)initWithObject:(Order*)orderItem;

-(IBAction)dePrioritizeClicked:(id)sender;
-(IBAction)showDrawingClicked:(id)sender;
-(IBAction)onModifyWorkCenterClicked:(id)sender;

@end
