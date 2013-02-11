//
//  backLogOrderDetailsVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "backLogOrderDetailsVC.h"

@interface backLogOrderDetailsVC ()

@end

@implementation backLogOrderDetailsVC

@synthesize header;
@synthesize orderNumber;
@synthesize item;
@synthesize quantity;
@synthesize exceptionCode;
@synthesize prioritizeButton;
@synthesize exceptionButton;

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
        isExceptionEntered = NO;
        
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
    
    if(!([[[UserProfile getInstance] privilegeLevel] isEqualToString:SUPERUSER] || [[[UserProfile getInstance] privilegeLevel] isEqualToString:@"Planner"]))
    {
        [self.prioritizeButton setEnabled:NO];
    }
    else 
    {
         [self.prioritizeButton setEnabled:YES];
    }
    
    
    if(!isExceptionEntered)
    {
        [self.prioritizeButton setEnabled:NO];
    }
    
    
    pickerArray = [[NSMutableArray alloc] initWithObjects:@"Break Down",@"Stock Adjustment",nil];
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


#pragma mark alertview call backs
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"text is %@",dummy.useridtext.text);
    NSLog(@"clicked index is %d",buttonIndex);
    NSLog(@"ordernumber is %@",order.orderNumber);
    
    if(buttonIndex == 0)
    {
        DataSource* dataSource = [[DataSource alloc] init];
        
        [dataSource prioritizeOrder:order];
        
        [dataSource release];
    }
    
    //[App_GeneralUtilities showAlertOKWithTitle:@"Success!!!" withMessage:@"Order successfully Prioritized"];
}

#pragma mark-action methods
#pragma mark - Action Methods
-(void)onHomeClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)exceptionButtonClicked:(id)sender
{
    
    [self.prioritizeButton setEnabled:YES];
    
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
    popoverController.delegate=self;
    [popoverContent release];
    
    [popoverController setPopoverContentSize:CGSizeMake(320, 250) animated:NO];
    //[popoverController presentPopoverFromRect:CGRectMake(218, 362, 280, 80) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [popoverController presentPopoverFromRect:CGRectMake(218, 662, 280, 400) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES]; 
}


-(IBAction)priorityClicked:(id)sender
{
    order.priority = 0;
    
    NSLog(@"exc code is %@",order.exceptionCode);
    
    [[UserProfile getInstance] setIsCommitDone:NO];
    
    DataSource* dataSource = [[DataSource alloc] init];
    
    //[dataSource updateExceptionCode:order];
    [dataSource prioritizeBacklogOrder:order];
    
    [dataSource release];
    
     [App_GeneralUtilities showAlertOKWithTitle:@"Success!!!" withMessage:@"Order successfully Prioritized"];
    
    [self dismissModalViewControllerAnimated:YES];


}


#pragma mark Popover Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"called is %@",order.exceptionCode);
    
    if(![order.exceptionCode length])
    {
        self.exceptionCode.text = [pickerArray objectAtIndex:0];
        order.exceptionCode  = [pickerArray objectAtIndex:0];
    }
    
    
}

#pragma picker callbacks

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [pickerArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
    
    //NSLog(@"Selected Color: %@. Index of selected color: %i", [pickerArray objectAtIndex:row], row);
    
    self.exceptionCode.text = [pickerArray objectAtIndex:row];
    
    order.exceptionCode = [pickerArray objectAtIndex:row];
    
        
}



@end
