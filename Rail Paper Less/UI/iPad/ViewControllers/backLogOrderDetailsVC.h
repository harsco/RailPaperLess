//
//  backLogOrderDetailsVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "dummyLoginView.h"
#import "DataSource.h"
#import "UserProfile.h"

@interface backLogOrderDetailsVC : UIViewController<UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UINavigationBar* header;
    IBOutlet UILabel* orderNumber;
    IBOutlet UILabel* item;
    IBOutlet UILabel* quantity;
    IBOutlet UILabel* exceptionCode;
    IBOutlet UIButton* prioritizeButton;
    IBOutlet UIButton* exceptionButton;
    
    BOOL isExceptionEntered;
    
    
    UIPickerView* customPicker;
    
    dummyLoginView* dummy;
    
    Order* order;
    
    NSMutableArray* pickerArray;

}


@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UILabel* orderNumber;
@property(nonatomic,retain)UILabel* item;
@property(nonatomic,retain)UILabel* quantity;
@property(nonatomic,retain)UILabel* exceptionCode;
@property(nonatomic,retain)UIButton* prioritizeButton;
@property(nonatomic,retain)UIButton* exceptionButton;

-(id)initWithObject:(Order*)orderItem;
-(IBAction)priorityClicked:(id)sender;
-(IBAction)exceptionButtonClicked:(id)sender;

@end
