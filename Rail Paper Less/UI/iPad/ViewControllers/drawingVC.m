//
//  drawingVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "drawingVC.h"

@interface drawingVC ()

@end

@implementation drawingVC

@synthesize imageScrollView;
@synthesize drawingView;
@synthesize header;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrderNumber:(NSString*)orderNumber
{
    if(self = [super init])
    {
        ordernumber = [[NSString alloc] initWithString:orderNumber];
    }
    
    return self;
}

-(id)initWithImage:(UIImage*)image
{
    if(self = [super init])
    {
        imageForDrawing = image;
        
        [self.drawingView setImage:image];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    //[self.drawingView setImage:imageForDrawing];
    self.imageScrollView.contentSize = self.drawingView.bounds.size;
    
    UIImage* image = [UIImage imageNamed:@"app_btn_back"];
    CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onHomeClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *backButton =[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    self.header.topItem.leftBarButtonItem = backButton;
    
    NSLog(@"orderNumber is %@",ordernumber);
    //self.drawingView.image = [UIImage imageNamed:ordernumber];
    
   // [self.drawingView setImage:[UIImage imageNamed:ordernumber]];
    
    //[self.drawingView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",ordernumber,@".gif"]]];
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



-(UIView *) viewForZoomingInScrollView:(UIScrollView *)inScroll {
    return self.drawingView;
}

#pragma mark-action methods
#pragma mark - Action Methods
-(void)onHomeClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
