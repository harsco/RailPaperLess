//
//  NetworkInterface.h
//  Rail Paper Less
//
//  Created by SadikAli on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkInterface : NSObject
{
    Reachability* reachability;
}


-(BOOL)isWiFiOn;


@end
