//
//  DataSource.m
//  Rail Paper Less
//
//  Created by SadikAli on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
@synthesize delegate;


-(id)init
{
    if(self = [super init])
    {
        dataBase = [App_Storage getInstance];
        interface = [[NetworkInterface alloc] init];
    }
    
    return self;
}

-(void)getOrderList
{
    
    dataBase = [App_Storage getInstance];
    
   // [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(sendData:) userInfo:nil repeats:NO];
    
    operationType = GETORDERS;
    
    if([interface isWiFiOn])
        [self fetchData];
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceOrderListDidFail:[errorStatement autorelease]];

    }
    
    
}


-(void)refreshOrderList
{
    [dataBase deleteOrderList];
    [dataBase deletePiorityList];
    
    if([interface isWiFiOn])
        [self fetchData];
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceOrderListDidFail:[errorStatement autorelease]];
        
    }
}

-(void)refreshPickAndConfirmList
{
    [dataBase deleteAllEntries:PCORDERSDB];
    [dataBase deleteAllEntries:POSITIONSDB];
    
    if([interface isWiFiOn])
    {
        operationType = GETPORDERS;
        [self fetchDataForPlanner];
    }
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceOrderListDidFail:[errorStatement autorelease]];
        
    }
}


-(void)refreshCWOperationsList
{
    if([interface isWiFiOn])
    {
        operationType = GETCWORDERS;
        [dataBase deleteAllEntries:CWORDERSDB];
        [dataBase deleteAllEntries:CWOPERATIONSDB];

        [self fetchDataForCellWorker];
    }
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceOrderListDidFail:[errorStatement autorelease]];
        
    }

}

-(void)getBacklogOrders
{
    [delegate dataSourceOrderListDidFinish:[[App_Storage getInstance] getBackLogOrders]];
}

-(void)getPrioritizedOrdersForPlanner
{
    if([interface isWiFiOn])
    {
        operationType = GETPORDERS;
        [self fetchDataForPlanner];
    }
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceOrderListDidFail:[errorStatement autorelease]];
        
    }
    
}

-(void)getPrioritizedOrdersForCellWorker
{
    if([interface isWiFiOn])
    {
        operationType = GETCWORDERS;
               
        [self fetchDataForCellWorker];
    }
    else 
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceOrderListDidFail:[errorStatement autorelease]];

    }
}


-(void)prioritizeOrder:(Order*)order
{
    [[App_Storage getInstance] storePrioritizedOrder:order];
    [[App_Storage getInstance] removeFromOpenOrders:order];
}

-(void)prioritizeBacklogOrder:(Order*)order
{
    [[App_Storage getInstance] updatePriority]; 
    [[App_Storage getInstance] storePrioritizedOrder:order];
     [[App_Storage getInstance] removeFromOpenOrders:order];
    
}

-(void)dePrioritizeOrder:(Order*)order
{
   // NSLog(@"order modified on %@",order.status);
    if([order.status isEqualToString:@"open"])
    {
        order.Modifiedon = @"N";
    }
    [[App_Storage getInstance] removePrioritizedOrder:order];
    [[App_Storage getInstance] storeOrderList:[[[NSMutableArray alloc] initWithObjects:order, nil] autorelease]];
}


-(void)deleteAllDBData:(NSString*)dbType
{
    [dataBase deleteAllEntries:dbType];
}

-(void)fetchData
{
    if([[dataBase getOrderList] count])
    {
        [delegate dataSourceOrderListDidFinish:[dataBase getOrderList]];
    }
    
    else
    {
    
       [[App_Storage getInstance] deleteOrderList];
        
        NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
        [testQueue setMaxConcurrentOperationCount:1];
        
        DataDownloadOperation* loginOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:GETORDERS_URL]];
        loginOp.postData = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><Getorders><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><Plannerfrom>",[[UserProfile getInstance] plannerFrom],@"</Plannerfrom><Plannerto>",[[UserProfile getInstance] plannerTo],@"</Plannerto><Workcenterfrom>",[[UserProfile getInstance] workCenterFrom],@"</Workcenterfrom><Workcenterto>",[[UserProfile getInstance] workCenterTo],@"</Workcenterto><Startdatefrom>",[[UserProfile getInstance] startDateFrom],@"</Startdatefrom><Startdateto>",[[UserProfile getInstance] startDateTo],@"</Startdateto><Enddatefrom>",[[UserProfile getInstance] endDateFrom],@"</Enddatefrom><Enddateto>",[[UserProfile getInstance] endDateTo],@"</Enddateto></Getorders>"];
    
        //NSLog(@"xml is %@",loginOp.postData);
    
        loginOp.delegate = self;
        operationType = GETORDERS;
        
        [testQueue addOperation:loginOp];
        
    }

}



