//
//  WMFSecondFolderViewController.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 6/6/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyPopListView.h"
#import <MessageUI/MessageUI.h>
#import "QBImagePickerController.h"
#import "RNGridMenu.h"
#import "MBProgressHUD.h"
#import "WMFFolderViewController.h"


#define ASSET_PHOTO_THUMBNAIL           0
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1
#define ASSET_PHOTO_SCREEN_SIZE         2
#define ASSET_PHOTO_FULL_RESOLUTION     3


@interface WMFSecondFolderViewController : UIViewController<LeveyPopListViewDelegate,QBImagePickerControllerDelegate,MFMailComposeViewControllerDelegate,RNGridMenuDelegate>

{
    
    IBOutlet UIView *viw_one;
    //Array For Retri Datas
    NSMutableArray *mu_fileNames_Con_Second;
    NSMutableArray *mu_fileId_Con_Second;
    NSMutableArray *mu_fileType_Con_Second;
    NSMutableArray *mu_filesize_Con_Second;
    NSMutableArray *mu_filecreated_Con_Second;
    NSMutableArray *mu_fileUrl_Con_Second;
    NSMutableArray *mu_fileDownUrl_con_Second;
    NSMutableArray *mu_fileParent_con_Second;
    
    //Result Story Array
    NSMutableArray *mu_fileNames_send_Second;
    NSMutableArray *mu_fileId_send_Second;
    NSMutableArray *mu_fileParentId_send_Second;
    NSMutableArray *mu_fileType_send_Second;
    NSMutableArray *mu_filesize_send_Second;
    NSMutableArray *mu_filecreated_send_Second;
    NSMutableArray *mu_filedownload_send_Second;
    NSMutableArray *filesharingurl_send_Second;
    NSMutableArray *mu_fileUrl_Select_Con;
    NSMutableArray *mu_idfile;
    NSMutableArray *mu_backmovefolders;
    
    UIView *Share_Views;
    UIView *rename_views;
    UITextField *txt_Rename;
    UIView *secondview;
    UIButton *btnclose;
    UIButton *btnsend;
    
    __weak IBOutlet UIView *viw_sharedlink;
    __weak IBOutlet UIView *viw_Deleted;
    
    __weak IBOutlet UIView *viw_Rename;
    __weak IBOutlet UIView *viw_Export;
    
    //Arrays
    NSArray *aray;
    NSArray *arayCreated;
    NSArray *arrayss;
    NSArray *arayCreatedZ;

    BOOL val;
    BOOL valcheck;
    
    //SQlite
    sqlite3 *contactDB;
    NSString *databaseName;
    NSString *databasePath;
    NSData *imgData;
    
    UIView *secondviews;
    UITextField *txtfoldername;
    UILabel *lbl;
    UIImageView *im_secondview;
    UIImageView *im_secondview_sendlogo;
    
    LeveyPopListView *lplv;
    NSMutableArray *myArray;
    
    __weak IBOutlet UIView *viw_alignment;
    BOOL boviepopupRed;
    BOOL boaligntype;
    BOOL boalignalpha;
    BOOL boaligntime;
    MBProgressHUD *hud;
    
    //Final Result Store
    NSMutableArray *mu_tweetarray;
    NSMutableArray *mu_tweetarrayrow;
    NSMutableArray *mu_dirnames;
    
    UIRefreshControl  *refreshControl;
    
    
    NSMutableArray *mu_FolderAndFileCombDownload_send;
    NSMutableArray *mu_notFolderDownload_send;
    
    __weak IBOutlet UIView *viw_sharedel;
    BOOL bosharedel;
    BOOL valuesForFolderreturn;
    __weak IBOutlet UIView *viw_upgrade_20gb;
    __weak IBOutlet UIView *viw_folderLow;
    __weak IBOutlet UIView *viw_Upgrade;
    __weak IBOutlet UIView *viw_CreatedFolder;
    
    UIFont *textFont;
    
}
@property(nonatomic,strong)NSOperationQueue *labelCell;
@property(nonatomic,strong)NSCache *labelCache;

@property (strong,nonatomic)  NSMutableString *str_parentId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPath;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPaths;

@property (strong, nonatomic) NSString  *idValue;

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) NSArray *options;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Deleted_view;

@property (strong,nonatomic)NSString *strs;
@property (strong,nonatomic)NSString *fileId;
@property (strong,nonatomic)NSString *filetypes;
@property (strong,nonatomic)NSString *fileNames;
@property (strong,nonatomic)NSString *fileDownload;
@property (strong,nonatomic)NSString *fileIdFormtb;

@property (strong,nonatomic)NSString *createornot;
@property (strong,nonatomic)NSString *checkinsert;

- (IBAction)btn_mail:(id)sender;
- (IBAction)btn_facebook:(id)sender;
- (IBAction)btn_tiwtter:(id)sender;
- (IBAction)btn_send_cancel:(id)sender;

- (IBAction)btn_Deleted_del:(id)sender;
- (IBAction)btn_Deleted_no:(id)sender;
- (IBAction)btn_rename_cancel:(id)sender;
- (IBAction)btn_rename_ren:(id)sender;

- (IBAction)btn_Export_InStore:(id)sender;
- (IBAction)btn_Export_Email:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt_view_Rename;

@property (weak, nonatomic) IBOutlet UIButton *btn_newFolder_secondtbl;
- (IBAction)tn_newFolder_secondtbl:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tn_newFolder_secondtbl;
- (IBAction)btn_Upload_secondtbl:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_alpha;
- (IBAction)btn_alpha:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_time;

- (IBAction)btn_time:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_type;
- (IBAction)btn_type:(id)sender;

- (IBAction)btn_tigalignment_viw:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_main_share;
@property (weak, nonatomic) IBOutlet UIButton *btn_main_delete;
@property (weak, nonatomic) IBOutlet UIButton *btn_main_rename;
@property (weak, nonatomic) IBOutlet UIButton *btn_main_export;


- (IBAction)btn_upgrade_20gbclose:(id)sender;

- (IBAction)btn_main_rename:(id)sender;

- (IBAction)btn_main_share:(id)sender;

- (IBAction)btn_main_delete:(id)sender;
- (IBAction)btn_main_export:(id)sender;
//Folder DB KEY
@property (nonatomic,strong)NSString *folderKeys;

@property (weak, nonatomic) IBOutlet UITextField *txt_extenison;

- (IBAction)btn_dismiss_dones:(id)sender;

- (IBAction)btn_ok_folderUploads:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt_folderUpload;
- (IBAction)btn_Gallary_Upload:(id)sender;

- (IBAction)btn_back_objects:(id)sender;


//Upgrade
- (IBAction)btn_upgradeViewUp:(id)sender;

- (IBAction)btn_upgrade_Cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *img_upgrade;


- (IBAction)viw_UploadsAfter_Creat:(id)sender;

- (IBAction)viw_NewFolders_Create:(id)sender;



@end
