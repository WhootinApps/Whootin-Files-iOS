//
//  WMFUpgradeInAppPur.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 6/3/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "WMFUpgradeInAppPur.h"
#import "PlacesParser.h"
#import "RageIAPHelper.h"
#define kTutorialPointProductID @"Whoot_Good"
@interface WMFUpgradeInAppPur ()
{
NSArray *_products;
NSTimer *schedulerTimer;
}
@end

@implementation WMFUpgradeInAppPur

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   /* _products = nil;
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
    {
        if (success)
        {
            _products = products;
                }
    }];*/
    [self GetUserInfo];
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = self.view.center;
    activityIndicatorView.color = [UIColor greenColor];
    [activityIndicatorView hidesWhenStopped];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    _btn_TenYear.hidden = YES;
    _btn_TweYear.hidden = YES;
    _btn_four.hidden = YES;
    [self fetchAvailableProducts];
    
}
- (void)viewWillAppear:(BOOL)animated
{
 //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [self GetUserInfo];
    [self imageShaw];
    [self dataupdate];
}
- (void)viewWillDisappear:(BOOL)animated
{
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchAvailableProducts
{
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                  @"Back_best",
                                  @"Back_better",
                                  @"Back_good",
                                  nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}
- (void)purchaseMyProduct:(SKProduct*)product{
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}
- (IBAction)btn_best_upgrade:(id)sender
{
    NSLog(@"BackUp_My_Files Post Calling");
    
}
- (IBAction)btn_close_upgrade:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 😗**************Status Bar Hidden**************👿
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (IBAction)btn_TenYear:(id)sender
{
    /*NSString *sUserDefault =kAccessToken;
    NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/private/subscribe.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    PlacesParser *oParser = [PlacesParser new];
    User *oUSer = [oParser getUserInfo];
    [defaults setObject:oUSer.sId forKey:@"UserId"];
    [defaults setObject:oUSer.sUsername forKey:@"Username"];
    [defaults setObject:oUSer.sName forKey:@"Name"];
    [defaults setObject:oUSer.sProfileImg forKey:@"ProfileImg"];

    //132331
    //change type to POST  (default is GET)
    [request setHTTPMethod:@"POST"];
    NSLog(@"body made");
    //NSString *fl = [NSString stringWithFormat:@"%@",_txt_folderUpload.text];
    NSString *params=@"name=Good&type=whootinfiles";
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    //[request setHTTPBody:postBody];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", sUserDefault] forHTTPHeaderField:@"Authorization"];
    NSLog(@"body set");
    // pointers to some necessary objects
    //  NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
    //  NSError* error = [[NSError alloc] init] ;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"just sent request");
    //this will set the image when loading is finished
    // convert data into string
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                      encoding:NSUTF8StringEncoding];
    NSLog(@"Data Receied%@",responseString);
    NSString *newStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *json=[newStr JSONValue];
    NSLog(@"JSON :%@",json);*/
   /* NSURL *postURL = [[NSURL alloc] initWithString:@"https://ssl.sendinvoic.es/?plan_id=Whootin.com_Bronze&user_id=5&name=Pete&email=pete@gmail.com&redirect_url=http:\\whootin.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                      encoding:NSUTF8StringEncoding];
    NSLog(@"Data Receied%@",responseString);
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = self.view.center;
    [activityIndicatorView hidesWhenStopped];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    SKProduct *product = [_products objectAtIndex:0];
    NSLog(@"Buying %@...", product.productIdentifier);
    [[RageIAPHelper sharedInstance] buyProduct:product];*/
    [self purchaseMyProduct:[validProducts objectAtIndex:2]];
    NSLog(@"Back_good");
}
- (IBAction)btn_TweYear:(id)sender
{
    /*SKProduct *product = [_products objectAtIndex:2];
    NSLog(@"Buying %@...", product.productIdentifier);
    [[RageIAPHelper sharedInstance] buyProduct:product];*/
    
    
    [self purchaseMyProduct:[validProducts objectAtIndex:1]];
    
    NSLog(@"Back_better");
 
}
- (IBAction)btn_four:(id)sender
{
    /*SKProduct *product = [_products objectAtIndex:1];
    NSLog(@"Buying %@...", product.productIdentifier);
    [[RageIAPHelper sharedInstance] buyProduct:product];*/
    
    
   [self purchaseMyProduct:[validProducts objectAtIndex:0]];
   
    NSLog(@"Back_best");
    
  
}
-(void)imageShaw
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {

        if([_planeName isEqualToString:@"Good"])
        {
            _btn_TenYear.enabled = NO;
            _imgV_one.image = [UIImage imageNamed:@"upgrade_20_sha.png"];
            
        }
        else if ([_planeName isEqualToString:@"Better"])
        {
            _btn_TweYear.enabled=NO;
            _btn_TenYear.enabled = NO;
            _imgV_one.image = [UIImage imageNamed:@"upgrade_20_sha.png"];
            _imgV_two.image = [UIImage imageNamed:@"upgrade_100_sha.png"];
        }
        else if ([_planeName isEqualToString:@"Best"])
        {
            _btn_TenYear.enabled = NO;
            _btn_TweYear.enabled=NO;
            _btn_four.enabled = NO;
            _imgV_one.image = [UIImage imageNamed:@"upgrade_20_sha.png"];
            _imgV_two.image = [UIImage imageNamed:@"upgrade_100_sha.png"];
            _imgV_three.image = [UIImage imageNamed:@"upgrade_1TB_sha.png"];
        }
        else
        {
            
        }
    }
    else
    {
        if([_planeName isEqualToString:@"Good"])
        {
            _btn_TenYear.enabled = NO;
            _imgV_one.image = [UIImage imageNamed:@"ipad_upgrade_20_dum.png"];
            
        }
        else if ([_planeName isEqualToString:@"Better"])
        {
            _btn_TweYear.enabled=NO;
            _btn_TenYear.enabled = NO;
            _imgV_one.image = [UIImage imageNamed:@"ipad_upgrade_20_dum.png"];
            _imgV_two.image = [UIImage imageNamed:@"ipad_upgrade_100_dum.png"];
        }
        else if ([_planeName isEqualToString:@"Best"])
        {
            _btn_TenYear.enabled = NO;
            _btn_TweYear.enabled=NO;
            _btn_four.enabled = NO;
            _imgV_one.image = [UIImage imageNamed:@"ipad_upgrade_20_dum.png"];
            _imgV_two.image = [UIImage imageNamed:@"ipad_upgrade_100_dum.png"];
            _imgV_three.image = [UIImage imageNamed:@"ipad_upgrade_1TB_dum.png"];
        }
        else
        {
            
        }

    }
    
   }
