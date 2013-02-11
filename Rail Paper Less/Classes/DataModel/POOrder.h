//
//  POOrder.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POOrder : NSObject
{
    NSString* orderNumber;
    NSString* status;
    NSString* workcenter;
    NSString* wcdescription;
    
    NSMutableArray* positionArray;
}


@property(nonatomic,retain)NSString* orderNumber;
@property(nonatomic,retain)NSString* status;
@property(nonatomic,retain)NSString* workcenter;
@property(nonatomic,retain)NSString* wcdescription;

@property(nonatomic,retain)NSMutableArray* positionArray;

@end
