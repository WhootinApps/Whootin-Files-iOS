//
//  WMFFIrstTableViewController.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/16/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFSecondViewController.h"
#import "QBImagePickerController.h"
#import "LeveyPopListView.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "RNGridMenu.h"
#import "WMFPopViewController.h"
#import "WMFFolderViewController.h"
#import "WMFSecondFolderViewController.h"
#import "WMFChooseLocationViewController.h"
#import "SListView.h"
#import "SListViewCell.h"
#import "WMFWhootingSettingViewController.h"
#import "Reachability.h"

#define ASSET_PHOTO_THUMBNAIL           0
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1
#define ASSET_PHOTO_SCREEN_SIZE         2
#define ASSET_PHOTO_FULL_RESOLUTION     3
@interface WMFFIrstTableViewController : UIViewController<QBImagePickerControllerDelegate,LeveyPopListViewDelegate,MFMailComposeViewControllerDelegate,MBProgressHUDDelegate,RNGridMenuDelegate,SListViewDelegate, SListViewDataSource>
{
    
    
    //Reachability Class Creation
    Reachability *reach;
    
    
   //Array For Retri Datas
    NSMutableArray *mu_fileNames_Con;
    NSMutableArray *mu_fileId_Con;
    NSMutableArray *mu_fileType_Con;
    NSMutableArray *mu_filesize_Con;
    NSMutableArray *mu_filecreated_Con;
    NSMutableArray *mu_fileUrl_Con;
    NSMutableArray *mu_fileDownUrl_con;

    
    //Result Story Array
    NSMutableArray *mu_fileNames_send;
    NSMutableArray *mu_fileId_send;
    NSMutableArray *mu_fileType_send;
    NSMutableArray *mu_filesize_send;
    NSMutableArray *mu_filecreated_send;
    NSMutableArray *mu_filedownload_send;
    NSMutableArray *filesharingurl_send;
    
    
    //Result Story Array Spliting
    NSMutableArray *mu_notFolder_send;
    NSMutableArray *mu_FolderAndFileComb_Send;
    
    NSMutableArray *mu_notFolderTime_send;
    NSMutableArray *mu_FolderAndFileCombTime_send;
    
    NSMutableArray *mu_notFolderId_send;
    NSMutableArray *mu_FolderAndFileCombId_send;
    
    NSMutableArray *mu_notFolderType_send;
    NSMutableArray *mu_FolderAndFileCombType_send;
    
    NSMutableArray *mu_notFolderSize_send;
    NSMutableArray *mu_FolderAndFileCombSize_send;
    
    NSMutableArray *mu_notFolderCreated_send;
    NSMutableArray *mu_FolderAndFileCombCreated_send;
    
    NSMutableArray *mu_notFolderDownload_send;
    NSMutableArray *mu_FolderAndFileCombDownload_send;
    
    NSMutableArray *mu_notFolderURL_send;
    NSMutableArray *mu_FolderAndFileCombURL_send;
    
    
    NSMutableDictionary *storeFiles;
    
    
    
    __weak IBOutlet UIView *viw_line;
    
    NSMutableArray *mu_fileUrl_Select_Con;
    NSArray *aray;
    NSArray *arayCreated;
    NSArray *arayCreatedZ;
    NSData *imgData;
    
    UIView *Share_Views;
    UIView *rename_views;
    UITextField *txt_Rename;
    UIView *secondview;
    UIButton *btnclose;
    UIButton *btnsend;
    
    NSMutableArray *theArray;
    
    
    //SQlite
    sqlite3 *contactDB;
    NSString *databaseName;
    NSString *databasePath;
    
    
    
    NSDictionary *dict;
    
    
    UIButton *btn_mail_pop;
    UIButton *btn_facebook_pop;
    UIButton *btn_tweet_pop;
    UIButton *btn_export_pop;
    
    UIButton *btnshare;
    UIButton *btnsharingCancel;

    UIView *secondviews;
    UITextField *txtfoldername;
    UILabel *lbl;
    UIImageView *im_secondview;
    UIImageView *im_secondview_sendlogo;
    UIRefreshControl  *refreshControl;
    
