//
//  LoginOperation.m
//  Rail Paper Less
//
//  Created by SadikAli on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginOperation.h"

@implementation LoginOperation

//@synthesize delegate;
@synthesize operationType;
@synthesize delegate;




- (id)initWithUsername:(NSString*)uname Password:(NSString*)pwd
{
    if(self = [super init])
    {
        userName = [[NSString alloc] initWithString:uname];
        passWord = [[NSString alloc] initWithString:pwd];
        receivedData = [[NSMutableData alloc] init];
    }
    
    return self;
}



-(void)dealloc
{
    [super dealloc];
    
    [receivedData release];
}

-(void)start
{
    if( finished_ || [self isCancelled] ) { //[self done]; 
        return; }
    
    [self performSelectorOnMainThread:@selector(initiateNetworkConnection) withObject:nil waitUntilDone:NO];
    
    
}


-(void)initiateNetworkConnection
{
    
   // NSString* temp = [[NSString alloc] initWithString:@"<?xml version='1.0' encoding='UTF-8'?><user id='57020'><username value='KATHLEEN HARBIN'><Open_Orders><Order value='470018835'><Item>57395-UA</Item><Quantity>10</Quantity><PldeliveryDate>2010-04-01</PldeliveryDate><StartDate>2010-03-03</StartDate><EndDate>2010-03-09</EndDate><Workcenter>1000</Workcenter><Planner>54001</Planner></Order><Order value='470018835'><Item>57395-UA</Item><Quantity>10</Quantity><PldeliveryDate>2010-04-01</PldeliveryDate><StartDate>2010-03-03</StartDate><EndDate>2010-03-09</EndDate><Workcenter>1000</Workcenter><Planner>54001</Planner></Order></Open_Orders></username></user>"];
    
    NSString* postXML = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><login><user>",userName,@"</user><userpwd>",passWord,@"</userpwd></login>"];
    
    NSLog(@"post XML is %@",postXML);
    
    
   /* NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://RAIINHYDLT00002.harsco.com:8080/Logindetails/"]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
													   timeoutInterval:60];*/
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://10.30.28.14:8080/Logindetails/"]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
													   timeoutInterval:30];
    

    
    NSString* requestDataLengthString = [NSString stringWithFormat:@"%d", [postXML length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];		
    [request setHTTPBody:[postXML dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    isResponseReceived = NO;
    
     [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(checkTimeOut) userInfo:nil repeats:NO];
    
    RELEASE_TO_NIL(postXML);
}


-(void)finish
{
    //[parser parseDataofIndustry:self.operationType withData:receivedData];
    
    NSString* temp = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
  //  NSLog(@"modified string is %@", [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
    
 //   NSLog(@"data is %@",temp);
    
//    NSRange start = [temp rangeOfString:@"e>"];
//    NSRange end = [temp rangeOfString:@"</s"];
//    //[myVar setName:[_contentsOfElement substringWithRange:NSMakeRange(start.location, end.location)]];
//    
//    NSLog(@"string is %@",[temp substringWithRange:NSMakeRange(start.location, end.location)]);
    
    LoginParser* parser = [[LoginParser alloc] init];
    parser.delegate = self;
    
    NSData* tempData = [[NSData alloc] initWithData:[[temp stringByReplacingOccurrencesOfString:@"\n" withString:@""] dataUsingEncoding:NSASCIIStringEncoding]];
    
    //[[parser parseWithReceivedData:[NSData alloc] initWithData:[temp stringByReplacingOccurrencesOfString:@"\n" withString:@""] dataUdi ]];
    
    [parser parseWithReceivedData:tempData];
    
    
}


-(void)checkTimeOut
{
    if(!isResponseReceived)
    {
        [connection cancel];
        [connection release];
        [delegate loginFailed:@"Server Not Responding!! Please Try after Sometime"];
    }
}




#pragma mark network Call backs

#pragma mark NSURL
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [receivedData setLength:0];
    isResponseReceived = YES;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"data bytes is %s",[data bytes]);
    [receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[connection release];
    [delegate loginFailed:@"Server Timed Out"];
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


#pragma mark Parser Call Backs
-(void)parsingDidFinish:(NSInteger)statusCode
{
    if(statusCode == 100)
    {
        [delegate loginSuccess];
    }
    else if(statusCode == 200)
    {
        [delegate loginFailed:@"Incorrect Password"];
    }
    else if(statusCode == 300)
    {
        [delegate loginFailed:@"Invalid Username"];
    }
    else if(statusCode == 400)
    {
        [delegate loginFailed:@"Unable to connect to Data Base"];
    }
    
}

-(void)parsingDidFail
{
    //show error
}



@end
