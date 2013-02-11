//
//  GridCell.m
//  Rail Paper Less
//
//  Created by SadikAli on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[self initVars];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addColumn:(CGFloat)position {
    [columns addObject:[NSNumber numberWithFloat:position]];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Use the same color and width as the default cell separator for now
  //  CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0);
    CGContextSetRGBStrokeColor(ctx, 2.0, 2.0, 2.0, 3.0);
    
    CGContextSetLineWidth(ctx, 10.0);
    
    for (int i = 0; i < [columns count]; i++) {
        CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
        CGContextMoveToPoint(ctx, f, 0);
        CGContextAddLineToPoint(ctx, f, self.bounds.size.height);
        //CGContextAddLineToPoint(ctx, f, 50);
        
    }
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
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
