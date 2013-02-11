//
//  App_GeneralUtilities.h
//  Xenon
//
//  Created by Mahendra on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface App_GeneralUtilities : NSObject
{
    BOOL isHomeClicked;
    
    
}


@property(nonatomic)BOOL isHomeClicked;
//@property(nonatomic,retain)Reachability* reachability;

+ (App_GeneralUtilities *)getInstance;
+(void)showAlertOKWithTitle:(NSString*)title withMessage:(NSString*)message;



@end
