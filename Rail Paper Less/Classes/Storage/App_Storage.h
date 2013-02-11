//
//  App_Storage.h
//  Xenon
//
//  Created by Mahendra on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Order.h"
#import "POOrder.h"
#import "CWOrder.h"
#import "ConstantDefines.h"
#import "PositionData.h"
#import "OperationsData.h"


@interface App_Storage : NSObject
{
    
}

//singleton Instance
+ (App_Storage *)getInstance;
-(BOOL)initVars;
-(void)checkAndCreateDatabase:(NSString*)dataBaseType;

-(void)storeOrderList:(NSMutableArray*)orderArray;
-(NSMutableArray*)getOrderList;
-(void)deleteOrderList;
-(void)deletePiorityList;
-(void)deleteAllEntries:(NSString*)dbType;

-(void)storePrioritizedOrder:(Order*)order;
-(NSMutableArray*)getPriorityOrderList;
-(void)removePrioritizedOrder:(Order*)order;
-(NSMutableArray*)getBackLogOrders;

//Pick And Confirm
-(void)storePCOrderList:(NSMutableArray*)dataArray;
-(void)storePositionsOfOrder:(POOrder*)order;
-(NSMutableArray*)getPCOrderList;
-(NSMutableArray*)getPositionsForOrder:(POOrder*)order;


//Compelete Operations
-(void)storeCWOrderList:(NSMutableArray*)dataArray;
-(void)storeOperationsOfOrder:(CWOrder*)order;
-(NSMutableArray*)getCWOrderList;
-(NSMutableArray*)getOperationsForOrder:(CWOrder*)order;



-(void)removeFromOpenOrders:(Order*)order;

-(void)updateCommitStatus:(Order*)order;
-(void)updateWorkCenter:(Order*)order;
-(void)updateExceptionCode:(Order*) order;
-(void)updatefieldsOfPosition:(PositionData*)pos;
-(void)updateOperationStatus:(OperationsData*)operation ofOrder:(NSString*)ordernumber;
-(void)updatePriority;
-(void)updatePCOrderStatus:(POOrder*)order;

-(NSInteger)getCount:(NSInteger)type;
-(NSInteger)getCountOfUncompletedOperations:(NSString*)orderNumber;
-(NSInteger)getCountOfAllRecords:(NSString*)type;


-(void)storeDrawingPath:(NSString*) path forItem:(NSString*)item;
-(NSString*)getDrawingPathforItem:(NSString*)item;

@end
