//
//  DataDownloadOperation.m
//  Rail Paper Less
//
//  Created by SadikAli on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataDownloadOperation.h"

@implementation DataDownloadOperation
@synthesize delegate;
@synthesize postData;


- (id)initWithURL:(NSURL *)url
{
    if( (self = [super init]) ) {
        connectionURL = [url copy];
        receivedData = [[NSMutableData alloc] init];
        
      
        //NSLog(@"URL is %@",connectionURL);
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    
    [receivedData release];
    [self.postData release];
}

-(void)start
{
    if( finished_ || [self isCancelled] ) { //[self done]; 
        return; }
    
    [self performSelectorOnMainThread:@selector(initiateNetworkConnection) withObject:nil waitUntilDone:NO];
    
    
}



-(void)initiateNetworkConnection
{
    
 //   NSString* temp = [[NSString alloc] initWithString:@"<?xml version='1.0' encoding='UTF-8'?><user id='57020'><username value='KATHLEEN HARBIN'><Open_Orders><Order value='470018835'><Item>57395-UA</Item><Quantity>10</Quantity><PldeliveryDate>2010-04-01</PldeliveryDate><StartDate>2010-03-03</StartDate><EndDate>2010-03-09</EndDate><Workcenter>1000</Workcenter><Planner>54001</Planner></Order><Order value='470018835'><Item>57395-UA</Item><Quantity>10</Quantity><PldeliveryDate>2010-04-01</PldeliveryDate><StartDate>2010-03-03</StartDate><EndDate>2010-03-09</EndDate><Workcenter>1000</Workcenter><Planner>54001</Planner></Order></Open_Orders></username></user>"];
    
    
  //  NSString* temp = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><Getorders><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><Plannerfrom>",[[UserProfile getInstance] plannerFrom],@"</Plannerfrom><Plannerto>",[[UserProfile getInstance] plannerTo],@"</Plannerto><Workcenterfrom>",[[UserProfile getInstance] workCenterFrom],@"</Workcenterfrom><Workcenterto>",[[UserProfile getInstance] workCenterTo],@"</Workcenterto><Startdatefrom>",[[UserProfile getInstance] startDateFrom],@"</Startdatefrom><Startdateto>",[[UserProfile getInstance] startDateTo],@"</Startdateto><Enddatefrom>",[[UserProfile getInstance] endDateFrom],@"</Enddatefrom><Enddateto>",[[UserProfile getInstance] endDateTo],@"</Enddateto></Getorders>"];
    
    NSLog(@"temp is %@",self.postData);
                      
    
   // NSString* temp = [NSString stringWithFormat:@"%@",@"<?xml version='1.0' encoding='UTF-8'?><Getorders><user>"];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:connectionURL
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
													   timeoutInterval:60];
    
    NSString* requestDataLengthString = [NSString stringWithFormat:@"%d", [self.postData length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];		
    [request setHTTPBody:[self.postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


-(void)finish
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didDownloadData:)])
    {
        [delegate didDownloadData:receivedData];
    }
}


#pragma mark network Call backs

#pragma mark NSURL
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"data bytes is %s",[data bytes]);
    [receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[connection release];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailDownloadData:)])
    {
        [delegate didFailDownloadData:error];
    }
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[connection release];
    //[self movieReceived];
    NSLog(@"data is %s",[receivedData bytes]);
    
    [self finish];
    
}



@end
