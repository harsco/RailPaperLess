//
//  AppDelegate.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "Reachability.h"
#import "NetwrokErrorVC.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability* reachability;
    BOOL isFirstTime;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginVC *viewController;
//@property (strong, nonatomic) ViewController *viewController;

@end
