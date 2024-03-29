//
//  AuthenticationService.h
//  Xenon
//
//  Created by Mahendra on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"
#import "LoginOperation.h"
#import "NetworkInterface.h"
@protocol authenticationServiceDelegate;


@interface AuthenticationService : NSObject<LoginProtocol>
{
    id <authenticationServiceDelegate> delegate;
   
}

@property(nonatomic,retain)id <authenticationServiceDelegate> delegate;


-(void)authenticateUserWithUserName:(NSString*)userName Password:(NSString*)password;

@end


@protocol authenticationServiceDelegate <NSObject>

-(void)signInDidPass;
-(void)signInDidFail:(NSError*)error;

@end