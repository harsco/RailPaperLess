//
//  XMLParser.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

@synthesize delegate;


-(void)parseWithReceivedData:(NSData*)receivedData
{
    
   // NSLog(@"parser data is %s",[receivedData bytes]);
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:receivedData];
    objectArray = [[NSMutableArray alloc] init];
    parser.delegate = self;
    [parser parse];
}


#pragma mark parser callback methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    
    if([elementName isEqualToString:@"Open_Orders"])
    {
        //do nothing
    }
    
    else if([elementName isEqualToString:@"Order"]) {
        //Initialize the array.
       // NSLog(@"found order");
       // NSLog(@"value is %@",[attributeDict objectForKey:@"value"]);
        //NSLog(@"value is %@",[attributeDict objectForKey:@"Item"]);
        
        order = [[Order alloc] init];
        order.orderNumber = [attributeDict objectForKey:@"value"];
        
       
    }
    
    
    //NSLog(@"processing element %@",elementName);
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
    
    //NSLog(@"Processing Value: %@", currentElementValue);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailParsing::)])
    {
        [delegate didFailParsing:[parseError localizedDescription]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"Open_Orders"]) 
    {
		NSLog(@"count of objects is %d",[objectArray count]);
//        for(int i=0;i<[objectArray count];i++)
//        {
//            //NSLog(@"order no is %@",[[objectArray objectAtIndex:i] orderNumber]);
//             //NSLog(@"item is %@",[[objectArray objectAtIndex:i] item]);
//             //NSLog(@"workcenter is %@",[[objectArray objectAtIndex:i] workcenter]);
//            
//        }
        [[App_Storage getInstance] storeOrderList:objectArray];
        return;
	}
    if([elementName isEqualToString:@"username"])
    {
        return;
    }
    if([elementName isEqualToString:@"user"])
    {
        return;
    }
    
//    if([elementName isEqualToString:@"Priority"])
//    {
//        return;
//    }
    
    if([elementName isEqualToString:@"Order"])
    {
        [objectArray addObject:order];
        [order release];
        order = nil;
    }
    else
    {
        [order setValue:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:elementName];
       // NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
        [currentElementValue release];
        currentElementValue = nil;
    }
	
  
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishParsing)])
    {
        [delegate didFinishParsing];
    }
}

@end