    __weak IBOutlet UIView *viw_whootinfiles;
    __weak IBOutlet UIView *viw_whootindelete;
    __weak IBOutlet UIView *viw_whootinexports;
    LeveyPopListView *lplv;
    MBProgressHUD *hud;
    
    
    __weak IBOutlet UIView *viw_sharing;
    
    //popupRedBar
    __weak IBOutlet UIView *vie_popupRed;
    BOOL boviepopupRed;
    BOOL boaligntype;
    BOOL boalignalpha;
    BOOL boaligntime;
    BOOL viwsharing_check;
    
    WMFPopViewController *popview;
    WMFFolderViewController *popfolderview;
    WMFSecondFolderViewController *pops;
    WMFWhootingSettingViewController *popSettings;
    
    NSMutableArray *mu_tweetarray;
    
    __weak IBOutlet UIView *viw_shaDelrenexport;
    __weak IBOutlet UIView *viw_sharingDelete;
    __weak IBOutlet UIView *viw_20sharing;
    
    
    
    //Horizontal List
    __weak IBOutlet UIView *viw_HorizontalList;
    
    
    
}
#pragma mark ********Log Out Button*********
@property (weak, nonatomic) IBOutlet UIButton *btn_logout;
- (IBAction)btn_logout:(id)sender;
#pragma mark ********SecondVIewController*********
@property(nonatomic,strong)WMFSecondViewController *secondviewController;
@property (strong, nonatomic) WMFChooseLocationViewController *chooseLocation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSOperationQueue *labelCell;
@property(nonatomic,strong)NSCache *labelCache;
@property (nonatomic) IBOutlet UINavigationController *navigationController;


@property (strong,nonatomic) NSString *uploadSizes;
@property (strong,nonatomic) NSString *planeName;

@property(strong,nonatomic) NSString *getUrlValues;

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) NSArray *options;
@property (strong,nonatomic)NSString *strs;
@property (strong,nonatomic)NSString *fileId;
@property (strong,nonatomic)NSString *filetypes;
@property (strong,nonatomic)NSString *fileNames;
@property (strong,nonatomic)NSString *fileDownload;

@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (nonatomic,assign) BOOL checkValueSet;
@property (weak, nonatomic) IBOutlet UITextField *txt_whootin_rename;
@property (weak, nonatomic) IBOutlet UIButton *btn_whootinrename_cancel;
- (IBAction)btn_whootinrename_cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_whootinrename_rename;
- (IBAction)btn_whootinrename_rename:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_delete_no;

- (IBAction)btn_delete_no:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete_del;

- (IBAction)btn_delete_del:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_delete_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_save_file;
- (IBAction)btn_save_file:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_save_Email;
- (IBAction)btn_save_Email:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_newfolder_firstviw;
- (IBAction)btn_newfolder_firstviw:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_Upload_firstviw;
- (IBAction)btn_Upload_firstviw:(id)sender;

//POPUPVIEW
- (IBAction)btn_trigger_align:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_align_alpha;
- (IBAction)btn_align_alpha:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_align_Time;
- (IBAction)btn_align_Time:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_align_filetype;
- (IBAction)btn_align_filetype:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txt_extbox;

//Main Share Delete Rename Export
@property (weak, nonatomic) IBOutlet UIButton *btn_main_share;
- (IBAction)btn_main_share:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_main_delete;
- (IBAction)btn_main_delete:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_main_rename;
- (IBAction)btn_main_rename:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_main_export;
- (IBAction)btn_main_export:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_20Gb_Close;
- (IBAction)btn_20Gb_Close:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *img_20gb;

@property (weak, nonatomic) IBOutlet UIButton *btn_cancel_upgrade;
- (IBAction)btn_cancel_upgrade:(id)sender;

//Folder DB KEY
@property (nonatomic,strong)NSString *folderKeys;
- (void)handleOpenURL:(NSURL *)url;
@property (weak, nonatomic) IBOutlet UIImageView *img_upgrades;
- (IBAction)btn_cancel_export:(id)sender;
- (IBAction)btn_barSettings:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_barSettings;
@end
