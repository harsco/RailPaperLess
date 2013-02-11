//
//  dummyLoginView.h
//  Germanium
//
//  Created by SadikAli on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface dummyLoginView : UIAlertView<UITextFieldDelegate>
{
    UITextField *useridtext;
    UITextField *passwordtext;
    UIView *signInButton;
    UIView *cancelButton;
    
    BOOL keyboardShown;

}

@property (nonatomic, retain)  UITextField *useridtext;
@property (nonatomic,retain)  UITextField *passwordtext;
@property (nonatomic,retain) UIView *sigInButton;
@property (nonatomic,retain) UIView *cancelButton;


@end
