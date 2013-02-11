//
//  PriorityOrdersVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PriorityOrdersVC.h"

@interface PriorityOrdersVC ()

@end

@implementation PriorityOrdersVC

@synthesize priorityInputView;
@synthesize doneButton;
@synthesize cancelButton;
@synthesize priorityTextBox;

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
    // Do any additional setup after loading the view from its nib.
    UIImage* image = [UIImage imageNamed:@"app_btn_back"];
    CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onHomeClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
  //  UIButton* commitButton = [[UIButton alloc] initWithFrame:CGRectMake(350, 730, 100, 100)];
    
    //commitButton.buttonType = UIButtonTypeCustom;
    
    self.commitButton.hidden = NO;
    
    self.priorityHeading.hidden = NO;
    
    //UIBarButtonItem *backButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.header.topItem.title = @"Proritized Orders";
    
    //[self.defaultTableView setFrame:CGRectMake(0, 215, 768, 100)];
    
   // self.defaultTableView.hidden = YES;
    
     self.userDetailsLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"USER:    ",[[UserProfile getInstance] userId],@"     ",[[UserProfile getInstance] userFirstName],@"     ",[[UserProfile getInstance] userLastName]];
    
   
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
   // dataSourceArray = [[App_Storage getInstance] getPriorityOrderList];
    
    dataArray = [[NSMutableArray alloc] initWithArray:[[App_Storage getInstance] getPriorityOrderList]];
    
     self.countLabel.text = [NSString stringWithFormat:@"%@%d",@"Number Of Prioritized Orders is ",[dataArray count]];
    
    NSInteger height = [dataArray count] * 80;
    
    if(height <= 720)
    {
        [self.defaultTableView setFrame:CGRectMake(0, 215, 768, height)];
    }
    else 
    {
        [self.defaultTableView setFrame:CGRectMake(0, 215, 768, 720)];
    }
    
    //[self.defaultTableView setFrame:CGRectMake(0, 215, 768, 340)];
    
    [self.defaultTableView reloadData];
    
     DataSource* dataSource = [[DataSource alloc] init];
    
    if([dataSource getCount:DBPRIORITYORDERS])
    {
        [self.commitButton setEnabled:YES];
        [self.commitButton setHidden:NO];
    }
    else
    {
        [self.commitButton setEnabled:NO];
        [self.commitButton setHidden:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}


-(IBAction)onCommitClicked:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Commit Alert" message:@"Are You Sure You Want To Commit All Orders?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [alert show];
    [alert release];
    
       
}


#pragma mark alertview methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
       
    if([alertView isEqual:inputAlert])
    {
        
        if(buttonIndex == 1)
        {
            NSObject *obj = [[NSBundle mainBundle] loadNibNamed:@"priorityInputView" owner:self options:nil];
            NSArray *array = nil;
            
            if ([obj isKindOfClass:[NSArray class]]) {
                
                array = (NSArray*) obj;
                
                for (UIView *customView in array) {
                    //NSLog(@"%@", customView);
                    [priorityInputView setFrame:CGRectMake(200, 400, 400, 100)];
                    [self.view addSubview:priorityInputView];
                    
                    //            NSArray *array = [self.customPageHeaderView subviews];
                    //            for (NSObject *obj in array) {
                    //                NSLog(@"%s: \t%@", __FUNCTION__, obj);
                    //            }
                }
            }
            
        }
        else if (buttonIndex ==2)
        {
            priorityOrderDetailsVC* detailVC = [[priorityOrderDetailsVC alloc] initWithObject:[dataArray objectAtIndex:index]];
            detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            //detailVC.isDepriorityEnabled = YES;
            
            [self presentModalViewController:detailVC animated:YES];
            
            [detailVC release];
        }
       
    }
    
    else 
    {
        if(buttonIndex == 1)
        {
            
            [self showHUD:@"Commiting Orders"];
            
            [[UserProfile getInstance] setIsCommitDone:YES];
            
            DataSource* dataSource = [[DataSource alloc] init];
            dataSource.delegate = self;
            [dataSource commitOrders];
            
            
            
        }
        

    }

}


#pragma mark DataSource Callbacks
-(void)dataSourceDidCommit
{
    [self dismissHUD];
    [self.commitButton setEnabled:NO];
    [self.commitButton setHidden:YES];
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Commit Alert" message:@"Orders Committed Successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    
//    [alert show];
//    [alert release];
    
    [self showHUD:@"Commit Successful !! Refreshing Order List"];
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    
    [dataSource refreshOrderList];
}


-(void)dataSourceDidFailCommit:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Commit Alert" message:@"Failed To Commit Orders" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alert show];
    [alert release];
}

-(void)dataSourceOrderListDidFinish:(NSMutableArray *)entityArray
{
    [dataArray release];
    dataArray = [[NSMutableArray alloc] initWithArray:[[App_Storage getInstance] getPriorityOrderList]];
    
    [self dismissHUD];
    [self.defaultTableView reloadData];
}


#pragma mark TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    // NSLog(@"array count is %d",[dataSourceArray count]);
    return [dataArray count];
} 