-(void)fetchDataForPlanner
{
    
    if([[dataBase getPCOrderList] count])
    {
        [delegate dataSourceOrderListDidFinish:[dataBase getPCOrderList]];
    }
    else 
    {
        NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
        [testQueue setMaxConcurrentOperationCount:1];
        
        DataDownloadOperation* dataFetchOP = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:GETPORDERS_URL]];
        dataFetchOP.postData = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><GetPorders><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><Orderfrom>",[[UserProfile getInstance] ordersFrom],@"</Orderfrom><Orderto>",[[UserProfile getInstance] ordersTo],@"</Orderto><Workcenterfrom>",[[UserProfile getInstance] workCenterFrom],@"</Workcenterfrom><Workcenterto>",[[UserProfile getInstance] workCenterTo],@"</Workcenterto></GetPorders>"];
        
        //NSLog(@"xml is %@",dataFetchOP.postData);
        
        dataFetchOP.delegate = self;
        //operationType = GET;
        
        [testQueue addOperation:dataFetchOP];
    }
    
   

}

-(void)fetchDataForCellWorker
{
    
   if([[dataBase getCWOrderList] count])
   {
       [delegate dataSourceOrderListDidFinish:[dataBase getCWOrderList]];
   }
   else
   {
       NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
       [testQueue setMaxConcurrentOperationCount:1];
       
       DataDownloadOperation* dataFetchOP = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:GETCWORDERS_URL]];
       dataFetchOP.postData = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><GetPorders><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><Orderfrom>",[[UserProfile getInstance] ordersFrom],@"</Orderfrom><Orderto>",[[UserProfile getInstance] ordersTo],@"</Orderto><Workcenterfrom>",[[UserProfile getInstance] workCenterFrom],@"</Workcenterfrom><Workcenterto>",[[UserProfile getInstance] workCenterTo],@"</Workcenterto></GetPorders>"];
       
       //NSLog(@"xml is %@",dataFetchOP.postData);
       
       dataFetchOP.delegate = self;
       //operationType = GET;
       
       [testQueue addOperation:dataFetchOP];
   }
    
    

}


-(void)fetchDrawingPathForItem:(NSString*)item
{
   
   if([[dataBase getDrawingPathforItem:item] length] && ![[dataBase getDrawingPathforItem:item] isEqualToString:@"NO"] )
   {
       [delegate dataSourceDidFetchDrawingPath];
   }
   else
   {
       operationType = GETDRAWINGPATH;
       NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
       [testQueue setMaxConcurrentOperationCount:1];
       
       DataDownloadOperation* dataFetchOP = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:GETDRAWINGPATH_URL]];
       dataFetchOP.postData = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><Getdrawing><user>",[[UserProfile getInstance] userId],@"</user><username>",[[[UserProfile getInstance] userFirstName] stringByAppendingString:[[UserProfile getInstance] userLastName]],@"</username><part>",item,@"</part></Getdrawing>"];
       NSLog(@"xml is %@",dataFetchOP.postData);
       
       dataFetchOP.delegate = self;
       //operationType = GET;
       
       [testQueue addOperation:dataFetchOP];
       
       // NSLog(@"name is %@",[[[UserProfile getInstance] userFirstName] stringByAppendingString:[[UserProfile getInstance] userLastName]]);
   }
    
   

}


-(void)sendData:(NSTimer*)timer
{
    if([[dataBase getOrderList] count])
    {
        [delegate dataSourceOrderListDidFinish:[dataBase getOrderList]];
    }
    
    else
    {
        NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
        [testQueue setMaxConcurrentOperationCount:1];
        
        DataDownloadOperation* loginOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:GETORDERS_URL]];
        loginOp.delegate = self;
        
        [testQueue addOperation:loginOp];
    }
}

