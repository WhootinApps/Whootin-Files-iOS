//
//  WMFViewController.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/16/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "MMReachabilityViewController.h"
@interface WMFViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate>
{
    
    //Reachability Class Creation
    Reachability *reach;

    //SQlite
    sqlite3 *contactDB;
    NSString *databaseName;
    NSString *databasePath;
    MBProgressHUD *hud;
    
}
#pragma mark ************Login In****************
@property (weak, nonatomic) IBOutlet UITextField *txt_login_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_login_password;
@property (weak, nonatomic) IBOutlet UIButton *btn_login_signin;
@property (weak, nonatomic) IBOutlet UIButton *btn_login_signup;
@property (strong,nonatomic) NSString *uploadSizes;
@property (strong,nonatomic) NSString *planeName;

#pragma mark ****Login In Buttons****
- (IBAction)btn_login_signin:(id)sender;
- (IBAction)btn_login_signup:(id)sender;
#pragma mark ******Jump Effects*******
@property (weak, nonatomic) IBOutlet UIImageView *img_jumpeffects;
#pragma mark ****Sign up Here*****
- (IBAction)btn_signup:(id)sender;
@end
