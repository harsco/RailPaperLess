//
//  POXMLParser.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POOrder.h"
#import "PositionData.h"
#import "App_Storage.h"

@protocol POparserDelegate;



@interface POXMLParser : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
   // Order* order;
    NSMutableArray* objectArray;
    
    id<POparserDelegate>delegate;
    
    POOrder* order;
    PositionData* position;
}

@property(nonatomic,retain)id<POparserDelegate>delegate;

-(void)parseWithReceivedData:(NSData*)receivedData;

@end

@protocol POparserDelegate <NSObject>

-(void)didFinishPOParsing;
-(void)didFailPOParsing:(NSString*)error;

@end


