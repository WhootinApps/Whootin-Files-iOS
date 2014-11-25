//
//  WMFFolderViewController.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 6/5/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "WMFSecondFolderViewController.h"
#import "WMFPopViewController.h"

#define ASSET_PHOTO_THUMBNAIL           0
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1
#define ASSET_PHOTO_SCREEN_SIZE         2
#define ASSET_PHOTO_FULL_RESOLUTION     3



@interface WMFFolderViewController : UIViewController<QBImagePickerControllerDelegate,WMFPopViewControllerDelegate>
{
    //SQlite
    sqlite3 *contactDB;
    NSString *databaseName;
    NSString *databasePath;
    NSArray *aray;
    
    NSMutableArray *mu_tweetarray;
    NSArray *arayCreated;
    NSArray *arayCreatedZ;
    
    __weak IBOutlet UIView *viw_folderLow;
  
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

     NSMutableArray *mu_dirnames;
    NSMutableArray *mu_fileNames_Con;
    NSMutableArray *mu_fileId_Con;
    NSMutableArray *mu_fileType_Con;
    NSMutableArray *mu_filesize_Con;
    NSMutableArray *mu_filecreated_Con;
    NSMutableArray *mu_fileUrl_Con;
    NSMutableArray *mu_fileDownUrl_con;

    NSMutableArray *mu_AssestValues;
    NSMutableArray *mu_backmovefolders;
    
    UIRefreshControl  *refreshControl;

     MBProgressHUD *hud;
    
    BOOL nonClicking;
    __weak IBOutlet UIView *viw_20gbupgrade;
    WMFPopViewController *popview;
   
    __weak IBOutlet UIView *viw_NewFolder_Creations;
    UIFont *textFont;
    
    BOOL folderCreateornot;
}

//Folder DB KEY MY Own Created
@property (nonatomic, strong, readonly) ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong)NSString *folderKeys;
@property (weak, nonatomic) IBOutlet UIButton *btn_folder_Done;
- (IBAction)btn_folder_Done:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPaths;

@property (nonatomic, strong) NSString *folderId;
@property (weak, nonatomic) IBOutlet UITextField *txt_folderId_view;
@property (strong, nonatomic) NSString  *idValue;
@property (strong, nonatomic) NSString  *idValuesecond;
@property (strong,nonatomic)NSString *fileIdFormtb;
@property(nonatomic,strong)NSOperationQueue *labelCell;
@property(nonatomic,strong)NSCache *labelCache;
@property(nonatomic,strong)NSString *IdOfAllValues;
@property (strong, nonatomic) NSString  *idValuesecondPassFromPopview;

- (IBAction)btn_ok_folder:(id)sender;
- (IBAction)btn_ok_Upload:(id)sender;

- (IBAction)btn_upgradeUp:(id)sender;

- (IBAction)btn_upgradeClose:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *img_upgrades;
- (IBAction)btn_uploadsAfter_Cancel:(id)sender;
- (IBAction)btn_createAfter_Cancel:(id)sender;

@end
