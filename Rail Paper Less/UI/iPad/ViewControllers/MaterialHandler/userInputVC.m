//
//  userInputVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "userInputVC.h"

@interface userInputVC ()

@end

@implementation userInputVC

@synthesize userDetailsLabel;
@synthesize ordersFrom;
@synthesize ordersTo;
@synthesize workCenterFrom;
@synthesize workCenterTo;
@synthesize rootTabMHController;
@synthesize header;
@synthesize getOrdersButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([[self presentingViewController] class] == [SettingsVC class])
    {
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
        
        self.header.topItem.leftBarButtonItem = [cancelButton autorelease];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.userDetailsLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"USER:    ",[[UserProfile getInstance] userId],@"     ",[[UserProfile getInstance] userFirstName],@"     ",[[UserProfile getInstance] userLastName]];
    
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


#pragma mark getter method for Tab
- (UITabBarController *)rootTabMHController {
	if (rootTabMHController == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"RootTabMH" owner:self options:nil];
        rootTabMHController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        rootTabMHController.modalPresentationStyle = UIModalPresentationFullScreen;
	}    
	return rootTabMHController;
}

#pragma mark action methods
-(IBAction)onGetPriorityOrdersClicked
{
    
    if(![self.workCenterFrom.text length])
    {
        [[UserProfile getInstance] setWorkCenterFrom:@" "];
    }
    else
    {
        [[UserProfile getInstance] setWorkCenterFrom:self.workCenterFrom.text];
    }
    
    if(![self.workCenterTo.text length])
    {
        [[UserProfile getInstance] setWorkCenterTo:@"ZZZZZZZZZZZZ"];
    }
    else
    {
        [[UserProfile getInstance] setWorkCenterTo:self.workCenterTo.text];
    }
    
    if(![self.ordersFrom.text length])
    {
        [[UserProfile getInstance] setOrdersFrom:@" "];
    }
    else
    {
        [[UserProfile getInstance] setOrdersFrom:self.ordersFrom.text];
    }
    
    if(![self.ordersTo.text length])
    {
        [[UserProfile getInstance] setOrdersTo:@"ZZZZZZZZZZZZ"];
    }
    else
    {
        [[UserProfile getInstance] setOrdersTo:self.ordersTo.text];
    }
    
    
    [self presentModalViewController:self.rootTabMHController animated:YES];
}

-(void)cancelClicked
{
    [self dismissModalViewControllerAnimated:YES];
}




@end
