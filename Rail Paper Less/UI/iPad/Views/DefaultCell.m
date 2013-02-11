//
//  DefaultCell.m
//  Xenon
//
//  Created by Mahendra on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultCell.h"

@implementation DefaultCell
@synthesize cellText;
@synthesize cellSubText;

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
    
    UIView* selectedView = [[UIView alloc] init];
    
    
   // selectedView.backgroundColor = [UIColor colorWithRed:0.6 green: 0.8 blue:0 alpha:1];
    
    selectedView.backgroundColor = [UIColor colorWithRed:0.80 green:0.94 blue:1 alpha:1];
    [self setSelectedBackgroundView:selectedView];
    [selectedView release];
    
}

- (void) initVars
{
    UIImage *myImage = [[UIImage imageNamed:@"list_item_bg"] stretchableImageWithLeftCapWidth:160
                                                                               topCapHeight:25];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
    myImageView.frame = self.frame;
    [self setBackgroundView:myImageView];
    [myImageView release];
    
}


@end
