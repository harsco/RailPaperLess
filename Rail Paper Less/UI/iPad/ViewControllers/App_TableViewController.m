//
//  App_TableViewController.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "App_TableViewController.h"

@interface App_TableViewController ()

@end

@implementation App_TableViewController
@synthesize defaultTableView;
@synthesize header;
@synthesize userDetailsLabel;
@synthesize commitButton;
@synthesize countLabel;
@synthesize priorityHeading;
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
//    UIImage* image = [UIImage imageNamed:@"app_btn_back"];
//    CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(onHomeClick:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [button setShowsTouchWhenHighlighted:YES];
//    
//    UIBarButtonItem *backButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    //self.header.topItem.leftBarButtonItem = backButton;
    
    UIImage* image = [UIImage imageNamed:@"app_btn_settings"];
    CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onSettingsClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *settingsButton =[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    [button release];

    
    self.header.topItem.rightBarButtonItem = settingsButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}

#pragma mark-action methods
#pragma mark - Action Methods
-(void)onHomeClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)onSettingsClick:(id)sender
{
    SettingsVC* settingsScreen = [[SettingsVC alloc] init];
    settingsScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:settingsScreen animated:YES];
    
    [settingsScreen release];
}

-(IBAction)onCommitClicked:(id)sender
{
    
}


#pragma mark HUD methods
#pragma mark -
#pragma mark HUD Methods 
- (void)showHUD:(NSString *)message {
    if(!hudAnimatedView){
        hudAnimatedView = [VZAnimatedView animatedViewWithSuperView:self.defaultTableView
                                                          labelText:message
                                                          dimScreen:NO];
    }
}

- (void)dismissHUD{
    if (hudAnimatedView) {
        [hudAnimatedView dismissView];
        hudAnimatedView = nil;
    } 
}



#pragma mark Table Methods

//Assuming only one section as the table is not a sectioned table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	DefaultTableCell *cell = (DefaultTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		// Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DefaultTableCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.accessoryView = nil;
	}
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
	return cell;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	static NSString *CellIdentifier = @"Cell";
//	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//	if (cell == nil) {
//		// Load the top-level objects from the custom cell XIB.
//        //NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Default_TableCell" owner:self options:nil];
//        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain). 
//        //  cell = [topLevelObjects objectAtIndex:0];
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//		cell.accessoryView = nil;
//	}
//    // Set up the cell...
//    [self configureCell:cell atIndexPath:indexPath];
//	return cell;
//}

@end
