//
//  UserProfile.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile


@synthesize userId;
@synthesize userName;
@synthesize passWord;
@synthesize privilegeLevel;
@synthesize isCommitDone;
@synthesize userFirstName;
@synthesize userLastName;

@synthesize plannerFrom;
@synthesize plannerTo;
@synthesize workCenterFrom;
@synthesize workCenterTo;
@synthesize startDateFrom;
@synthesize startDateTo;
@synthesize endDateFrom;
@synthesize endDateTo;
@synthesize ordersFrom;
@synthesize ordersTo;


+ (UserProfile *)getInstance
{
    static UserProfile* instance;
    @synchronized(self)
    {
        if(!instance)
        {
            instance = [[UserProfile alloc] init];
            
        
        }
    }
    
    
    return instance;
}




@end
