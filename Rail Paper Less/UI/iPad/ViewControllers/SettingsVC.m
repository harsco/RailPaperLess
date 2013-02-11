//
//  SettingsVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC
@synthesize header;
@synthesize switchUserButton;
@synthesize logOutButton;
@synthesize prioritizeOrdersButton;
@synthesize pickAndConfirmButton;
@synthesize completeOperationsButton;
@synthesize switchAlert;
@synthesize helpButton;

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
    UIImage* image = [UIImage imageNamed:@"app_btn_back"];
    CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onHomeClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    self.completeOperationsButton.backgroundColor = [UIColor orangeColor];
    
    UIBarButtonItem *backButton =[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    self.header.topItem.leftBarButtonItem = backButton;
    
    if([[[UserProfile getInstance] privilegeLevel] isEqualToString:SUPERUSER])
    {
        //[self.fetchOrdersButton setEnabled:YES];
        //[self.fetchPCOrders setEnabled:NO];
        //[self.fetchPCOrders setHidden:YES];
    }
    else if([[[UserProfile getInstance] privilegeLevel] isEqualToString:MATERIALHANDLER])
    {
        [self.prioritizeOrdersButton setHidden:YES];
        [self.completeOperationsButton setHidden:YES];
    }
    else if([[[UserProfile getInstance] privilegeLevel] isEqualToString:CELLWORKER])
    {
        [self.prioritizeOrdersButton setHidden:YES];
        [self.pickAndConfirmButton setHidden:YES];
    }
    else if([[[UserProfile getInstance] privilegeLevel] isEqualToString:@"Planner"])
    {
        [self.pickAndConfirmButton setHidden:YES];
        [self.completeOperationsButton setHidden:YES];
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


-(IBAction)onSwitchUserClicked:(id)sender
{
    
     switchAlert = [[UIAlertView alloc] initWithTitle:@"Switch user Alert!!" message:@"Are You Sure You Want To Switch The User?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    
    switchAlert.delegate = self;
    
    [switchAlert show];
    [switchAlert release];
    
    
}

-(IBAction)prioritizeOrdersClicked:(id)sender
{
    inputParamVC* inputsVC = [[inputParamVC alloc] init];
    
    [self presentModalViewController:inputsVC animated:YES];
    
    [inputsVC release];
}

-(IBAction)onPickAndConfirmClicked:(id)sender
{
    
    userInputVC* inputsVC = [[userInputVC alloc] init];
    
    [self presentModalViewController:inputsVC animated:YES];
    
    [inputsVC release];
}

-(IBAction)onCompleteOperationsClicked:(id)sender
{
    userInputCWVC* inputsVC = [[userInputCWVC alloc] init];
    
    [self presentModalViewController:inputsVC animated:YES];
    
    [inputsVC release];
}

-(IBAction)onHelpClicked:(id)sender
{
//    helpViewController* helpVC = [[helpViewController alloc] init];
//    [self presentModalViewController:helpVC animated:YES];
//    [helpVC release];
    
    /*NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    
    UIDocumentInteractionController* docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
    
    
    docController.delegate = self;
    
    [docController retain];
    
    
    BOOL isValid = [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];*/
    
    /** Set document name */
    
    NSString *documentName = @"help";
    
    /** Get temporary directory to save thumbnails */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    /** Set thumbnails path */
    NSString *thumbnailsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",documentName]];
    
    /** Get document from the App Bundle */
    NSURL *documentUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:documentName ofType:@"pdf"]];
    
    /** Instancing the documentManager */
    MFDocumentManager *documentManager = [[MFDocumentManager alloc]initWithFileUrl:documentUrl];
    
    /** Instancing the readerViewController */
    ReaderViewController *pdfViewController = [[ReaderViewController alloc]initWithDocumentManager:documentManager];
    
    /** Set resources folder on the manager */
    documentManager.resourceFolder = thumbnailsPath;
    
    /** Set document id for thumbnail generation */
    pdfViewController.documentId = documentName;
    
    /** Present the pdf on screen in a modal view */
    [self presentModalViewController:pdfViewController animated:YES]; 
    
    /** Release the pdf controller*/
    [pdfViewController release];
}

-(IBAction)onLogoutClicked:(id)sender
{
    //exit(0);
    UIAlertView* exitAlert = [[UIAlertView alloc] initWithTitle:@"Exit Alert!!" message:@"Are You Sure You Want To Exit The App" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    
    exitAlert.delegate = self;
    
    [exitAlert show];
    [exitAlert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView isKindOfClass:[switchAlert class]])
    {
        if(buttonIndex == 1)
        {
            LoginVC* loginScreen = [[LoginVC alloc] init];
            [self presentModalViewController:loginScreen animated:YES];
            
            [loginScreen release];
        }
    }
    
    else 
    {
        if(buttonIndex == 1)
        {
            exit(0);
        }
    }
        
    
}


#pragma mark-action methods
#pragma mark - Action Methods
-(void)onHomeClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
