//
//  userInputCWVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "userInputCWVC.h"

@interface userInputCWVC ()

@end

@implementation userInputCWVC

@synthesize rootTabCWController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"userInputVC" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*self.header.tintColor =  [UIColor colorWithRed:102/255.0f 
                                             green:51/255.0f 
                                              blue:153/255.0f 
                                             alpha:255/255.f];*/
    
    self.header.tintColor = [UIColor orangeColor];
    self.getOrdersButton.backgroundColor = [UIColor orangeColor];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark getter method for Tab
- (UITabBarController *)rootTabCWController {
	if (rootTabCWController == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"RootTabCW" owner:self options:nil];
        rootTabCWController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        rootTabCWController.modalPresentationStyle = UIModalPresentationFullScreen;
	}    
	return rootTabCWController;
}


#pragma mark Action Method

-(IBAction)onGetPriorityOrdersClicked
{
    NSLog(@"action");
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

    [self presentModalViewController:self.rootTabCWController animated:YES];
}

@end
