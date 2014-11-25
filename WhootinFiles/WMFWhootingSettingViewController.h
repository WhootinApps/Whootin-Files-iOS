//
//  WMFWhootingSettingViewController.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 7/1/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "WMFViewController.h"
#import "KKPasscodeViewController.h"
#import "SettingsViewController.h"
@interface WMFWhootingSettingViewController : UIViewController<MFMailComposeViewControllerDelegate,KKPasscodeViewControllerDelegate>
{
    UIImage *profileImage;
    
    BOOL clickIma;
    //SQlite
    sqlite3 *contactDB;
    NSString *databaseName;
    NSString *databasePath;

    SettingsViewController* settingsViewController;
    WMFViewController *pop_signout;
    __weak IBOutlet UIView *viw_webs;
    __weak IBOutlet UIWebView *web_content;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *img_circle;
@property (strong,nonatomic) NSString *uploadSizes;
@property (strong,nonatomic) NSString *planeName;
- (IBAction)btn_back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

@property (weak, nonatomic) IBOutlet UILabel *lbl_space;
- (IBAction)btn_percentage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_percentage;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *btn_signout;
- (IBAction)btn_signoutbtns:(id)sender;
- (IBAction)btn_privacypolicy:(id)sender;
- (IBAction)btn_tellfriends:(id)sender;
- (IBAction)btn_help:(id)sender;
- (IBAction)btn_cancel:(id)sender;
- (IBAction)btn_passcodeLock:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_passcodeLock;

@end