-(void)commitOrders
{
    operationType = COMMIT;
    
   // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISREFRESH"];
    
    NSMutableArray* orderData =  [[App_Storage getInstance] getPriorityOrderList];
    
    //form XML request
    
    NSString* finalXML = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><Commitall><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><PriorityOrders>"];
    
   
    for(int i =0;i<[orderData count];i++)
    {
        NSString* temp = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%d%@%@%@", @"<Order value='",[[orderData objectAtIndex:i] orderNumber],@"'><Planner>",[[orderData objectAtIndex:i] planner],@"</Planner><Workcenter>",[[orderData objectAtIndex:i] workcenter],@"</Workcenter><Priority>",i,@"</Priority><ExceptionCode>",[[orderData objectAtIndex:i] exceptionCode],@"</ExceptionCode></Order>"];

        
        finalXML = [finalXML stringByAppendingString:temp];
        
    }
    
    NSString* temp1 = [[NSString alloc] initWithString:@"</PriorityOrders></Commitall>"];
    
    finalXML = [finalXML stringByAppendingString:temp1];
                          
                          
    NSLog(@"finalXML is %@", finalXML);
    
    NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
    [testQueue setMaxConcurrentOperationCount:1];
    
    if([interface isWiFiOn])
    {
        DataDownloadOperation* loginOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:COMMITT_URL]];
        
        loginOp.postData = finalXML;
        loginOp.delegate = self;
        
        [testQueue addOperation:loginOp];
    }
        
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceDidFailCommit:[errorStatement autorelease]];
        
    }
    
    
    
}

-(void)confirmPicking:(POOrder*)order
{
    operationType = CONFIRMPICK;
    
    NSMutableArray* orderData =  order.positionArray;
    
    //form XML request
    
    NSString* finalXML = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><Confirmpickingorder><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><Order value='",[order orderNumber],@"'><Status>",[order status],@"</Status>"];
    
    
    for(int i =0;i<[orderData count];i++)
    {
        NSString* temp = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"<Position value = '",[[orderData objectAtIndex:i] positionNumber],@"'><Item>",[[orderData objectAtIndex:i] item],@"</Item><Description>",[[orderData objectAtIndex:i] description],@"</Description><UOM>", [[orderData objectAtIndex:i] UOM],@"</UOM><PickLocation>",[[orderData objectAtIndex:i] pickLocation],@"</PickLocation><Pickqty>",[[orderData objectAtIndex:i] pickqty],@"</Pickqty><PickedLocation>",[[orderData objectAtIndex:i] pickedLocation],@"</PickedLocation><Pickedqty>",[[orderData objectAtIndex:i] pickedqty],@"</Pickedqty></Position>"];
        
        finalXML = [finalXML stringByAppendingString:temp];
        
    }
    
    NSString* temp1 = [[NSString alloc] initWithString:@"</Order></Confirmpickingorder>"];
    
    finalXML = [finalXML stringByAppendingString:temp1];
    
    
    NSLog(@"finalXML is %@", finalXML);
    
    NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
    [testQueue setMaxConcurrentOperationCount:1];
    
    if([interface isWiFiOn])
    {
        DataDownloadOperation* loginOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:CONFIRMPICK_URL]];
        
        loginOp.postData = finalXML;
        loginOp.delegate = self;
        
        [testQueue addOperation:loginOp];
    }
    
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceDidFailCommit:[errorStatement autorelease]];
        
    }

    
}

-(void)completeOperation:(CWOrder*)order
{
    operationType = COMPLETEOPERATION;
    
     NSMutableArray* orderData =  order.operationArray;
    
    NSString* finalXML = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><CompleteOperation><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><Order>",[order orderNumber],@"</Order><Status>",[order status],@"</Status>"];
    
    NSLog(@"count is %d",[orderData count]);
    
    for(int i =0;i<1;i++)
    {
        NSString* temp = [[NSString alloc] initWithFormat:@"%@%@%@",@"<Operation>",[NSString stringWithFormat:@"%d",[[orderData objectAtIndex:i] operation]],@"</Operation>"];
        finalXML = [finalXML stringByAppendingString:temp];
    }
    
    NSString* temp1 = [[NSString alloc] initWithString:@"</CompleteOperation>"];
    
    finalXML = [finalXML stringByAppendingString:temp1];
    
    NSLog(@"finalXML is %@", finalXML);
    
    NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
    [testQueue setMaxConcurrentOperationCount:1];
    
    if([interface isWiFiOn])
    {
        DataDownloadOperation* loginOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:COMPLETEOPERATION_URL]];
        
        loginOp.postData = finalXML;
        loginOp.delegate = self;
        
        [testQueue addOperation:loginOp];
    }
    
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceDidFailCommit:[errorStatement autorelease]];
        
    }
    

}

