//
//  WMFAppDelegate.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/16/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "WMFAppDelegate.h"
#import "WMFFIrstTableViewController.h"
#import "RageIAPHelper.h"
@implementation WMFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Override point for customization after application launch.
    [self GetUserInfo];
    [self imageShaw];
    sleep(5);
    if (kAccessToken)
    {
        //If KAccessToken Value store call this Value
        UIStoryboard *storyboard=nil;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            
            if(result.height==568)
            {
                storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone5" bundle:nil];
            }
            else
            {
                storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            }
        }
        else
        {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        }
        _WMFFirstTable = [storyboard instantiateViewControllerWithIdentifier:@"FirstView"];
        self.window =[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        _navigationController = [[UINavigationController alloc] initWithRootViewController:_WMFFirstTable];
        self.window.rootViewController = _navigationController;
        [self.window makeKeyAndVisible];
    }
    else
    {
        NSLog(@"Access Token Null");
        UIStoryboard *mainStoryboard = nil;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //UIStoryboard *storyBoard;
            
            CGSize result = [[UIScreen mainScreen] bounds].size;
            //CGFloat scale = [UIScreen mainScreen].scale;
            //result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height==568)
            {
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone5" bundle:nil];
            }
            else
            {
                NSLog(@"gj");
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            }
        }
        else
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        }
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
        [self.window makeKeyAndVisible];
    }
    _navigationController.navigationBarHidden = YES;
   // [[UINavigationBar appearance] setFrame:CGRectMake(10,0,320,500)];
    //UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 0, 120, 150) ];
   // titleView.image = [[UIImage imageNamed:@"tab_bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
   // [[UINavigationBar appearance] setBackgroundImage:titleView.image forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *gradientImage44 = [[UIImage imageNamed:@"tab_bar.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                       forBarMetrics:UIBarMetricsDefault];
    
    
    
    _navigationController.navigationBar.tintColor = [UIColor colorWithRed:26
                                               green:143
                                                blue:99
                                               alpha:1.0f];
    
       return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    exit(0);
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        vc.mode = KKPasscodeModeEnter;
        vc.delegate = self;
        dispatch_async(dispatch_get_main_queue(),^ {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.navigationBar.barStyle = UIBarStyleBlack;
                nav.navigationBar.opaque = NO;
            }
            else
            {
                nav.navigationBar.tintColor = _navigationController.navigationBar.tintColor;
                nav.navigationBar.translucent = _navigationController.navigationBar.translucent;
                nav.navigationBar.opaque = _navigationController.navigationBar.opaque;
                nav.navigationBar.barStyle = _navigationController.navigationBar.barStyle;
            }
            [_navigationController presentViewController:nav animated:YES completion:nil];
        });
        
    }
}
- (void)shouldEraseApplicationData:(KKPasscodeViewController*)viewController
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have entered an incorrect passcode too many times. All account data in this app has been deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)didPasscodeEnteredIncorrectly:(KKPasscodeViewController*)viewController
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have entered an incorrect passcode too many times." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //[_WMFFirstTable handleOpenURL:url];
    
   
    return YES;
}*/
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (url){
        
        _WMFFirstTable.getUrlValues = @"YesUrl";
        
        _navigationController.navigationBarHidden = YES;
        //this is not the way to display this on the screen
        //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
        
        UIStoryboard *mainStoryboard = nil;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //UIStoryboard *storyBoard;
            
            CGSize result = [[UIScreen mainScreen] bounds].size;
            //CGFloat scale = [UIScreen mainScreen].scale;
            //result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height==568)
            {
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone5" bundle:nil];
            }
            else
            {
                NSLog(@"gj");
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            }
        }
        else
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        }
        self.chooseLocation = [mainStoryboard instantiateViewControllerWithIdentifier:@"savetoDropbox"];
        self.chooseLocation.fileLocations = [NSString stringWithFormat:@"%@",url];
        self.chooseLocation.fileLocationsUrl = url;
        dispatch_async(dispatch_get_main_queue(),^ {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: self.chooseLocation];
            nav.navigationBarHidden = YES;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                /*nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.navigationBar.barStyle = UIBarStyleBlack;
                nav.navigationBar.opaque = NO;*/
            }
            else
            {
                nav.navigationBar.tintColor = _navigationController.navigationBar.tintColor;
                nav.navigationBar.translucent = _navigationController.navigationBar.translucent;
                nav.navigationBar.opaque = _navigationController.navigationBar.opaque;
                nav.navigationBar.barStyle = _navigationController.navigationBar.barStyle;
            }
            [_navigationController presentViewController:nav animated:YES completion:nil];
        });

        
        
        //[_navigationController presentViewController:nav animated:YES completion:nil];
        NSLog(@"url recieved: %@", url);
        NSLog(@"query string: %@", [url query]);
        NSLog(@"host: %@", [url host]);
        NSLog(@"url path: %@", [url path]);
       
    }
    return YES;
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
-(void)imageShaw
{
    if([_planeName isEqualToString:@"Good"]||[_planeName isEqualToString:@"Better"]||[_planeName isEqualToString:@"Best"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
        
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"one" forKey:@"upgrades"];
        [prefs synchronize];
        
    }
    
}

@end
