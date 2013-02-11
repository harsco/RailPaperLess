//
//  App_Storage.m
//  Xenon
//
//  Created by Mahendra on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


//error handling needed

#import "App_Storage.h"

#define kMaxItemsForLoop 1000

NSString* const OPENORDERS        = @"create table if not exists Openorders (ordernumber text primary key,item text,quantity text,pldeliverydate text,startdate text,enddate text,workcenter text,planner text,status text);";

NSString* const PRIORITYORDERS    =@"create table if not exists PriorityOrders (ordernumber text primary key,item text,quantity text,pldeliverydate text,startdate text,enddate text,workcenter text,planner text,iscommitted integer,exceptioncode text,priority int,status text);";

NSString* const PCORDERS          =@"create table if not exists PcOrders (ordernumber text primary key,status text,workcenter text,wcdesc text,poscount int);";

NSString* const POSITIONS         =@"create table if not exists Positions (ordernumber text,position text,item text,description text,uom text,picklocation text,pickqty text,pickedlocation text,pickedqty text,positionint int)";

NSString* const CWORDERS          =@"create table if not exists CWOrders (ordernumber text,priority int,workcenter text,planner text,item text,itemdesc text,uom text,revision text,quantity text,status text)";

NSString* const OPERATIONS        =@"create table if not exists Operations (ordernumber text,operation int,task text,desc text,wc text,wdesc text,machine text,startdate text,enddate text,prodtime text,completed text,taskdesc text)";

NSString* const DRAWINGPATHS      =@"create table if not exists Drawingpaths (item text primary key,drawingpath text)";


NSString* const OPEN_ORDERS      =  @"Openorders";
NSString* const PRIORITY_ORDERS  =  @"PriorityOrders";
NSString* const PC_ORDERS         =  @"PcOrders";
NSString* const PC_POSITIONS     =  @"Positions";
NSString* const CW_ORDERS        =  @"CWOrders";
NSString* const CW_OPERATIONS    =  @"Operations";
NSString* const DRAWING_PATHS    =  @"Drawingpaths";



static sqlite3 *database = nil;

@implementation App_Storage

//singleton Instance
+ (App_Storage *)getInstance
{
    static App_Storage* instance;
    @synchronized(self)
    {
        if(!instance)
        {
            instance = [[App_Storage alloc] init];
            [instance initVars];
        }
    }
    
    
    if(instance)
    return instance;
    
    return nil;
}


-(BOOL)initVars
{
    
    //essentially checking and loading the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:DB_NAME];
    
    
    NSLog(@"db path is %@",documentsDir);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    // Check if the sqlite db exists in the application path
	if(![fileManager fileExistsAtPath:documentsDir])
    {
        NSString *defaultAppPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
        NSLog(@"path is %@",defaultAppPath);
        
       if(! [fileManager copyItemAtPath:defaultAppPath toPath:documentsDir error:&error])
       {
           NSLog(@"error is %@",[error localizedDescription]);
           return NO;
       }
    }
    
    
    if (sqlite3_open([documentsDir UTF8String], &database) == SQLITE_OK) 
    {
		[self checkAndCreateDatabase:OPENORDERS];
        [self checkAndCreateDatabase:PRIORITYORDERS];
        [self checkAndCreateDatabase:PCORDERS];
        [self checkAndCreateDatabase:POSITIONS];
        [self checkAndCreateDatabase:CWORDERS];
        [self checkAndCreateDatabase:OPERATIONS];
        [self checkAndCreateDatabase:DRAWINGPATHS];
        
        
        return YES;
    }
	else
		return NO;
    

    return NO;
}

-(void)checkAndCreateDatabase:(NSString*)dataBaseType
{
   
  //create the tables if they donot exist    
    
    //int returnCode = 0;
    sqlite3_stmt* statement = NULL;
    sqlite3_prepare(database, [dataBaseType UTF8String], -1, &statement, 0);
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"checkAndCreateDatabase:%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"checkAndCreateDatabase: Successfully created DB");
    }
    
    sqlite3_finalize(statement);
    
}

