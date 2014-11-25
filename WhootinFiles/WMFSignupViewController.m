//
//  WMFSignupViewController.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/22/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "WMFSignupViewController.h"
#import "PlacesParser.h"
#import "WMFFIrstTableViewController.h"

#define kOFFSET_FOR_KEYBOARD 140.0
@interface WMFSignupViewController ()

@end

@implementation WMFSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    datePicker.maximumDate = [NSDate date];
    [_btn_acceptTerm setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    
    web_viewHtml.delegate = self;
    _btn_signup.enabled=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_select_dob:(id)sender
{
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: -13];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: -100];
    NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear:-25];
    NSDate * disDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    datePicker.date = disDate;
    viw_dateofbirth.hidden = NO;
}
- (IBAction)btn_select_cancel:(id)sender
{
     viw_dateofbirth.hidden = YES;
}
- (IBAction)btn_select_set:(id)sender
{
    NSDate *date1=datePicker.date;
    NSDate *now=[NSDate date];
    NSDateComponents *ageComponents=[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date1 toDate:now options:0];
    NSInteger age=[ageComponents year];
    if (age>=13)
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *date2=[dateFormatter stringFromDate:date1];
        
        _txt_dob.text=date2;
        viw_dateofbirth.hidden=YES;
    }
    else
    {
        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"Oven Apprentice" message:@"Your age must be 13 years or older" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert1 show];
        
    }
     viw_dateofbirth.hidden = YES;
}
- (IBAction)btn_signup:(id)sender
{
    
    
    if (_txt_emailid.text.length == 0 || _txt_username.text.length == 0 || _txt_fname.text.length == 0 || _txt_psw.text.length == 0)
    {
		showAlert(@"Please enter all the values.");
	}
    else
    {
        
        if ([self validEmailAddress:_txt_emailid.text])
        {
            
    
        if ([[_txt_psw text] isEqualToString:[_txt_conpsw text]])
        {
            NSString *theURLString = @"http:/whootin.com/api/v1/users/new.json";
            
            NSURL *theURL = [[NSURL alloc] initWithString: [theURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
            
            
            NSString *theMessage =[NSString stringWithFormat: @"username=%@&password=%@&name=%@&email=%@", _txt_username.text, _txt_psw.text, _txt_fname.text, _txt_emailid.text];;
            
            NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
            [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            //  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
            [theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
            [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
            
            NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL];
            
            NSString* newStr = [[NSString alloc] initWithData:response
                                                     encoding:NSUTF8StringEncoding];
            //NSLog(@"Response %@", newStr);
            
            NSDictionary *json = [newStr JSONValue];
            
            //NSLog(@"Value %@", json);
            
            NSString* sError = [json objectForKey:@"error"];
            
            if (sError == nil) {
                
                NSLog(@"Successfully Reg..");
                //			showAlert(@"Successfully Registered.");
                //			UserLogin *oUserLogin = [[UserLogin alloc] initWithNibName:@"UserLogin" bundle:nil];
                //			[self.navigationController pushViewController:oUserLogin animated:NO];
                
                NSString *theURLString = @"http://whootin.com/oauth/token";
                
                NSURL *theURL = [[NSURL alloc] initWithString: [theURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
                
                
                NSString *theMessage = [NSString stringWithFormat: @"grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@",WH_CLIENT_ID, WH_CLIENT_SECRET, _txt_username.text, _txt_psw.text];
                
                NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
                [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                //  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
                [theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
                [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
                
                NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL];
                
                NSString* newStr = [[NSString alloc] initWithData:response
                                                         encoding:NSUTF8StringEncoding];
                //NSLog(@"Response %@", newStr);
                
                NSDictionary *json = [newStr JSONValue];
                
                NSLog(@"Value %@", json);
                
                sError = [json objectForKey:@"error"];
                
                if (sError == nil) {
                    
                    NSLog(@"Succsssfully Logined !...");
                    
                    NSLog(@"access_token %@", [json objectForKey:@"access_token"]);
                    
                    
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:[json objectForKey:@"access_token"] forKey:@"ACCESS_TOKEN"];
                    
                    
                    PlacesParser *oParser = [PlacesParser new];
                    User* oUser = [oParser getUserInfo];
                    [defaults setObject:oUser.sId forKey:@"UserId"];
                    [defaults setObject:oUser.sUsername forKey:@"Username"];
                    [defaults setObject:oUser.sName forKey:@"Name"];
                    [defaults setObject:oUser.sProfileImg forKey:@"ProfileImg"];
                    [defaults synchronize];
                    
                    if (kAccessToken)
                    {
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
                      WMFFIrstTableViewController *WMFFirstTable = [mainStoryboard instantiateViewControllerWithIdentifier:@"FirstView"];
                        hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        //hud.mode = MBProgressHUDModeAnnularDeterminate;
                        hud.mode = MBProgressHUDModeDeterminate;
                        hud.labelText = @"Please Wait.";
                        [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
                        [hud show:YES];
                        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                        dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
                        dispatch_async(downloadQueue, ^{[NSThread sleepForTimeInterval:5];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [hud hide:YES];
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                
                                [self presentViewController:WMFFirstTable animated:YES completion:nil];
                            });
                        });
                    }
                    else
                    {
                        NSLog(@"Not Token");
                    }
                } 
            } 
            
            else 
            {
                NSLog(@"succes");
                
                NSDictionary *details = [json objectForKey:@"details"];
                
                NSArray * arrMessage = [details objectForKey:@"username"];
                NSString* sMessage = @"";
                
                if (arrMessage != nil && arrMessage.count > 0) {
                    sMessage = [NSString stringWithFormat:@"Username %@", [arrMessage objectAtIndex:0]];
                } else {
                    arrMessage = [details objectForKey:@"email"];
                    if (arrMessage != nil && arrMessage.count > 0) 
                        sMessage = [NSString stringWithFormat:@"Email %@", [arrMessage objectAtIndex:0]];
                }
                
                showAlert(sMessage);
                // [self keyboardWillHide];
                [_txt_fname resignFirstResponder];
                [_txt_emailid resignFirstResponder];
                [_txt_username resignFirstResponder];
                [_txt_psw resignFirstResponder];
                
                //[self setViewMovedUp:NO];
                //showAlert(sMessage);
            }
        }
        else
        {
            showAlert(@"Password missmatch");
        }
        }
        else
        {
            showAlert(@"Incorrect E-Mail id");
        }
    }
}
-(BOOL)validEmailAddress:(NSString *)emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[com in net org int edu gov mil ac ad ae at br cu es gb is io la lk pk qa us]$";
    NSRegularExpression *regEX = [[NSRegularExpression alloc]initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEX numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    if(regExMatches==0)
        return NO;
    else
        return YES;
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
- (IBAction)btn_signup_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark **************Status Bar Hidden**************
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(IBAction)textFieldReturn
{
    [_txt_fname resignFirstResponder];
    [_txt_lname resignFirstResponder];
    [_txt_username resignFirstResponder];
    [_txt_emailid resignFirstResponder];
    [_txt_dob resignFirstResponder];
    [_txt_psw resignFirstResponder];
    [_txt_conpsw resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect1=CGRectMake(20,52,291,404);
    scrollSignUp.frame=rect1;
    
    [UIView commitAnimations];
    
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
		mIsKeyBoard = NO;
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
		if (rect.origin.y >= 0) {
			rect.origin.y -= kOFFSET_FOR_KEYBOARD;
			rect.size.height += kOFFSET_FOR_KEYBOARD;
		}
    }
    else
    {
		mIsKeyBoard = YES;
        // revert back to the normal state.
		if (rect.origin.y < 0) {
			rect.origin.y += kOFFSET_FOR_KEYBOARD;
			rect.size.height -= kOFFSET_FOR_KEYBOARD;
		}
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    
    
    
    
    
    
    
    if ([sender isEqual:_txt_emailid])
    {
        CGRect rect1=CGRectMake(20,52,291,404);
        scrollSignUp.frame=rect1;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3]; // if you want to slide up the view
        
        CGRect rect=scrollSignUp.frame;
        rect.origin.y+=-50;
        scrollSignUp.frame=rect;
        
        [UIView commitAnimations];
        
      /*  _txt_username.layer.masksToBounds=YES;
        _txt_username.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_username.layer.borderWidth= 1.0f;
        
        _txt_psw.layer.masksToBounds=YES;
        _txt_psw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_psw.layer.borderWidth= 1.0f;
        
        _txt_conpsw.layer.masksToBounds=YES;
        _txt_conpsw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_conpsw.layer.borderWidth= 1.0f;
        
        
        _txt_lname.layer.masksToBounds=YES;
        _txt_lname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_lname.layer.borderWidth= 1.0f;
        
        _txt_fname.layer.masksToBounds=YES;
        _txt_fname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_fname.layer.borderWidth= 1.0f;
        
        _txt_emailid.layer.masksToBounds=YES;
        _txt_emailid.layer.borderColor=[[UIColor whiteColor]CGColor];
        _txt_emailid.layer.borderWidth= 1.0f;*/
        
        
    }
    else if ([sender isEqual:_txt_username]) {
        
        CGRect rect1=CGRectMake(20,52,291,404);
        scrollSignUp.frame=rect1;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3]; // if you want to slide up the view
        
        CGRect rect=scrollSignUp.frame;
        rect.origin.y+=-50;
        scrollSignUp.frame=rect;
        
        [UIView commitAnimations];
        
       
        
        
    /*    _txt_emailid.layer.masksToBounds=YES;
        _txt_emailid.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_emailid.layer.borderWidth= 1.0f;
        
        _txt_psw.layer.masksToBounds=YES;
        _txt_psw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_psw.layer.borderWidth= 1.0f;
        
        _txt_conpsw.layer.masksToBounds=YES;
        _txt_conpsw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_conpsw.layer.borderWidth= 1.0f;
        
        
        _txt_lname.layer.masksToBounds=YES;
        _txt_lname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_lname.layer.borderWidth= 1.0f;
        
        _txt_fname.layer.masksToBounds=YES;
        _txt_fname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_fname.layer.borderWidth= 1.0f;
        
        
        
        _txt_username.layer.masksToBounds=YES;
        _txt_username.layer.borderColor=[[UIColor whiteColor]CGColor];
        _txt_username.layer.borderWidth= 1.0f;
*/
        
        
        
	}
    else if ([sender isEqual:_txt_psw]) {
        
        CGRect rect1=CGRectMake(20,52,291,404);
        scrollSignUp.frame=rect1;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3]; // if you want to slide up the view
        
        CGRect rect=scrollSignUp.frame;
        rect.origin.y+=-100;
        scrollSignUp.frame=rect;
        
        [UIView commitAnimations];
        
        
 /*
        _txt_emailid.layer.masksToBounds=YES;
        _txt_emailid.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_emailid.layer.borderWidth= 1.0f;
        
        _txt_username.layer.masksToBounds=YES;
        _txt_username.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_username.layer.borderWidth= 1.0f;
        
        _txt_conpsw.layer.masksToBounds=YES;
        _txt_conpsw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_conpsw.layer.borderWidth= 1.0f;
        
        
        _txt_lname.layer.masksToBounds=YES;
        _txt_lname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_lname.layer.borderWidth= 1.0f;
        
        _txt_fname.layer.masksToBounds=YES;
        _txt_fname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_fname.layer.borderWidth= 1.0f;
        
        _txt_psw.layer.masksToBounds=YES;
        _txt_psw.layer.borderColor=[[UIColor whiteColor]CGColor];
        _txt_psw.layer.borderWidth= 1.0f;
        
        */
        
	}
    else if([sender isEqual:_txt_conpsw])
    {
        
        CGRect rect1=CGRectMake(20,52,291,404);
        scrollSignUp.frame=rect1;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3]; // if you want to slide up the view
        
        CGRect rect=scrollSignUp.frame;
        rect.origin.y+=-150;
        scrollSignUp.frame=rect;
        
        [UIView commitAnimations];
        
        
        
  /*      _txt_emailid.layer.masksToBounds=YES;
        _txt_emailid.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_emailid.layer.borderWidth= 1.0f;
        
        _txt_username.layer.masksToBounds=YES;
        _txt_username.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_username.layer.borderWidth= 1.0f;
        
        _txt_psw.layer.masksToBounds=YES;
        _txt_psw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_psw.layer.borderWidth= 1.0f;
        
        
        _txt_lname.layer.masksToBounds=YES;
        _txt_lname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_lname.layer.borderWidth= 1.0f;
        
        _txt_fname.layer.masksToBounds=YES;
        _txt_fname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_fname.layer.borderWidth= 1.0f;
        
        
        _txt_conpsw.layer.masksToBounds=YES;
        _txt_conpsw.layer.borderColor=[[UIColor whiteColor]CGColor];
        _txt_conpsw.layer.borderWidth= 1.0f;
     */
        
    }
    else if([sender isEqual:_txt_fname])
    {
       /* _txt_emailid.layer.masksToBounds=YES;
        _txt_emailid.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_emailid.layer.borderWidth= 1.0f;
        
        _txt_username.layer.masksToBounds=YES;
        _txt_username.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_username.layer.borderWidth= 1.0f;
        
        _txt_psw.layer.masksToBounds=YES;
        _txt_psw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_psw.layer.borderWidth= 1.0f;
        
        
        _txt_conpsw.layer.masksToBounds=YES;
        _txt_conpsw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_conpsw.layer.borderWidth= 1.0f;

        
        
        _txt_lname.layer.masksToBounds=YES;
        _txt_lname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_lname.layer.borderWidth= 1.0f;

        
        
        _txt_fname.layer.masksToBounds=YES;
        _txt_fname.layer.borderColor=[[UIColor whiteColor]CGColor];
        _txt_fname.layer.borderWidth= 1.0f;*/
    }
    
    else if([sender isEqual:_txt_lname])
    {
      /*  _txt_emailid.layer.masksToBounds=YES;
        _txt_emailid.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_emailid.layer.borderWidth= 1.0f;
        
        _txt_username.layer.masksToBounds=YES;
        _txt_username.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_username.layer.borderWidth= 1.0f;
        
        _txt_psw.layer.masksToBounds=YES;
        _txt_psw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_psw.layer.borderWidth= 1.0f;
        
        
        _txt_conpsw.layer.masksToBounds=YES;
        _txt_conpsw.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_conpsw.layer.borderWidth= 1.0f;
        
        
        _txt_fname.layer.masksToBounds=YES;
        _txt_fname.layer.borderColor=[[UIColor clearColor]CGColor];
        _txt_fname.layer.borderWidth= 1.0f;
        
        
        _txt_lname.layer.masksToBounds=YES;
        _txt_lname.layer.borderColor=[[UIColor whiteColor]CGColor];
        _txt_lname.layer.borderWidth= 1.0f;*/
        
        
    }
    
    
}
- (IBAction)btn_acceptTerm:(id)sender
{
    if(_txt_emailid.text.length == 0 || _txt_username.text.length == 0 || _txt_fname.text.length == 0 || _txt_psw.text.length == 0)
    {
		showAlert(@"Please enter all the values.");
	}
    else
    {
    _btn_signup.enabled=YES;
    viw_webviews.hidden=NO;
    viw_webviews.transform = CGAffineTransformMakeScale( 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    NSLog(@"bounce start 1");
    viw_webviews.transform = CGAffineTransformMakeScale( 1.1, 1.1);
    [UIView commitAnimations];
    NSLog(@"Finidhed");
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    
    //web_viewHtml.scalesPageToFit = YES;
    web_viewHtml.contentMode = UIViewContentModeScaleAspectFit;
    path = [thisBundle pathForResource:@"agreement" ofType:@"html"];
    NSURL *instructionsURL = [NSURL fileURLWithPath:path];
    [web_viewHtml loadRequest:[NSURLRequest requestWithURL:instructionsURL]];

   [_btn_acceptTerm setImage:[UIImage imageNamed:@"accept_1.png"] forState:UIControlStateNormal];
    
    NSLog(@"ssss");
    }
}

- (IBAction)btn_closeacceptTerm:(id)sender
{
    viw_webviews.hidden=YES;
}
- (IBAction)btn_privacypolicyTerms:(id)sender
{
    viw_webviews.hidden=NO;
    viw_webviews.transform = CGAffineTransformMakeScale( 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    NSLog(@"bounce start 1");
    viw_webviews.transform = CGAffineTransformMakeScale( 1.1, 1.1);
    [UIView commitAnimations];
    NSLog(@"Finidhed");
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    
    //web_viewHtml.scalesPageToFit = YES;
    web_viewHtml.contentMode = UIViewContentModeScaleAspectFit;
    path = [thisBundle pathForResource:@"terms" ofType:@"html"];
    NSURL *instructionsURL = [NSURL fileURLWithPath:path];
    [web_viewHtml loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
    

}
@end
