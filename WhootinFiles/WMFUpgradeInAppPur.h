//
//  WMFUpgradeInAppPur.h
//  WHOOTIN:-)
//
//  Created by Nua i7 on 6/3/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface WMFUpgradeInAppPur : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
    UIActivityIndicatorView *activityIndicatorView;
    __weak IBOutlet UIView *viw_cardnumber;
    
   
}
-(void)fetchAvailableProducts;
-(BOOL)canMakePurchase;
-(void)purchaseMyProduct:(SKProduct *)product;

@property (strong,nonatomic) NSString *uploadSizes;
@property (strong,nonatomic) NSString *planeName;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_cardnumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_expdate;
@property (weak, nonatomic) IBOutlet UITextField *txt_cvcnumber;
@property (strong,nonatomic) NSString *advanceplans;

@property (weak, nonatomic) IBOutlet UIButton *btn_best_upgrade;
- (IBAction)btn_best_upgrade:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_close_upgrade;
- (IBAction)btn_close_upgrade:(id)sender;
//Upgrade
- (IBAction)btn_TenYear:(id)sender;
- (IBAction)btn_TweYear:(id)sender;
- (IBAction)btn_four:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_TenYear;
@property (weak, nonatomic) IBOutlet UIButton *btn_TweYear;
@property (weak, nonatomic) IBOutlet UIButton *btn_four;

@property (weak, nonatomic) IBOutlet UIImageView *imgV_one;
@property (weak, nonatomic) IBOutlet UIImageView *imgV_two;
@property (weak, nonatomic) IBOutlet UIImageView *imgV_three;
@end
