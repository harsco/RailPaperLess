//
//  drawingVC.h
//  Rail Paper Less
//
//  Created by SadikAli on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface drawingVC : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView* imageScrollView;
    IBOutlet UIImageView* drawingView;
     IBOutlet UINavigationBar* header;
    
    NSString* ordernumber;
    UIImage* imageForDrawing;
}

@property(nonatomic,retain)UIScrollView* imageScrollView;
@property(nonatomic,retain)UIImageView* drawingView;
@property(nonatomic,retain)UINavigationBar* header;


-(id)initWithOrderNumber:(NSString*)orderNumber;
-(id)initWithImage:(UIImage*)image;

@end
