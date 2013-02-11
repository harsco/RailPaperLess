//
//  LoginParser.m
//  Rail Paper Less
//
//  Created by SadikAli on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginParser.h"

@implementation LoginParser
@synthesize delegate;

-(void)parseWithReceivedData:(NSData*)receivedData
{
    
    NSLog(@"received data is %s",[receivedData bytes]);
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:receivedData];
    objectArray = [[NSMutableArray alloc] init];
    parser.delegate = self;
    [parser parse];
}



#pragma mark parser callback methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"loginstatus"])
    {
        //do nothing
         //NSLog(@"value is %@",[attributeDict objectForKey:@"value"]);
    }
    
    else if([elementName isEqualToString:@"statuscode"]) {
        //Initialize the array.
      //  NSLog(@"found order %@", [attributeDict objectForKey:@"value"]);
        // NSLog(@"value is %@",[attributeDict objectForKey:@"value"]);
        //NSLog(@"value is %@",[attributeDict objectForKey:@"Item"]);
        
       // order = [[Order alloc] init];
        //order.orderNumber = [attributeDict objectForKey:@"value"];
        
       
        
        
    }
    
    
    //NSLog(@"processing element %@",elementName);
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
    
   // NSLog(@"Processing Value: %@", currentElementValue);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    NSLog(@"error due to %@",[parseError localizedDescription]);
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    if([elementName isEqualToString:@"Open_Orders"]) 
//    {
//		NSLog(@"count of objects is %d",[objectArray count]);
//        for(int i=0;i<[objectArray count];i++)
//        {
//            NSLog(@"order no is %@",[[objectArray objectAtIndex:i] orderNumber]);
//            NSLog(@"item is %@",[[objectArray objectAtIndex:i] item]);
//            NSLog(@"workcenter is %@",[[objectArray objectAtIndex:i] workcenter]);
//            
//        }
//        [[App_Storage getInstance] storeOrderList:objectArray];
//        return;
//	}
    
    if([elementName isEqualToString:@"loginstatus"])
    {
        
        
        return;
    }
    
    if([elementName isEqualToString:@"statuscode"])
    {
        NSLog(@"code Yes");
        //NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
        
        statusCode = [currentElementValue intValue];
        //NSLog(@"value of status code is %d",statusCode);
        [delegate parsingDidFinish:statusCode];
        
    }
    else if([elementName isEqualToString:@"firstname"])
    {
        [[UserProfile getInstance] setUserFirstName:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [currentElementValue release];
        currentElementValue = nil;
    }
    else if([elementName isEqualToString:@"lastname"])
    {
        [[UserProfile getInstance] setUserLastName:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [currentElementValue release];
        currentElementValue = nil;
    }
    else if([elementName isEqualToString:@"user"])
    {
        [[UserProfile getInstance] setUserId:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [currentElementValue release];
        currentElementValue = nil;
        
        
    }
    else if([elementName isEqualToString:@"role"])
    {
        [[UserProfile getInstance] setPrivilegeLevel:[currentElementValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [currentElementValue release];
        currentElementValue = nil;
    }
    else
    {
        //        [order setValue:currentElementValue forKey:elementName];
        //        // NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
        [currentElementValue release];
        currentElementValue = nil;
        
        //NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
    }

    
    
    if([elementName isEqualToString:@"status"])
    {
        return;
    }
    
    
   // NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
    
    
}


@end
