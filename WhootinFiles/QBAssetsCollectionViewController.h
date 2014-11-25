//
//  QBAssetsCollectionViewController.h
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
// ViewControllers
#import "QBImagePickerController.h"
#import "WMFPopViewController.h"
#import "WMFFolderViewController.h"

@class QBAssetsCollectionViewController;

@protocol QBAssetsCollectionViewControllerDelegate <NSObject>

@optional
- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didSelectAsset:(ALAsset *)asset;
- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didDeselectAsset:(ALAsset *)asset;
- (void)assetsCollectionViewControllerDidFinishSelection:(QBAssetsCollectionViewController *)assetsCollectionViewController;
- (void)assetsCollectionViewControllerFolder:(QBAssetsCollectionViewController *)imagePickerController didBoolSelect:(BOOL)cancelbool;
@end
@interface QBAssetsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate>

{
    
    UIView *firstview;
    UIView *secondview;
    UITextField *txtfoldername;
    UILabel *lbl;
    UIButton *btnclose;
    UIButton *btnsend;
    UIImageView *im_secondview;
    UIImageView *im_secondview_sendlogo;
    
     UITextField *txt_Rename;
    UIButton *btnsendfilecreation;
    
    
    
    //File Arrays;
    NSMutableArray *mu_fileNames_Con;
    NSMutableArray *mu_fileId_Con;
    NSMutableArray *mu_fileType_Con;
    NSMutableArray *mu_filesize_Con;
    NSMutableArray *mu_filecreated_Con;
    NSMutableArray *mu_fileUrl_Con;
    NSMutableArray *mu_fileUrl_Select_Con;
    
    
    NSMutableArray *mu_fileNames_Con_Second;
    NSMutableArray *mu_fileId_Con_Second;
    NSMutableArray *mu_fileType_Con_Second;
    NSMutableArray *mu_filesize_Con_Second;
    NSMutableArray *mu_filecreated_Con_Second;
    NSMutableArray *mu_fileUrl_Con_Second;
    NSMutableArray *mu_fileDownUrl_con_Second;
    NSMutableArray *mu_fileParent_con_Second;
    NSMutableArray *mu_fileUrl_Select_Cons;
    
    
     NSMutableArray *mu_fileDownUrl_con;
    
    //SQlite
    sqlite3 *contactDB;
    NSString *databaseName;
    NSString *databasePath;

    
    WMFPopViewController *popview;
    WMFFolderViewController *popfolderview;
    
    MBProgressHUD *hud;
    UIButton *placeBtn;
    
}
@property (nonatomic, weak) QBImagePickerController *imagePickerController;
@property (nonatomic, weak) id<QBAssetsCollectionViewControllerDelegate> delegate;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, assign) QBImagePickerControllerFilterType filterType;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, strong, readonly) NSMutableSet *selectedAssetURLs;
@property (nonatomic, strong, readonly) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAsset *assetssValues;
@property (nonatomic, strong) NSString *folderId;
@property (nonatomic, strong) NSString *folderIdFolding;

//Folder DB KEY MY Own Created
@property (nonatomic,strong)NSString *folderKeys;



- (void)selectAssetHavingURL:(NSURL *)URL;

@end
