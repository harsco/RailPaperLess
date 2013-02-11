//
//  GridCell.h
//  Rail Paper Less
//
//  Created by SadikAli on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCell : UITableViewCell
{
     NSMutableArray *columns;
}

- (void)addColumn:(CGFloat)position;

@end
