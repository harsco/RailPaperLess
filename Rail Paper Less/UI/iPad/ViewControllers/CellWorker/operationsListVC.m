//
//  operationsListVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "operationsListVC.h"

@interface operationsListVC ()

@end

@implementation operationsListVC
@synthesize lineTable;
@synthesize header;
@synthesize holderView;
@synthesize orderNumber;
@synthesize planner;
@synthesize item;
@synthesize desc;
@synthesize quantity;
@synthesize uom;
@synthesize revision;
@synthesize status;
@synthesize completeOrderButton;
@synthesize cancelOrderButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrder:(CWOrder*)order
{
    if(self = [super init])
    {
        orderPos = order;
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
    
    [self.holderView.layer setMasksToBounds:YES];           //mask the extra area
    [self.holderView.layer setCornerRadius:20.0];
    [self.holderView.layer setBorderColor:[[UIColor orangeColor] CGColor]];
    [self.holderView.layer setBorderWidth:3.0];
    
    locationOfEditObject = -1;
    countOfUncompletedOperations = [[App_Storage getInstance] getCountOfUncompletedOperations:orderPos.orderNumber];
    
    dataArray = [[NSMutableArray alloc] initWithArray:[[App_Storage getInstance] getOperationsForOrder:orderPos]];
    orderPos.operationArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    self.orderNumber.text = orderPos.orderNumber;
    self.planner.text = orderPos.planner;
    self.item.text = [orderPos.item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.desc.text = [orderPos.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.quantity.text = [orderPos.orderquan stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.uom.text = [orderPos.UOM stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    self.revision.text = [orderPos.revision stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.status.text = [orderPos.status stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([self.status.text isEqualToString:@"AwatingReceipt"])
    {
        [self.cancelOrderButton setEnabled:NO];
    }
    
    if(countOfUncompletedOperations)
    {
        [self.completeOrderButton setHidden:YES];
        [self.cancelOrderButton setHidden:NO];
    }
    else
    {
        [self.completeOrderButton setHidden:NO];
        [self.cancelOrderButton setHidden:YES];
    }       

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


-(IBAction)onCompleteOrderClicked:(id)sender
{
    [self showHUD:@"Completeing Operation"];
    isOrderCompleted = YES;
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    [dataSource completeOrder:orderPos];
}
-(IBAction)onCancelOrderClicked:(id)sender
{
    [self showHUD:@"Cancelling Operation"];
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    [dataSource cancelOrder:orderPos];

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


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    GridCell *cell = (GridCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        // cell = [[[GridCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
        cell = [[GridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    NSLog(@"indexpath is %d",indexPath.row);
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    // GridCell *cell = (GridCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    DefaultGridCell* cell = (DefaultGridCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
		// Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DefaultGridCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.accessoryView = nil;
	}
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
	return cell;
    
    //return cell;
}


- (void)configureCell:(DefaultGridCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_item_bg@2x.png"]] autorelease];
    
    cell.positionNumber.text = [NSString stringWithFormat:@"%d",[[dataArray objectAtIndex:indexPath.row] operation]];
    
    cell.item.frame = CGRectMake(60.0, 25, 50, 21);
    cell.item.text = [[dataArray objectAtIndex:indexPath.row] task];
    
    cell.description.frame = CGRectMake(120.0, 25, 160.0,21);
    cell.description.text = [[dataArray objectAtIndex:indexPath.row] taskDescription];
    
    cell.pickLocation.frame = CGRectMake(300.0, 25, 60.0, 21);
    cell.pickLocation.text = [[dataArray objectAtIndex:indexPath.row] oPWorkcenter];
    
    cell.pickqty.frame = CGRectMake(400.0, 25, 200.0,21);
    cell.pickqty.text = [[dataArray objectAtIndex:indexPath.row] workcenterdesc];
    
    cell.uom.frame = CGRectMake(620.0, 25, 30.0,21);
    cell.uom.text =[[dataArray objectAtIndex:indexPath.row] machine];
    
    cell.pickedLocation.frame = CGRectMake(670.0, 25, 30.0,21);
    cell.pickedLocation.text = [[dataArray objectAtIndex:indexPath.row] currentOperation];
    //cell.pickedQty.text = [NSString stringWithFormat:@"%.2f",[[[dataArray objectAtIndex:indexPath.row] pickedqty] floatValue] ];
    
    [cell.pickedQty setHidden:YES];
    
    if(locationOfEditObject == indexPath.row)
        cell.positionNumber.textColor = [UIColor redColor];
    if(locationOfEditObject == indexPath.row)
        cell.item.textColor = [UIColor redColor];
    if(locationOfEditObject == indexPath.row)
        cell.description.textColor = [UIColor redColor];
    if(locationOfEditObject == indexPath.row)
        cell.pickLocation.textColor = [UIColor redColor];
    if(locationOfEditObject == indexPath.row)
        cell.pickqty.textColor = [UIColor redColor];
    if(locationOfEditObject == indexPath.row)
        cell.uom.textColor = [UIColor redColor];
    if(locationOfEditObject == indexPath.row)
        cell.pickedLocation.textColor = [UIColor redColor];
    if(locationOfEditObject == indexPath.row)
        cell.pickedQty.textColor = [UIColor redColor];
}

/*
- (void)configureCell1:(GridCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 0, 30.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:200];
    // label.tag = LABEL_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = UITextAlignmentLeft;
    label.text = [NSString stringWithFormat:@"%d",[[dataArray objectAtIndex:indexPath.row] operation]];
    //label.text = @"100";
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label]; 
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(60.0, 0, 50.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = UITextAlignmentLeft;
    // add some silly value
    
    
    label.text = [[dataArray objectAtIndex:indexPath.row] task];
    //label.text = @"999";
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    
    
    
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(120.0, 0, 160.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    
    label.text = [[dataArray objectAtIndex:indexPath.row] taskDescription];
    //label.text = @"Clean Assessment";
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    label.textAlignment = UITextAlignmentLeft;
    
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(300.0, 0, 60.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    
    label.text = [[dataArray objectAtIndex:indexPath.row] oPWorkcenter];
    //label.text = @"3245";
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(400.0, 0, 200.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    
     label.text = [[dataArray objectAtIndex:indexPath.row] workcenterdesc];
   // label.text = [NSString stringWithFormat:@"%.2f",[[[dataArray objectAtIndex:indexPath.row] pickqty] floatValue] ];
    
   // label.text = @"sdkfjkdfjdkfjsdfdfldkf;lkdlfkdl;fkd;lfkdf";
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(620.0, 0, 30.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    label.text = [[dataArray objectAtIndex:indexPath.row] machine];
   // label.text = @"410";
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(670.0, 0, 30.0,self.lineTable.rowHeight)] autorelease];
    
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    
    label.text = [[dataArray objectAtIndex:indexPath.row] currentOperation];
    //label.text = @"Yes";
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
       
    UIView* tempView = [[UIView alloc] init];
    
    tempView.backgroundColor = [UIColor darkGrayColor];
    
    //cell.backgroundView = tempView;
    
}*/


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    locationOfEditObject = indexPath.row;
    
    [self showAlert];
    
}

#pragma Alert View Methods
-(void)showAlert
{
    operationAlert = [[UIAlertView alloc] initWithTitle:@"Input Alert!!" message:@"Please Choose Your Action" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Complete Operation",@"View Details", nil];
    
    [operationAlert show];
    [operationAlert release];
}

#pragma mark alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if([alertView isEqual:operationAlert])
    {
    
        if(buttonIndex == 1)
        {
            
            if([[[dataArray objectAtIndex:locationOfEditObject] currentOperation] isEqualToString:@"Yes"])
            {
                [App_GeneralUtilities showAlertOKWithTitle:@"Operation Alert!!" withMessage:@"Operation Already Completed"];
            }
            
            else 
            {
                [self showHUD:@"Completing Operation"];
                
                CWOrder* order = [[CWOrder alloc] init];
                order.orderNumber = orderPos.orderNumber;
                
                
                countOfUncompletedOperations--;
                
                if(countOfUncompletedOperations>0)
                {
                    order.status = @"Active";
                    self.status.text = @"Active";
                    [self.completeOrderButton setHidden:YES];
                    [self.cancelOrderButton setHidden:NO];
                }
                else
                {
                    order.status = @"Awaiting Receipt";
                    self.status.text = @"Awaiting Receipt";
                    [self.completeOrderButton setHidden:NO];
                    [self.cancelOrderButton setHidden:YES];
                }
                
                
                [[dataArray objectAtIndex:locationOfEditObject] setCurrentOperation:@"YES"];
                order.operationArray = [[NSMutableArray alloc] initWithObjects:[dataArray objectAtIndex:locationOfEditObject], nil];
                
                
                [[App_Storage getInstance] updateOperationStatus:[dataArray objectAtIndex:locationOfEditObject] ofOrder:order.orderNumber];
                
                DataSource* dataSource = [[DataSource alloc] init];
                dataSource.delegate = self;
                [dataSource completeOperation:order];
            }
               
            
            
            
        }
        if(buttonIndex == 2)
        {
            operationsDetailsVC* detailsVC = [[operationsDetailsVC alloc] initWithOperation:[dataArray objectAtIndex:locationOfEditObject]];
            [self presentModalViewController:detailsVC animated:YES];
            [detailsVC release];
        }
    }
}

#pragma mark DataSource Callbacks

-(void)dataSourceDidCompleteOperation
{
    [self dismissHUD];
    dataArray = [[NSMutableArray alloc] initWithArray:[[App_Storage getInstance] getOperationsForOrder:orderPos]];
    
    [self.lineTable reloadData];
    
    if(isOrderCompleted)
    {
        isOrderCompleted = NO;
        [self.completeOrderButton setEnabled:NO];
        [self showHUD:@"Completed Order!!! Refreshing Orders List"];
        DataSource* dataSource = [[DataSource alloc] init];
        dataSource.delegate = self;
        [dataSource refreshCWOperationsList];
    }
    
    
    
}
-(void)dataSourceDidFailOperationCommit:(NSError *)error
{
    [self dismissHUD];
    [App_GeneralUtilities showAlertOKWithTitle:@"Error" withMessage:[error localizedDescription]];
}

-(void)dataSourceOrderListDidFinish:(NSMutableArray *)entityArray
{
     [self dismissHUD];
}

-(void)dataSourceOrderListDidFail:(NSError *)error
{
    [self dismissHUD];
    [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:@"Unable to Refresh Order List"];
}


@end
