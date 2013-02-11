//
//  OperationsData.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationsData : NSObject
{
    NSInteger operation;
    NSString* task;
    NSString* taskDescription;
    NSString* oPWorkcenter;
    NSString* workcenterdesc;
    NSString* machine;
    NSString* startDate;
    NSString* enddate;
    NSString* productiontime;
    NSString* currentOperation;
    NSString* taskText;
}

@property(nonatomic)NSInteger operation;
@property(nonatomic,retain)NSString* task;
@property(nonatomic,retain)NSString* taskDescription;
@property(nonatomic,retain)NSString* oPWorkcenter;
@property(nonatomic,retain)NSString* workcenterdesc;
@property(nonatomic,retain)NSString* machine;
@property(nonatomic,retain)NSString* startDate;
@property(nonatomic,retain)NSString* enddate;
@property(nonatomic,retain)NSString* productiontime;
@property(nonatomic,retain)NSString* currentOperation;
@property(nonatomic,retain)NSString* taskText;

@end
