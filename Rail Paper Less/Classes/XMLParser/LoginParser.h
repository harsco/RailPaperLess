//
//  LoginParser.h
//  Rail Paper Less
//
//  Created by SadikAli on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"
@protocol loginParser;

@interface LoginParser : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
    NSMutableArray* objectArray;
    
    NSInteger statusCode;
    
    id <loginParser> delegate;
}


@property(nonatomic,retain)id<loginParser>delegate;
-(void)parseWithReceivedData:(NSData*)receivedData;



@end


@protocol loginParser <NSObject>

-(void)parsingDidFinish:(NSInteger)statusCode;
-(void)parsingDidFail;

@end
