//
//  NetworkInterface.m
//  Rail Paper Less
//
//  Created by SadikAli on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkInterface.h"

@implementation NetworkInterface



-(BOOL)isWiFiOn
{
    reachability = [[Reachability reachabilityForLocalWiFi] retain];
    
    if([reachability currentReachabilityStatus] == ReachableViaWiFi)
    {
        return YES;
    }
    
    return NO;
}

@end
