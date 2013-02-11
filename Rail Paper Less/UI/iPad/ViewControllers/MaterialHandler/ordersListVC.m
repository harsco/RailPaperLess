//
//  ordersListVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ordersListVC.h"

@interface ordersListVC ()

@end

@implementation ordersListVC
@synthesize userDetailsLabel;
@synthesize defaultTableView;
@synthesize header;

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
    UIImage* image = [UIImage imageNamed:@"app_btn_settings"];
    CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onSettingsClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *settingsButton =[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    
    self.header.topItem.rightBarButtonItem = settingsButton;
    
    [self showHUD:@"Fetching Prioritzed orders"];
    
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    
    [dataSource deleteAllDBData:POSITIONSDB];
    [dataSource deleteAllDBData:PCORDERSDB];
    
     [dataSource release];
    
    //[dataSource getPrioritizedOrdersForPlanner];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.userDetailsLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"USER:    ",[[UserProfile getInstance] userId],@"     ",[[UserProfile getInstance] userFirstName],@"     ",[[UserProfile getInstance] userLastName]];
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    [dataSource getPrioritizedOrdersForPlanner];
    
    [dataSource release];
    
       
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
    // return [dataArray count];
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
    
    
    cell.cellOrderNumber.frame = CGRectMake(90,30,110,21);
    cell.cellOrderNumber.text = [[dataArray objectAtIndex:indexPath.row] orderNumber];
    cell.cellOrderNumber.textColor = [UIColor blueColor];
    
    cell.cellWC.frame = CGRectMake(500,30,150,21);
    cell.cellWC.text = [[dataArray objectAtIndex:indexPath.row] status];
    NSLog(@"status is %@",[[dataArray objectAtIndex:indexPath.row] status]);
    cell.cellWC.textColor = [UIColor purpleColor];
    
    cell.cellStartDate.hidden = YES;
    cell.cellEndDate.hidden = YES;
    cell.cellPlanner.hidden = YES;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    orderLineDetailsVC* detailsVC = [[orderLineDetailsVC alloc] init];
//    
//    [self presentModalViewController:detailsVC animated:YES];
//    
//    [detailsVC release];
    
    //[[App_Storage getInstance] getPositionsForOrder:[dataArray objectAtIndex:indexPath.row]];
    
    orderLineDetailsVC* detailsVC = [[orderLineDetailsVC alloc] initWithOrder:[dataArray objectAtIndex:indexPath.row]];
    
    [self presentModalViewController:detailsVC animated:YES];
    
    [detailsVC release];
    
    
}

#pragma mark callbacks
-(void)dataSourceOrderListDidFinish:(NSMutableArray*)entityArray
{
    NSLog(@"success");
    [self dismissHUD];
    dataArray = [entityArray retain];
    
    if([dataArray count] == 0)
    {
        [App_GeneralUtilities showAlertOKWithTitle:@"No Prioritized Orders!!" withMessage:@"There are no Prioritized Orders!! Please contact Planner or SuperUser"];
    }
    
    NSInteger height = [dataArray count] * 60.0;
    
    if(height <= 720)
    {
        [self.defaultTableView setFrame:CGRectMake(0, 168, 768, height)];
    }
    else 
    {
        [self.defaultTableView setFrame:CGRectMake(0, 168, 768, 720)];
    }
    

   
    [self.defaultTableView reloadData];
}

-(void)dataSourceOrderListDidFail:(NSError*)error
{
    NSLog(@"error");
    [self dismissHUD];
}


@end
