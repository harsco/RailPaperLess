//
//  CWOrder.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWOrder : NSObject
{
    NSString* orderNumber;
    NSString* planner;
    NSString* workcenter;
    NSString* status;
    NSString* item;
    NSString* description;
    NSString* UOM;
    NSString* orderquan;
    NSString* revision;
    NSInteger priority;
    
    NSMutableArray* operationArray;

}

@property(nonatomic,retain)NSString* orderNumber;
@property(nonatomic,retain)NSString* planner;
@property(nonatomic,retain)NSString* workcenter;
@property(nonatomic,retain)NSString* status;
@property(nonatomic,retain)NSString* item;
@property(nonatomic,retain)NSString* description;
@property(nonatomic,retain)NSString* UOM;
@property(nonatomic,retain)NSString* revision;
@property(nonatomic,retain)NSString* orderquan;
@property(nonatomic)NSInteger priority;

@property(nonatomic,retain)NSMutableArray* operationArray;

@end
