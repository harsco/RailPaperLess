//
//  Order.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
{
    NSString* orderNumber;
    NSString* item;
    NSString* quantity;
    NSString* pldeliveryDate;
    NSString* startDate;
    NSString* endDate;
    NSString* workcenter;
    NSString* planner;
    NSString* Modifiedon;
    NSString* exceptionCode;
    NSInteger isCommitted;
    NSString* status;
    NSInteger priority;
    
    
    
}


@property(nonatomic,retain)NSString* orderNumber;
@property(nonatomic,retain)NSString* item;
@property(nonatomic,retain)NSString* quantity;
@property(nonatomic,retain)NSString* pldeliveryDate;
@property(nonatomic,retain)NSString* startDate;
@property(nonatomic,retain)NSString* endDate;
@property(nonatomic,retain)NSString* workcenter;
@property(nonatomic,retain)NSString* planner;
@property(nonatomic,retain)NSString* Modifiedon;
@property(nonatomic,retain)NSString* exceptionCode;
@property(nonatomic,retain)NSString* status;
@property(nonatomic)NSInteger priority;
@property(nonatomic)NSInteger isCommitted;




@end
