//
//  XMLParser.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
#import "App_Storage.h"

@protocol parserDelegate;

@interface XMLParser : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
    Order* order;
    NSMutableArray* objectArray;
    
    id<parserDelegate>delegate;
}

@property(nonatomic,retain)id<parserDelegate>delegate;

-(void)parseWithReceivedData:(NSData*)receivedData;

@end

@protocol parserDelegate <NSObject>

-(void)didFinishParsing;
-(void)didFailParsing:(NSString*)error;

@end
