//
//  OrderDetailsVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderDetailsVC.h"

@interface OrderDetailsVC ()

@end

@implementation OrderDetailsVC
@synthesize header;
@synthesize orderNumber;
@synthesize item;
@synthesize quantity;
@synthesize prioritizeButton;
@synthesize showDrawingButton;
@synthesize drawingView;


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
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if(!([[[UserProfile getInstance] privilegeLevel] isEqualToString:SUPERUSER] || [[[UserProfile getInstance] privilegeLevel] isEqualToString:@"Planner"]))
    {
        [self.prioritizeButton setEnabled:NO];
        [self.prioritizeButton setHidden:YES];
    }
    else 
    {
//        if(![[UserProfile getInstance] isCommitDone])
//            [self.prioritizeButton setEnabled:YES];
//        else 
//        {
//            [self.prioritizeButton setEnabled:NO];
//        }
        if(![order.status isEqualToString:@"open"])
        {
            [self.prioritizeButton setEnabled:NO];
             [self.prioritizeButton setHidden:YES];
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


-(IBAction)priorityClicked:(id)sender
{
    
    order.priority = [[App_Storage getInstance] getCountOfAllRecords:PRIORITYORDERSDB];
    
    NSMutableArray* temp = [[App_Storage getInstance] getPriorityOrderList];
     NSLog(@"priority is %d",[temp count]);
    
    if([temp count] ==0)
    {
        order.priority = 0;
    }
    else 
    {
        order.priority = [(Order*)[temp lastObject] priority] +1;
    }
    
    //order.exceptionCode = @"";
   
    [[UserProfile getInstance] setIsCommitDone:NO];
    DataSource* dataSource = [[DataSource alloc] init];
    
    [dataSource prioritizeOrder:order];
    
    [dataSource release];
    
    [App_GeneralUtilities showAlertOKWithTitle:@"Success!!!" withMessage:@"Order successfully Prioritized"];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)dePrioritizeClicked:(id)sender
{
    DataSource* dataSource = [[DataSource alloc] init];
    
    if([order.status isEqualToString:@"open"])
    {
        order.Modifiedon = @"N";
    }
    
    [dataSource dePrioritizeOrder:order];
    
    [dataSource release];
    
    [App_GeneralUtilities showAlertOKWithTitle:@"Success!!!" withMessage:@"Order successfully DePrioritized"];
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)showDrawingClicked:(id)sender
{
    //[self listContents];
    
    //[loadingIndicator startAnimating];
    
   // [self showHUD:@"Fetching Drawing"];
    
//    WRRequestDownload * downloadFile = [[WRRequestDownload alloc] init];
//    downloadFile.delegate = self;
    
    //the path needs to be absolute to the FTP root folder.
    //full URL would be ftp://xxx.xxx.xxx.xxx/space.jpg
    //downloadFile.path = @"/space.jpg";
    
    //downloadFile.path =  @"/Harsco_Rail_Signature_RGB_JPEG.jpg";
    
   // downloadFile.path = @"/4000198.GIF";
   // downloadFile.path = @"/test.png";
    
    //for anonymous login just leave the username and password nil
//    downloadFile.hostname = @"ftp.harscotrack.com/OSC/SolidEdge/";
//    downloadFile.username = @"rchinnapangu";
//    downloadFile.password = @"rk123456";
    
//    downloadFile.username = nil;
//   downloadFile.password = nil;
//    
   // downloadFile.hostname = @"ftp://raiuscolwsfp002/";
    
  
    //we start the request
   // [downloadFile start];
    
    //drawingVC* drawScreen = [[drawingVC alloc] initWithImage:[UIImage imageNamed:@"4000198"]];
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSource.delegate = self;
    
    [dataSource fetchDrawingPathForItem:order.item];
    
    //[dataSource release];
    
    

    
//    drawingVC* drawScreen = [[drawingVC alloc] init];
//    
//    [self presentModalViewController:drawScreen animated:YES];
//    
//    [drawScreen release];
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

-(void) requestCompleted:(WRRequest *) request{
    //called after 'request' is completed successfully
    
    [self dismissHUD];
    NSLog(@"%@ completed!", request);
    
//    [loadingIndicator stopAnimating];
//    [loadingIndicator setHidden:YES];
    
    //we cast the request to download request
    WRRequestDownload * downloadFile = (WRRequestDownload *)request;
    
    //we get the image from the data
    UIImage * image = [UIImage imageWithData:downloadFile.receivedData];
    //[self.imageView setImage:image];
    
    drawingVC* drawingScreen = [[drawingVC alloc] initWithImage:image];
    
    [self presentModalViewController:drawingScreen animated:YES];
    
    [drawingScreen release];
}

-(void) requestFailed:(WRRequest *) request{
    //called after 'request' ends in error
    //we can print the error message
    [self dismissHUD];
    NSLog(@"%@", request.error.message);
//    [loadingIndicator stopAnimating];
//    [loadingIndicator setHidden:YES];
}

//-(void) requestCompleted:(WRRequest *) request{
//    
//    //called after 'request' is completed successfully
//    NSLog(@"%@ completed!", request);
//    
//    //we cast the request to list request
//    WRRequestListDirectory * listDir = (WRRequestListDirectory *)request;
//    
//    //we print each of the files name
//    for (NSDictionary * file in listDir.filesInfo) {
//        NSLog(@"%@", [file objectForKey:(id)kCFFTPResourceName]);            
//    }
//    
//}
//
//-(void) requestFailed:(WRRequest *) request{
//    
//    //called if 'request' ends in error
//    //we can print the error message
//    NSLog(@"%@", request.error.message);
//    
//}
//
//
//-(void)listContents
//{
//    
//        
//        //we don't autorelease the object so that it will be around when the callback gets called
//        //this is not a good practice, in real life development you should use a retain property to store a reference to the request
//        WRRequestListDirectory * listDir = [[WRRequestListDirectory alloc] init];
//        listDir.delegate = self;
//        
//        
//        //the path needs to be absolute to the FTP root folder.
//        //if we want to list the root folder we let the path nil or /
//        //full URL would be ftp://xxx.xxx.xxx.xxx/
//        listDir.path = @"/";
//        
//        listDir.hostname = @"raiuscolwsfp002.harsco.com/";
//        listDir.username = @"";
//        listDir.password = @"";
//        
//        
//        [listDir start];
//        
//    
//    
//}

@end