-(void)completeOrder:(CWOrder*)order
{
    operationType = COMPLETEOPERATION;
    
    NSMutableArray* orderData =  order.operationArray;
    
     NSString* finalXML = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><CompleteOperation><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><Order>",[order orderNumber],@"</Order><Status>",@"Completed",@"</Status>"];
    
    NSLog(@"count is %d",[orderData count]);
    
    for(int i =0;i<1;i++)
    {
        NSString* temp = [[NSString alloc] initWithFormat:@"%@%@%@",@"<Operation>",[NSString stringWithFormat:@"%d",[[orderData objectAtIndex:i] operation]],@"</Operation>"];
        finalXML = [finalXML stringByAppendingString:temp];
    }
    
    NSString* temp1 = [[NSString alloc] initWithString:@"</CompleteOperation>"];
    
    finalXML = [finalXML stringByAppendingString:temp1];
    
    NSLog(@"finalXML is %@", finalXML);
    
    NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
    [testQueue setMaxConcurrentOperationCount:1];
    
    if([interface isWiFiOn])
    {
        DataDownloadOperation* loginOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:COMPLETEOPERATION_URL]];
        
        loginOp.postData = finalXML;
        loginOp.delegate = self;
        
        [testQueue addOperation:loginOp];
    }
    
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceDidFailCommit:[errorStatement autorelease]];
        
    }

}

-(void)cancelOrder:(CWOrder*)order
{
    operationType = COMPLETEOPERATION;
    
    NSMutableArray* orderData =  order.operationArray;
    
    NSString* finalXML = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@",@"<?xml version='1.0' encoding='UTF-8'?><CompleteOperation><user>",[[UserProfile getInstance] userId],@"</user><username>",[[UserProfile getInstance] userName],@"</username><Order>",[order orderNumber],@"</Order><Status>",@"Cancelled",@"</Status>"];
    
    NSLog(@"count is %d",[orderData count]);
    
    for(int i =0;i<[orderData count];i++)
    {
        NSString* temp = [[NSString alloc] initWithFormat:@"%@%@%@",@"<Operation>",[NSString stringWithFormat:@"%d",[[orderData objectAtIndex:i] operation]],@"</Operation>"];
        finalXML = [finalXML stringByAppendingString:temp];
    }
    
    NSString* temp1 = [[NSString alloc] initWithString:@"</CompleteOperation>"];
    
    finalXML = [finalXML stringByAppendingString:temp1];
    
    NSLog(@"finalXML is %@", finalXML);
    
    NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
    [testQueue setMaxConcurrentOperationCount:1];
    
    if([interface isWiFiOn])
    {
        DataDownloadOperation* loginOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:COMPLETEOPERATION_URL]];
        
        loginOp.postData = finalXML;
        loginOp.delegate = self;
        
        [testQueue addOperation:loginOp];
    }
    
    else
    {
        NSError* errorStatement = [[NSError alloc] initWithDomain:@"Authentication" code:1 userInfo:[NSDictionary dictionaryWithObject:@"No Network Connection" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceDidFailCommit:[errorStatement autorelease]];
        
    }

}


-(void)updateWorkCenter:(Order*)order
{
    [dataBase updateWorkCenter:order];
}

-(void)updateExceptionCode:(Order*)order
{
    
}

-(NSInteger)getCount:(NSInteger)type
{
    return [dataBase getCount:type];
}


