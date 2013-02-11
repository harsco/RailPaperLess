//
//  LoginOperation.h
//  Rail Paper Less
//
//  Created by SadikAli on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginParser.h"

@protocol LoginProtocol ;



@interface LoginOperation :NSOperation<NSURLConnectionDelegate,loginParser>
{
    BOOL executing_;
    BOOL finished_;
    
    BOOL isResponseReceived;
    
    // The actual NSURLConnection management
    NSURL*    connectionURL;
    NSURLConnection*  connection;
    NSMutableData*    receivedData;
    NSInteger operationType;
    
    
    NSString* userName;
    NSString* passWord;
    
    id<LoginProtocol>delegate;
}


@property(nonatomic)NSInteger operationType;
@property(nonatomic,retain)id<LoginProtocol>delegate;

- (id)initWithUsername:(NSString*)uname Password:(NSString*)pwd;

@end


@protocol LoginProtocol <NSObject>

-(void)loginSuccess;
-(void)loginFailed:(NSString*)error;

@end
