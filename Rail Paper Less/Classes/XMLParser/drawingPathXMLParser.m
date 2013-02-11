//
//  drawingPathXMLParser.m
//  Rail Paper Less
//
//  Created by Mahi on 10/12/12.
//
//

#import "drawingPathXMLParser.h"

@implementation drawingPathXMLParser
@synthesize delegate;


-(void)parseWithReceivedData:(NSData*)receivedData
{
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:receivedData];
    objectArray = [[NSMutableArray alloc] init];
    parser.delegate = self;
    [parser parse];
}





#pragma mark parser callback methods
#pragma mark parser callback methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"showdrawing"])
    {
        //do nothing
        //NSLog(@"value is %@",[attributeDict objectForKey:@"value"]);
        
        
    }
    
   
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
    [delegate didFailParsingDrawingPath:parseError];
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"showdrawing"])
    {
        
        return;
    }
    
    else if([elementName isEqualToString:@"part"])
    {
        NSLog(@"path is %@",currentElementValue);
        item = [[NSString alloc] initWithString:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [currentElementValue release];
        currentElementValue = nil;
    }
   
    else if([elementName isEqualToString:@"partpath"])
    {
        NSLog(@"path is %@",currentElementValue);
        
        [[App_Storage getInstance] storeDrawingPath:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forItem:item];
        
        [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    }
    else
    {
        
        [currentElementValue release];
        currentElementValue = nil;
        
        //NSLog(@"value is %@ and key is %@",currentElementValue,elementName);
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishPOParsing)])
    {
        [delegate didFinishParsingDrawingPath];
    }
}



@end
