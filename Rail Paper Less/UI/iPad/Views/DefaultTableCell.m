//
//  DefaultTableCell.m
//  Rail Paper Less
//
//  Created by SadikAli on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultTableCell.h"

@implementation DefaultTableCell
@synthesize cellOrderNumber;
@synthesize cellStartDate;
@synthesize cellEndDate;
@synthesize cellWC;
@synthesize cellPlanner;
@synthesize priority;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
         [self initVars];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) initVars
{
    UIImage *myImage = [[UIImage imageNamed:@"list_item_bg"] stretchableImageWithLeftCapWidth:160
                                                                               topCapHeight:25];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
    myImageView.frame = self.frame;
    [self setBackgroundView:myImageView];
    [myImageView release];
    //    self.selectionStyle = UITableViewCellSelectionStyleGray;
    //    self.textLabel.backgroundColor = [UIColor clearColor];
    //    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}


@end
