//
//  drawingPathXMLParser.h
//  Rail Paper Less
//
//  Created by Mahi on 10/12/12.
//
//

#import <Foundation/Foundation.h>
#import "App_Storage.h"

@protocol drawingParserDelegate;

@interface drawingPathXMLParser : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
    NSMutableArray* objectArray;
    
    NSString* item;
    
     id<drawingParserDelegate>delegate;
}


@property(nonatomic,retain)id<drawingParserDelegate>delegate;

-(void)parseWithReceivedData:(NSData*)receivedData;

@end


@protocol drawingParserDelegate <NSObject>

-(void)didFinishParsingDrawingPath;
-(void)didFailParsingDrawingPath:(NSError*)error;

@end