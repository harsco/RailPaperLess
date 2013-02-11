//
//  CWOrdersListVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CWOrdersListVC.h"

@interface CWOrdersListVC ()

@end

@implementation CWOrdersListVC
@synthesize header;
@synthesize defaultTable;
@synthesize userDetailsLabel;
@synthesize imageView;
@synthesize holderView;

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
    
     self.userDetailsLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"USER:    ",[[UserProfile getInstance] userId],@"     ",[[UserProfile getInstance] userFirstName],@"     ",[[UserProfile getInstance] userLastName]];
    
    UIImage* image = [UIImage imageNamed:@"app_btn_settings"];
    CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onSettingsClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *settingsButton =[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    
    self.header.topItem.rightBarButtonItem = settingsButton;
    self.header.tintColor = [UIColor orangeColor];
    
    
    [self.holderView.layer setMasksToBounds:YES];           //mask the extra area
    [self.holderView.layer setCornerRadius:20.0];
   /* [self.holderView.layer setBorderColor:[[UIColor colorWithRed:102/255.0f 
                                                           green:51/255.0f 
                                                            blue:153/255.0f 
                                                           alpha:255/255.f] CGColor]];*/
    [self.holderView.layer setBorderColor:[[UIColor orangeColor] CGColor]];
    
    [self.holderView.layer setBorderWidth:3.0];
    
    
    [self showHUD:@"Fetching Prioritzed orders"];
    
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
//    
   [dataSource deleteAllDBData:CWORDERSDB];
   [dataSource deleteAllDBData:CWOPERATIONSDB];
    
    [dataSource release];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    [dataSource getPrioritizedOrdersForCellWorker];
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


-(void)onSettingsClick:(id)sender
{
    SettingsVC* settingsScreen = [[SettingsVC alloc] init];
    settingsScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:settingsScreen animated:YES];
    
    [settingsScreen release];
}

#pragma mark TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
     return [dataArray count];
  
    //return 20;
} 



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
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


- (void)configureCell:(DefaultTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_item_bg@2x.png"]] autorelease];
    
    
    cell.cellOrderNumber.frame = CGRectMake(100,30,50,21);
    //cell.cellOrderNumber.text = @"11";//[[dataArray objectAtIndex:indexPath.row] orderNumber];
    cell.cellOrderNumber.text = [NSString stringWithFormat:@"%d",[[dataArray objectAtIndex:indexPath.row] priority]];
    cell.cellOrderNumber.textColor = [UIColor blueColor];
    
    cell.cellWC.frame = CGRectMake(200,30,110,21);
    cell.cellWC.text = [[dataArray objectAtIndex:indexPath.row] orderNumber];
    cell.cellWC.textColor = [UIColor blueColor];
    
    cell.cellStartDate.frame = CGRectMake(360,30,110,21);
    cell.cellStartDate.text = [[dataArray objectAtIndex:indexPath.row] workcenter];
    cell.cellStartDate.textColor = [UIColor blueColor];
    
    cell.cellEndDate.frame = CGRectMake(510,30,110,21);
    cell.cellEndDate.text = [[dataArray objectAtIndex:indexPath.row] planner];
    cell.cellEndDate.textColor = [UIColor blueColor];
    
    //cell.cellStartDate.hidden = YES;
    //cell.cellEndDate.hidden = YES;
    cell.cellPlanner.hidden = YES;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    operationsListVC* opVC = [[operationsListVC alloc] initWithOrder:[dataArray objectAtIndex:indexPath.row]];
    
    [self presentModalViewController:opVC animated:YES];
    
    [opVC release];
    
}

#pragma mark callbacks
-(void)dataSourceOrderListDidFinish:(NSMutableArray*)entityArray
{
    NSLog(@"success");
    [self dismissHUD];
    dataArray = [entityArray retain];
    
    [self.defaultTable reloadData];
}

-(void)dataSourceOrderListDidFail:(NSError*)error
{
    NSLog(@"error");
    [App_GeneralUtilities showAlertOKWithTitle:@"Error Fetching!!" withMessage:[error localizedDescription]];
    [self dismissHUD];
}


@end
