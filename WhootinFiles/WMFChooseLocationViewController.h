//
//  WMFChooseLocationViewController.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 6/11/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFSecondChooseLocationViewController.h"
#import "WMFPopViewController.h"
@interface WMFChooseLocationViewController : UIViewController
{
    //SQlite
    sqlite3 *contactDB;
    NSString *databaseName;
    NSString *databasePath;
    NSArray *aray;
    NSData *imgData;
    NSMutableArray *mu_tweetarray;
    NSArray *arayCreated;
    NSArray *arayCreatedZ;
    
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
    
    
    NSMutableArray *mu_fileNames_Con;
    NSMutableArray *mu_fileId_Con;
    NSMutableArray *mu_fileType_Con;
    NSMutableArray *mu_filesize_Con;
    NSMutableArray *mu_filecreated_Con;
    NSMutableArray *mu_fileUrl_Con;
    NSMutableArray *mu_fileDownUrl_con;
    
    WMFSecondChooseLocationViewController *pops;
    WMFPopViewController *popview;
    __weak IBOutlet UIView *viw_upgrade_20gbs;
    
    
    __weak IBOutlet UIView *viw_folder_creation;

}
@property (nonatomic,strong)NSString *folderKeys;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_dismiss;
@property (strong, nonatomic) NSString  *idValue;
@property (strong, nonatomic) NSString  *idValuesecond;
@property (strong,nonatomic)NSString *fileIdFormtb;
@property(nonatomic,strong)NSOperationQueue *labelCell;
@property(nonatomic,strong)NSCache *labelCache;
@property(nonatomic,strong)NSString *IdOfAllValues;
@property(nonatomic,strong)NSString *fileLocations;
@property(nonatomic,strong)NSURL *fileLocationsUrl;
@property(nonatomic,strong)NSString *idValuesStore;
@property(nonatomic,strong)NSString *stringCheckings;

- (IBAction)btn_dismiss:(id)sender;
- (IBAction)btn_upgrade:(id)sender;
- (IBAction)btn_upgrade_cancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *img_upgrade_20gb;
- (IBAction)btn_add_whootin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel_whootin;
- (IBAction)btn_cancel_whootin:(id)sender;
- (IBAction)btn_foldercreations:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txt_folder_name;

@property (weak, nonatomic) IBOutlet UIButton *btn_no_folder;
- (IBAction)btn_no_folder:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_yes_folder;
- (IBAction)btn_yes_folder:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel_mainView;
- (IBAction)btn_cancel_mainView:(id)sender;

@end
