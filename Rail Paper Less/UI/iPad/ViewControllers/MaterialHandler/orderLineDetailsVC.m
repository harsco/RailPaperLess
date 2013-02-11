//
//  orderLineDetailsVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "orderLineDetailsVC.h"

@interface orderLineDetailsVC ()

@end

@implementation orderLineDetailsVC
@synthesize lineTable;
@synthesize header;
@synthesize orderNumber;
@synthesize orderStatus;
@synthesize wcDesc;
@synthesize wcNumber;
@synthesize pno;
@synthesize item;
@synthesize uom;
@synthesize desc;
@synthesize pkLocation;
@synthesize pkQty;
@synthesize pkdLocation;
@synthesize pkdQty;

@synthesize doneButton;
@synthesize cancelButton;
@synthesize saveButton;
@synthesize addNewButton;
@synthesize confirmPicking;
@synthesize isPickingConfirmed;

@synthesize inputView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrder:(POOrder*)order
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
    
    [self.lineTable.layer setMasksToBounds:YES];           //mask the extra area
    [self.lineTable.layer setCornerRadius:20.0];
   // [self.lineTable.layer setBorderColor:[[UIColor cyanColor] CGColor]];
    [self.lineTable.layer setBorderColor:[[UIColor magentaColor] CGColor]];
    [self.lineTable.layer setBorderWidth:3.0];
    
    self.pno.delegate = self;
    self.item.delegate = self;
    self.desc.delegate = self;
    self.pkLocation.delegate = self;
    self.pkdQty.delegate = self;
    self.pkdLocation.delegate = self;
    self.pkdQty.delegate = self;
    self.uom.delegate = self;
    self.uom.text = @"ea";
    
    [self.pkdQty addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventEditingDidEndOnExit]; 
    
    dataArray = [[NSMutableArray alloc] initWithArray:[[App_Storage getInstance] getPositionsForOrder:orderPos]];
    
    if([dataArray count] == 0)
    {
        [self.confirmPicking setEnabled:NO];
    }
    
    orderPos.positionArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    self.orderNumber.text = orderPos.orderNumber;
    self.orderStatus.text = [orderPos.status stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.wcNumber.text = orderPos.workcenter;
    self.wcDesc.text = orderPos.wcdescription;
    
    [self.saveButton setEnabled:NO];
    
    //NSLog(@"%@",[orderPos.status stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    
    if([[orderPos.status stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"Picked"])
    {
        [self.saveButton setEnabled:NO];
        [self.addNewButton setEnabled:NO];
        [self.confirmPicking setEnabled:NO];
    }
    
    
    locationOfEditObject = -1;
    
   // NSLog(@"modified string is %@", [orderPos.status stringByReplacingOccurrencesOfString:@"\n" withString:@""]
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


-(IBAction)addNewClicked:(id)sender
{
    
    NSObject *obj = [[NSBundle mainBundle] loadNibNamed:@"inputView" owner:self options:nil];
    NSArray *array = nil;
    
    if ([obj isKindOfClass:[NSArray class]]) {
        
        array = (NSArray*) obj;
        
        for (UIView *customView in array) {
            //NSLog(@"%@", customView);
            [self.view addSubview:inputView];
            
            //            NSArray *array = [self.customPageHeaderView subviews];
            //            for (NSObject *obj in array) {
            //                NSLog(@"%s: \t%@", __FUNCTION__, obj);
            //            }
        }
    }
    
    if([dataArray count])
    {
        
        int position = [[[dataArray lastObject] positionNumber] intValue] + 10;
        NSLog(@"position is %d",position);
        self.pno.text = [NSString stringWithFormat:@"%d",position];
        self.uom.text = @"ea";
    }
    else
    {
        int position =  10;
        //NSLog(@"position is %d",position);
        self.pno.text = [NSString stringWithFormat:@"%d",position];
        self.uom.text = @"ea";
    }
    
    inputView.frame = CGRectMake(0, 300, 768,150);
    
    [self.view addSubview:inputView];
    
    self.orderStatus.text = @"Partially Picked";
    
    //[self.saveButton setEnabled:YES];
    
    [self.confirmPicking setEnabled:NO];
    
   
}

-(IBAction)saveClicked:(id)sender
{
    [self showHUD:@"Saving Field"];
    
   // isSaveClicked = YES;
    
    PositionData* posObj = [[PositionData alloc] init];
    
    posObj.positionNumber = [pno text];
    posObj.item = [item text];
    posObj.description = [desc text];
    posObj.pickLocation = [pkLocation text];
    posObj.pickqty = [pkQty text];
    posObj.pickedLocation = [pkdLocation text];
    posObj.pickedqty = [pkdQty text];
    posObj.UOM = [uom text];
    
    POOrder* order = [[POOrder alloc] init];
    
    order.orderNumber = orderPos.orderNumber;
    order.positionArray = [[NSMutableArray alloc] initWithObjects:posObj, nil];
    order.status = @"Partially Picked";
    
    [[App_Storage getInstance] storePositionsOfOrder:order];
    
    [self.lineTable reloadData];
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    
    [dataSource confirmPicking:order];
    
    [dataSource release];
    
    [order release];
    [posObj release];
    
    
}


-(IBAction)doneClicked:(id)sender
{
    
    [self.confirmPicking setEnabled:YES];
    
    PositionData* posObj = [[PositionData alloc] init];
    
    if(![item.text length])
    {
         errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Item cant be left blank" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
        [errorAlert release];
        
        self.item.backgroundColor = [UIColor redColor];
    }
    else if(![pkQty.text length])
    {
        errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Pick Quantity cant be left blank" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
        [errorAlert release];
        
        self.pkQty.backgroundColor = [UIColor redColor];

    }
    else if(!([pkQty.text floatValue] > 0.00))
    {
        errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Pick Quantity Should be greater than 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
        [errorAlert release];
        
        self.pkQty.backgroundColor = [UIColor redColor];
    }
    else if(![pkdLocation.text length])
    {
        errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Picked Location cant be left blank" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
        [errorAlert release];
        
        self.pkdLocation.backgroundColor = [UIColor redColor];

    }
    else
    {
        [self.inputView removeFromSuperview];
    
        posObj.positionNumber = [pno text];
        posObj.item = [item text];
        posObj.description = [desc text];
        posObj.pickLocation = [pkLocation text];
        posObj.pickqty = [pkQty text];
        posObj.pickedLocation = [pkdLocation text];
        posObj.pickedqty = [pkdQty text];
        posObj.UOM = [uom text];
        
        POOrder* order = [[POOrder alloc] init];
        
        order.orderNumber = orderPos.orderNumber;
        order.positionArray = [[NSMutableArray alloc] initWithObjects:posObj, nil];
        order.status = @"Partially Picked";
        
        
        [[App_Storage getInstance] storePositionsOfOrder:order];
        [[App_Storage getInstance] updatePCOrderStatus:order];
        
        dataArray = [[NSMutableArray alloc] initWithArray:[[App_Storage getInstance] getPositionsForOrder:orderPos]];
        
        [self.lineTable reloadData];
        
        [self showHUD:@"Saving Details!!"];
        
        DataSource* dataSource = [[DataSource alloc] init];
        dataSource.delegate = self;
        
        [dataSource confirmPicking:order];
        
        [dataSource release];
        
        [order release];
        [posObj release];
    
    }
    
}

-(IBAction)confirmPickingClicked:(id)sender
{
    
    UIAlertView* myAlert = [[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Are you sure you want to confirm the picking of entire Order" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [myAlert show];
    [myAlert release];

}

-(IBAction)cancelClicked:(id)sender
{
    if([dataArray count])
    [self.confirmPicking setEnabled:YES];
    
    [self.inputView removeFromSuperview];
}

#pragma mark TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [dataArray count];
} 



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


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
    
    cell.positionNumber.text = [[dataArray objectAtIndex:indexPath.row] positionNumber];
    cell.item.text = [[dataArray objectAtIndex:indexPath.row] item];
    cell.description.text = [[dataArray objectAtIndex:indexPath.row] description];
    cell.pickLocation.text = [[dataArray objectAtIndex:indexPath.row] pickLocation];
    cell.pickqty.text = [NSString stringWithFormat:@"%.2f",[[[dataArray objectAtIndex:indexPath.row] pickqty] floatValue] ];
    cell.uom.text = [[dataArray objectAtIndex:indexPath.row] UOM];
    cell.pickedLocation.text = [[dataArray objectAtIndex:indexPath.row] pickedLocation];
    cell.pickedQty.text = [NSString stringWithFormat:@"%.2f",[[[dataArray objectAtIndex:indexPath.row] pickedqty] floatValue] ];
    
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
    
    
//    if ([[cell subviews] count] > 0) 
//    {
//        UIView *viewToClear = [[cell subviews] objectAtIndex:0];
//        [viewToClear removeFromSuperview];
//    }
    
//    for(int i=0;i< [[cell subviews] count];i++)
//    {
//        UIView *viewToClear = [[cell subviews] objectAtIndex:0];
//        [viewToClear removeFromSuperview];
//    }
    
    
    
    //Label 1
    /*
    
    UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 0, 30.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:200];
    // label.tag = LABEL_TAG;
    label1.font = [UIFont systemFontOfSize:12.0];
    label1.textAlignment = UITextAlignmentLeft;
    label1.text = [[dataArray objectAtIndex:indexPath.row] positionNumber];
    
    if(locationOfEditObject == indexPath.row)
        label1.textColor = [UIColor redColor];
    else 
        label1.textColor = [UIColor blueColor];
    
    label1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label1]; 
    
    //Label 2
    
    UILabel * label =  [[[UILabel alloc] initWithFrame:CGRectMake(60.0, 0, 100.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = UITextAlignmentLeft;
    
    label.text = [[dataArray objectAtIndex:indexPath.row] item];
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    //Label 3
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(190.0, 0, 150.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    
    label.text = [[dataArray objectAtIndex:indexPath.row] description];
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    label.textAlignment = UITextAlignmentLeft;
    
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    //Label 4
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(370.0, 0, 60.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    
    label.text = [[dataArray objectAtIndex:indexPath.row] pickLocation];
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    //Label 5
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(460.0, 0, 30.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    
    // label.text = [[dataArray objectAtIndex:indexPath.row] pickqty];
    label.text = [NSString stringWithFormat:@"%.2f",[[[dataArray objectAtIndex:indexPath.row] pickqty] floatValue] ];
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    //Label 6
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(520.0, 0, 30.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    label.text = [[dataArray objectAtIndex:indexPath.row] UOM];
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    
    //Label 7
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(580.0, 0, 60.0,self.lineTable.rowHeight)] autorelease];
    
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    
    label.text = [[dataArray objectAtIndex:indexPath.row] pickedLocation];
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    [label release];
    
    //Label 8
    
    label =  [[[UILabel alloc] initWithFrame:CGRectMake(670.0, 0, 30.0,self.lineTable.rowHeight)] autorelease];
    [cell addColumn:3000];
    //label.tag = VALUE_TAG;
    label.font = [UIFont systemFontOfSize:12.0];
    // add some silly value
    //label.text = [[dataArray objectAtIndex:indexPath.row] pickedqty];
    label.text = [NSString stringWithFormat:@"%.2f",[[[dataArray objectAtIndex:indexPath.row] pickedqty] floatValue] ];
    
    label.backgroundColor = [UIColor clearColor];
    
    if(locationOfEditObject == indexPath.row)
        label.textColor = [UIColor redColor];
    else 
        label.textColor = [UIColor blueColor];
    
    
    label.textAlignment = UITextAlignmentLeft;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];

//    UIView* tempView = [[UIView alloc] init];
//    
//    tempView.backgroundColor = [UIColor darkGrayColor];
//    
//    cell.backgroundView = tempView;*/
    
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    locationOfEditObject = indexPath.row;
    
    if(![[orderPos.status stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"Picked"])
    {
        dummy = [[dummyLoginView alloc] initWithTitle:@"Edit Picked Location & Picked QTY" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Cancel", nil];
        
        dummy.delegate = self;
        
        [dummy show];
    }
    
}




- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"index is %d",buttonIndex);
    
    if([alertView isKindOfClass:[dummy class]])
    {
        
        if(buttonIndex == 0)
        {
            PositionData* posObj = [[PositionData alloc] init];
            
            posObj.positionNumber = [[dataArray objectAtIndex:locationOfEditObject] positionNumber];
            posObj.item = [[dataArray objectAtIndex:locationOfEditObject] item];
            posObj.description = [[dataArray objectAtIndex:locationOfEditObject] description];
            posObj.UOM = [[dataArray objectAtIndex:locationOfEditObject] UOM];
            posObj.pickLocation = [[dataArray objectAtIndex:locationOfEditObject] pickLocation];
            posObj.pickqty = [[dataArray objectAtIndex:locationOfEditObject] pickqty];
            
            if([dummy.useridtext.text length])
            {
                posObj.pickedLocation = dummy.useridtext.text;
            }
            else 
            {
                posObj.pickedLocation = [[dataArray objectAtIndex:locationOfEditObject] pickedLocation];
            }
            
            if([dummy.passwordtext.text length])
            {
                posObj.pickedqty = dummy.passwordtext.text;
            }
            else 
            {
                posObj.pickedqty = 0;
            }
            
            [[App_Storage getInstance] updatefieldsOfPosition:posObj];
            
            POOrder* order = [[POOrder alloc] init];
            
            order.orderNumber = orderPos.orderNumber;
            order.positionArray = [[NSMutableArray alloc] initWithObjects:posObj, nil];
            order.status = @"Partially Picked";
            self.orderStatus.text = @"Partially Picked";
            
            [self showHUD:@"Saving Details"];
            
            [[App_Storage getInstance] updatePCOrderStatus:order];
            
            DataSource* dataSource = [[DataSource alloc] init];
            dataSource.delegate = self;
            
            [dataSource confirmPicking:order];
            
            [dataSource release];
            
            [order release];
            [posObj release];
            
            //[self.lineTable reloadData];
            
           // [self.saveButton setEnabled:YES];
        }
    }
    
    else if([alertView isEqual:errorAlert])
    {
        NSLog(@"done");
    }
    
    else
    {
        if(buttonIndex == 1)
        {
            [self showHUD:@"Confirming Picking"];
            POOrder* order = [[POOrder alloc] init];
            order.orderNumber = orderPos.orderNumber;
            order.positionArray = [[NSMutableArray alloc] initWithArray:[[App_Storage getInstance] getPositionsForOrder:order]];
            order.status = @"Picked";
            self.orderStatus.text = @"Picked";
            isPickingConfirmed = YES;
            
            DataSource* dataSource = [[DataSource alloc] init];
            dataSource.delegate =self;
            
            [dataSource confirmPicking:order];
            
            [dataSource release];
            
            [self.saveButton setEnabled:NO];
            [self.addNewButton setEnabled:NO];
            [self.confirmPicking setEnabled:NO];
        }
    }
    
    
}


#pragma mark data source call backs
-(void)dataSourceDidCommit
{
    [self dismissHUD];
    
    if(dataArray)
    {
        [dataArray release];
        
       // [[App_Storage getInstance] updateOrderStatus:<#(POOrder *)#> Status:<#(NSString *)#>
        

        dataArray = [[NSMutableArray alloc] initWithArray:[[App_Storage getInstance] getPositionsForOrder:orderPos]];
        //NSLog(@"count is %d",[dataArray count]);
    }
    
    [self.lineTable reloadData];
    
   
    if(isPickingConfirmed)
    {
        isPickingConfirmed = NO;
        [self showHUD:@"Refreshing Orders List"];
        
        DataSource* dataSource = [[DataSource alloc] init];
        dataSource.delegate = self;
        
        [dataSource refreshPickAndConfirmList];
    }
    
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


#pragma mark Textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if(textField == self.item)
    {
        [desc becomeFirstResponder];
    }
    if(textField == self.desc)
    {
        [pkLocation becomeFirstResponder];
    }
    if(textField == self.pkLocation)
    {
        [pkQty becomeFirstResponder];
    }
    if(textField == self.pkQty)
    {
        [uom becomeFirstResponder];
    }
    if(textField == self.uom)
    {
        [pkdLocation becomeFirstResponder];
    }
    if(textField == self.pkdLocation)
    {
        [pkdQty becomeFirstResponder];
    }
    if(textField == self.pkdQty)
    {
        [self doneClicked:textField];
    }
    
    return YES;
}



@end
