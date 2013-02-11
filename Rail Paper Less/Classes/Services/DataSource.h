//
//  DataSource.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App_Storage.h"
#import "XMLParser.h"
#import "DataDownloadOperation.h"
#import "NetworkInterface.h"
#import "POXMLParser.h"
#import "CWXMLParser.h"
#import "drawingPathXMLParser.h"

@protocol dataSourceDelegate;

@interface DataSource : NSObject<dataDownloadOperationDelegate,parserDelegate,POparserDelegate,CWparserDelegate,drawingParserDelegate>
{
    App_Storage* dataBase;
    
    id <dataSourceDelegate> delegate;
    
    NetworkInterface* interface;
    
    NSInteger operationType;
}


@property(nonatomic,retain)id<dataSourceDelegate>delegate;

-(void)getOrderList;
-(void)getBacklogOrders;
-(void)getPrioritizedOrdersForPlanner;
-(void)getPrioritizedOrdersForCellWorker;


-(void)prioritizeOrder:(Order*)order;
-(void)prioritizeBacklogOrder:(Order*)order;
-(void)dePrioritizeOrder:(Order*)order;

-(void)fetchData;

-(void)commitOrders;
-(void)confirmPicking:(POOrder*)order;
-(void)refreshPickAndConfirmList;

-(void)refreshOrderList;
-(void)updateWorkCenter:(Order*)order;
-(void)updateExceptionCode:(Order*)order;

-(void)deleteAllDBData:(NSString*)dbType;

-(NSInteger)getCount:(NSInteger)type;

-(void)completeOperation:(CWOrder*)order;
-(void)completeOrder:(CWOrder*)order;
-(void)cancelOrder:(CWOrder*)order;
-(void)refreshCWOperationsList;

-(void)fetchDrawingPathForItem:(NSString*)item;


@end



@protocol dataSourceDelegate <NSObject>

@optional
-(void)dataSourceOrderListDidFinish:(NSMutableArray*)entityArray;
-(void)dataSourceOrderListDidFail:(NSError*)error;
-(void)dataSourceDidCommit;
-(void)dataSourceDidFailCommit:(NSError*)error;
-(void)dataSourceDidCompleteOperation;
-(void)dataSourceDidFailOperationCommit:(NSError*)error;
-(void)dataSourceDidFetchDrawingPath;
-(void)dataSourceDidFailFetchingDrawingPath:(NSError*)error;

@end