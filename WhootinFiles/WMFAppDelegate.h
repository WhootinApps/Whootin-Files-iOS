//
//  WMFAppDelegate.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/16/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFFIrstTableViewController.h"
#import "KKPasscodeLock.h"
@interface WMFAppDelegate : UIResponder <UIApplicationDelegate,KKPasscodeViewControllerDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WMFFIrstTableViewController *WMFFirstTable;
@property (strong,nonatomic) NSString *uploadSizes;
@property (strong,nonatomic) NSString *planeName;
@property (nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) WMFChooseLocationViewController *chooseLocation;
@end
