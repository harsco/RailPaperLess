//
//  BackLogOrders.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App_TableViewController.h"
#import "OrderDetailsVC.h"
#import "backLogOrderDetailsVC.h"

@interface BackLogOrders : App_TableViewController<dataSourceDelegate>
{
    Order* order;
}

@end
