//
//  POXMLParser.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "POXMLParser.h"

@implementation POXMLParser
@synthesize delegate;


-(void)parseWithReceivedData:(NSData*)receivedData
{
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:receivedData];
    objectArray = [[NSMutableArray alloc] init];
    parser.delegate = self;
    [parser parse];
}


#pragma mark parser callback methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    
    if([elementName isEqualToString:@"Prioritize_Orders"])
    {
        //do nothing
        //return;
    }
    
    else if([elementName isEqualToString:@"Order"]) {
        //Initialize the array.
       // NSLog(@"found order");
        // NSLog(@"value is %@",[attributeDict objectForKey:@"value"]);
        //NSLog(@"value is %@",[attributeDict objectForKey:@"Item"]);
        
        //order = [[Order alloc] init];
       // order.orderNumber = [attributeDict objectForKey:@"value"];
        
        order = [[POOrder alloc] init];
        order.orderNumber = [attributeDict objectForKey:@"value"];
        order.positionArray = [[NSMutableArray alloc] init];
        
        
    }
    
    else if([elementName isEqualToString:@"Position"])
    {
        position = [[PositionData alloc] init];
        position.positionNumber = [attributeDict objectForKey:@"value"];
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
    
    NSLog(@"error is %@",[parseError localizedDescription]);
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailPOParsing::)])
    {
        [delegate didFailPOParsing:[parseError localizedDescription]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"Prioritize_Orders"]) 
    {
		NSLog(@"count of objects is %d",[objectArray count]);
//        for(int i=0;i<[objectArray count];i++)
//        {
//            NSLog(@"order no is %@",[[objectArray objectAtIndex:i] orderNumber]);
//           NSLog(@"item is %@",[[objectArray objectAtIndex:i] item]);
//            NSLog(@"workcenter is %@",[[objectArray objectAtIndex:i] workcenter]);
//            
//        }
       // NSLog(@"count is %d",[[[objectArray objectAtIndex:0] positionArray] count]);
        
        [[App_Storage getInstance] storePCOrderList:objectArray];
        return;
	}
    else if([elementName isEqualToString:@"username"])
    {
        return;
    }
    else if([elementName isEqualToString:@"user"])
    {
        return;
    }
    
    else if([elementName isEqualToString:@"Status"]||[elementName isEqualToString:@"Workcenter"]||[elementName isEqualToString:@"Wcdescription"])
    {
        //[order setValue:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:elementName];
        
        // [order stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [order setValue:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName];
       // NSLog(@"value is %@ and key is %@",currentElementValue,elementName);

        [currentElementValue release];
        currentElementValue = nil;
        return;
        
    }
    
      
    else if([elementName isEqualToString:@"Order"])
    {
        [objectArray addObject:order];
        [order release];
        order = nil;
        return;
    }
    else if([elementName isEqualToString:@"Position"])
    {
        [order.positionArray addObject:position];
                
        
        // NSLog(@"count is %d",[order.positionArray count]);
        [position release];
        position = nil;
        
        [currentElementValue release];
        currentElementValue = nil;
        return;
    }
    
    
    
    else
    {
        [position setValue:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:elementName];
         //NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
        [currentElementValue release];
        currentElementValue = nil;
        
    }
	
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPOParsing)])
    {
        [delegate didFinishPOParsing];
    }
}


@end