#pragma marks datadownload callbacks
-(void)didDownloadData:(NSData *)downloadedData
{
    if([downloadedData length] && operationType == GETORDERS)
    {
       
        NSString* temp = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
        NSData* tempData = [[NSData alloc] initWithData:[[temp stringByReplacingOccurrencesOfString:@"\n" withString:@""] dataUsingEncoding:NSASCIIStringEncoding]];
        
        XMLParser* parser = [[XMLParser alloc] init];
        parser.delegate = self;
        [parser parseWithReceivedData:tempData];
        //[delegate dataSourceOrderListDidFinish:[dataBase getOrderList]];
        
        [temp release];
        [tempData release];
    }
    
    else if([downloadedData length] && operationType == COMMIT)
    {
         NSMutableArray* orderData =  [[App_Storage getInstance] getPriorityOrderList];
        
        for(int i =0;i<[orderData count];i++)
        {
            [dataBase updateCommitStatus:[orderData objectAtIndex:i]];
        }
        
        [delegate dataSourceDidCommit];
    }
    
    else if([downloadedData length] && operationType == GETPORDERS)
    {
        NSString* temp = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
        NSData* tempData = [[NSData alloc] initWithData:[[temp stringByReplacingOccurrencesOfString:@"\n" withString:@""] dataUsingEncoding:NSASCIIStringEncoding]];
        
        NSLog(@"data is %@",temp);
        
        POXMLParser* parser = [[POXMLParser alloc] init];
        parser.delegate = self;

        [parser parseWithReceivedData:tempData];
               
        
        [temp release];
        [tempData release];
    }
    
    else if([downloadedData length] && operationType == CONFIRMPICK)
    {
        // NSString* temp = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
        //NSLog(@"data is %@",temp);
        
        [delegate dataSourceDidCommit];
    }
    
    else if([downloadedData length] && operationType == GETCWORDERS)
    {
        NSString* temp = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
        NSData* tempData = [[NSData alloc] initWithData:[[temp stringByReplacingOccurrencesOfString:@"\n" withString:@""] dataUsingEncoding:NSASCIIStringEncoding]];
        
        //NSLog(@"temp is %@",temp);
        
        CWXMLParser* parser = [[CWXMLParser alloc] init];
        parser.delegate = self;
        [parser parseWithReceivedData:tempData];
        
        [temp release];
        [tempData release];
    }
    
    else if([downloadedData length] && operationType == COMPLETEOPERATION)
    {
        [delegate dataSourceDidCompleteOperation];
    }
    
    else if([downloadedData length] && operationType == GETDRAWINGPATH)
    {
        NSString* temp = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
        NSData* tempData = [[NSData alloc] initWithData:[[temp stringByReplacingOccurrencesOfString:@"\n" withString:@""] dataUsingEncoding:NSASCIIStringEncoding]];
        NSLog(@"data is %@",temp);
        
        drawingPathXMLParser* drawingParser = [[drawingPathXMLParser alloc] init];
        drawingParser.delegate = self;
        [drawingParser parseWithReceivedData:tempData];
        
        [tempData release];
        [temp release];
    }
    
  

}

-(void)didFailDownloadData:(NSError *)error
{
    NSLog(@"error downloading");
    [delegate dataSourceOrderListDidFail:error];
}

#pragma mark Get Order Parser Callbacks

-(void)didFinishParsing
{
    [delegate dataSourceOrderListDidFinish:[dataBase getOrderList]];
}

-(void)didFailParsing:(NSString *)error
{
    NSLog(@"error in parsing");
}

#pragma mark PO Orders Callbacks

-(void)didFinishPOParsing
{
    NSLog(@"PO parsing done");
    [delegate dataSourceOrderListDidFinish:[dataBase getPCOrderList]];
}

-(void)didFailPOParsing:(NSString*)error
{
    NSLog(@"error");
    [App_GeneralUtilities showAlertOKWithTitle:@"XML Parse Error" withMessage:@"Error occured in Parsing XML"];
}

#pragma mark CW Orders Callbacks

-(void)didFinishCWParsing
{
    [delegate dataSourceOrderListDidFinish:[dataBase getCWOrderList]];
}

-(void)didFailCWParsing:(NSString *)error
{
    NSLog(@"error");
    [App_GeneralUtilities showAlertOKWithTitle:@"XML Parse Error" withMessage:@"Error occured in Parsing XML"];
}

#pragma mark Drawing Path Callbacks
-(void)didFinishParsingDrawingPath
{
    [delegate dataSourceDidFetchDrawingPath];
}

-(void)didFailParsingDrawingPath:(NSError*)error
{
    [App_GeneralUtilities showAlertOKWithTitle:@"XML Parse Error" withMessage:@"Error occured in Parsing XML"];
}

@end
