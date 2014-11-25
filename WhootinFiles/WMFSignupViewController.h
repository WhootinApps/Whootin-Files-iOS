//
//  WMFSignupViewController.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/22/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface WMFSignupViewController : UIViewController<UIWebViewDelegate>
{
    
    __weak IBOutlet UIView *viw_dateofbirth;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UIScrollView *scrollSignUp;
    
    
    
     BOOL mIsKeyBoard;
    
    MBProgressHUD *hud;
    
    __weak IBOutlet UIWebView *web_viewHtml;
    
    __weak IBOutlet UIView *viw_webviews;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_select_dob;
- (IBAction)btn_select_dob:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_select_cancel;
- (IBAction)btn_select_cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_select_set;
- (IBAction)btn_select_set:(id)sender;


#pragma mark *****Button Signup*******
@property (weak, nonatomic) IBOutlet UIButton *btn_signup;
- (IBAction)btn_signup:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_signup_back;
- (IBAction)btn_signup_back:(id)sender;

#pragma mark ****TextView*****
@property (weak, nonatomic) IBOutlet UITextField *txt_fname;
@property (weak, nonatomic) IBOutlet UITextField *txt_lname;
@property (weak, nonatomic) IBOutlet UITextField *txt_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_emailid;
@property (weak, nonatomic) IBOutlet UITextField *txt_dob;
@property (weak, nonatomic) IBOutlet UITextField *txt_psw;
@property (weak, nonatomic) IBOutlet UITextField *txt_conpsw;
@property (weak, nonatomic) IBOutlet UIButton *btn_acceptTerm;
- (IBAction)btn_acceptTerm:(id)sender;
- (IBAction)btn_closeacceptTerm:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_privacypolicyTerms;
- (IBAction)btn_privacypolicyTerms:(id)sender;

@end
