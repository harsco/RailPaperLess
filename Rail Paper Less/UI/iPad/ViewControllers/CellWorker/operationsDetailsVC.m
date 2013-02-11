//
//  operationsDetailsVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "operationsDetailsVC.h"

@interface operationsDetailsVC ()

@end

@implementation operationsDetailsVC
@synthesize header;
@synthesize taskText;
@synthesize opLabel;
@synthesize statusLabel;
@synthesize taskLabel;
@synthesize taskDescLabel;
@synthesize wcLabel;
@synthesize wcDescLabel;
@synthesize machineLabel;
@synthesize prodTimeLabel;
@synthesize sDateLabel;
@synthesize eDateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOperation:(OperationsData*)operation
{
    if(self = [super init])
    {
        op = [operation retain];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage* image = [UIImage imageNamed:@"app_btn_back"];
    CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onHomeClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *backButton =[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    self.header.topItem.leftBarButtonItem = backButton;
    self.header.tintColor = [UIColor orangeColor];
    
    self.opLabel.text = [NSString stringWithFormat:@"%d",op.operation];
    
    self.statusLabel.text = op.currentOperation;
    self.taskLabel.text = op.task;
    self.taskDescLabel.text = op.taskDescription;
    self.wcLabel.text = op.oPWorkcenter;
    self.wcDescLabel.text = op.workcenterdesc;
    self.machineLabel.text = op.machine;
    self.prodTimeLabel.text = op.productiontime;
    self.sDateLabel.text = op.startDate;
    self.eDateLabel.text = op.enddate;
    
    [self.taskText.layer setMasksToBounds:YES];           //mask the extra area
    [self.taskText.layer setCornerRadius:20.0];
    [self.taskText.layer setBorderColor:[[UIColor orangeColor] CGColor]];
    [self.taskText.layer setBorderWidth:2.0];
    
    if([op.taskText length])
     self.taskText.text = op.taskText;
    
    else 
        self.taskText.text = @"No Description To Show";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark-action methods
#pragma mark - Action Methods
-(void)onHomeClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