-(NSInteger)getCount:(NSInteger)type
{
    
    sqlite3_stmt* statement = NULL;
    NSString* sqlQuery=@"";
    
    int count=0;
    
    if(type == DBOPENORDERS)
    {
        sqlQuery = [[NSString alloc] initWithFormat:@"%@%@",@"select count(*) from ",OPEN_ORDERS];
    }
    else if(type == DBPRIORITYORDERS)
    {
        sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"select count(*) from ",PRIORITY_ORDERS,@" where iscommitted = '0';"];
    }
        
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    else 
    {
        while(sqlite3_step(statement) == SQLITE_ROW) 
        {
            count = sqlite3_column_int(statement, 0);
        }
    }
    
    
   
    
    sqlite3_reset(statement);
    
    return count;
}

-(NSInteger)getCountOfAllRecords:(NSString*)type
{
    sqlite3_stmt* statement = NULL;
    NSString* sqlQuery;
    
    int count;
    
    sqlQuery = [[NSString alloc] initWithFormat:@"%@%@",@"select count(*) from ",type];
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    else 
    {
        while(sqlite3_step(statement) == SQLITE_ROW) 
        {
            count = sqlite3_column_int(statement, 0);
        }
    }
    
    sqlite3_reset(statement);
    
    return count;

}


-(NSInteger)getCountOfUncompletedOperations:(NSString*)orderNumber
{
    sqlite3_stmt* statement = NULL;
    NSString* sqlQuery;
    
    int count;
    
    
    sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select count(*) from ",CW_OPERATIONS,@" where completed = 'NO' and ordernumber = '",orderNumber,@"'"];
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    else 
    {
        while(sqlite3_step(statement) == SQLITE_ROW) 
        {
            count = sqlite3_column_int(statement, 0);
        }
    }
    
    
    sqlite3_reset(statement);
    
    return count;
}


