//
//  inputParamVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "inputParamVC.h"

@interface inputParamVC ()

@end

@implementation inputParamVC

@synthesize userDetailsLabel;
@synthesize rootTabController;
@synthesize plannerFromLabel;
@synthesize plannerToLabel;
@synthesize workCenterFromLabel;
@synthesize workCenterToLabel;
@synthesize startDateFromLabel;
@synthesize startDateToLabel;
@synthesize endDateFromLabel;
@synthesize endDateToLabel;

@synthesize plannerFrom;
@synthesize plannerTo;
@synthesize workCenterFrom;
@synthesize workCenterTo;
@synthesize startDateFrom;
@synthesize startDateTo;
@synthesize endDateFrom;
@synthesize endDateTo;

@synthesize getOrderButton;

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
    
    if([[self presentingViewController] class] == [SettingsVC class])
    {
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
        
        self.header.topItem.leftBarButtonItem = [cancelButton autorelease];
    }
    
    
    
    self.startDateFrom.delegate = self;
    self.startDateTo.delegate = self;
    self.endDateFrom.delegate = self;
    self.endDateTo.delegate = self;
    
}

-(void)dealloc
{
    [super dealloc];
    
//    RELEASE_TO_NIL(self.plannerFromLabel);
//    RELEASE_TO_NIL(self.plannerToLabel);
//    RELEASE_TO_NIL(self.workCenterFromLabel);
//    RELEASE_TO_NIL(self.workCenterToLabel);
//    RELEASE_TO_NIL(self.startDateFromLabel);
//    RELEASE_TO_NIL(self.startDateToLabel);
//    RELEASE_TO_NIL(self.endDateFromLabel);
//    RELEASE_TO_NIL(self.endDateToLabel);
//    
//    RELEASE_TO_NIL(self.plannerFrom);
//    RELEASE_TO_NIL(self.plannerTo);
//    RELEASE_TO_NIL(self.workCenterFrom);
//    RELEASE_TO_NIL(self.workCenterTo);
//    RELEASE_TO_NIL(self.startDateFrom);
//    RELEASE_TO_NIL(self.startDateTo);
//    RELEASE_TO_NIL(self.endDateFrom);
//    RELEASE_TO_NIL(self.endDateTo);
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
    
   // self.startDateTo.text = [NSDate date];
    
    //self.plannerFrom.text = [[UserProfile getInstance] userId];
   // [self.plannerFrom setEnabled:NO];
    
    //self.plannerTo.text = [[UserProfile getInstance] userId];
   // [self.plannerTo setEnabled:NO];
    
    textFieldSelected = 0;
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}



-(void)onSettingsClick:(id)sender
{
    SettingsVC* settingsScreen = [[SettingsVC alloc] init];
    settingsScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:settingsScreen animated:YES];
    
    [settingsScreen release];
}

-(void)cancelClicked
{
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)onGetOrdersClicked:(id)sender
{
    
    if(![self.plannerFrom.text length])
    {
        [[UserProfile getInstance] setPlannerFrom:@" "];
    }
    else 
    {
        [[UserProfile getInstance] setPlannerFrom:self.plannerFrom.text];
    }
    
    if(![self.plannerTo.text length])
    {
        [[UserProfile getInstance] setPlannerTo:@"ZZZZZZ"];
    }
    else 
    {
        [[UserProfile getInstance] setPlannerTo:self.plannerTo.text];
    }
    
    if(![self.workCenterFrom.text length])
    {
        [[UserProfile getInstance] setWorkCenterFrom:@" "];
    }
    else
    {
         [[UserProfile getInstance] setWorkCenterFrom:self.workCenterFrom.text];
    }
   
    if(![self.workCenterTo.text length])
    {
        [[UserProfile getInstance] setWorkCenterTo:@"ZZZZZZZZZZZZ"];
    }
    else
    {
        [[UserProfile getInstance] setWorkCenterTo:self.workCenterTo.text];
    }
    
    if(![self.startDateFrom.text length])
    {
        [[UserProfile getInstance] setStartDateFrom:@" "];
    }
    else
    {
         [[UserProfile getInstance] setStartDateFrom:self.startDateFrom.text];
    }
    
    if(![self.startDateTo.text length])
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [[UserProfile getInstance] setStartDateTo:[formatter stringFromDate:[NSDate date]]];
        [formatter release];
    }
    else
    {
         [[UserProfile getInstance] setStartDateTo:self.startDateTo.text];
    }
    
    if(![self.endDateFrom.text length])
    {
        [[UserProfile getInstance] setEndDateFrom:@" "];
    }
    else
    {
       [[UserProfile getInstance] setEndDateFrom:self.endDateFrom.text];
    }
    
    if(![self.endDateTo.text length])
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [[UserProfile getInstance] setEndDateTo:[formatter stringFromDate:[NSDate date]]];
        [formatter release];
    }
    else
    {
        [[UserProfile getInstance] setEndDateTo:self.endDateTo.text];
    }
   
    [[UserProfile getInstance] setIsCommitDone:NO];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISREFRESH"];
    
    [self presentModalViewController:self.rootTabController animated:YES];
}

#pragma mark getter method for Tab
- (UITabBarController *)rootTabController {
	if (rootTabController == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"RootTab" owner:self options:nil];
        rootTabController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        rootTabController.modalPresentationStyle = UIModalPresentationFullScreen;
	}    
	return rootTabController;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];

    
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor blackColor];
    
    datePicker=[[UIDatePicker alloc]init];//Date picker
    datePicker.frame=CGRectMake(0,14,320, 250);
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setMinuteInterval:5];
    [datePicker setTag:10];
    [datePicker addTarget:self action:@selector(pickDate:) forControlEvents:UIControlEventValueChanged];
    [popoverView addSubview:datePicker];
    
    popoverContent.view = popoverView;
    UIPopoverController* popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    popoverController.delegate=self;
    [popoverContent release];
    
    [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    //[popoverController presentPopoverFromRect:CGRectMake(218, 362, 280, 80) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    if([textField isEqual:self.startDateFrom])
    {
        textFieldSelected = 1;
        [popoverController presentPopoverFromRect:CGRectMake(218, 362, 280, 60) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES]; 
    }
    else if([textField isEqual:self.startDateTo])
    {
        textFieldSelected = 2;
        [popoverController presentPopoverFromRect:CGRectMake(418, 362, 280, 60) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else if([textField isEqual:self.endDateFrom])
    {
        textFieldSelected = 3;
        [popoverController presentPopoverFromRect:CGRectMake(218, 462, 280, 60) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else if([textField isEqual:self.endDateTo])
    {
        textFieldSelected = 4;
        [popoverController presentPopoverFromRect:CGRectMake(418, 462, 280, 60) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
     
}

-(void)pickDate:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"date picked is %@",[formatter stringFromDate:[datePicker date]]);
    
    if(textFieldSelected == 1)
    {
        [self.startDateFrom setText:[formatter stringFromDate:[datePicker date]]];
    }
    else if(textFieldSelected == 2)
    {
        [self.startDateTo setText:[formatter stringFromDate:[datePicker date]]];
    }
    else if(textFieldSelected == 3)
    {
        [self.endDateFrom setText:[formatter stringFromDate:[datePicker date]]];
    }
    else if(textFieldSelected == 4)
    {
        [self.endDateTo setText:[formatter stringFromDate:[datePicker date]]];
    }
    
    
}

@end
