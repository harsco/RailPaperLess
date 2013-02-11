//
//  DefaultTableCell.h
//  Rail Paper Less
//
//  Created by SadikAli on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultTableCell : UITableViewCell
{
     IBOutlet UILabel* cellOrderNumber;
     IBOutlet UILabel* cellStartDate;
     IBOutlet UILabel* cellEndDate;
     IBOutlet UILabel* cellWC;
     IBOutlet UILabel* cellPlanner;
     IBOutlet UILabel* priority;
    
}

@property(nonatomic,retain)UILabel* cellOrderNumber;
@property(nonatomic,retain)UILabel* cellStartDate;
@property(nonatomic,retain)UILabel* cellEndDate;
@property(nonatomic,retain)UILabel* cellWC;
@property(nonatomic,retain)UILabel* cellPlanner;
@property(nonatomic,retain)UILabel* priority;

@end
