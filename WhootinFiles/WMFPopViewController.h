//
//  WMFPopViewController.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/20/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"

@class WMFPopViewController;
@protocol WMFPopViewControllerDelegate <NSObject>
@optional
- (void)WMFPopViewControllerDidFinishSelection:(WMFPopViewController *)assetsCollectionViewController;
@end



@interface WMFPopViewController : UIViewController<QBImagePickerControllerDelegate>

{
__weak IBOutlet UILabel *labels_Val;
    
    
    UILabel *lbels;
    
    NSMutableArray *mu_names;
    NSMutableArray *mu_names_files;
    //SQlite
    sqlite3 *contactDB;
    NSString *databaseName;
    NSString *databasePath;
    __weak IBOutlet UISlider *slider_animation;
    NSTimer *timers;
    
    UIFont *textFont;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPath;
@property (nonatomic, weak) id<WMFPopViewControllerDelegate> delegate;
@property (strong,nonatomic) NSMutableArray *mu_name;
@property (strong,nonatomic) NSString *nsname;
@property (strong,nonatomic) ALAsset *assests;

-(void)name:(NSMutableArray *)jj;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pathNames;
@property (weak, nonatomic) IBOutlet UITextField *txt_pathnames;

@property (strong,nonatomic) NSString *checkpoint;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

@property(strong,nonatomic) NSString *newvFolderId;

@property (strong,nonatomic)NSString *allFilesUploads;

@end
