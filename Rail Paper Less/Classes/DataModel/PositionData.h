//
//  PositionData.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionData : NSObject
{
    NSString* positionNumber;
    NSString* item;
    NSString* description;
    NSString* UOM;
    NSString* pickLocation;
    NSString* pickqty;
    NSString* pickedLocation;
    NSString* pickedqty;
    
}

@property(nonatomic,retain)NSString* positionNumber;
@property(nonatomic,retain)NSString* item;
@property(nonatomic,retain)NSString* description;
@property(nonatomic,retain)NSString* UOM;
@property(nonatomic,retain)NSString* pickLocation;
@property(nonatomic,retain)NSString* pickqty;
@property(nonatomic,retain)NSString* pickedLocation;
@property(nonatomic,retain)NSString* pickedqty;

@end
