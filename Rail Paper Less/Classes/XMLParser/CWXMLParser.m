//
//  CWXMLParser.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CWXMLParser.h"

@implementation CWXMLParser

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
    
    
    if([elementName isEqualToString:@"Prioritized_Orders"])
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
        
        order = [[CWOrder alloc] init];
        order.orderNumber = [attributeDict objectForKey:@"value"];
        order.operationArray = [[NSMutableArray alloc] init];
        
        
    }
    
    else if([elementName isEqualToString:@"Operation"])
    {
        operation = [[OperationsData alloc] init];
        operation.operation = [[attributeDict objectForKey:@"value"] intValue];
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
        [delegate didFailCWParsing:[parseError localizedDescription]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"Prioritized_Orders"]) 
    {
		NSLog(@"count of objects is %d",[objectArray count]);
        //        for(int i=0;i<[objectArray count];i++)
        //        {
        //            NSLog(@"order no is %@",[[objectArray objectAtIndex:i] orderNumber]);
        //            NSLog(@"item is %@",[[objectArray objectAtIndex:i] item]);
        //            NSLog(@"workcenter is %@",[[objectArray objectAtIndex:i] workcenter]);
        //            
        //        }
        // NSLog(@"count is %d",[[[objectArray objectAtIndex:0] positionArray] count]);
        
        [[App_Storage getInstance] storeCWOrderList:objectArray];
        
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
    else if([elementName isEqualToString:@"Priority"])
    {
        order.priority = [[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        
        [currentElementValue release];
        currentElementValue = nil;
        
    }
    
    else if([elementName isEqualToString:@"Status"]||[elementName isEqualToString:@"Workcenter"]||[elementName isEqualToString:@"Planner"]||[elementName isEqualToString:@"Item"]||[elementName isEqualToString:@"Description"]||[elementName isEqualToString:@"Orderquan"]||[elementName isEqualToString:@"UOM"]||[elementName isEqualToString:@"Revision"])
    {
        [order setValue:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:elementName];
         NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
        
        [currentElementValue release];
        currentElementValue = nil;
        return;
        
    }
//    else if([elementName isEqualToString:@"TaskText"])
//    {
//        [order setValue:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:elementName];
//        NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
//        
//        [currentElementValue release];
//        currentElementValue = nil;
//        return;
//
//    }
    
    
    else if([elementName isEqualToString:@"Order"])
    {
        [objectArray addObject:order];
        [order release];
        order = nil;
        return;
    }
    else if([elementName isEqualToString:@"Operation"])
    {
        [order.operationArray addObject:operation];
        
        
        // NSLog(@"count is %d",[order.positionArray count]);
        [operation release];
        operation = nil;
        
        [currentElementValue release];
        currentElementValue = nil;
        return;
    }
    
    
    
    else
    {
        
        if([elementName isEqualToString:@"TaskText"])
        {
            [operation setValue:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName];
        }
        else 
        {
             [operation setValue:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:elementName];
        }
              
       
        NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
        [currentElementValue release];
        currentElementValue = nil;
        
    }
	
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPOParsing)])
    {
        [delegate didFinishCWParsing];
    }
}



@end