-(void)storeOrderList:(NSMutableArray*)orderArray
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //(ordervalue text primary key,item text,quantity integer,pldeliverydate text,startdate text,enddate text,workcenter text,planner text)
    
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"insert into ",OPEN_ORDERS,@"(ordernumber,item,quantity,pldeliverydate,startdate,enddate,workcenter,planner,status) values(?,?,?,?,?,?,?,?,?)"];
    NSLog(@"query is %@",sqlQuery);
    
    sqlite3_stmt* statement = NULL;

    
        
        for(int j=0;j<[orderArray count];j++)
        {
            if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
            {
                NSLog(@"%s",sqlite3_errmsg(database));
                
            }
            
            
            Order* order = [orderArray objectAtIndex:j];
            const char* orderValue = [order.orderNumber UTF8String];
            const char* item = [order.item UTF8String];
            const char* quantity = [order.quantity UTF8String];
            const char* pldeliverydate = [order.pldeliveryDate UTF8String];
            const char* startdate = [order.startDate UTF8String];
            const char* enddate = [order.endDate UTF8String];
            const char* workcenter = [order.workcenter UTF8String];
            const char* planner  = [order.planner UTF8String];
           
            
            
            //date comparision for order
            
           // NSLog(@"order modified is %@",order.Modifiedon);
            
            if([order.Modifiedon isEqualToString:@"N"])
            {
                const char* status = [@"open" UTF8String];
                order.status = @"open";
                
                if(sqlite3_bind_text(statement, 9, status, -1, SQLITE_TRANSIENT) != SQLITE_OK)
                {
                    //error
                    NSLog(@"%s",sqlite3_errmsg(database));
                }
            }
            else 
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                
                NSDate* datevar = [formatter dateFromString:order.Modifiedon];
                
                NSDate* currentDate = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
                
                if([datevar isEqualToDate:currentDate])
                {
                    order.isCommitted = YES;
                    order.exceptionCode = @"9999";
                    order.status = @"priority";
                    
                    [self storePrioritizedOrder:order];
                    const char* status = [@"priority" UTF8String];
                    if(sqlite3_bind_text(statement, 9, status, -1, SQLITE_TRANSIENT) != SQLITE_OK)
                    {
                        //error
                        NSLog(@"%s",sqlite3_errmsg(database));
                    }
                }
                else 
                {
                    const char* status = [@"backlog" UTF8String];
                    order.status = @"backlog";
                    if(sqlite3_bind_text(statement, 9, status, -1, SQLITE_TRANSIENT) != SQLITE_OK)
                    {
                        //error
                        NSLog(@"%s",sqlite3_errmsg(database));
                    }
                }
                
                
                //NSLog(@"date is %@", [formatter stringFromDate:datevar]);

            }
            
                        
            if(sqlite3_bind_text(statement, 1, orderValue, -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            
            if(sqlite3_bind_text(statement, 2, item, -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            
            if(sqlite3_bind_text(statement, 3, quantity, -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            if(sqlite3_bind_text(statement, 4, pldeliverydate, -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            if(sqlite3_bind_text(statement, 5, startdate, -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            if(sqlite3_bind_text(statement, 6, enddate, -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            if(sqlite3_bind_text(statement, 7, workcenter, -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            if(sqlite3_bind_text(statement, 8, planner, -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            
            
            
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                //error
                NSLog(@"%s",sqlite3_errmsg(database));
                
            }
            else
            {
                //NSLog(@"storeOrderList: Successfull");
            }
        }
    
    
    [sqlQuery release];
    sqlite3_finalize(statement);
    
    [pool release];

}


-(void)storePCOrderList:(NSMutableArray*)dataArray
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    

    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"insert into ",PC_ORDERS,@"(ordernumber,status,workcenter,wcdesc,poscount) values(?,?,?,?,?)"];
   // NSLog(@"query is %@",sqlQuery);
    
    sqlite3_stmt* statement = NULL;
    
    
    
    for(int j=0;j<[dataArray count];j++)
    {
        if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
        {
            NSLog(@"%s",sqlite3_errmsg(database));
            
        }
        
        
        POOrder* order = [dataArray objectAtIndex:j];
        const char* orderValue = [order.orderNumber UTF8String];
        const char* status     = [order.status UTF8String];
        NSLog(@"status %@",order.status);
        const char* workcenter = [order.workcenter UTF8String];
        const char* wcdesc     = [order.wcdescription UTF8String];
        int count              = [order.positionArray count];
        
    
        
        if(sqlite3_bind_text(statement, 1, orderValue, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_text(statement, 2, status, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_text(statement, 3, workcenter, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 4, wcdesc, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
               
        if(sqlite3_bind_int(statement, 5,count ) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        
        if(SQLITE_DONE != sqlite3_step(statement))
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
            
        }
        else
        {
            //NSLog(@"StorePCOrderList: Success");
        }
        
        
        [self storePositionsOfOrder:order];
    }
    
    
    [sqlQuery release];
    sqlite3_finalize(statement);
    
    [pool release];

}


-(NSMutableArray*)getPCOrderList
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"select * from ",PC_ORDERS,@";"];
    
    //NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",table,@" where foreignId = '",entity,@"'"];
    
   // NSLog(@"sql query is %@",sqlQuery);
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    else
    {
        [sqlQuery release];
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            POOrder* order = [[POOrder alloc] init];
            order.orderNumber = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 0)];
            order.status = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)];
           // NSLog(@"state is %@",[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)]);

            order.workcenter = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 2)];
            order.wcdescription = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 3)];
            
            [dataArray addObject:order];

            RELEASE_TO_NIL(order);
        }
    }
    
    //NSLog(@"count of data is %d",[dataArray count]);
    
    return [dataArray autorelease];
    

}

-(void)storePositionsOfOrder:(POOrder*)order
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"insert into ",PC_POSITIONS,@"(ordernumber,position,item,description,uom,picklocation,pickqty,pickedlocation,pickedqty,positionint) values(?,?,?,?,?,?,?,?,?,?)"];
   // NSLog(@"query is %@",sqlQuery);
    
    sqlite3_stmt* statement = NULL;
    
    
    
    for(int j=0;j<[order.positionArray count];j++)
    {
        if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
        {
            NSLog(@"%s",sqlite3_errmsg(database));
            
        }
        
        
        PositionData* position = [order.positionArray objectAtIndex:j];
        const char* orderValue = [order.orderNumber UTF8String];
        const char* positionValue    = [position.positionNumber UTF8String];
        const char* item = [position.item UTF8String];
        const char* desc     = [position.description UTF8String];
        const char* uom = [position.UOM UTF8String];
        const char* pickedlocation = [position.pickedLocation UTF8String];
        const char* pickedqty = [position.pickedqty UTF8String];
        const char* picklocation = [position.pickLocation UTF8String];
        const char* pickqty = [position.pickqty UTF8String];
        int positionInt = [position.positionNumber intValue];
        
        //NSLog(@"picked location %@",position.pickedLocation);
        
        if(sqlite3_bind_text(statement, 1, orderValue, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_text(statement, 2, positionValue, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_text(statement, 3, item, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 4, desc, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_text(statement, 5, uom, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 6, picklocation, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 7, pickqty, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 8, pickedlocation, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 9, pickedqty, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_int(statement, 10, positionInt) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }

        
               
        
        if(SQLITE_DONE != sqlite3_step(statement))
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
            
        }
        else
        {
            //NSLog(@"StorePositionsOfOrder: Success");
        }
    }
    
    
    [sqlQuery release];
    sqlite3_finalize(statement);
    
    [pool release];

}

-(void)updatefieldsOfPosition:(PositionData*)pos
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"update ",PC_POSITIONS,@" set pickedlocation ='",[pos pickedLocation],@"' where position = '",[pos positionNumber],@"'"];
    
    
    sqlite3_stmt* statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updatefieldsOfPosition: PickedLocation Update Success");
    }
    
    [sqlQuery release];
    sqlite3_finalize(statement);
    
    
    //Updating Committ status
    
    NSString* sqlQuery1 = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"update ",PC_POSITIONS,@" set pickedqty ='",[pos pickedqty],@"' where position = '",[pos positionNumber],@"'"];
    
    statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery1 UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery1 release];
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
         NSLog(@"updatefieldsOfPosition: PickedQTY Update Success");
    }
    
    [sqlQuery1 release];
    sqlite3_finalize(statement);}


