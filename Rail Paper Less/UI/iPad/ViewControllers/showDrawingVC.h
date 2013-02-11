//
//  showDrawingVC.h
//  Rail Paper Less
//
//  Created by Mahi on 10/12/12.
//
//

#import <UIKit/UIKit.h>

@interface showDrawingVC : UIViewController<UIWebViewDelegate>
{
    IBOutlet UINavigationBar* header;
    IBOutlet UIWebView* drawingView;
    IBOutlet UIActivityIndicatorView* loadingIndicator;
    
    NSString* pathForDrawing;
    NSString* itemNumber;
}

@property(nonatomic,retain)UINavigationBar* header;
@property(nonatomic,retain)UIWebView* drawingView;
@property(nonatomic,retain)UIActivityIndicatorView* loadingIndicator;
@property(nonatomic,retain)NSString* itemNumber;


-(id)initWithDrawingPath:(NSString*)path;

@end
