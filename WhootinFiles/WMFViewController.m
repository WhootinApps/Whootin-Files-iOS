//  OM Shiva
//  WMFViewController.m
//  WHOOTIN:-)
//  Created by Nua on 5/16/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.


#import "WMFViewController.h"
#import "PlacesParser.h"
#import "WMFSignupViewController.h"
#import "MMReachabilityViewController.h"
@interface WMFViewController ()

@end

@implementation WMFViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///use transform
    theAnimation.duration=0.4;
    theAnimation.repeatCount=2;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:-20];
    [_img_jumpeffects.layer addAnimation:theAnimation forKey:@"animateTranslation"];
    //_img_jumpeffects.transform = transform;
    
    
   // _txt_login_username.font = [UIFont fontWithName:@"Segoe UI" size:30];
}
-(void) viewWillAppear:(BOOL)animated
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///use transform
    theAnimation.duration=0.4;
    theAnimation.repeatCount=2;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:-20];
    [_img_jumpeffects.layer addAnimation:theAnimation forKey:@"animateTranslation"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ************Text Fields****************
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_txt_login_username])
    {
        CGRect frame;
        frame =[self.view  frame];
        frame.origin.y=-80;
        [self slideUpDown:self.view withFrame:frame];
        
        
        _txt_login_password.layer.masksToBounds=YES;
        _txt_login_password.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_login_password.layer.borderWidth= 1.0f;
        
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[UIColor whiteColor]CGColor];
        textField.layer.borderWidth= 1.0f;
        
        
    }
    if ([textField isEqual:_txt_login_password])
    {
        CGRect frame;
        frame =[self.view  frame];
        frame.origin.y=-100;
        [self slideUpDown:self.view withFrame:frame];
        
        
        _txt_login_username.layer.masksToBounds=YES;
        _txt_login_username.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_login_username.layer.borderWidth= 1.0f;
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[UIColor whiteColor]CGColor];
        textField.layer.borderWidth= 1.0f;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_txt_login_username])
    {
        CGRect frame;
        frame =[self.view  frame];
        frame.origin.y=0;
        [self slideUpDown:self.view withFrame:frame];
       
    }
    if ([textField isEqual:_txt_login_password])
    {
        CGRect frame;
        frame =[self.view  frame];
        frame.origin.y=0;
        [self slideUpDown:self.view withFrame:frame];
    
    }
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
    textField.layer.borderWidth= 1.0f;
    return YES;
}
- (IBAction) textFieldReturn:(id)sender
{
	[sender resignFirstResponder];
}
#pragma mark ***********SlideUp Down***************
-(void)slideUpDown:(UIView*)view withFrame:(CGRect)frame
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [view setFrame:frame];
    [UIView commitAnimations];
}
#pragma mark **************Login UI*******************
- (IBAction)btn_login_signin:(id)sender
{
    if ([self internetConnection]==YES)
    {
        [self showAlertView:@"Internet Connection"  Message:@"No Internet Connection"];
    }
    else
    {
    //Login Functions
    [self whootinLoginFunc];
    }
}
- (IBAction)btn_login_signup:(id)sender
{
}
#pragma mark ************Rotate**************
-(BOOL)shouldAutorotate
{
    return YES;
}
#pragma mark **************Status Bar Hidden**************
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark <<<++==++==InterNet Connection==++==++>>>
-(BOOL)internetConnection
{
    BOOL valss = NO;
    reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    if (remoteHostStatus==NotReachable)
    {
        valss = YES;
    }
    return valss;
}
-(void)showAlertView:(NSString *)titleName Message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titleName message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    
    [alert show];
}



#pragma mark **************Alert Box*******************
-(void)showAlertBox:(NSString *)title alertBoxMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark ***********Whootin:-)Methods***********
-(void)whootinLoginFunc
{
    if ((_txt_login_password.text.length==0)||(_txt_login_username.text.length==0))
    {
        if(_txt_login_username.text.length==0)
        {
            [self showAlertBox:@"SignIn" alertBoxMessage:@"Username Missing"];
        }
        else if (_txt_login_password.text.length==0)
        {
            [self showAlertBox:@"SignIn" alertBoxMessage:@"Password Missing"];
        }
    }
    else
    {
        NSString *theURLString = @"http://whootin.com/oauth/token";
        NSURL *theURL = [[NSURL alloc]initWithString:[theURLString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:theURL];
        NSString *theMessage = [NSString stringWithFormat:@"grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@",WH_CLIENT_ID,WH_CLIENT_SECRET,_txt_login_username.text,_txt_login_password.text];
        NSString *theMessageLength = [[NSString alloc]initWithFormat:@"%lu",(unsigned long)[theMessage length]];
        [theRequest addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:[theMessage dataUsingEncoding:NSUTF8StringEncoding]];
        [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL];   NSString *newStr = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary *json = [newStr JSONValue];
        NSLog(@"value:%@",json);
        NSString *sError = [json objectForKey:@"error"];
        if(sError==nil)
        {
            NSLog(@"Access_Token:%@",[json objectForKey:@"access_token"]);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[json objectForKey:@"access_token"] forKey:@"ACCESS_TOKEN"];
            PlacesParser *oParser = [PlacesParser new];
            User *oUSer = [oParser getUserInfo];
            [defaults setObject:oUSer.sId forKey:@"UserId"];
            [defaults setObject:oUSer.sUsername forKey:@"Username"];
            [defaults setObject:oUSer.sName forKey:@"Name"];
            [defaults setObject:oUSer.sProfileImg forKey:@"ProfileImg"];
            [defaults synchronize];
            [defaults objectForKey:@"UserId"];
            NSLog(@"success");
            //@@@@@@@@ Gallery View  Moving ########
            
            /*UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
             SMFGalleryViewController *smfgalleryviewCont = [storyboard instantiateViewControllerWithIdentifier:@"FirstView"];
             [self presentViewController:smfgalleryviewCont animated:YES completion:nil];*/
            
            hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.mode = MBProgressHUDModeDeterminate;
            hud.labelText = @"Please Wait";
            [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
            [hud show:YES];
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
            dispatch_async(downloadQueue, ^{[NSThread sleepForTimeInterval:2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        CGSize result = [[UIScreen mainScreen] bounds].size;
                        if(result.height==568)
                        {
                            [self GetUserInfo];
                            [self imageShaw];
                            [self performSegueWithIdentifier:@"openingView5" sender:self];
                            
                        }
                        else
                        {
                            NSLog(@"gj");
                            [self GetUserInfo];
                            [self imageShaw];
                            [self performSegueWithIdentifier:@"openingView" sender:self];
                            
                        }
                        
                    }
                    else
                    {
                        [self GetUserInfo];
                        [self imageShaw];
                        [self performSegueWithIdentifier:@"ipadopeningView" sender:self];
                    }
                });
            });
        }
        else
        {
            [self showAlertBox:@"Sign In" alertBoxMessage:@"Username or Password wrong"];
        }
    }
}
- (void)doSomeFunkyStuff
{
    float progress = 0.0;
    
    while (progress < 1.0)
    {
        progress += 0.01;
        hud.progress = progress;
        usleep(50000);
    }
}
- (IBAction)btn_signup:(id)sender
{
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
    WMFSignupViewController *WMFFirstTable = [storyboard instantiateViewControllerWithIdentifier:@"signuppage"];
    [self presentViewController:WMFFirstTable animated:YES completion:Nil];
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
