//
//  priorityOrderDetailsVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "priorityOrderDetailsVC.h"

@interface priorityOrderDetailsVC ()

@end

@implementation priorityOrderDetailsVC

@synthesize header;
@synthesize orderNumber;
@synthesize item;
@synthesize quantity;
@synthesize unprioritizeButton;
@synthesize modifyWorkCenter;
@synthesize workCenter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithObject:(Order*)orderItem
{
    if(self = [super init])
    {
        order = orderItem;
        
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
    
    self.orderNumber.text = order.orderNumber;
    self.item.text = order.item;
    self.quantity.text = order.quantity;
    self.workCenter.text = order.workcenter;
    
    pickerArray = [[NSMutableArray alloc] initWithObjects:@"Table1",@"Table2",@"Table3",@"Table4",@"Table5",@"Table6",@"Table7",@"Table8",@"Table9",@"Layout Table",@"Frames",@"BM-03",@"BM-04",@"BM-09",@"DR-11",@"DR-12",@"DR-19",@"LE-19",@"LE-21", nil];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    if([[UserProfile getInstance] privilgegLevel] == 2)
//    {
//        [self.unprioritizeButton setEnabled:NO];
//    }
//    else 
//    {
//        [self.unprioritizeButton setEnabled:YES];
//    }
    
    //if([order
    
    if([order isCommitted])
    {
        [self.modifyWorkCenter setEnabled:NO];
        [self.unprioritizeButton setEnabled:NO];
        [self.modifyWorkCenter setHidden:YES];
        [self.unprioritizeButton setHidden:YES];
    }
    
    
    if(!([[[UserProfile getInstance] privilegeLevel] isEqualToString:SUPERUSER] || [[[UserProfile getInstance] privilegeLevel] isEqualToString:@"Planner"]))
    {
        [self.unprioritizeButton setEnabled:NO];
        [self.unprioritizeButton setHidden:YES];
    }
    else 
    {
        if(![[UserProfile getInstance] isCommitDone]&& ![order isCommitted])
        {
            [self.unprioritizeButton setEnabled:YES];
            [self.modifyWorkCenter setEnabled:YES];
            [self.modifyWorkCenter setHidden:NO];
            [self.unprioritizeButton setHidden:NO];
        }
        else 
        {
            [self.unprioritizeButton setEnabled:NO];
            [self.modifyWorkCenter setEnabled:NO];
            [self.modifyWorkCenter setHidden:YES];
            [self.unprioritizeButton setHidden:YES];
        }
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


-(IBAction)dePrioritizeClicked:(id)sender
{
    DataSource* dataSource = [[DataSource alloc] init];
    
    [dataSource dePrioritizeOrder:order];
    
    [dataSource release];
    
    [App_GeneralUtilities showAlertOKWithTitle:@"Success!!!" withMessage:@"Order successfully UnPrioritized"];
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)showDrawingClicked:(id)sender
{
    
    DataSource* dataSource = [[DataSource alloc] init];
    
    dataSource.delegate = self;
    
    [dataSource fetchDrawingPathForItem:order.item];
    
   // [dataSource release];
    
    
//    drawingVC* drawingScreen = [[drawingVC alloc] init];
//    
//    [self presentModalViewController:drawingScreen animated:YES];
//    
//    [drawingScreen release];
}

-(IBAction)onModifyWorkCenterClicked:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor blackColor];
    
    customPicker=[[UIPickerView alloc]init];//Date picker
    customPicker.frame=CGRectMake(0,14,320, 250);
    //datePicker.datePickerMode = UIDatePickerModeDate;
    customPicker.showsSelectionIndicator = YES;
    
   // [datePicker setMinuteInterval:5];
    [customPicker setTag:10];
    customPicker.dataSource = self;
    customPicker.delegate = self;
    [popoverView addSubview:customPicker];
    
    popoverContent.view = popoverView;
    UIPopoverController* popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    //popoverController.delegate=self;
    [popoverContent release];
    
    [popoverController setPopoverContentSize:CGSizeMake(320, 250) animated:NO];
    //[popoverController presentPopoverFromRect:CGRectMake(218, 362, 280, 80) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [popoverController presentPopoverFromRect:CGRectMake(218, 662, 280, 400) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES]; 
    

}

-(void)dataSourceDidFetchDrawingPath
{
    // NSLog(@"suucessfully fetched %@",[[[App_Storage getInstance] getDrawingPathforItem:order.item] stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
    if([[[[App_Storage getInstance] getDrawingPathforItem:order.item] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"NO"])
    {
        [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:@"No Path Found"];
        
    }
    else
    {
        
        
        showDrawingVC* drawingVC = [[showDrawingVC alloc] initWithDrawingPath:[[[App_Storage getInstance] getDrawingPathforItem:order.item] stringByReplacingOccurrencesOfString:@" " withString:@""]];
           drawingVC.itemNumber = order.item;
           
           [self presentModalViewController:drawingVC animated:YES];
           
           [drawingVC release];
       
    }
    
    
}


-(void)dataSourceDidFailFetchingDrawingPath:(NSError *)error
{
    [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:[error localizedDescription]];
}

#pragma picker callbacks

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [pickerArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //NSLog(@"Selected Color: %@. Index of selected color: %i", [pickerArray objectAtIndex:row], row);
    
    self.workCenter.text = [pickerArray objectAtIndex:row];
    
    order.workcenter = [pickerArray objectAtIndex:row];
    order.isCommitted = 0;
    
    DataSource* dataSource = [[DataSource alloc] init];
    
    [dataSource updateWorkCenter:order];
    
    [dataSource release];    
    
}

@end