//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if(section == 0)
//    {
//        return @"Order                   StartDate        End Date       W/C       Planner";
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

    
    cell.cellOrderNumber.text = [[dataArray objectAtIndex:indexPath.row] orderNumber];
    cell.cellStartDate.text = [[[dataArray objectAtIndex:indexPath.row] startDate] stringByReplacingOccurrencesOfString:@" " withString:@""];
    cell.cellEndDate.text = [[dataArray objectAtIndex:indexPath.row] endDate];
    cell.cellWC.text = [[dataArray objectAtIndex:indexPath.row] workcenter];
    cell.cellPlanner.text = [[dataArray objectAtIndex:indexPath.row] planner];
    [cell.priority setHidden:NO];
    cell.priority.text = [NSString stringWithFormat:@"%d",[(Order*)[dataArray objectAtIndex:indexPath.row] priority]];
    
    //NSLog(@"cell is %@",[[[dataArray objectAtIndex:indexPath.row] startDate] stringByReplacingOccurrencesOfString:@" " withString:@""]);
        
    if([[dataArray objectAtIndex:indexPath.row] isCommitted])
    {
        cell.cellOrderNumber.textColor = [UIColor grayColor];
        cell.cellStartDate.textColor = [UIColor grayColor];
        cell.cellEndDate.textColor = [UIColor grayColor];
        cell.cellWC.textColor = [UIColor grayColor];
        cell.cellPlanner.textColor = [UIColor grayColor];
    }
         
    else 
    {
        [self.commitButton setEnabled:YES];
        //cell.textLabel.textColor = [UIColor purpleColor];
        
//        if([[[dataArray objectAtIndex:indexPath.row] exceptionCode] length])
//        {
//            NSLog(@"exception code is %@",[[dataArray objectAtIndex:indexPath.row] exceptionCode]);
//            cell.cellOrderNumber.textColor = [UIColor magentaColor];
//            cell.cellStartDate.textColor = [UIColor magentaColor];
//            cell.cellEndDate.textColor = [UIColor magentaColor];
//            cell.cellWC.textColor = [UIColor magentaColor];
//            cell.cellPlanner.textColor = [UIColor magentaColor];
//        }
//        else
//        {
//            cell.cellOrderNumber.textColor = [UIColor blueColor];
//            cell.cellStartDate.textColor = [UIColor blueColor];
//            cell.cellEndDate.textColor = [UIColor blueColor];
//            cell.cellWC.textColor = [UIColor blueColor];
//            cell.cellPlanner.textColor = [UIColor blueColor];
//        }
        
        
        if([[[dataArray objectAtIndex:indexPath.row] exceptionCode] isEqualToString:@"(null)"])
        {
            cell.cellOrderNumber.textColor = [UIColor blueColor];
            cell.cellStartDate.textColor = [UIColor blueColor];
            cell.cellEndDate.textColor = [UIColor blueColor];
            cell.cellWC.textColor = [UIColor blueColor];
            cell.cellPlanner.textColor = [UIColor blueColor];
        }
        else 
        {
            cell.cellOrderNumber.textColor = [UIColor magentaColor];
            cell.cellStartDate.textColor = [UIColor magentaColor];
            cell.cellEndDate.textColor = [UIColor magentaColor];
            cell.cellWC.textColor = [UIColor magentaColor];
            cell.cellPlanner.textColor = [UIColor magentaColor];
        }
           
       
    }
    
    
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    inputAlert = [[UIAlertView alloc] initWithTitle:@"Select an Option" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reassign Priority",@"View Details", nil];
    
    [inputAlert show];
    [inputAlert release];
    
    index = indexPath.row;
    
}

-(IBAction)onDoneClicked:(id)sender
{
    NSLog(@"priority is %@",self.priorityTextBox.text);
    
    
    
    int priorityEntered = [self.priorityTextBox.text intValue];
   // int indexNew;
    
    int currentPriority = [(Order*)[dataArray objectAtIndex:index] priority];
    
    int maxPriority = [dataArray count] - 1;
    
    if(priorityEntered <0 || priorityEntered > maxPriority)
    {
        [App_GeneralUtilities showAlertOKWithTitle:@"Error" withMessage:@"Please enter a valid Priority"];
    }
    
    else 
    {
        if(priorityEntered < currentPriority)
        {
            
            [self.priorityInputView removeFromSuperview];
            
            [(Order *)[dataArray objectAtIndex:index] setPriority:[self.priorityTextBox.text intValue]];
            
            //updating priority for the rest of items greater than entered priority
            
            for(int i=0;i<[dataArray count];i++)
            {
                if(!(index == i))
                {
                    if(priorityEntered <= [(Order *)[dataArray objectAtIndex:i] priority])
                    {
                        [(Order *)[dataArray objectAtIndex:i] setPriority:[(Order *)[dataArray objectAtIndex:i] priority] + 1];           
                    }
                }
                
                
            }
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
            
            [dataArray sortUsingDescriptors:sortDescriptors];
            
            
            [[App_Storage getInstance] deletePiorityList];
            
            for(int i=0;i<[dataArray count];i++)
            {
                [[App_Storage getInstance] storePrioritizedOrder:[dataArray objectAtIndex:i]];
            }
            
            
            [self.defaultTableView reloadData];
            
            
        }
        
        else 
        {
            [self.priorityInputView removeFromSuperview];
            [(Order *)[dataArray objectAtIndex:index] setPriority:[self.priorityTextBox.text intValue]];
            
            for(int i=0;i<[dataArray count];i++)
            {
                if(!(index == i))
                {
                    if(priorityEntered >= [(Order *)[dataArray objectAtIndex:i] priority])
                    {
                        [(Order *)[dataArray objectAtIndex:i] setPriority:[(Order *)[dataArray objectAtIndex:i] priority] - 1];           
                    }
                }
                
                
            }
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
            
            [dataArray sortUsingDescriptors:sortDescriptors];
            
            
            [[App_Storage getInstance] deletePiorityList];
            
            for(int i=0;i<[dataArray count];i++)
            {
                [[App_Storage getInstance] storePrioritizedOrder:[dataArray objectAtIndex:i]];
            }
            
            
            [self.defaultTableView reloadData];
            
        }

    }
    
        
}

-(IBAction)onCancelClicked:(id)sender
{
    [self.priorityInputView removeFromSuperview];
}


@end
