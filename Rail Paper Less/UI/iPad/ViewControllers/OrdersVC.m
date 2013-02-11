//
//  OrdersVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrdersVC.h"

@interface OrdersVC ()

@end

@implementation OrdersVC

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
    self.header.topItem.title = @"Orders";
    [self.commitButton setHidden:YES];
    
    //[self.defaultTableView setFrame:CGRectMake(0, 120, 768, 300)];
    
    //App_Storage* dataBase = [App_Storage getInstance];
    //NSError* error;
    
  // NSData* jsonString = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"orderXML" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
    
    //NSData* test1 = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"orderXML" ofType:@"xml"] options:(NSDataReadingOptions) error:(NSError **)
    
//    NSData* test = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"orderXML" ofType:@"xml"]];
//    
//    XMLParser* parser = [[XMLParser alloc] init];
//    [parser parseWithReceivedData:test];
//    
//    NSLog(@"count is %d",[[[App_Storage getInstance] getOrderList] count]);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //Optionally for time zone converstions
  //  [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
   // NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];

   // NSLog(@"date is %@",stringFromDate);
    
    [self showHUD:@"Fetching Order Data"];
    
    self.commitButton.hidden = YES;
    
    self.userDetailsLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"USER:    ",[[UserProfile getInstance] userId],@"     ",[[UserProfile getInstance] userFirstName],@"     ",[[UserProfile getInstance] userLastName]];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ISREFRESH"])
    {
         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISREFRESH"];
        
        [self showHUD:@"fetching orders"];
        
         [dataSource refreshOrderList];
    }
    else 
    {
        [self showHUD:@"fetching orders"];

        [dataSource getOrderList];
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
    
    //self.countLabel.text = [NSString stringWithFormat:@"%@%d",@"Number Of Open Orders is ",[dataSourceArray count]];
    
   [ countLabel setText:[NSString stringWithFormat:@"%@%d",@"Number Of Open Orders is ",[dataSourceArray count]]];
    
    [self.defaultTableView reloadData];
}

-(void)dataSourceOrderListDidFail:(NSError*)error
{
    //[App_GeneralUtilities show
    [self dismissHUD];
    [App_GeneralUtilities showAlertOKWithTitle:@"Error!!!" withMessage:[error localizedDescription]];
}

#pragma mark TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
   // NSLog(@"array count is %d",[dataSourceArray count]);
    return [dataSourceArray count];
} 


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
        
     //   NSLog(@"cell is %@",[[[dataSourceArray objectAtIndex:indexPath.row] startDate] stringByReplacingOccurrencesOfString:@" " withString:@""]);

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    //orders details
    OrderDetailsVC* detailVC = [[OrderDetailsVC alloc] initWithObject:[dataSourceArray objectAtIndex:indexPath.row]];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:detailVC animated:YES];
    
    [detailVC release];
         
    
}

@end
