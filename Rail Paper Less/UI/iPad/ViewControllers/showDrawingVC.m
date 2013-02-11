//
//  showDrawingVC.m
//  Rail Paper Less
//
//  Created by Mahi on 10/12/12.
//
//

#import "showDrawingVC.h"

@interface showDrawingVC ()

@end

@implementation showDrawingVC
@synthesize header;
@synthesize drawingView;
@synthesize loadingIndicator;
@synthesize itemNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithDrawingPath:(NSString*)path
{
    if(self = [super init])
    {
        pathForDrawing = [path copy];
        
        NSLog(@"path for drawing is %@",pathForDrawing);
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
    self.header.topItem.title = self.itemNumber;
    
    [self.loadingIndicator setHidden:NO];
    [self.loadingIndicator startAnimating];
    
    self.drawingView.delegate = self;
    
    [self.drawingView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pathForDrawing]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingIndicator stopAnimating];
    [self.loadingIndicator setHidden:YES];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.loadingIndicator stopAnimating];
    [self.loadingIndicator setHidden:YES];
    [App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:@"Unable to Fetch Drawing"];
}

#pragma mark-action methods
#pragma mark - Action Methods
-(void)onHomeClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
