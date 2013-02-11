//
//  NetwrokErrorVC.m
//  Rail Paper Less
//
//  Created by SadikAli on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetwrokErrorVC.h"

@interface NetwrokErrorVC ()

@end

@implementation NetwrokErrorVC

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


-(IBAction)onExitClicked:(id)sender;
{
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
    exit(0);
}

@end
