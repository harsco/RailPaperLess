//
//  AuthenticationService.m
//  Xenon
//
//  Created by Mahendra on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthenticationService.h"

@interface AuthenticationService ()
{

    NSString* UNAME;
    NSString* PWD;
}
@end

@implementation AuthenticationService
@synthesize delegate;

-(id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

-(void)dealloc
{
   
    RELEASE_TO_NIL(delegate);
    RELEASE_TO_NIL(UNAME);
    RELEASE_TO_NIL(PWD);
    [super dealloc];
}


-(void)authenticateUserWithUserName:(NSString*)userName Password:(NSString*)password
{
    
    NSLog(@"Username is %@",userName);
    NSLog(@"passWordField is %@",password);
    
    NetworkInterface* interface = [[NetworkInterface alloc] init];
    
    if([interface isWiFiOn])
    {
    
        UNAME = [[NSString alloc] initWithString:userName];
        PWD = [[NSString alloc] initWithString:password];
        
        NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
        [testQueue setMaxConcurrentOperationCount:1];
        
        LoginOperation* loginOp = [[LoginOperation alloc] initWithUsername:UNAME Password:PWD];
        loginOp.delegate = self;
        
        
       // DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:@"http://RAIINHYDLT00002.harsco.com:8080/Sendorders/"]];
        
       // downloaderOp.delegate = self;
        
        //downloaderOp.operationType = IND;
        [testQueue addOperation:loginOp];
        
        [loginOp release];
    }
    else 
    {
        //[App_GeneralUtilities showAlertOKWithTitle:@"Network Error!!" withMessage:@"No Network Connection!!"];
         NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
         [self.delegate signInDidFail:[errorStatement autorelease]];
    }

    
  //  [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(sendAuthResponse) userInfo:nil repeats:NO];
    
    [interface release];
           
}


-(void)loginFailed:(NSString *)error
{
    //show error;
    
    NSLog(@"error");
    if(self.delegate && [self.delegate respondsToSelector:@selector(signInDidFail:)])
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:error forKey:NSLocalizedDescriptionKey]];
        
        
        [self.delegate signInDidFail:[errorStatement autorelease]];
        
        
    }

}

-(void)loginSuccess
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(signInDidPass)])
    {
        [self.delegate signInDidPass];
    }
}

@end
