//
//  DataDownloadOperation.h
//  Rail Paper Less
//
//  Created by SadikAli on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@protocol dataDownloadOperationDelegate;



@interface DataDownloadOperation : NSOperation<NSURLConnectionDelegate>
{
    BOOL executing_;
    BOOL finished_;
    
    // The actual NSURLConnection management
    NSURL*    connectionURL;
    NSURLConnection*  connection;
    NSMutableData*    receivedData;
    
    id <dataDownloadOperationDelegate> delegate;
    
    NSString* postData;
}

@property(nonatomic,retain)id<dataDownloadOperationDelegate>delegate;
@property(nonatomic,retain)NSString* postData;
- (id)initWithURL:(NSURL*)url;

@end


@protocol dataDownloadOperationDelegate <NSObject>

-(void)didDownloadData:(NSData*)downloadedData;
-(void)didFailDownloadData:(NSError*)error;

@end