-(NSMutableArray*)getPositionsForOrder:(POOrder*)order
{
    //NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"select * from ",PC_POSITIONS,@";"];
       
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@",@"select * from ",PC_POSITIONS,@" where ordernumber = '",order.orderNumber,@"'",@" order by positionint;"];
    
    //NSLog(@"sql query is %@",sqlQuery);
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    else
    {
        [sqlQuery release];
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            PositionData* positionObj = [[PositionData alloc] init];
            positionObj.positionNumber = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)];
            positionObj.item = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 2)];
            positionObj.description = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 3)];
            positionObj.UOM = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 4)];
            positionObj.pickLocation = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 5)];
            positionObj.pickqty = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 6)];
            positionObj.pickedLocation = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 7)];
            // NSLog(@"picked location %@",[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 7)]);
            positionObj.pickedqty = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 8)];

            
            [dataArray addObject:positionObj];
            
            RELEASE_TO_NIL(positionObj);
        }
    }
    
   // NSLog(@"count of data is %d",[dataArray count]);
    
    return [dataArray autorelease];
}

-(NSMutableArray*)getOrderList
{
  //  NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@",@"select * from ",OPEN_ORDERS];
    
     NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",OPEN_ORDERS,@" where status = '",@"open",@"'"];
    
    //NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",table,@" where foreignId = '",entity,@"'"];
    
   // NSLog(@"sql query is %@",sqlQuery);
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    else
    {
        [sqlQuery release];
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            Order* order = [[Order alloc] init];
            order.orderNumber = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 0)];
            order.item = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)];
            order.quantity = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 2)];
            order.pldeliveryDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 3)];
            order.startDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 4)];
            order.endDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 5)];
            order.workcenter = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 6)];
            order.planner = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 7)];
            order.status = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 8)];
            [dataArray addObject:order];
            RELEASE_TO_NIL(order);
            // NSLog(@"item is %@",[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)]);
            
        }
    }
    
   // NSLog(@"count of data is %d",[dataArray count]);
    
    return [dataArray autorelease];

}

-(void)deleteAllEntries:(NSString*)dbType
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@",@"delete from ",dbType];
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"deleteAllEntries: Successfully deleted");
    }
    
    sqlite3_finalize(statement);
}

-(void)deleteOrderList
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@",@"delete from ",OPEN_ORDERS];
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"deleteOrderList: successfully deleted");
    }
    
    sqlite3_finalize(statement);
}

