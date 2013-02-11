//
//  dummyLoginView.m
//  Germanium
//
//  Created by SadikAli on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dummyLoginView.h"

@implementation dummyLoginView

@synthesize useridtext,passwordtext;
@synthesize sigInButton,cancelButton;


- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {               
        CGRect iframe = CGRectMake(21.0, 78.0, 244.0, 31.0);
        useridtext = [[UITextField alloc] initWithFrame:iframe];

        useridtext.textAlignment = UITextAlignmentLeft;
        useridtext.borderStyle = UITextBorderStyleRoundedRect;
        useridtext.placeholder = @"Picked Location";
        useridtext.autocapitalizationType = UITextAutocapitalizationTypeNone;
        useridtext.autocorrectionType = UITextAutocorrectionTypeNo;
        useridtext.keyboardType = UIKeyboardTypeDefault;
        useridtext.returnKeyType = UIReturnKeyNext;
        useridtext.delegate = self;

        
        [useridtext setClearButtonMode:UITextFieldViewModeWhileEditing];
        [useridtext setKeyboardAppearance:UIKeyboardAppearanceAlert];
         [useridtext addTarget:self action:@selector(useridtextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];  
        [self addSubview:useridtext];
        
        //Password input text field.
        CGRect pframe = CGRectMake(21.0, 120.0, 244.0, 31.0);
        passwordtext = [[UITextField alloc] initWithFrame:pframe];
        
        passwordtext.textAlignment = UITextAlignmentLeft;
        passwordtext.borderStyle = UITextBorderStyleRoundedRect;
        passwordtext.placeholder = @"Picked Qty";
        passwordtext.autocapitalizationType = UITextAutocapitalizationTypeNone;
        passwordtext.keyboardType = UIKeyboardTypeNumberPad;
        passwordtext.returnKeyType = UIReturnKeyDone;
       // passwordtext.secureTextEntry = TRUE;
        passwordtext.delegate = self;
        [passwordtext setClearButtonMode:UITextFieldViewModeWhileEditing];
        [passwordtext setKeyboardAppearance:UIKeyboardAppearanceAlert];
        
         [passwordtext addTarget:self action:@selector(passwordtextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];  
        [self addSubview:passwordtext];
        
        // add label for checkbox //////////////////////////////////
//        UILabel *lblRememberPwd = [[UILabel alloc] initWithFrame:CGRectMake(26, 134,170, 16)];
//        [lblRememberPwd setFont:[UIFont systemFontOfSize:14]];
//        [lblRememberPwd setTextColor:[UIColor whiteColor]];
//        [lblRememberPwd setBackgroundColor:[UIColor clearColor]];
//        [lblRememberPwd setText:@"Keep me signed-in"];
//        [self addSubview:lblRememberPwd];
//        
        UILabel *lblRememberMsg = [[UILabel alloc] initWithFrame:CGRectMake(26, 154,230, 86)];
        [lblRememberMsg setFont:[UIFont systemFontOfSize:13]];
        [lblRememberMsg setTextColor:[UIColor whiteColor]];
        [lblRememberMsg setBackgroundColor:[UIColor clearColor]];
        [lblRememberMsg setText:@" Please enter the new parameters and press Done!!"];
        [lblRememberMsg setNumberOfLines:4];
        [self addSubview:lblRememberMsg];
//        
//        //Switch control for Remember password
//        rememberSwitch= [[UISwitch alloc]initWithFrame:CGRectMake(178, 128,10, 14)];
//        [self addSubview:rememberSwitch];
        //Forgot userid or password
        
//        CGRect fframe = CGRectMake(14, 226,210, 36);
//        UIButton *forgotPwdBtn = [[UIButton alloc] initWithFrame:fframe ];
//        forgotPwdBtn.frame = fframe;
//        [forgotPwdBtn setTitle:@"Forgot User ID or Password" forState:UIControlStateNormal ];
//        forgotPwdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [forgotPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
//        [forgotPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted ];
//        
//        [forgotPwdBtn addTarget:self action:@selector(forgotPwd:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:forgotPwdBtn];
//        
        keyboardShown = NO;
        
    } 
    return self; 

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    keyboardShown = YES;
    return YES;
}

- (IBAction)useridtextFieldDone:(id)sender {
	//[sender resignFirstResponder];
    if ([useridtext.text length] < 1){
        
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Empty Picked Location." delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }
    [useridtext resignFirstResponder];
    
	NSLog(@"Log");
}

- (IBAction)passwordtextFieldDone:(id)sender {
	if ([passwordtext.text length] < 1){
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Empty Picked Qty" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    }
    NSLog(@"Log");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"Keyboard Done Pressed");
	
	
	if (textField == useridtext )
	{
		//[ passwordtext  becomeFirstResponder ];
		
	}
	else
	{
        
		[textField resignFirstResponder];
        [ self resignFirstResponder ];
        
//        if (textField==passwordtext) {
//            [ self dismissWithClickedButtonIndex:0 animated:YES ];
//            
//            if (self.delegate)
//            {
//                [self.delegate alertView:self clickedButtonAtIndex: 0 ];    
//            }
//            
//        }
        
	}
    
	return YES;
}



- (void)setFrame:(CGRect)rect {        
    
    
    [super setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 320)]; 
    
    if( !keyboardShown ) {
        
        CGRect cgRect =[[UIScreen mainScreen] bounds];
        CGSize cgSize = cgRect.size;
        self.center = CGPointMake(cgSize.width/2.0, cgSize.height/2.0); 
        
    }
    
} 

- (void)drawRect:(CGRect)rect {         
    [super drawRect:rect];         
}

- (void)layoutSubviews {
    for (UIView *view in self.subviews) {
        NSString *viewType = [[view class] description];
        if ([viewType isEqualToString:@"UIThreePartButton"] || [viewType isEqualToString:@"UIAlertButton"]) {
            int newY = ((self.bounds.size.height - view.frame.size.height) - 15);
            if ( [[ view title ] isEqualToString:@"Sign In" ] )
            {
                signInButton = view;
            }
            else
            {
                cancelButton = view;
            }
            view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height);
        }
    }
}



@end
