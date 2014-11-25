//
//  WMFWhootingSettingViewController.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 7/1/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "WMFWhootingSettingViewController.h"
#import "PlacesParser.h"
@interface WMFWhootingSettingViewController ()

@end

@implementation WMFWhootingSettingViewController

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
    [self GetUserInfo];
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    databasePath = [[NSString alloc]initWithString: [documentsDirectory stringByAppendingPathComponent:@"whootinfiles.sqlite"]];
    success = [fileManager fileExistsAtPath:databasePath];
    if (success)
    {
        return;
    }
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"whootinfiles.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
    if (!success)
    {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_async(concurrentQueue, ^{
           dispatch_async(dispatch_get_main_queue(), ^{
    NSString *sProfileImg = [kProfileImg stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    profileImage=[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sProfileImg]]];
    self.img_circle.image = profileImage;
    self.img_circle.layer.cornerRadius = self.img_circle.frame.size.width / 2;
    self.img_circle.layer.borderWidth = 3.0f;
    self.img_circle.layer.borderColor = [UIColor colorWithRed:76 green:202 blue:242 alpha:1].CGColor;
    self.img_circle.clipsToBounds = YES;
           });
     });
    
    [self uiDataShowing];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 😗**************Status Bar Hidden**************👿
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
      UILabel *gallery_name = (UILabel *)[cell viewWithTag:1];
      UILabel *name = (UILabel *)[cell viewWithTag:2];
    if(indexPath.row==0)
    {
        gallery_name.text = [NSString stringWithFormat:@"%@",kName];
        name.text = @"Name";
    }
    else if(indexPath.row==1)
    {
        NSString *uploadSizes = [NSString stringWithFormat:@"%@",_uploadSizes];
        NSString *localplanname;
        
        if([_planeName isEqualToString:@"Good"])
        {
            
            localplanname = @"20GB";
        }
        else if ([_planeName isEqualToString:@"Better"])
        {
            localplanname = @"100GB";
        }
        else if ([_planeName isEqualToString:@"Best"])
        {
            localplanname = @"1TB";
        }
         else
        {
            
            localplanname = @"2GB";
        }

        if([uploadSizes integerValue]==1000)
        {
        
        }
        gallery_name.text = [NSString stringWithFormat:@"%@",_uploadSizes];
        name.text = @"Space used";
    }
      return  cell;
}
-(void)uiDataShowing
{
    _lbl_name.text = [NSString stringWithFormat:@"%@",kName];
        NSString *localplanname;
    if([_planeName isEqualToString:@"Good"])
    {
        
        localplanname = @"20GB";
    }
    else if ([_planeName isEqualToString:@"Better"])
    {
        localplanname = @"100GB";
    }
    else if ([_planeName isEqualToString:@"Best"])
    {
        localplanname = @"1TB";
    }
    else
    {
        
        localplanname = @"2GB";
        
    }
    
        _lbl_space.text = [NSString stringWithFormat:@"%@ of %@",[self transformedValue:_uploadSizes],localplanname];
}
- (id)transformedValue:(id)value
{
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB"];
    while (convertedValue > 1024)
    {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%.f%@",floor(convertedValue),tokens[multiplyFactor]];
}
- (id)transformedValuePercentage:(id)value
{
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    //NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB"];
    while (convertedValue > 1024)
    {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%.f",floor(convertedValue)];
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
- (IBAction)btn_percentage:(id)sender
{
    if (clickIma == YES)
    {
        [_btn_percentage setTitle:@"%" forState:UIControlStateNormal];
        NSString *localplanname;
        if([_planeName isEqualToString:@"Good"])
        {
            localplanname = @"20GB";
        }
        else if ([_planeName isEqualToString:@"Better"])
        {
            localplanname = @"100GB";
        }
        else if ([_planeName isEqualToString:@"Best"])
        {
            localplanname = @"1TB";
        }
        else
        {
            localplanname = @"2GB";
        }
         _lbl_space.text = [NSString stringWithFormat:@"%@ of %@",[self transformedValue:_uploadSizes],localplanname];
        CATransition *transition = [CATransition  animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"cube";
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = self;
        [_lbl_space.layer addAnimation:transition forKey:kCATransition];
        clickIma = NO;
    }
    else
    {
        NSString *localplanname;
        NSString *cald;
        double  cals;
        if([_planeName isEqualToString:@"Good"])
        {
            localplanname = @"20GB";
            cald = @"GB";
            cals =1024*20;
        }
        else if ([_planeName isEqualToString:@"Better"])
        {
            localplanname = @"100GB";
            cald = @"GB";
            cals =1024*100;
        }
        else if ([_planeName isEqualToString:@"Best"])
        {
            localplanname = @"1TB";
            cald = @"TB";
            cals =1024*1024;
        }
        else
        {
            localplanname = @"2GB";
            cald = @"GB";
            cals =1024;
        }
        [_btn_percentage setTitle:[NSString stringWithFormat:@"%@",cald] forState:UIControlStateNormal];
        double cal = ([[self transformedValuePercentage:_uploadSizes] doubleValue]/cals)*100;
        _lbl_space.text = [NSString stringWithFormat:@"%.3f%% of %@",cal,localplanname];
        CATransition *transition = [CATransition  animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"cube";
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [_lbl_space.layer addAnimation:transition forKey:kCATransition];
        clickIma = YES;

       
    }
}
- (IBAction)btn_signoutbtns:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ACCESS_TOKEN"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserId"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Username"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ProfileImg"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Name"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIStoryboard* storyboard;
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
    pop_signout = [storyboard instantiateViewControllerWithIdentifier:@"loginViews"];
    [self presentViewController:pop_signout animated:YES completion:NULL];
    [self deleteDataFromDBFirst];

}
-(void)deleteDataFromDBFirst
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinfirst_tbl"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Deleted");
        }
        else
        {
            NSLog(@"Don't Deleted");
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}

- (IBAction)btn_privacypolicy:(id)sender
{
    viw_webs.hidden=NO;
    viw_webs.transform = CGAffineTransformMakeScale( 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    NSLog(@"bounce start 1");
    viw_webs.transform = CGAffineTransformMakeScale( 1.1, 1.1);
    [UIView commitAnimations];
    NSLog(@"Finidhed");
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    //web_viewHtml.scalesPageToFit = YES;
    web_content.contentMode = UIViewContentModeScaleAspectFit;
    path = [thisBundle pathForResource:@"terms" ofType:@"html"];
    NSURL *instructionsURL = [NSURL fileURLWithPath:path];
    [web_content loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
}
- (IBAction)btn_tellfriends:(id)sender
{
    // Email Subject
    NSString *emailTitle = @"Whootin Files";
    NSString *urlNames = @"I've been using Whootin and thought you might like it. It's a free way to bring all your files anywhere and share them easily";
    NSString *links = @"http://whootin.com";
    NSString *emailValue = [NSString stringWithFormat:@"%@  %@",urlNames,links];
    // Email Content
    //NSString *messageBody = @"iOS programming is so fun!";
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:emailValue isHTML:NO];
    [self presentViewController:mc animated:YES completion:NULL];
    

}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btn_help:(id)sender
{
}
- (IBAction)btn_cancel:(id)sender
{
     viw_webs.hidden=YES;
}
- (IBAction)btn_passcodeLock:(id)sender
{
     UIStoryboard* storyboard;
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
    SettingsViewController* settingsViewControllers = [[SettingsViewController alloc]
                                                      initWithNibName:@"SettingsViewController" bundle:nil];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:settingsViewControllers];


    [self presentViewController:navController animated:YES completion:NULL];
}
@end