-(void)deletePiorityList
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@",@"delete from ",PRIORITY_ORDERS];
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"deletePiorityList: successfully deleted");
    }
    
    sqlite3_finalize(statement);
}

-(void)removeFromOpenOrders:(Order*)order
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"delete from ",OPEN_ORDERS,@" where ordernumber = '",[order orderNumber],@"';"];
    
    NSLog(@"query is %@",sqlQuery);
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"removeFromOpenOrders: Success");
    }
    
    sqlite3_finalize(statement);
}


-(void)updatePriority
{
    NSString* sqlquery = [[NSString alloc] initWithFormat:@"%@",@"update PriorityOrders set priority = priority+1"];
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlquery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updateWorkCenter: Workcenter update success");
    }
    
    [sqlquery release];
    sqlite3_finalize(statement);

                          
                         

}



-(void)storePrioritizedOrder:(Order*)order
{
//    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"insert into ",PRIORITY_ORDERS,@"(ordernumber) values(?)"];
    //NSLog(@"query is %@",sqlQuery);
    
   
    
     NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"insert into ",PRIORITY_ORDERS,@"(ordernumber,item,quantity,pldeliverydate,startdate,enddate,workcenter,planner,iscommitted,exceptioncode,priority,status) values(?,?,?,?,?,?,?,?,?,?,?,?)"];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    
   // NSLog(@"ordernumber is %@",order.orderNumber);
    
    //Order* order = [orderArray objectAtIndex:j];
    const char* orderValue = [order.orderNumber UTF8String];
    const char* item = [order.item UTF8String];
    const char* quantity = [order.quantity UTF8String];
    const char* pldeliverydate = [order.pldeliveryDate UTF8String];
    const char* startdate = [order.startDate UTF8String];
    const char* enddate = [order.endDate UTF8String];
    const char* workcenter = [order.workcenter UTF8String];
    const char* planner  = [order.planner UTF8String];
    const char* exceptioncode = [order.exceptionCode UTF8String];
    const char* status = [order.status UTF8String];
    int iscommitted = order.isCommitted;
    int priority = order.priority;
    
    NSLog(@"priority is %d",priority);
    
    //NSLog(@"storePrioritizedOrder:order number is %@ priority is %d",order.orderNumber,priority);
    
    if(sqlite3_bind_text(statement, 1, orderValue, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
    if(sqlite3_bind_text(statement, 2, item, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
    if(sqlite3_bind_text(statement, 3, quantity, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    if(sqlite3_bind_text(statement, 4, pldeliverydate, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    if(sqlite3_bind_text(statement, 5, startdate, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    if(sqlite3_bind_text(statement, 6, enddate, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    if(sqlite3_bind_text(statement, 7, workcenter, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    if(sqlite3_bind_text(statement, 8, planner, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
    if(sqlite3_bind_int(statement, 9, iscommitted) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
    if(sqlite3_bind_text(statement, 10, exceptioncode, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
    if(sqlite3_bind_int(statement, 11, priority) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
    if(sqlite3_bind_text(statement, 12, status, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }

    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    else
    {
        NSLog(@"storePrioritizedOrder: Success");
    }

    [sqlQuery release];
    sqlite3_finalize(statement);
    

}

-(void)removePrioritizedOrder:(Order*)order
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"delete from ",PRIORITY_ORDERS,@" where ordernumber = '",[order orderNumber],@"';"];
    
    NSLog(@"query is %@",sqlQuery);
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"removePrioritizedOrder:Success");
    }
    
    sqlite3_finalize(statement);
    
    
}

-(NSMutableArray*)getPriorityOrderList
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"select * from ",PRIORITY_ORDERS,@" order by priority"];
    
   // NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@",@"select * from ",PC_POSITIONS,@" where ordernumber = '",order.orderNumber,@"'",@" order by positionint;"];
    //NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",PRIORITY_ORDERS,@" where ordernumber = '",entity,@"'"];
    
    //NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",table,@" where foreignId = '",entity,@"'"];
    
   // NSLog(@"sql query is %@",sqlQuery);
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    else
    {
        [sqlQuery release];
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            Order* order = [[Order alloc] init];
            order.orderNumber = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 0)];
            order.item = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)];
            order.quantity = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 2)];
            order.pldeliveryDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 3)];
            order.startDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 4)];
            order.endDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 5)];
            order.workcenter = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 6)];
            order.planner = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 7)];
            order.isCommitted = sqlite3_column_int(statement, 8);
            order.exceptionCode = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 9)];
            order.status = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 11)];
            order.priority = sqlite3_column_int(statement, 10);
            [dataArray addObject:order];
            // NSLog(@"status is %@",order.exceptionCode);
             //NSLog(@"getPriorityOrderList:order number is %@ priority is %d",order.orderNumber, order.priority);
            RELEASE_TO_NIL(order);
            // NSLog(@"item is %@",[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)]);
            
           
            
        }
    }
    
    //NSLog(@"count of data is %d",[dataArray count]);
    
    return [dataArray autorelease];
    
}


