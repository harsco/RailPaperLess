//
//  ConstantDefines.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RELEASE_TO_NIL(x) { if (x!=nil) { [x release]; x = nil; } }

#define TEST_USER @"test"
#define TEST_PWD  @"test"

#define DB_NAME @"rail.db"


//URL Schemas

#define LOGIN_URL @"http://10.30.28.14:8080/Logindetails/"


//Ramesh Box
//#define GETORDERS_URL @"http://RAIINHYDLT00002.harsco.com:8080/Sendorders/"
//#define GETPORDERS_URL @"http://RAIINHYDLT00002.harsco.com:8080/Sendprioritizeorders/"
//#define COMMITT_URL @"http://RAIINHYDLT00002.harsco.com:8080/Commitorders/"
//#define CONFIRMPICK_URL @"http://RAIINHYDLT00002.harsco.com:8080/Commitpickandconfirm/"
//#define GETCWORDERS_URL @"http://RAIINHYDLT00002.harsco.com:8080/Sendprioritizecompleteop/"
//#define COMPLETEOPERATION_URL @"http://RAIINHYDLT00002.harsco.com:8080//Commitoperations/"
//#define GETDRAWINGPATH_URL @"http://raiuscolwsetst1.harsco.com:8080/Showdrawing"


//Live Data

#define GETORDERS_URL @"http://10.30.28.14:8080/Sendorders/"
#define GETPORDERS_URL @"http://10.30.28.14:8080/Sendprioritizeorders/"
#define COMMITT_URL @"http://10.30.28.14:8080/Commitorders/"
#define CONFIRMPICK_URL @"http://10.30.28.14:8080/Commitpickandconfirm/"
#define GETCWORDERS_URL @"http://10.30.28.14:8080/Sendprioritizecompleteop/"
#define COMPLETEOPERATION_URL @"http://10.30.28.14:8080/Commitoperations/"
#define GETDRAWINGPATH_URL @"http://raiuscolwsetst1.harsco.com:8080/Showdrawing/"

//Uncomment this only if you are a developer
//#define DEVELOPMENT 1


//Privilege Levels
#define SUPERUSER @"Superuser"
#define MATERIALHANDLER @"MaterialHandler"
#define CELLWORKER @"CellWorker"
#define PLANNER @"Planner"


//DB Types
#define DBOPENORDERS 1
#define DBPRIORITYORDERS 2
#define DBBACKLOGORDERS 3

#define OPENORDERSDB @"Openorders"
#define PRIORITYORDERSDB @"PriorityOrders"
#define POSITIONSDB @"Positions"
#define PCORDERSDB @"PcOrders"
#define CWORDERSDB @"CWOrders"
#define CWOPERATIONSDB @"Operations"

//#define POSITIONSDB @"Positions"
//#define OPENORDERSDB  @"Openorders"
//#define PCORDERSDB @"PcOrders"

//Type of Data Operations

#define GETORDERS 1
#define COMMIT 2
#define GETPORDERS 3
#define CONFIRMPICK 4
#define GETCWORDERS 5
#define COMPLETEOPERATION 6
#define GETDRAWINGPATH 7

@interface ConstantDefines : NSObject

@end
