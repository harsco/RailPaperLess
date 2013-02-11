//
//  CWXMLParser.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWOrder.h"
#import "OperationsData.h"
#import "App_Storage.h"

@protocol CWparserDelegate;

@interface CWXMLParser :  NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
    NSMutableArray* objectArray;
    
    id<CWparserDelegate>delegate;
    
    CWOrder* order;
    OperationsData* operation;
}


@property(nonatomic,retain)id<CWparserDelegate>delegate;

-(void)parseWithReceivedData:(NSData*)receivedData;

@end

@protocol CWparserDelegate <NSObject>

-(void)didFinishCWParsing;
-(void)didFailCWParsing:(NSString*)error;

@end