-(void)updateCommitStatus:(Order*)order
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"update ",PRIORITY_ORDERS,@" set iscommitted = 1 where ordernumber = '",[order orderNumber],@"'"];
    
    
    sqlite3_stmt* statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updateCommitStatus: Success");
    }
    
    sqlite3_finalize(statement);
    
}

-(void)updateOrderStatus:(CWOrder*)order
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@",@"update ",CW_ORDERS,@" set status =",[order status], @"where ordernumber = '",[order orderNumber],@"'"];
    
    sqlite3_stmt* statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
        return;
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updateOrderStatus: Workcenter update success");
    }
    
    [sqlQuery release];
    sqlite3_finalize(statement);
}


-(void)updateOperationStatus:(OperationsData*)operation ofOrder:(NSString*)ordernumber
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%d",@"update ",CW_OPERATIONS,@" set completed = '",[operation currentOperation], @"' where ordernumber = '",ordernumber,@"' and operation = ",[operation operation]];
    
    NSLog(@"query is %@",sqlQuery);
    
    sqlite3_stmt* statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
        return;
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updateOperationStatus: Workcenter update success");
    }
    
    [sqlQuery release];
    sqlite3_finalize(statement);

}

-(void)updatePCOrderStatus:(POOrder*)order
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"update ",PC_ORDERS,@" set status ='",order.status,@"' where ordernumber = '",[order orderNumber],@"'"];
    
    
    sqlite3_stmt* statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updateOrderStatus: Order Status update success");
    }
    
    [sqlQuery release];
    sqlite3_finalize(statement);
}

-(void)updateWorkCenter:(Order*)order
{
    //NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"update ",PRIORITY_ORDERS,@" set workcenter =' 1 where ordernumber = '",[order orderNumber],@"'"];
    
    //Two things one to update the workcenter and the other to update commit status as this order has to be committed now to server
    
    
    //Updating Workcenter
    
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"update ",PRIORITY_ORDERS,@" set workcenter ='",[order workcenter],@"' where ordernumber = '",[order orderNumber],@"'"];
    
    
    sqlite3_stmt* statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updateWorkCenter: Workcenter update success");
    }
    
    [sqlQuery release];
    sqlite3_finalize(statement);
    
    
    //Updating Committ status
    
     sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"update ",PRIORITY_ORDERS,@" set iscommitted ='",[order isCommitted],@"' where ordernumber = '",[order orderNumber],@"'"];
    
     statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updateWorkCenter: Commit update success");
    }
    
    [sqlQuery release];
    sqlite3_finalize(statement);
}

-(void)updateExceptionCode:(Order*) order
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"update ",PRIORITY_ORDERS,@" set exceptioncode ='",[order exceptionCode],@"' where ordernumber = '",[order orderNumber],@"'"];
    
    sqlite3_stmt* statement = NULL;
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    
    //throw proper errors
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    else
    {
        NSLog(@"updateExceptionCode: Success");
    }
    
    [sqlQuery release];
    sqlite3_finalize(statement);
}

