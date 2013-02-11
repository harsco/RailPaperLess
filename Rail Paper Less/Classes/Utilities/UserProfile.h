//
//  UserProfile.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject
{
    NSString* userName;
    NSString* passWord;
    NSString* userId;
    NSString* userFirstName;
    NSString* userLastName;
    
    NSString* privilegeLevel;
    
    BOOL isCommitDone;
    
    NSString* plannerFrom;
    NSString* plannerTo;
    NSString* workCenterFrom;
    NSString* workCenterTo;
    NSString* startDateFrom;
    NSString* startDateTo;
    NSString* endDateFrom;
    NSString* endDateTo;
    
    NSString* ordersFrom;
    NSString* ordersTo;
    
}


@property(nonatomic,retain)NSString* userName;
@property(nonatomic,retain)NSString* passWord;
@property(nonatomic,retain)NSString* userId;
@property(nonatomic,retain)NSString* userFirstName;
@property(nonatomic,retain)NSString* userLastName;
@property(nonatomic,retain)NSString* privilegeLevel;
@property(nonatomic)BOOL isCommitDone;

@property(nonatomic,retain)NSString* plannerFrom;
@property(nonatomic,retain)NSString* plannerTo;
@property(nonatomic,retain)NSString* workCenterFrom;
@property(nonatomic,retain)NSString* workCenterTo;
@property(nonatomic,retain)NSString* startDateFrom;
@property(nonatomic,retain)NSString* startDateTo;
@property(nonatomic,retain)NSString* endDateFrom;
@property(nonatomic,retain)NSString* endDateTo;
@property(nonatomic,retain)NSString* ordersFrom;

@property(nonatomic,retain)NSString* ordersTo;



+ (UserProfile *)getInstance;


@end
