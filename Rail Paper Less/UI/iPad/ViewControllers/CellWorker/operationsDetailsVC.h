//
//  operationsDetailsVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationsData.h"
#import "quartzcore/QuartzCore.h"

@interface operationsDetailsVC : UIViewController
{
    IBOutlet UINavigationBar* header;
    
    IBOutlet UITextView* taskText;
    
    IBOutlet UILabel* opLabel;
    IBOutlet UILabel* statusLabel;
    IBOutlet UILabel* taskLabel;
    IBOutlet UILabel* taskDescLabel;
    IBOutlet UILabel* wcLabel;
    IBOutlet UILabel* wcDescLabel;
    IBOutlet UILabel* machineLabel;
    IBOutlet UILabel* prodTimeLabel;
    IBOutlet UILabel* sDateLabel;
    IBOutlet UILabel* eDateLabel;
    
    OperationsData* op;
}

@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UITextView* taskText;

@property(nonatomic,retain)UILabel* opLabel;
@property(nonatomic,retain)UILabel* statusLabel;
@property(nonatomic,retain)UILabel* taskLabel;
@property(nonatomic,retain)UILabel* taskDescLabel;
@property(nonatomic,retain)UILabel* wcLabel;
@property(nonatomic,retain)UILabel* wcDescLabel;
@property(nonatomic,retain)UILabel* machineLabel;
@property(nonatomic,retain)UILabel* prodTimeLabel;
@property(nonatomic,retain)UILabel* sDateLabel;
@property(nonatomic,retain)UILabel* eDateLabel;



-(id)initWithOperation:(OperationsData*)operation;

@end