-(NSMutableArray*)getBackLogOrders
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",OPEN_ORDERS,@" where status = '",@"backlog",@"'"];
    // NSLog(@"sql query is %@",sqlQuery);
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    else
    {
        [sqlQuery release];
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            Order* order = [[Order alloc] init];
            order.orderNumber = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 0)];
            order.item = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)];
            order.quantity = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 2)];
            order.pldeliveryDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 3)];
            order.startDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 4)];
            order.endDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 5)];
            order.workcenter = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 6)];
            order.planner = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 7)];
            order.Modifiedon = @"backlog";
            [dataArray addObject:order];
            RELEASE_TO_NIL(order);
            // NSLog(@"item is %@",[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)]);
            
        }
    }
    
    //NSLog(@"count of data is %d",[dataArray count]);
    
    return [dataArray autorelease];

}


//Complete Operations
-(void)storeCWOrderList:(NSMutableArray*)dataArray
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    
    
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"insert into ",CW_ORDERS,@"(ordernumber,priority,workcenter,planner,item,itemdesc,uom,revision,quantity,status) values(?,?,?,?,?,?,?,?,?,?)"];
    // NSLog(@"query is %@",sqlQuery);
    
    sqlite3_stmt* statement = NULL;
    
    
    
    for(int j=0;j<[dataArray count];j++)
    {
        if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
        {
            NSLog(@"%s",sqlite3_errmsg(database));
            
        }
        
        
        CWOrder* order = [dataArray objectAtIndex:j];
        const char* orderValue = [order.orderNumber UTF8String];
        int priority           = order.priority;
        const char* workcenter = [order.workcenter UTF8String];
        const char* planner     = [order.planner UTF8String];
        const char* item        = [order.item UTF8String];
        const char* itemdesc    = [order.description UTF8String];
        const char* uom         = [order.UOM UTF8String];
        const char* revision    = [order.revision UTF8String];
        const char* quantity    = [order.orderquan UTF8String];
        const char* status      = [order.status UTF8String];
        
        
        
        
        if(sqlite3_bind_text(statement, 1, orderValue, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_int(statement, 2,priority ) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_text(statement, 3, workcenter, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 4, planner, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 5, item, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 6, itemdesc, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 7, uom, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 8, revision, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 9, quantity, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 10, status, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        
        
        if(SQLITE_DONE != sqlite3_step(statement))
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
            
        }
        else
        {
            //NSLog(@"StorePCOrderList: Success");
        }
        
        
        [self storeOperationsOfOrder:order];
    }
    
    
    [sqlQuery release];
    sqlite3_finalize(statement);
    
    [pool release];

}

-(void)storeOperationsOfOrder:(CWOrder*)order
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"insert into ",CW_OPERATIONS,@"(ordernumber,operation,task,desc,wc,wdesc,machine,startdate,enddate,prodtime,completed,taskdesc) values(?,?,?,?,?,?,?,?,?,?,?,?)"];
    // NSLog(@"query is %@",sqlQuery);
    
    sqlite3_stmt* statement = NULL;
    
    
    
    for(int j=0;j<[order.operationArray count];j++)
    {
        if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
        {
            NSLog(@"%s",sqlite3_errmsg(database));
            
        }
        
        
        OperationsData* operationObj = [order.operationArray objectAtIndex:j];
        const char* orderValue = [order.orderNumber UTF8String];
        int operation          = operationObj.operation;
        const char* task = [operationObj.task UTF8String];
        const char* desc     = [operationObj.taskDescription UTF8String];
        const char* wc = [operationObj.oPWorkcenter UTF8String];
        const char* wdesc = [operationObj.workcenterdesc UTF8String];
        const char* machine = [operationObj.machine UTF8String];
        const char* startdate = [operationObj.startDate UTF8String];
        const char* enddate = [operationObj.enddate UTF8String];
        const char* prodtime = [operationObj.productiontime UTF8String];
        const char* completed = [operationObj.currentOperation UTF8String];
        const char* taskDesc = [operationObj.taskText UTF8String];
        
        if(![operationObj.currentOperation length])
        {
              completed = "NO";
        }
       
        
        
        if(sqlite3_bind_text(statement, 1, orderValue, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_int(statement, 2, operation) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_text(statement, 3, task, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 4, desc, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        if(sqlite3_bind_text(statement, 5, wc, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 6, wdesc, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 7, machine, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 8, startdate, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 9, enddate, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 10, prodtime, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 11, completed, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        if(sqlite3_bind_text(statement, 12, taskDesc, -1, SQLITE_TRANSIENT) != SQLITE_OK)
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        
        
        if(SQLITE_DONE != sqlite3_step(statement))
        {
            //error
            NSLog(@"%s",sqlite3_errmsg(database));
            
        }
        else
        {
            //NSLog(@"StorePositionsOfOrder: Success");
        }
    }
    
    
    [sqlQuery release];
    sqlite3_finalize(statement);
    
    [pool release];

}


-(NSMutableArray*)getCWOrderList
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"select * from ",CW_ORDERS,@";"];
    
        
    //NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",table,@" where foreignId = '",entity,@"'"];
    
    // NSLog(@"sql query is %@",sqlQuery);
    
    

    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    else
    {
        [sqlQuery release];
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            CWOrder* order = [[CWOrder alloc] init];
            order.orderNumber = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 0)];
            order.priority  = sqlite3_column_int(statement, 1);
            order.workcenter = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 2)];
            order.planner = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 3)];
            order.item = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 4)];
            order.description = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 5)];
            order.UOM = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 6)];
            order.revision = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 7)];
            order.orderquan = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 8)];
            order.status    = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 9)];
            
            
            [dataArray addObject:order];
            
            RELEASE_TO_NIL(order);
        }
    }
    
    //NSLog(@"count of data is %d",[dataArray count]);
    
    return [dataArray autorelease];

}

