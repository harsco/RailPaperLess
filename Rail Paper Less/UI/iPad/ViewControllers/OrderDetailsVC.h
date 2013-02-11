//
//  OrderDetailsVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "DataSource.h"
#import "drawingVC.h"
#import "PriorityOrdersVC.h"
#import "UserProfile.h"
#import "WhiteRaccoon.h"
#import "showDrawingVC.h"


@interface OrderDetailsVC : App_ViewController<WRRequestDelegate,dataSourceDelegate>
{
    IBOutlet UINavigationBar* header;
    IBOutlet UILabel* orderNumber;
    IBOutlet UILabel* item;
    IBOutlet UILabel* quantity;
    
    IBOutlet UIButton* prioritizeButton;
    IBOutlet UIButton* showDrawingButton;
    IBOutlet UIImageView* drawingView;

   // IBOutlet UIActivityIndicatorView* loadingIndicator;
    
    Order* order;
}

@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UILabel* orderNumber;
@property(nonatomic,retain)UILabel* item;
@property(nonatomic,retain)UILabel* quantity;
@property(nonatomic,retain)UIButton* prioritizeButton;
@property(nonatomic,retain)UIButton* showDrawingButton;
@property(nonatomic,retain)UIImageView* drawingView;



-(IBAction)priorityClicked:(id)sender;
-(IBAction)showDrawingClicked:(id)sender;
-(IBAction)dePrioritizeClicked:(id)sender;

-(id)initWithObject:(Order*)orderItem;

@end
