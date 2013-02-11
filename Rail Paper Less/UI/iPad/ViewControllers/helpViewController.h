//
//  helpViewController.h
//  Rail Paper Less
//
//  Created by SadikAli on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface helpViewController : UIViewController
{
    IBOutlet UIWebView* helpView;
    IBOutlet UINavigationBar* header;
}

@property(nonatomic,retain)UIWebView* helpView;
@property(nonatomic,retain)UINavigationBar* header;

@end
