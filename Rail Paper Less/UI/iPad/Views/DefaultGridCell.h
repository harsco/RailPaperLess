//
//  DefaultGridCell.h
//  Rail Paper Less
//
//  Created by SadikAli on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultGridCell : UITableViewCell
{
    IBOutlet UILabel* positionNumber;
    IBOutlet UILabel* item;
    IBOutlet UILabel* description;
    IBOutlet UILabel* pickLocation;
    IBOutlet UILabel* pickqty;
    IBOutlet UILabel* uom;
    IBOutlet UILabel* pickedLocation;
    IBOutlet UILabel* pickedQty;
}

@property(nonatomic,retain)UILabel* positionNumber;
@property(nonatomic,retain)UILabel* item;
@property(nonatomic,retain)UILabel* description;
@property(nonatomic,retain)UILabel* pickLocation;
@property(nonatomic,retain)UILabel* pickqty;
@property(nonatomic,retain)UILabel* uom;
@property(nonatomic,retain)UILabel* pickedLocation;
@property(nonatomic,retain)UILabel* pickedQty;

@end
