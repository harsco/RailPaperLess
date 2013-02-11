//
//  App_GeneralUtilities.m
//  Xenon
//
//  Created by Mahendra on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "App_GeneralUtilities.h"

@implementation App_GeneralUtilities

@synthesize isHomeClicked;
//@synthesize reachability;

//singleton Instance
+ (App_GeneralUtilities *)getInstance
{
    static App_GeneralUtilities* instance;
    @synchronized(self)
    {
        if(!instance)
        {
            instance = [[App_GeneralUtilities alloc] init];
        }
    }
    
    
    
        return instance;
}



+(void)showAlertOKWithTitle:(NSString*)title withMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}




@end