#pragma mark StoreKit Delegate
-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                activityIndicatorView = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                activityIndicatorView.center = self.view.center;
                activityIndicatorView.color = [UIColor greenColor];
                [activityIndicatorView hidesWhenStopped];
                [self.view addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];

                NSLog(@"Purchasing Finishing");
                break;
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:@"Back_good"])
                {
                    [self whootinFilesSubscribe:@"Good"];
                    _btn_TenYear.enabled = NO;
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        _imgV_one.image = [UIImage imageNamed:@"upgrade_20_sha.png"];
                    }
                    else
                    {
                         _imgV_one.image = [UIImage imageNamed:@"ipad_upgrade_20_dum.png"];
                    }
                    NSDate *today = [[NSDate alloc] init];
                    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setYear:1];
            NSDate *nextYear = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:[NSString stringWithFormat:@"%@",nextYear] forKey:@"ten"];
                    [prefs synchronize];
                    
                    _advanceplans = [NSString stringWithFormat:@"one"];
                    
                    NSLog(@"Purchased ");
                    [activityIndicatorView stopAnimating];
                }
                else if ([transaction.payment.productIdentifier
                          isEqualToString:@"Back_better"])
                {
                [self whootinFilesSubscribe:@"Better"];
                    _btn_TweYear.enabled=NO;
                    _btn_TenYear.enabled = NO;
                    
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        _imgV_one.image = [UIImage imageNamed:@"upgrade_20_sha.png"];
                        _imgV_two.image = [UIImage imageNamed:@"upgrade_100_sha.png"];
                    }
                    else
                    {
                        _imgV_one.image = [UIImage imageNamed:@"ipad_upgrade_20_dum.png"];
                        _imgV_two.image = [UIImage imageNamed:@"ipad_upgrade_100_dum.png"];

                    }
                    NSDate *today = [[NSDate alloc] init];
                    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setYear:1];
                    NSDate *nextYear = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:[NSString stringWithFormat:@"%@",nextYear] forKey:@"tew"];
                    [prefs synchronize];
                    
                     _advanceplans = [NSString stringWithFormat:@"two"];
                    [activityIndicatorView stopAnimating];
                NSLog(@"Purchased ");
                }
                else if ([transaction.payment.productIdentifier
                          isEqualToString:@"Back_best"])
                {
                [self whootinFilesSubscribe:@"Best"];
                    _btn_TenYear.enabled = NO;
                    _btn_TweYear.enabled=NO;
                    _btn_four.enabled = NO;
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        _imgV_one.image = [UIImage imageNamed:@"upgrade_20_sha.png"];
                        _imgV_two.image = [UIImage imageNamed:@"upgrade_100_sha.png"];
                        _imgV_three.image = [UIImage imageNamed:@"upgrade_1TB_sha.png"];
                    }
                    else
                    {
                        _imgV_one.image = [UIImage imageNamed:@"ipad_upgrade_20_dum.png"];
                        _imgV_two.image = [UIImage imageNamed:@"ipad_upgrade_100_dum.png"];
                        _imgV_three.image = [UIImage imageNamed:@"ipad_upgrade_1TB_dum.png"];
                    }
                    NSDate *today = [[NSDate alloc] init];
                    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setYear:1];
                    NSDate *nextYear = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:[NSString stringWithFormat:@"%@",nextYear] forKey:@"four"];
                    [prefs synchronize];
                     _advanceplans = [NSString stringWithFormat:@"three"];
                    [activityIndicatorView stopAnimating];
                NSLog(@"Purchased ");
                }
                else
                {
                    
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                
                if (transaction.error.code != SKErrorPaymentCancelled)
                {
                    [activityIndicatorView stopAnimating];
                }
                
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Purchasing failed");
                break;
                
            default:
                break;
        }
    }
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count>0)
    {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
    }
    else
    {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
    [activityIndicatorView stopAnimating];
    _btn_TenYear.hidden = NO;
    _btn_TweYear.hidden = NO;
    _btn_four.hidden = NO;
}
-(void)whootinFilesSubscribe :(NSString *)name
{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
    NSString *sUserDefault =kAccessToken;
    NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/private/subscribe.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    //132331
    //change type to POST  (default is GET)
    [request setHTTPMethod:@"POST"];
    NSLog(@"body made");
    //NSString *fl = [NSString stringWithFormat:@"%@",_txt_folderUpload.text];
    NSString *params=[NSString stringWithFormat:@"name=%@&type=whootinfiles",name];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    //[request setHTTPBody:postBody];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", sUserDefault] forHTTPHeaderField:@"Authorization"];
    NSLog(@"body set");
    // pointers to some necessary objects
    //  NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
    //  NSError* error = [[NSError alloc] init] ;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"just sent request");
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                    encoding:NSUTF8StringEncoding];
    NSLog(@"Data Receied%@",responseString);
    NSString *newStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *json=[newStr JSONValue];
    NSLog(@"JSON :%@",json);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)GetUserInfo
{
    //dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // dispatch_async(concurrentQueue, ^{
    NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/user.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
    //  dispatch_async(dispatch_get_main_queue(), ^{
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
    // convert data into string
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                      encoding:NSUTF8StringEncoding];
    NSLog(@"Data Receied%@",responseString);
    NSString *newStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *json=[newStr JSONValue];
    NSLog(@"JSON :%@",json);
    _uploadSizes = [json valueForKey:@"uploads_total_size"];
    _planeName = [json valueForKeyPath:@"plan.name"];
    NSLog(@"Name SS:%@",[json valueForKeyPath:@"plan.name"]);
    // });
    // });
}
-(void)dataupdate
{
    NSString *getDates;
    NSUserDefaults *prefsr = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    if([_advanceplans isEqualToString:@"one"])
    {
        getDates = [prefsr stringForKey:@"ten"];
        NSLog(@"Date Ten:%@",getDates);
    }
    else if([_advanceplans isEqualToString:@"two"])
    {
        getDates = [prefsr stringForKey:@"tew"];
        NSLog(@"Date Tew:%@",getDates);
    }
    else if ([_advanceplans isEqualToString:@"three"])
    {
         getDates = [prefsr stringForKey:@"four"];
        NSLog(@"Date Four:%@",getDates);
    }
    else
    {
        
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:getDates];
    schedulerTimer=[[NSTimer alloc] initWithFireDate:dateFromString interval:0 target:self selector:@selector(recordByScheduler) userInfo:nil repeats:false];
    
}
-(void)recordByScheduler
{
_btn_TenYear.enabled = YES;
_btn_TweYear.enabled=YES;
_btn_TenYear.enabled=YES;
_btn_TweYear.enabled=YES;
_btn_four.enabled = YES;
_imgV_one.image = [UIImage imageNamed:@"Upgrade-20GB.png"];
_imgV_two.image = [UIImage imageNamed:@"Upgrade-100GB.png"];
_imgV_three.image = [UIImage imageNamed:@"Upgrade-1TB.png"];
[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ten"];
[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"tew"];
[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"four"];
}
@end
