//
//  BackLogOrders.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackLogOrders.h"

@interface BackLogOrders ()

@end

@implementation BackLogOrders

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"App_TableViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.header.topItem.title = @"Backlog Orders";
    //[self.defaultTableView setFrame:CGRectMake(0, 120, 768, 300)];
    
   self.userDetailsLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"USER:    ",[[UserProfile getInstance] userId],@"     ",[[UserProfile getInstance] userFirstName],@"     ",[[UserProfile getInstance] userLastName]];
    [self.commitButton setHidden:YES];
    
    [self showHUD:@"Fetching Backlog Orders"];
    
    self.commitButton.hidden = YES;
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)viewWillAppear:(BOOL)animate
{
   
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    [dataSource getBacklogOrders];
    NSInteger height = [dataSourceArray count] * 80;
    
    if(height <= 720)
    {
        [self.defaultTableView setFrame:CGRectMake(0, 215, 768, height)];
    }
    else 
    {
        [self.defaultTableView setFrame:CGRectMake(0, 215, 768, 720)];
    }
    
   

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}


#pragma mark DataSource Callbacks
-(void)dataSourceOrderListDidFinish:(NSMutableArray*)entityArray
{
    [self dismissHUD];
    dataSourceArray = [entityArray retain];
     self.countLabel.text = [NSString stringWithFormat:@"%@%d",@"Number Of Backlog Orders is ",[dataSourceArray count]];
    [self.defaultTableView reloadData];
}

-(void)dataSourceOrderListDidFail:(NSError*)error
{
    //[App_GeneralUtilities show
}


#pragma mark TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    // NSLog(@"array count is %d",[dataSourceArray count]);
    return [dataSourceArray count];
} 


//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if(section == 0)
//    {
//        return @"Order                  StartDate         End Date            W/C           Planner";
//    }
//    else
//    {
//        return  @"";
//    }
//    
//    return @"";
//}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)configureCell:(DefaultTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_item_bg@2x.png"]] autorelease];
    
    
    cell.cellOrderNumber.text = [[dataSourceArray objectAtIndex:indexPath.row] orderNumber];
    cell.cellStartDate.text = [[[dataSourceArray objectAtIndex:indexPath.row] startDate] stringByReplacingOccurrencesOfString:@" " withString:@""];
    cell.cellEndDate.text = [[dataSourceArray objectAtIndex:indexPath.row] endDate];
    cell.cellWC.text = [[dataSourceArray objectAtIndex:indexPath.row] workcenter];
    cell.cellPlanner.text = [[dataSourceArray objectAtIndex:indexPath.row] planner];
    
   // NSLog(@"cell is %@",[[[dataSourceArray objectAtIndex:indexPath.row] startDate] stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
    
    
    
    
    
}

//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    cell.textLabel.textColor = [UIColor redColor];
//   // cell.textLabel.text = @"470018835       : 2010-03-03   : 2010-03-09    : 1000      : 54001";
//    
////    if(indexPath.row == 0)
////    {
////        //cell.textLabel.textColor = [UIColor redColor];
////         cell.textLabel.text = @"370018835       : 2010-01-02   : 2010-01-04    : 1001      : 54005";
////    
////    }
////    else
////    {
////        cell.textLabel.text = @"370018831        : 2009-12-14   : 2009-12-18    : 1002       : 54008";
////    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",[[dataSourceArray objectAtIndex:indexPath.row] orderNumber],@"   ",[[dataSourceArray objectAtIndex:indexPath.row] startDate],@"   ",[[dataSourceArray objectAtIndex:indexPath.row] endDate],@"    ",[[dataSourceArray objectAtIndex:indexPath.row] workcenter],@"      ",[[dataSourceArray objectAtIndex:indexPath.row] planner],@"   "];
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        
    //orders details
    backLogOrderDetailsVC* detailVC = [[backLogOrderDetailsVC alloc] initWithObject:[dataSourceArray objectAtIndex:indexPath.row]];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
   [self presentModalViewController:detailVC animated:YES];
    
    [order release];
    
   [detailVC release];
        
    
}


@end