-(NSMutableArray*)getOperationsForOrder:(CWOrder*)order
{
    
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",CW_OPERATIONS,@" where ordernumber = '",order.orderNumber,@"'"];
    
    //NSLog(@"sql query is %@",sqlQuery);
  
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    else
    {
        [sqlQuery release];
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            OperationsData* positionObj = [[OperationsData alloc] init];
            positionObj.operation = sqlite3_column_int(statement, 1);
            positionObj.task = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 2)];
            positionObj.taskDescription = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 3)];
            positionObj.oPWorkcenter = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 4)];
            positionObj.workcenterdesc = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 5)];
            positionObj.machine = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 6)];
            positionObj.startDate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 7)];
            // NSLog(@"picked location %@",[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 7)]);
            positionObj.enddate = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 8)];
            positionObj.productiontime = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 9)];
            positionObj.currentOperation = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 10)];
            positionObj.taskText = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 11)];
            
            
            [dataArray addObject:positionObj];
            
            RELEASE_TO_NIL(positionObj);
        }
    }
    
    // NSLog(@"count of data is %d",[dataArray count]);
    
    return [dataArray autorelease];
}


-(void)storeDrawingPath:(NSString*) path forItem:(NSString*)item
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@",@"insert into ",DRAWING_PATHS,@"(item,drawingpath) values(?,?)"];
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    
    // NSLog(@"ordernumber is %@",order.orderNumber);
    
    //Order* order = [orderArray objectAtIndex:j];
    const char* itemName = [item UTF8String];
    const char* pathName = [path UTF8String];
    
    
    //NSLog(@"storePrioritizedOrder:order number is %@ priority is %d",order.orderNumber,priority);
    
    if(sqlite3_bind_text(statement, 1, itemName, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
    if(sqlite3_bind_text(statement, 2, pathName, -1, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
       
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        //error
        NSLog(@"%s",sqlite3_errmsg(database));
        
    }
    else
    {
        NSLog(@"storeDrawingPath: Success");
    }
    
    [sqlQuery release];
    sqlite3_finalize(statement);
    

}

-(NSString*)getDrawingPathforItem:(NSString*)item
{
    NSString* sqlQuery = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"select * from ",DRAWING_PATHS,@" where item = '",item,@"'"];
    
    NSString* drawingPath = @"";
    
    sqlite3_stmt* statement = NULL;
    
    if(sqlite3_prepare(database, [sqlQuery UTF8String], -1, &statement, 0) != SQLITE_OK)
    {
        NSLog(@"%s",sqlite3_errmsg(database));
        [sqlQuery release];
    }
    else
    {
        [sqlQuery release];
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            //Order* order = [[Order alloc] init];
            
            drawingPath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)]];
            
            
        }
    }
    
    NSLog(@"drawing path is %@",drawingPath);
    
    return [drawingPath autorelease];
}


@end
