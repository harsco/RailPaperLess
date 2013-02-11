//
//  userInputCWVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInputVC.h"

@interface userInputCWVC : userInputVC
{
    IBOutlet UITabBarController* rootTabCWController;
    
}

@property(nonatomic,retain)UITabBarController* rootTabCWController;

@end
