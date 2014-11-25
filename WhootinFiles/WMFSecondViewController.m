//
//  WMFSecondViewController.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/16/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "WMFSecondViewController.h"
#import "QBAssetsCollectionViewController.h"
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import "NSDate+DateTools.h"
#import "HorizontalCell.h"
#import <QuartzCore/QuartzCore.h>

@interface WMFSecondViewController ()
@property NSDate *selectedDate;
@property NSDateFormatter *formatter;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *colors;
@end
static int didcount;
@implementation WMFSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.colors = [NSMutableArray array];
        for (int i = 0; i < 10; i++)
        {
            [self.colors addObject:[UIColor colorWithRed:rand()/(float)RAND_MAX
                                                   green:rand()/(float)RAND_MAX
                                                    blue:rand()/(float)RAND_MAX
                                                   alpha:1.0f]];
        }

    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        
        
       /* listView = [[SListView alloc] initWithFrame:CGRectMake(0, 200, 320, 500)];
        listView.delegate = self;
        listView.dataSource = self;
        [viw_horiza addSubview:listView];*/
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    arrItems=[[NSArray alloc] initWithObjects:@"Apple", @"Mango", @"Orange", @"Banana", @"Chickoo", @"Black Berry", @"Watermelon", @"Figs" , @"Grapes", @"Papaya" ,@"Olive", @"Dates",  nil];
[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //Horizal
    mu_dirnames = [[NSMutableArray alloc]init];
   [self performSelector:@selector(SListViews) withObject:nil afterDelay:2.0];

    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    /* NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
     [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
     refreshControl.attributedTitle = refreshString; */
    [self.tableView addSubview:refreshControl];
    _labelCell = [[NSOperationQueue alloc]init];
    [_labelCell setMaxConcurrentOperationCount:1];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"upgrades"];
    NSLog(@"NSUserDefaults:%@",myString);
    if ([myString isEqualToString:@"one"])
    {
        viw_upgrade_20gb.hidden=NO;
    }
    else
    {
        viw_upgrade_20gb.hidden=YES;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
    }
    mu_fileNames_send_Second = [[NSMutableArray alloc]init];
    mu_fileId_send_Second = [[NSMutableArray alloc]init];
    mu_fileType_send_Second = [[NSMutableArray alloc]init];
    mu_filesize_send_Second = [[NSMutableArray alloc]init];
    mu_filecreated_send_Second = [[NSMutableArray alloc]init];
    mu_fileId_send_Second = [[NSMutableArray alloc]init];
    filesharingurl_send_Second = [[NSMutableArray alloc]init];
    mu_idfile= [[NSMutableArray alloc]init];
    mu_fileParentId_send_Second= [[NSMutableArray alloc]init];
    
    mu_tweetarray =[[NSMutableArray alloc]init];
    mu_tweetarrayrow =[[NSMutableArray alloc]init];
    mu_FolderAndFileCombDownload_send=[[NSMutableArray alloc]init];
    mu_notFolderDownload_send=[[NSMutableArray alloc]init];
    mu_backmove = [[NSMutableArray alloc]init];
    
     textFont=[UIFont fontWithName:@"Helvetica" size:15.0];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height==568)
        {
            CGPoint oldCenter=_tableViewPath.center;
            _tableViewPath.frame=CGRectMake(0.0, 0.0, _tableViewPath.bounds.size.height-1000, _tableViewPath.bounds.size.width);
            _tableViewPath.transform=CGAffineTransformMakeRotation(-M_PI_2);
            _tableViewPath.center=oldCenter;
        }
        else
        {
            CGPoint oldCenter=_tableViewPath.center;
            _tableViewPath.frame=CGRectMake(0.0, 0.0, _tableViewPath.bounds.size.height-20, _tableViewPath.bounds.size.width);
            _tableViewPath.transform=CGAffineTransformMakeRotation(-M_PI_2);
            _tableViewPath.center=oldCenter;
        }
    }
    else
    {
        CGPoint oldCenter=_tableViewPath.center;
        _tableViewPath.frame=CGRectMake(0.0, 0.0, _tableViewPath.bounds.size.height-1000, _tableViewPath.bounds.size.width);
        _tableViewPath.transform=CGAffineTransformMakeRotation(-M_PI_2);
        _tableViewPath.center=oldCenter;
    }
    _tableViewPath.showsVerticalScrollIndicator = NO;
    _tableViewPath.separatorStyle=UITableViewCellSeparatorStyleNone;
    //myArray = [[NSMutableArray alloc]init];
    boviepopupRed = YES;
    bosharedel=YES;
    //valuesForFolderreturn=YES;
    
    NSLog(@"Idvalues:%@",_idValue);
    //_btn_newFolder_secondtbl.enabled=NO;
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 30)];
    _infoLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_infoLabel];
    _options = [NSArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ic_share.png"],@"img",@"Share",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ic_delete.png"],@"img",@"Delete",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ic_rename.png"],@"img",@"Rename",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ic_export.png"],@"img",@"Export",@"text", nil],
                nil];
    
    _lbl_parentID.text =self.idValue;
     [self updateCurrentTime];
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
-(void)viewDidAppear:(BOOL)animated
{
    
    [self deleteDataFromDBPOP];
    NSLog(@"Checking FOlder Pass OR Not>>>>>:%@",self.idValue);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"upgrades"];
    NSLog(@"NSUserDefaults:%@",myString);
    if ([myString isEqualToString:@"one"])
    {
        viw_upgrade_20gb.hidden=NO;
    }
    else
    {
        viw_upgrade_20gb.hidden=YES;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
    }
    [self whootingGetFiles:self.idValue];
    [self.tableView reloadData];
    [mu_idfile addObject:self.idValue];
    hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Please Wait";
    [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    [hud show:YES];
    //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
    dispatch_async(downloadQueue, ^{[NSThread sleepForTimeInterval:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    });
    }
-(void)reloadDatas
{
    //update here...
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}
-(void)SListViews
{
   /*listViews  = [[SListView alloc] initWithFrame:CGRectMake(0,0,320,30)];
    listViews.delegate = self;
    listViews.dataSource = self;
    [viw_horiza addSubview:listViews];*/
    //configure swipe view
    self.swipeview.alignment = SwipeViewAlignmentCenter;
    self.swipeview.pagingEnabled = YES;
    self.swipeview.wrapEnabled = NO;
    self.swipeview.itemsPerPage = 3;
    self.swipeview.truncateFinalPage = YES;

}
-(void)viewWillAppear:(BOOL)animated
{
   
}
- (void)updateCurrentTime
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        [UIView transitionWithView:_img_upgrades duration:20 options:UIViewAnimationOptionTransitionCrossDissolve   animations:^{
            _img_upgrades.image = [UIImage imageNamed:@"upgradecancel-20GB.png"];
        } completion:^(BOOL done){
            [UIView transitionWithView:_img_upgrades duration:20 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _img_upgrades.image = [UIImage imageNamed:@"upgradecancel-100GB.png"];
            } completion:^(BOOL done){
                [UIView transitionWithView:_img_upgrades duration:20 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    
                    _img_upgrades.image = [UIImage imageNamed:@"upgradecancel-1TB.png"];
                    
                } completion:^(BOOL done){
                    [self updateCurrentTime];
                }];
            }];
        }];
    }
    else
    {
        [UIView transitionWithView:_img_upgrades duration:20 options:UIViewAnimationOptionTransitionCrossDissolve   animations:^{
            _img_upgrades.image = [UIImage imageNamed:@"ipad_upgrade20_cancel.png"];
        } completion:^(BOOL done){
            [UIView transitionWithView:_img_upgrades duration:20 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _img_upgrades.image = [UIImage imageNamed:@"ipad_upgrade100_cancel.png"];
            } completion:^(BOOL done){
                [UIView transitionWithView:_img_upgrades duration:20 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    
                    _img_upgrades.image = [UIImage imageNamed:@"ipad_upgrade1tb_cancel.png"];
                    
                } completion:^(BOOL done){
                    [self updateCurrentTime];
                }];
            }];
        }];
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
#pragma mark ********Tableview****************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Return the number of sections.
    if (tableView == _tableViewPath)
    {
        return 1;
    }
    else
    {
        return 2;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableViewPath)
    {
    //return 100.0f;
    NSString *strCellText=[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"];
    return 50+[strCellText sizeWithFont:textFont].width;
    }
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableViewPath)
    {
        [self SelectDataFromWHootinName_tbl];
        
       return mu_dirnames.count;
    }
    if (section==0)
    {
        return 1;
    }
    else
    {
    [self SelectDataFromDbForSendMeFiles];
    return mu_tweetarray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableViewPath)
    {
    static NSString *identifier=@"reusableIdentifier";
    HorizontalCell *cell=(HorizontalCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(nil==cell)
    {
        cell=[[HorizontalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font=textFont;
        
    }
    NSString *homes = [NSString stringWithFormat:@"%@",[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"]];
    NSString *lastOb = [NSString stringWithFormat:@"%d",[mu_dirnames count]-1];
    NSString *indexGet = [NSString stringWithFormat:@"%d",indexPath.row];
        
    NSLog(@"ValuesKKKKK::::::KK%@",indexGet);
    NSLog(@"ValuesKKKKK::::::KKPPPP%@",lastOb);
        
    if([homes isEqualToString:@"Home"])
     {
        cell.imageView.image = [UIImage imageNamed:@"Shape-4.png"];
         cell.textLabel.text=[NSString stringWithFormat:@"%@ >",[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"]];
        cell.ArrowimageView.image = [UIImage imageNamed:@"Shape-4.png"];
     }
    else if ([indexGet isEqualToString:lastOb])
    {
         cell.imageView.image = [UIImage imageNamed:@"Shape-3.png"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"]];
        cell.ArrowimageView.image = [UIImage imageNamed:@"Shape-3.png"];
    }
    else if (![indexGet isEqualToString:lastOb])
    {
        cell.imageView.image = [UIImage imageNamed:@"Shape-2.png"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ >",[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"]];
        cell.ArrowimageView.image = [UIImage imageNamed:@"Shape-2.png"];
    }
    return cell;
    }
    NSLog(@"TableCellForRowIndexPath");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel *gallery_name = (UILabel *)[cell viewWithTag:1];
    UILabel *gallery_subname = (UILabel *)[cell viewWithTag:7];
    UIImageView *imageviw = (UIImageView *)[cell viewWithTag:3];
    UIButton *btnShare = (UIButton *)[cell viewWithTag:12];
    
    UIView *line = (UIView *)[cell viewWithTag:10];
    [line setBackgroundColor:[UIColor blackColor]];
    
    btnShare.tag = indexPath.row;
    [btnShare addTarget:self action:@selector(btn_Arrow:) forControlEvents:UIControlEventTouchUpInside];
    gallery_name.font = [UIFont fontWithName:@"Segoe UI" size:500];
    gallery_subname.font = [UIFont fontWithName:@"Segoe UI" size:500];
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
        imageviw.image = [UIImage imageNamed:@"btn_uparrow.png"];
        gallery_name.text = @"Up to Whootin Files";
        gallery_subname.text = @" ";
        [btnShare removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        //btnShare.hidden = YES;
       // btnShare.tag = 0;
        }
    }
    else if(indexPath.section==1)
    {
    //btnShare.hidden = NO;
    [self SelectDataFromDbForSendMeFiles];
   /*[temp setObject:filename forKey:@"name"];
    [temp setObject:fid forKey:@"id"];
    [temp setObject:fileType forKey:@"type"];
    [temp setObject:fileSize forKey:@"size"];
    [temp setObject:fileCreated forKey:@"created"];
    [temp setObject:fileSharingURL forKey:@"url"];
    [temp setObject:parentid forKey:@"parentid"];
    [temp setObject:rowid forKey:@"rowid"];*/
    
    gallery_name.text=[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"]];
        
        NSLog(@"Name%@",[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"]]);
        
   //NSLog(@"DownloadUrls:%@",[filesharingurl_send_Second objectAtIndex:indexPath.row]);
    
    _str_parentId = [NSMutableString stringWithFormat:@"%@",[[mu_tweetarray lastObject]objectForKey:@"parentid"]];
    _lbl_parentID_cell.text =[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:0] objectForKey:@"parentid"]];
    NSString *fileIds =[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"parentid"]];
    if([fileIds isEqualToString:@""])
    {
        _fileIdFormtb=[NSString stringWithFormat:@"%@",self.idValue];
    }
    else
    {
       _fileIdFormtb=[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"parentid"]];
    }
    //[mu_idfile addObject:[mu_fileParentId_send_Second lastObject]];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //UIStoryboard *storyBoard;
            imageviw.image = [UIImage imageNamed:@"ico_folder.png"];
        }
        else
        {
            imageviw.image = [UIImage imageNamed:@"Ipad_ico_folder.png"];
        }

    NSString *dateGetFromWoo = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"created"]];
    arayCreated = [dateGetFromWoo componentsSeparatedByString:@"T"];
    //NSLog(@"ArrayCreates:%@",arayCreated[0]);
    NSString *value3 = [NSString stringWithFormat:@"%@",arayCreated[0]];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [NSDate date];
    //NSLog(@"%@",startDate);
    NSDate *endDate = [f dateFromString:value3];
    //NSLog(@"%@",endDate);
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
   // NSLog(@"TU%ld",(long)components.day);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //declare your unitFlags
    int unitFlags = NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit;
    // int unitFlagsmo = NSMonthCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:endDate  toDate:startDate options:0];
    int minFlags =NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSTimeInterval timeSince = [endDate timeIntervalSinceNow];
    int weeksInBetween = [dateComponents week];
    int monthInBetween = [dateComponents month];
    int dayInBetween = [dateComponents day];
    NSInteger secondInBetween = [dateComponents second];
   // NSLog(@"Week Finder:%d",monthInBetween);
    NSString *ext = [NSString stringWithFormat:@"%@",gallery_name.text];
    aray = [ext componentsSeparatedByString:@"."];
    arayCreated = [dateGetFromWoo componentsSeparatedByString:@"T"];
    //NSLog(@"ArrayCreates:%@",arayCreated[0]);
   // NSString *value3 = [NSString stringWithFormat:@"%@",arayCreated[0]];
    NSString *value4    = [NSString stringWithFormat:@"%@",arayCreated[1]];
    arayCreatedZ = [value4 componentsSeparatedByString:@"Z"];
    NSString *value5 =[ NSString stringWithFormat:@"%@",arayCreatedZ[0]];
    NSString *valu3 = [NSString stringWithFormat:@"%@ %@",value3,value5];
    
    NSLog(@"Value^^^^^^^^^^:%@",valu3);
    
    NSString *dateGetFromWoos = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"created"]];
    
    arayCreated = [dateGetFromWoos componentsSeparatedByString:@"T"];
    //NSLog(@"ArrayCreates:%@",arayCreated[0]);
    NSString *value3s = [NSString stringWithFormat:@"%@",arayCreated[0]];

    NSString *value4s    = [NSString stringWithFormat:@"%@",arayCreated[1]];
    arayCreatedZ = [value4 componentsSeparatedByString:@"Z"];
    NSString *value5s =[ NSString stringWithFormat:@"%@",arayCreatedZ[0]];
    NSString *valu3s = [NSString stringWithFormat:@"%@ %@",value3s,value5s];
     NSLog(@"Value^^^^^^^^^^:%@",valu3s);
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.selectedDate = [self.formatter dateFromString:valu3s];
    gallery_subname.text=@" ";
    if (aray.count>=2)
    {
       //NSLog(@"Fixing:%@",aray[1]);
        NSString *fileex = [NSString stringWithFormat:@"%@",aray[1]];
        if([fileex isEqualToString:@"jpg"]||[fileex isEqualToString:@"JPG"]||[fileex isEqualToString:@"png"]||[fileex isEqualToString:@"PNG"]||[fileex isEqualToString:@"jpeg"]||[fileex isEqualToString:@"JPEG"]||[fileex isEqualToString:@"bmp"]||[fileex isEqualToString:@"BMP"]||[fileex isEqualToString:@"svg"]||[fileex isEqualToString:@"SVG"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_images.png"];
        }
        else if ([fileex isEqualToString:@"pdf"]||[fileex isEqualToString:@"PDF"])
        {
            imageviw.image = [UIImage imageNamed:@"ico_pdf.png"];
        }
        else if ([fileex isEqualToString:@"doc"]||[fileex isEqualToString:@"DOC"]||[fileex isEqualToString:@"csv"]||[fileex isEqualToString:@"CSV"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_doc.png"];
        }
        else if([fileex isEqualToString:@"rt"]||[fileex isEqualToString:@"RT"]||[fileex isEqualToString:@"rtf"]||[fileex isEqualToString:@"RTF"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_txt.png"];
        }
        else if ([fileex isEqualToString:@"zip"]||[fileex isEqualToString:@"ZIP"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_zip.png"];
        }
        else if ([fileex isEqualToString:@"ppt"]||[fileex isEqualToString:@"PPT"]||[fileex isEqualToString:@"pptx"]||[fileex isEqualToString:@"PPTX"]||[fileex isEqualToString:@"pptm"]||[fileex isEqualToString:@"PPTM"]||[fileex isEqualToString:@"pot"]||[fileex isEqualToString:@"POT"]||[fileex isEqualToString:@"potx"]||[fileex isEqualToString:@"POTX"]||[fileex isEqualToString:@"pps"]||[fileex isEqualToString:@"PPSX"]||[fileex isEqualToString:@"ppsm"]||[fileex isEqualToString:@"PPSM"])
        {
            imageviw.image = [UIImage imageNamed:@"ico_ppt.png"];
        }
        else if ([fileex isEqualToString:@"mp4"]||[fileex isEqualToString:@"MP4"]||[fileex isEqualToString:@"avi"]||[fileex isEqualToString:@"AVI"]||[fileex isEqualToString:@"flv"]||[fileex isEqualToString:@"FLV"]||[fileex isEqualToString:@"3gp"]||[fileex isEqualToString:@"3GP"]||[fileex isEqualToString:@"MPEG"]||[fileex isEqualToString:@"mpeg"]||[fileex isEqualToString:@"mkv"]||[fileex isEqualToString:@"MKV"]||[fileex isEqualToString:@"mov"]||[fileex isEqualToString:@"MOV"]||[fileex isEqualToString:@"WMV"]||[fileex isEqualToString:@"WMV"]||[fileex isEqualToString:@"ASF"]||[fileex isEqualToString:@"ASF"])
        {
            imageviw.image = [UIImage imageNamed:@"ico_video.png"];
        }
        else if ([fileex isEqualToString:@"mp3"]||[fileex isEqualToString:@"MP3"]||[fileex isEqualToString:@"mp2"]||[fileex isEqualToString:@"MP2"]||[fileex isEqualToString:@"WAV"]||[fileex isEqualToString:@"wav"]||[fileex isEqualToString:@"aac"]||[fileex isEqualToString:@"AAC"]||[fileex isEqualToString:@"ac3"]||[fileex isEqualToString:@"AC3"]||[fileex isEqualToString:@"midi"]||[fileex isEqualToString:@"MIDI"]||[fileex isEqualToString:@"aif"]||[fileex isEqualToString:@"AIF"]||[fileex isEqualToString:@"AIFC"]||[fileex isEqualToString:@"aifc"]||[fileex isEqualToString:@"aiff"]||[fileex isEqualToString:@"AIFF"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_audio.png"];
        }
        else if ([fileex isEqualToString:@"xlsx"]||[fileex isEqualToString:@"XLSX"]||[fileex isEqualToString:@"xls"]||[fileex isEqualToString:@"XLS"]||[fileex isEqualToString:@"xlam"]||[fileex isEqualToString:@"XLAM"]||[fileex isEqualToString:@"xltm"]||[fileex isEqualToString:@"XLTM"]||[fileex isEqualToString:@"xlsm"]||[fileex isEqualToString:@"XLSM"]||[fileex isEqualToString:@"XML"]||[fileex isEqualToString:@"xml"])
        {
            
            imageviw.image = [UIImage imageNamed:@"ic_xls.png"];
        }
        else if ([fileex isEqualToString:@"html"]||[fileex isEqualToString:@"HTML"]||[fileex isEqualToString:@"shtml"]||[fileex isEqualToString:@"SHTML"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_html.png"];
        }
        else if ([fileex isEqualToString:@"ustar"]||[fileex isEqualToString:@"USTAR"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_ustar.png"];
        }
        else if ([fileex isEqualToString:@"bin"]||[fileex isEqualToString:@"BIN"]||[fileex isEqualToString:@"a"]||[fileex isEqualToString:@"A"]||[fileex isEqualToString:@"aab"]||[fileex isEqualToString:@"AAB"]||[fileex isEqualToString:@"aam"]||[fileex isEqualToString:@"AAM"]||[fileex isEqualToString:@"AI"]||[fileex isEqualToString:@"ai"]||[fileex isEqualToString:@"aim"]||[fileex isEqualToString:@"AIM"]||[fileex isEqualToString:@"AIP"]||[fileex isEqualToString:@"aip"]||[fileex isEqualToString:@"ARC"]||[fileex isEqualToString:@"arc"]||[fileex isEqualToString:@"ARJ"]||[fileex isEqualToString:@"arj"]||[fileex isEqualToString:@"AOS"]||[fileex isEqualToString:@"aos"]||[fileex isEqualToString:@"APS"]||[fileex isEqualToString:@"aps"]||[fileex isEqualToString:@"ANI"]||[fileex isEqualToString:@"ani"]||[fileex isEqualToString:@"asx"]||[fileex isEqualToString:@"ASX"]||[fileex isEqualToString:@"bsh"]||[fileex isEqualToString:@"BSH"]||[fileex isEqualToString:@"BOZ"]||[fileex isEqualToString:@"boz"]||[fileex isEqualToString:@"c++"]||[fileex isEqualToString:@"C++"]||[fileex isEqualToString:@"c"]||[fileex isEqualToString:@"C"]||[fileex isEqualToString:@"CAT"]||[fileex isEqualToString:@"cat"]||[fileex isEqualToString:@"CC"]||[fileex isEqualToString:@"cc"]||[fileex isEqualToString:@"CHAT"]||[fileex isEqualToString:@"chat"]||[fileex isEqualToString:@"COM"]||[fileex isEqualToString:@"com"]||[fileex isEqualToString:@"CRT"]||[fileex isEqualToString:@"crt"]||[fileex isEqualToString:@"DWG"]||[fileex isEqualToString:@"dwg"]||[fileex isEqualToString:@"dvi"]||[fileex isEqualToString:@"DVI"]||[fileex isEqualToString:@"PFUNK"]||[fileex isEqualToString:@"pfunk"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_application.png"];
        }
        else if ([fileex isEqualToString:@"3dm"]||[fileex isEqualToString:@"3DM"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_xworld.png"];
        }
        else if ([fileex isEqualToString:@"ABC"]||[fileex isEqualToString:@"abc"]||[fileex isEqualToString:@"ACGI"]||[fileex isEqualToString:@"acgi"]||[fileex isEqualToString:@"aip"]||[fileex isEqualToString:@"AIP"]||[fileex isEqualToString:@"CSH"]||[fileex isEqualToString:@"csh"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_txt.png"];
        }
        else if([fileex isEqualToString:@"class"]||[fileex isEqualToString:@"CLASS"]||[fileex isEqualToString:@"js"]||[fileex isEqualToString:@"JS"]||[fileex isEqualToString:@"p12"]||[fileex isEqualToString:@"P12"]||[fileex isEqualToString:@"TALK"]||[fileex isEqualToString:@"talk"]||[fileex isEqualToString:@"ZOO"]||[fileex isEqualToString:@"zoo"]||[fileex isEqualToString:@"z"]||[fileex isEqualToString:@"Z"]||[fileex isEqualToString:@"ZSH"]||[fileex isEqualToString:@"zsh"]||[fileex isEqualToString:@"xyz"]||[fileex isEqualToString:@"XYZ"]||[fileex isEqualToString:@"xpix"]||[fileex isEqualToString:@"XPIX"]||[fileex isEqualToString:@"xlm"]||[fileex isEqualToString:@"XLM"]||[fileex isEqualToString:@"XLS"]||[fileex isEqualToString:@"xls"]||[fileex isEqualToString:@"xmz"]||[fileex isEqualToString:@"XMZ"]||[fileex isEqualToString:@"wrz"]||[fileex isEqualToString:@"WRZ"]||[fileex isEqualToString:@"wp5"]||[fileex isEqualToString:@"WP5"]||[fileex isEqualToString:@"wp6"]||[fileex isEqualToString:@"WP6"]||[fileex isEqualToString:@"vrm"]||[fileex isEqualToString:@"VRM"]||[fileex isEqualToString:@"voc"]||[fileex isEqualToString:@"VOC"]||[fileex isEqualToString:@"UUE"]||[fileex isEqualToString:@"uue"]||[fileex isEqualToString:@"AF1"]||[fileex isEqualToString:@"af1"]||[fileex isEqualToString:@"ASM"]||[fileex isEqualToString:@"asm"]||[fileex isEqualToString:@"asp"]||[fileex isEqualToString:@"ASP"]||[fileex isEqualToString:@"au"]||[fileex isEqualToString:@"AU"]||[fileex isEqualToString:@"avs"]||[fileex isEqualToString:@"AVS"]||[fileex isEqualToString:@"bcpio"]||[fileex isEqualToString:@"BCPIO"]||[fileex isEqualToString:@"BOOK"]||[fileex isEqualToString:@"book"]||[fileex isEqualToString:@"CCAD"]||[fileex isEqualToString:@"ccad"]||[fileex isEqualToString:@"CHA"]||[fileex isEqualToString:@"cha"]||[fileex isEqualToString:@"CER"]||[fileex isEqualToString:@"cer"]||[fileex isEqualToString:@"CDF"]||[fileex isEqualToString:@"cdf"]||[fileex isEqualToString:@"CCO"]||[fileex isEqualToString:@"cco"]||[fileex isEqualToString:@"CSS"]||[fileex isEqualToString:@"css"]||[fileex isEqualToString:@"dcr"]||[fileex isEqualToString:@"DCR"]||[fileex isEqualToString:@"dp"]||[fileex isEqualToString:@"DP"]||[fileex isEqualToString:@"DXF"]||[fileex isEqualToString:@"dxf"]||[fileex isEqualToString:@"el"]||[fileex isEqualToString:@"EL"]||[fileex isEqualToString:@"ELC"]||[fileex isEqualToString:@"elc"]||[fileex isEqualToString:@"evy"]||[fileex isEqualToString:@"EVY"]||[fileex isEqualToString:@"crl"]||[fileex isEqualToString:@"CRL"]||[fileex isEqualToString:@"cpt"]||[fileex isEqualToString:@"CPT"]||[fileex isEqualToString:@"CPIO"]||[fileex isEqualToString:@"cpio"]||[fileex isEqualToString:@"wiz"]||[fileex isEqualToString:@"WIZ"]||[fileex isEqualToString:@"UNV"]||[fileex isEqualToString:@"unv"]||[fileex isEqualToString:@"UNIS"]||[fileex isEqualToString:@"unis"]||[fileex isEqualToString:@"UNI"]||[fileex isEqualToString:@"uni"]||[fileex isEqualToString:@"TR"]||[fileex isEqualToString:@"tr"]||[fileex isEqualToString:@"UIL"]||[fileex isEqualToString:@"uil"]||[fileex isEqualToString:@"tsv"]||[fileex isEqualToString:@"TSV"]||[fileex isEqualToString:@"tsp"]||[fileex isEqualToString:@"TSP"]||[fileex isEqualToString:@"TEX"]||[fileex isEqualToString:@"tex"]||[fileex isEqualToString:@"SSI"]||[fileex isEqualToString:@"ssi"]||[fileex isEqualToString:@"SRC"]||[fileex isEqualToString:@"src"]||[fileex isEqualToString:@"TCSH"]||[fileex isEqualToString:@"tcsh"]||[fileex isEqualToString:@"SCM"]||[fileex isEqualToString:@"scm"]||[fileex isEqualToString:@"S"]||[fileex isEqualToString:@"s"]||[fileex isEqualToString:@"RNX"]||[fileex isEqualToString:@"rnx"]||[fileex isEqualToString:@"rng"]||[fileex isEqualToString:@"RNG"]||[fileex isEqualToString:@"rmp"]||[fileex isEqualToString:@"RMP"]||[fileex isEqualToString:@"rmm"]||[fileex isEqualToString:@"RMM"]||[fileex isEqualToString:@"RM"]||[fileex isEqualToString:@"rm"]||[fileex isEqualToString:@"rexx"]||[fileex isEqualToString:@"REXX"]||[fileex isEqualToString:@"ras"]||[fileex isEqualToString:@"RAS"]||[fileex isEqualToString:@"RAM"]||[fileex isEqualToString:@"ram"]||[fileex isEqualToString:@"ra"]||[fileex isEqualToString:@"RA"]||[fileex isEqualToString:@"QTC"]||[fileex isEqualToString:@"qtc"]||[fileex isEqualToString:@"QT"]||[fileex isEqualToString:@"qt"]||[fileex isEqualToString:@"PY"]||[fileex isEqualToString:@"py"]||[fileex isEqualToString:@"PYC"]||[fileex isEqualToString:@"pyc"]||[fileex isEqualToString:@"PSD"]||[fileex isEqualToString:@"psd"]||[fileex isEqualToString:@"POT"]||[fileex isEqualToString:@"pot"]||[fileex isEqualToString:@"PNM"]||[fileex isEqualToString:@"pnm"]||[fileex isEqualToString:@"PM4"]||[fileex isEqualToString:@"pm4"]||[fileex isEqualToString:@"PL"]||[fileex isEqualToString:@"pl"]||[fileex isEqualToString:@"PKO"]||[fileex isEqualToString:@"pko"]||[fileex isEqualToString:@"PKG"]||[fileex isEqualToString:@"pkg"]||[fileex isEqualToString:@"PDB"]||[fileex isEqualToString:@"pdb"]||[fileex isEqualToString:@"PAS"]||[fileex isEqualToString:@"pas"]||[fileex isEqualToString:@"PART"]||[fileex isEqualToString:@"part"]||[fileex isEqualToString:@"P7R"]||[fileex isEqualToString:@"p7r"]||[fileex isEqualToString:@"P7S"]||[fileex isEqualToString:@"p7s"]||[fileex isEqualToString:@"P7M"]||[fileex isEqualToString:@"p7m"]||[fileex isEqualToString:@"P7C"]||[fileex isEqualToString:@"p7c"]||[fileex isEqualToString:@"P7A"]||[fileex isEqualToString:@"p7a"]||[fileex isEqualToString:@"P10"]||[fileex isEqualToString:@"p10"]||[fileex isEqualToString:@"OMCR"]||[fileex isEqualToString:@"omcr"]||[fileex isEqualToString:@"OMCD"]||[fileex isEqualToString:@"omcd"]||[fileex isEqualToString:@"OMC"]||[fileex isEqualToString:@"omc"]||[fileex isEqualToString:@"ODA"]||[fileex isEqualToString:@"oda"]||[fileex isEqualToString:@"O"]||[fileex isEqualToString:@"o"]||[fileex isEqualToString:@"NVD"]||[fileex isEqualToString:@"nvd"]||[fileex isEqualToString:@"NIF"]||[fileex isEqualToString:@"nif"]||[fileex isEqualToString:@"NCM"]||[fileex isEqualToString:@"ncm"]||[fileex isEqualToString:@"NC"]||[fileex isEqualToString:@"nc"]||[fileex isEqualToString:@"MZZ"]||[fileex isEqualToString:@"mzz"]||[fileex isEqualToString:@"MY"]||[fileex isEqualToString:@"my"]||[fileex isEqualToString:@"MV"]||[fileex isEqualToString:@"mv"]||[fileex isEqualToString:@"MS"]||[fileex isEqualToString:@"ms"]||[fileex isEqualToString:@"MRC"]||[fileex isEqualToString:@"mrc"]||[fileex isEqualToString:@"MPX"]||[fileex isEqualToString:@"mpx"]||[fileex isEqualToString:@"MPV"]||[fileex isEqualToString:@"mpv"]||[fileex isEqualToString:@"MPC"]||[fileex isEqualToString:@"mpc"]||[fileex isEqualToString:@"MPEG"]||[fileex isEqualToString:@"mpeg"]||[fileex isEqualToString:@"MOVIE"]||[fileex isEqualToString:@"movie"]||[fileex isEqualToString:@"MOOV"]||[fileex isEqualToString:@"moov"]||[fileex isEqualToString:@"MOD"]||[fileex isEqualToString:@"mod"]||[fileex isEqualToString:@"MME"]||[fileex isEqualToString:@"mme"]||[fileex isEqualToString:@"MM"]||[fileex isEqualToString:@"mm"]||[fileex isEqualToString:@"MIF"]||[fileex isEqualToString:@"mif"]||[fileex isEqualToString:@"MID"]||[fileex isEqualToString:@"mid"]||[fileex isEqualToString:@"MAR"]||[fileex isEqualToString:@"mar"]||[fileex isEqualToString:@"MAP"]||[fileex isEqualToString:@"map"]||[fileex isEqualToString:@"MAN"]||[fileex isEqualToString:@"man"]||[fileex isEqualToString:@"M3U"]||[fileex isEqualToString:@"m3u"]||[fileex isEqualToString:@"M2V"]||[fileex isEqualToString:@"m2v"]||[fileex isEqualToString:@"M2A"]||[fileex isEqualToString:@"m2a"]||[fileex isEqualToString:@"M1V"]||[fileex isEqualToString:@"m1v"]||[fileex isEqualToString:@"M"]||[fileex isEqualToString:@"m"]||[fileex isEqualToString:@"LZX"]||[fileex isEqualToString:@"lzx"]||[fileex isEqualToString:@"LZH"]||[fileex isEqualToString:@"lzh"]||[fileex isEqualToString:@"LTX"]||[fileex isEqualToString:@"ltx"]||[fileex isEqualToString:@"LSP"]||[fileex isEqualToString:@"lsp"]||[fileex isEqualToString:@"LOG"]||[fileex isEqualToString:@"log"]||[fileex isEqualToString:@"LMA"]||[fileex isEqualToString:@"lma"]||[fileex isEqualToString:@"LIST"]||[fileex isEqualToString:@"list"]||[fileex isEqualToString:@"LHX"]||[fileex isEqualToString:@"lhx"]||[fileex isEqualToString:@"LHA"]||[fileex isEqualToString:@"lha"]||[fileex isEqualToString:@"LA"]||[fileex isEqualToString:@"la"]||[fileex isEqualToString:@"KSH"]||[fileex isEqualToString:@"ksh"]||[fileex isEqualToString:@"KAR"]||[fileex isEqualToString:@"kar"]||[fileex isEqualToString:@"IV"]||[fileex isEqualToString:@"iv"]||[fileex isEqualToString:@"IT"]||[fileex isEqualToString:@"it"]||[fileex isEqualToString:@"ISU"]||[fileex isEqualToString:@"isu"]||[fileex isEqualToString:@"IP"]||[fileex isEqualToString:@"ip"]||[fileex isEqualToString:@"INS"]||[fileex isEqualToString:@"ins"]||[fileex isEqualToString:@"INF"]||[fileex isEqualToString:@"inf"]||[fileex isEqualToString:@"HTA"]||[fileex isEqualToString:@"hta"]||[fileex isEqualToString:@"HQX"]||[fileex isEqualToString:@"hqx"]||[fileex isEqualToString:@"HH"]||[fileex isEqualToString:@"hh"]||[fileex isEqualToString:@"HGL"]||[fileex isEqualToString:@"hgl"]||[fileex isEqualToString:@"HELP"]||[fileex isEqualToString:@"help"]||[fileex isEqualToString:@"HDF"]||[fileex isEqualToString:@"hdf"]||[fileex isEqualToString:@"H"]||[fileex isEqualToString:@"h"]||[fileex isEqualToString:@"GSM"]||[fileex isEqualToString:@"gsm"]||[fileex isEqualToString:@"g"]||[fileex isEqualToString:@"G"]||[fileex isEqualToString:@"FOR"]||[fileex isEqualToString:@"for"]||[fileex isEqualToString:@"java"]||[fileex isEqualToString:@"JAVA"]||[fileex isEqualToString:@"jar"]||[fileex isEqualToString:@"JAR"])
        {
            imageviw.image = [UIImage imageNamed:@"ic_file.png"];
        }
       if([fileex isEqualToString:@"png"]||[fileex isEqualToString:@"jpg"]||[fileex isEqualToString:@"pdf"]||[fileex isEqualToString:@"mp4"]||[fileex isEqualToString:@"PNG"]||[fileex isEqualToString:@"JPG"]||[fileex isEqualToString:@"PDF"]||[fileex isEqualToString:@"MP4"]||[fileex isEqualToString:@"xlsx"]||[fileex isEqualToString:@"XLSX"]||[fileex isEqualToString:@"xls"]||[fileex isEqualToString:@"XLS"]||[fileex isEqualToString:@"xlam"]||[fileex isEqualToString:@"XLAM"]||[fileex isEqualToString:@"xltm"]||[fileex isEqualToString:@"XLTM"]||[fileex isEqualToString:@"xlsm"]||[fileex isEqualToString:@"XLSM"]||[fileex isEqualToString:@"mp3"]||[fileex isEqualToString:@"MP3"]||[fileex isEqualToString:@"mp2"]||[fileex isEqualToString:@"MP2"]||[fileex isEqualToString:@"WAV"]||[fileex isEqualToString:@"wav"]||[fileex isEqualToString:@"aac"]||[fileex isEqualToString:@"AAC"]||[fileex isEqualToString:@"ac3"]||[fileex isEqualToString:@"AC3"]||[fileex isEqualToString:@"avi"]||[fileex isEqualToString:@"AVI"]||[fileex isEqualToString:@"flv"]||[fileex isEqualToString:@"FLV"]||[fileex isEqualToString:@"3gp"]||[fileex isEqualToString:@"3GP"]||[fileex isEqualToString:@"MPEG"]||[fileex isEqualToString:@"mpeg"]||[fileex isEqualToString:@"mkv"]||[fileex isEqualToString:@"MKV"]||[fileex isEqualToString:@"mov"]||[fileex isEqualToString:@"MOV"]||[fileex isEqualToString:@"WMV"]||[fileex isEqualToString:@"WMV"]||[fileex isEqualToString:@"ASF"]||[fileex isEqualToString:@"ASF"]||[fileex isEqualToString:@"ppt"]||[fileex isEqualToString:@"PPT"]||[fileex isEqualToString:@"pptx"]||[fileex isEqualToString:@"PPTX"]||[fileex isEqualToString:@"pptm"]||[fileex isEqualToString:@"PPTM"]||[fileex isEqualToString:@"pot"]||[fileex isEqualToString:@"POT"]||[fileex isEqualToString:@"potx"]||[fileex isEqualToString:@"POTX"]||[fileex isEqualToString:@"pps"]||[fileex isEqualToString:@"PPSX"]||[fileex isEqualToString:@"ppsm"]||[fileex isEqualToString:@"PPSM"]||[fileex isEqualToString:@"bmp"]||[fileex isEqualToString:@"BMP"]||[fileex isEqualToString:@"svg"]||[fileex isEqualToString:@"SVG"]||[fileex isEqualToString:@"DOC"]||[fileex isEqualToString:@"doc"]||[fileex isEqualToString:@"zip"]||[fileex isEqualToString:@"ZIP"]||[fileex isEqualToString:@"XML"]||[fileex isEqualToString:@"xml"]||[fileex isEqualToString:@"HTML"]||[fileex isEqualToString:@"html"]||[fileex isEqualToString:@"a"]||[fileex isEqualToString:@"A"]||[fileex isEqualToString:@"class"]||[fileex isEqualToString:@"CLASS"]||[fileex isEqualToString:@"js"]||[fileex isEqualToString:@"JS"]||[fileex isEqualToString:@"3dm"]||[fileex isEqualToString:@"3DM"]||[fileex isEqualToString:@"bin"]||[fileex isEqualToString:@"BIN"]||[fileex isEqualToString:@"p12"]||[fileex isEqualToString:@"P12"]||[fileex isEqualToString:@"TALK"]||[fileex isEqualToString:@"talk"]||[fileex isEqualToString:@"ZOO"]||[fileex isEqualToString:@"zoo"]||[fileex isEqualToString:@"z"]||[fileex isEqualToString:@"Z"]||[fileex isEqualToString:@"ZSH"]||[fileex isEqualToString:@"zsh"]||[fileex isEqualToString:@"xyz"]||[fileex isEqualToString:@"XYZ"]||[fileex isEqualToString:@"xpix"]||[fileex isEqualToString:@"XPIX"]||[fileex isEqualToString:@"xlm"]||[fileex isEqualToString:@"XLM"]||[fileex isEqualToString:@"XLS"]||[fileex isEqualToString:@"xls"]||[fileex isEqualToString:@"xmz"]||[fileex isEqualToString:@"XMZ"]||[fileex isEqualToString:@"wrz"]||[fileex isEqualToString:@"WRZ"]||[fileex isEqualToString:@"wp5"]||[fileex isEqualToString:@"WP5"]||[fileex isEqualToString:@"wp6"]||[fileex isEqualToString:@"WP6"]||[fileex isEqualToString:@"vrm"]||[fileex isEqualToString:@"VRM"]||[fileex isEqualToString:@"voc"]||[fileex isEqualToString:@"VOC"]||[fileex isEqualToString:@"UUE"]||[fileex isEqualToString:@"uue"]||[fileex isEqualToString:@"aab"]||[fileex isEqualToString:@"AAB"]||[fileex isEqualToString:@"aam"]||[fileex isEqualToString:@"AAM"]||[fileex isEqualToString:@"ABC"]||[fileex isEqualToString:@"abc"]||[fileex isEqualToString:@"ACGI"]||[fileex isEqualToString:@"acgi"]||[fileex isEqualToString:@"AF1"]||[fileex isEqualToString:@"af1"]||[fileex isEqualToString:@"aim"]||[fileex isEqualToString:@"AIM"]||[fileex isEqualToString:@"aip"]||[fileex isEqualToString:@"AIP"]||[fileex isEqualToString:@"ANI"]||[fileex isEqualToString:@"ani"]||[fileex isEqualToString:@"AOS"]||[fileex isEqualToString:@"aos"]||[fileex isEqualToString:@"APS"]||[fileex isEqualToString:@"aps"]||[fileex isEqualToString:@"AI"]||[fileex isEqualToString:@"ai"]||[fileex isEqualToString:@"aif"]||[fileex isEqualToString:@"AIF"]||[fileex isEqualToString:@"AIFC"]||[fileex isEqualToString:@"aifc"]||[fileex isEqualToString:@"aiff"]||[fileex isEqualToString:@"AIFF"]||[fileex isEqualToString:@"AIP"]||[fileex isEqualToString:@"aip"]||[fileex isEqualToString:@"ARC"]||[fileex isEqualToString:@"arc"]||[fileex isEqualToString:@"ARJ"]||[fileex isEqualToString:@"arj"]||[fileex isEqualToString:@"ASM"]||[fileex isEqualToString:@"asm"]||[fileex isEqualToString:@"asp"]||[fileex isEqualToString:@"ASP"]||[fileex isEqualToString:@"asx"]||[fileex isEqualToString:@"ASX"]||[fileex isEqualToString:@"au"]||[fileex isEqualToString:@"AU"]||[fileex isEqualToString:@"avs"]||[fileex isEqualToString:@"AVS"]||[fileex isEqualToString:@"bcpio"]||[fileex isEqualToString:@"BCPIO"]||[fileex isEqualToString:@"BOOK"]||[fileex isEqualToString:@"book"]||[fileex isEqualToString:@"BOZ"]||[fileex isEqualToString:@"boz"]||[fileex isEqualToString:@"bsh"]||[fileex isEqualToString:@"BSH"]||[fileex isEqualToString:@"c++"]||[fileex isEqualToString:@"C++"]||[fileex isEqualToString:@"c"]||[fileex isEqualToString:@"C"]||[fileex isEqualToString:@"CAT"]||[fileex isEqualToString:@"cat"]||[fileex isEqualToString:@"CC"]||[fileex isEqualToString:@"cc"]||[fileex isEqualToString:@"CCAD"]||[fileex isEqualToString:@"ccad"]||[fileex isEqualToString:@"COM"]||[fileex isEqualToString:@"com"]||[fileex isEqualToString:@"CHAT"]||[fileex isEqualToString:@"chat"]||[fileex isEqualToString:@"CHA"]||[fileex isEqualToString:@"cha"]||[fileex isEqualToString:@"CER"]||[fileex isEqualToString:@"cer"]||[fileex isEqualToString:@"CDF"]||[fileex isEqualToString:@"cdf"]||[fileex isEqualToString:@"CCO"]||[fileex isEqualToString:@"cco"]||[fileex isEqualToString:@"CRT"]||[fileex isEqualToString:@"crt"]||[fileex isEqualToString:@"CSH"]||[fileex isEqualToString:@"csh"]||[fileex isEqualToString:@"CSS"]||[fileex isEqualToString:@"css"]||[fileex isEqualToString:@"dcr"]||[fileex isEqualToString:@"DCR"]||[fileex isEqualToString:@"dp"]||[fileex isEqualToString:@"DP"]||[fileex isEqualToString:@"dvi"]||[fileex isEqualToString:@"DVI"]||[fileex isEqualToString:@"DWG"]||[fileex isEqualToString:@"dwg"]||[fileex isEqualToString:@"DXF"]||[fileex isEqualToString:@"dxf"]||[fileex isEqualToString:@"el"]||[fileex isEqualToString:@"EL"]||[fileex isEqualToString:@"ELC"]||[fileex isEqualToString:@"elc"]||[fileex isEqualToString:@"evy"]||[fileex isEqualToString:@"EVY"]||[fileex isEqualToString:@"crl"]||[fileex isEqualToString:@"CRL"]||[fileex isEqualToString:@"cpt"]||[fileex isEqualToString:@"CPT"]||[fileex isEqualToString:@"CPIO"]||[fileex isEqualToString:@"cpio"]||[fileex isEqualToString:@"wiz"]||[fileex isEqualToString:@"WIZ"]||[fileex isEqualToString:@"ustar"]||[fileex isEqualToString:@"USTAR"]||[fileex isEqualToString:@"UNV"]||[fileex isEqualToString:@"unv"]||[fileex isEqualToString:@"UNIS"]||[fileex isEqualToString:@"unis"]||[fileex isEqualToString:@"UNI"]||[fileex isEqualToString:@"uni"]||[fileex isEqualToString:@"TR"]||[fileex isEqualToString:@"tr"]||[fileex isEqualToString:@"UIL"]||[fileex isEqualToString:@"uil"]||[fileex isEqualToString:@"tsv"]||[fileex isEqualToString:@"TSV"]||[fileex isEqualToString:@"tsp"]||[fileex isEqualToString:@"TSP"]||[fileex isEqualToString:@"TEX"]||[fileex isEqualToString:@"tex"]||[fileex isEqualToString:@"SSI"]||[fileex isEqualToString:@"ssi"]||[fileex isEqualToString:@"SRC"]||[fileex isEqualToString:@"src"]||[fileex isEqualToString:@"TCSH"]||[fileex isEqualToString:@"tcsh"]||[fileex isEqualToString:@"SCM"]||[fileex isEqualToString:@"scm"]||[fileex isEqualToString:@"S"]||[fileex isEqualToString:@"s"]||[fileex isEqualToString:@"RNX"]||[fileex isEqualToString:@"rnx"]||[fileex isEqualToString:@"rng"]||[fileex isEqualToString:@"RNG"]||[fileex isEqualToString:@"rmp"]||[fileex isEqualToString:@"RMP"]||[fileex isEqualToString:@"rmm"]||[fileex isEqualToString:@"RMM"]||[fileex isEqualToString:@"RM"]||[fileex isEqualToString:@"rm"]||[fileex isEqualToString:@"rexx"]||[fileex isEqualToString:@"REXX"]||[fileex isEqualToString:@"ras"]||[fileex isEqualToString:@"RAS"]||[fileex isEqualToString:@"RAM"]||[fileex isEqualToString:@"ram"]||[fileex isEqualToString:@"ra"]||[fileex isEqualToString:@"RA"]||[fileex isEqualToString:@"QTC"]||[fileex isEqualToString:@"qtc"]||[fileex isEqualToString:@"QT"]||[fileex isEqualToString:@"qt"]||[fileex isEqualToString:@"PY"]||[fileex isEqualToString:@"py"]||[fileex isEqualToString:@"PYC"]||[fileex isEqualToString:@"pyc"]||[fileex isEqualToString:@"PSD"]||[fileex isEqualToString:@"psd"]||[fileex isEqualToString:@"POT"]||[fileex isEqualToString:@"pot"]||[fileex isEqualToString:@"PNM"]||[fileex isEqualToString:@"pnm"]||[fileex isEqualToString:@"PM4"]||[fileex isEqualToString:@"pm4"]||[fileex isEqualToString:@"PL"]||[fileex isEqualToString:@"pl"]||[fileex isEqualToString:@"PKO"]||[fileex isEqualToString:@"pko"]||[fileex isEqualToString:@"PKG"]||[fileex isEqualToString:@"pkg"]||[fileex isEqualToString:@"PFUNK"]||[fileex isEqualToString:@"pfunk"]||[fileex isEqualToString:@"PDB"]||[fileex isEqualToString:@"pdb"]||[fileex isEqualToString:@"PAS"]||[fileex isEqualToString:@"pas"]||[fileex isEqualToString:@"PART"]||[fileex isEqualToString:@"part"]||[fileex isEqualToString:@"P7R"]||[fileex isEqualToString:@"p7r"]||[fileex isEqualToString:@"P7S"]||[fileex isEqualToString:@"p7s"]||[fileex isEqualToString:@"P7M"]||[fileex isEqualToString:@"p7m"]||[fileex isEqualToString:@"P7C"]||[fileex isEqualToString:@"p7c"]||[fileex isEqualToString:@"P7A"]||[fileex isEqualToString:@"p7a"]||[fileex isEqualToString:@"P10"]||[fileex isEqualToString:@"p10"]||[fileex isEqualToString:@"OMCR"]||[fileex isEqualToString:@"omcr"]||[fileex isEqualToString:@"OMCD"]||[fileex isEqualToString:@"omcd"]||[fileex isEqualToString:@"OMC"]||[fileex isEqualToString:@"omc"]||[fileex isEqualToString:@"ODA"]||[fileex isEqualToString:@"oda"]||[fileex isEqualToString:@"O"]||[fileex isEqualToString:@"o"]||[fileex isEqualToString:@"NVD"]||[fileex isEqualToString:@"nvd"]||[fileex isEqualToString:@"NIF"]||[fileex isEqualToString:@"nif"]||[fileex isEqualToString:@"NCM"]||[fileex isEqualToString:@"ncm"]||[fileex isEqualToString:@"NC"]||[fileex isEqualToString:@"nc"]||[fileex isEqualToString:@"MZZ"]||[fileex isEqualToString:@"mzz"]||[fileex isEqualToString:@"MY"]||[fileex isEqualToString:@"my"]||[fileex isEqualToString:@"MV"]||[fileex isEqualToString:@"mv"]||[fileex isEqualToString:@"MS"]||[fileex isEqualToString:@"ms"]||[fileex isEqualToString:@"MRC"]||[fileex isEqualToString:@"mrc"]||[fileex isEqualToString:@"MPX"]||[fileex isEqualToString:@"mpx"]||[fileex isEqualToString:@"MPV"]||[fileex isEqualToString:@"mpv"]||[fileex isEqualToString:@"MPC"]||[fileex isEqualToString:@"mpc"]||[fileex isEqualToString:@"MPEG"]||[fileex isEqualToString:@"mpeg"]||[fileex isEqualToString:@"MOVIE"]||[fileex isEqualToString:@"movie"]||[fileex isEqualToString:@"MOOV"]||[fileex isEqualToString:@"moov"]||[fileex isEqualToString:@"MOD"]||[fileex isEqualToString:@"mod"]||[fileex isEqualToString:@"MME"]||[fileex isEqualToString:@"mme"]||[fileex isEqualToString:@"MM"]||[fileex isEqualToString:@"mm"]||[fileex isEqualToString:@"MIF"]||[fileex isEqualToString:@"mif"]||[fileex isEqualToString:@"MID"]||[fileex isEqualToString:@"mid"]||[fileex isEqualToString:@"MAR"]||[fileex isEqualToString:@"mar"]||[fileex isEqualToString:@"MAP"]||[fileex isEqualToString:@"map"]||[fileex isEqualToString:@"MAN"]||[fileex isEqualToString:@"man"]||[fileex isEqualToString:@"M3U"]||[fileex isEqualToString:@"m3u"]||[fileex isEqualToString:@"M2V"]||[fileex isEqualToString:@"m2v"]||[fileex isEqualToString:@"M2A"]||[fileex isEqualToString:@"m2a"]||[fileex isEqualToString:@"M1V"]||[fileex isEqualToString:@"m1v"]||[fileex isEqualToString:@"M"]||[fileex isEqualToString:@"m"]||[fileex isEqualToString:@"LZX"]||[fileex isEqualToString:@"lzx"]||[fileex isEqualToString:@"LZH"]||[fileex isEqualToString:@"lzh"]||[fileex isEqualToString:@"LTX"]||[fileex isEqualToString:@"ltx"]||[fileex isEqualToString:@"LSP"]||[fileex isEqualToString:@"lsp"]||[fileex isEqualToString:@"LOG"]||[fileex isEqualToString:@"log"]||[fileex isEqualToString:@"LMA"]||[fileex isEqualToString:@"lma"]||[fileex isEqualToString:@"LIST"]||[fileex isEqualToString:@"list"]||[fileex isEqualToString:@"LHX"]||[fileex isEqualToString:@"lhx"]||[fileex isEqualToString:@"LHA"]||[fileex isEqualToString:@"lha"]||[fileex isEqualToString:@"LA"]||[fileex isEqualToString:@"la"]||[fileex isEqualToString:@"KSH"]||[fileex isEqualToString:@"ksh"]||[fileex isEqualToString:@"KAR"]||[fileex isEqualToString:@"kar"]||[fileex isEqualToString:@"IV"]||[fileex isEqualToString:@"iv"]||[fileex isEqualToString:@"IT"]||[fileex isEqualToString:@"it"]||[fileex isEqualToString:@"ISU"]||[fileex isEqualToString:@"isu"]||[fileex isEqualToString:@"IP"]||[fileex isEqualToString:@"ip"]||[fileex isEqualToString:@"INS"]||[fileex isEqualToString:@"ins"]||[fileex isEqualToString:@"INF"]||[fileex isEqualToString:@"inf"]||[fileex isEqualToString:@"HTA"]||[fileex isEqualToString:@"hta"]||[fileex isEqualToString:@"HQX"]||[fileex isEqualToString:@"hqx"]||[fileex isEqualToString:@"HH"]||[fileex isEqualToString:@"hh"]||[fileex isEqualToString:@"HGL"]||[fileex isEqualToString:@"hgl"]||[fileex isEqualToString:@"HELP"]||[fileex isEqualToString:@"help"]||[fileex isEqualToString:@"HDF"]||[fileex isEqualToString:@"hdf"]||[fileex isEqualToString:@"H"]||[fileex isEqualToString:@"h"]||[fileex isEqualToString:@"GSM"]||[fileex isEqualToString:@"gsm"]||[fileex isEqualToString:@"g"]||[fileex isEqualToString:@"G"]||[fileex isEqualToString:@"FOR"]||[fileex isEqualToString:@"for"]||[fileex isEqualToString:@"java"]||[fileex isEqualToString:@"JAVA"]||[fileex isEqualToString:@"jar"]||[fileex isEqualToString:@"JAR"])
       {
            NSString *lenfind = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"size"]];
            if([lenfind length]>6)
            {
                NSString *str = [NSString stringWithFormat:@"%.2f",[[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"size"] doubleValue]/1000];
                //NSString *strOnceAgain = [NSString stringWithFormat:@"%.2f",[str doubleValue]/1000];
                NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                                   decimalNumberHandlerWithRoundingMode:NSRoundUp
                                                   scale:0
                                                   raiseOnExactness:NO
                                                   raiseOnOverflow:NO
                                                   raiseOnUnderflow:NO
                                                   raiseOnDivideByZero:YES];
                NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithString:str];
                NSDecimalNumber *discount = [NSDecimalNumber decimalNumberWithString:@"1000"];
                NSDecimalNumber *strOnceAgain = [subtotal decimalNumberByDividingBy:discount withBehavior:roundUp];
                
                //NSLog(@"Rounded total: %@", strOnceAgain);
                NSString *bitadd;
                if(monthInBetween==0)
                {
                    bitadd = [NSString stringWithFormat:@"%@MB,modified %dweeks ago",strOnceAgain,weeksInBetween];
                }
                else
                {
                    bitadd = [NSString stringWithFormat:@"%@MB,modified %dmonths ago",strOnceAgain,monthInBetween];
                }
                if(weeksInBetween==0)
                {
                    bitadd = [NSString stringWithFormat:@"%@MB,modified %dmonths ago",strOnceAgain,dayInBetween];
                }
                if(dayInBetween==0)
                {
                    bitadd = [NSString stringWithFormat:@"%@MB,modified %.0fmins ago",strOnceAgain,-timeSince/60/60];
                }
        bitadd = [NSString stringWithFormat:@"%@MB, modified %@",strOnceAgain,[self timeAgoSinceDate:self.selectedDate numericDates:NO]];
                gallery_subname.text= [NSString stringWithFormat:@"%@",bitadd];
            }
            else if ([lenfind length]>=5||[lenfind length]>=4||[lenfind length]>=3||[lenfind length]>=2)
            {
                NSString *str = [NSString stringWithFormat:@"%.2f",[[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"size"] doubleValue]/1000];
                
                NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                                   decimalNumberHandlerWithRoundingMode:NSRoundUp
                                                   scale:0
                                                   raiseOnExactness:NO
                                                   raiseOnOverflow:NO
                                                   raiseOnUnderflow:NO
                                                   raiseOnDivideByZero:YES];
                
                NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithString:str];
                NSDecimalNumber *discount = [NSDecimalNumber decimalNumberWithString:@"1000"];
                NSDecimalNumber *total = [subtotal decimalNumberByDividingBy:discount withBehavior:roundUp];
               // NSLog(@"Rounded total: %@", total);
                NSString *bitadd;
                if(monthInBetween==0)
                {
                    bitadd = [NSString stringWithFormat:@"%@KB,modified %dweeks ago",total,weeksInBetween];
                }
                else
                {
                    bitadd = [NSString stringWithFormat:@"%@KB,modified %dmonths ago",total,monthInBetween];
                }
                if(weeksInBetween==0)
                {
                    bitadd = [NSString stringWithFormat:@"%@KB,modified %ddays ago",total,dayInBetween];
                }
                
                if(dayInBetween==0)
                {
                    bitadd = [NSString stringWithFormat:@"%@MB,modified %.0fmins ago",total,-timeSince/60/60];
                    
                }
                bitadd = [NSString stringWithFormat:@"%@KB, modified %@",total,[self timeAgoSinceDate:self.selectedDate numericDates:NO]];
                gallery_subname.text= [NSString stringWithFormat:@"%@",bitadd];
            }
        }
    }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==_tableViewPath)
    {
        NSString *lastOb = [NSString stringWithFormat:@"%d",[mu_dirnames count]-1];
        NSString *indexGet = [NSString stringWithFormat:@"%d",indexPath.row];
        if ([indexGet isEqualToString:lastOb])
        {
            [self.tableView reloadData];
            [_tableViewPath reloadData];
        }
        else
        {
            didcount--;
            [self whootingGetFiles:[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"rowid"]];
            [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_Tbl]];
            [self deleteTableBackWhootin_Tbl:[self backSelectedDataFromWhootinName_Tbl]];
            [self.tableView reloadData];
            [_tableViewPath reloadData];
        }
        NSString *homes = [[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"];
        if ([homes isEqualToString:@"Home"])
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    else
    {
        [self SelectDataFromDbForSendMeFiles];
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            
            [self SelectDataFromDbForSendMeFilesIdsBack];
            NSString *backidValues;
            if([mu_backmove count]>0)
            {
                for (int i=0; i<[mu_backmove count]; i++)
                {
                    //NSLog(@"ReverseObjectEnumerator:%@",[[reversedArray objectAtIndex:i] objectForKey:@"parentidv"]);
                    
                    backidValues= [[mu_backmove objectAtIndex:i] objectForKey:@"parentidv"];
                }
                [self whootingGetFiles:backidValues];
                [self.tableView reloadData];
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_Tbl]];
            [self deleteTableBackWhootin_Tbl:[self backSelectedDataFromWhootinName_Tbl]];
            [_tableViewPath reloadData];
            [_str_parentId stringByAppendingFormat:@""];
        //[self SelectDataFromDbForSendMeFilesIds];
       /*NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:mu_idfile];
        myArray = [[NSMutableArray alloc]initWithArray:[mySet array]];*/
        /*NSArray *copy = [mu_idfile copy];
         NSInteger index = [copy count] - 1;
         for (id object in [copy reverseObjectEnumerator]) {
         if ([mu_idfile indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
         [mu_idfile removeObjectAtIndex:index];
         }
         index--;
         }*/
        /*NSLog(@"mu_idfile:%@",mu_idfile);
        [myArray removeLastObject];
        NSLog(@"Parent_Id:%@",myArray);
        // NSLog(@"Rows_Id:%@",[[mu_tweetarrayrow objectAtIndex:0] objectForKey:@"rowids"]);
        NSLog(@"Rows_Id didcount :%d",didcount);
        if (valcheck==YES)
        {
            didcount--;
            [self deleteDataFromDB];
            [mu_fileNames_send_Second removeAllObjects];
            for (int i=0; i<[myArray count]; i++)
            {
                NSLog(@"JSON ID ALL Values:%@",[myArray objectAtIndex:i]);
            }
            if (didcount !=-1)
            {
                //[self whootingChecking:[myArray objectAtIndex:didcount]];
                //[self whootingChecking:_str_parentId];
                self.idValue = [myArray objectAtIndex:didcount];
                [self whootingGetFiles:self.idValue];
            }
            else
            {
                valcheck=NO;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [self.tableView reloadData];
            self.idValue = [mu_idfile lastObject];
            [self whootingGetFiles:self.idValue];*/
            //[self whootinFolder:[mu_idfile lastObject]];
            //NSLog(@"Laset Object:%@",[mu_idfile lastObject]);
            //if([self.idValue isEqualToString:[NSString stringWithFormat:@"%@",[mu_idfile lastObject]]])
            //{
            //[mu_idfile removeAllObjects];
            //}
        /*}
        else if (valcheck==NO)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (valcheck!=YES&&valcheck!=NO)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        NSLog(@"Count Values Whootin Names:>>>>>>%@",[self SelectedDataFromWhootinName_Tbl]);
        [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_Tbl]];
        [_tableViewPath reloadData];
        [_str_parentId stringByAppendingFormat:@""];
        }*/
        }
    }
    else
    {
    NSString *idsChecking = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:0] objectForKey:@"parentid"]];
    //_lbl_parentID.text =[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:0] objectForKey:@"parentid"]];
    if ([idsChecking isEqualToString:self.idValue])
    {
        [self deleteDatawhootintemp_id];
    }
    //[self DeleteUnValues:idsChecking];
    if ([[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"type"] isEqualToString:@"folder"])
    {
        NSLog(@"VKKKK:%@",[[mu_tweetarray objectAtIndex:0] objectForKey:@"parentid"]);
        [self whootinIds:[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:0] objectForKey:@"parentid"]] BOOLCHECKING:[self countDataFromDBIds:[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:0] objectForKey:@"parentid"]]]];
        
        [mu_idfile addObject:[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:0] objectForKey:@"parentid"]]];
        [self pathStorageUsesDB:[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"name"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];
        
        [self pathStorageUsesDBs:[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"name"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];
        
        [self backStorageUsesDBs:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"parentid"] BOOLCHECKING:[self countDataFromDBBack:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]]];
        
        [self backFolderStorageUsesDBs:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"parentid"] BOOLCHECKING:[self countDataFromDBBackFolder:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]]];
        
        [_tableViewPath reloadData];
        @try
        {
            self.idValue = [[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"];
            [self whootingGetFiles:self.idValue];
            //_fileIdFormtb=self.idValue;
            //[mu_idfile addObject:self.idValue];
            //[self whootinFolder:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];
            val=NO;
            valcheck=YES;
            didcount++;
            //NSLog(@"Folders:%d",didcount);
            [self.tableView reloadData];
            
           // _str_parentId = [NSString stringWithFormat:@"%@",[mu_fileParentId_send_Second objectAtIndex:indexPath.row]];
        }
        @catch (NSException *exception)
        {
            didcount=didcount-1;
            NSLog(@"Folder is Empty");
        }
        @finally
        {
        }
    }
    else
    {
        valcheck = NO;
        NSLog(@"File");
    }
    }
    NSLog(@"muKeep_id Counts:%d",[mu_idfile count]);
    }
}
-(void)backBtn
{
    //BackMoves
    
   //NSArray  *reversedArray = [[mu_backmove reverseObjectEnumerator] allObjects];
    [self SelectDataFromDbForSendMeFilesIdsBack];
    NSString *backidValues;
    if([mu_backmove count]>0)
    {
    for (int i=0; i<[mu_backmove count]; i++)
    {
        //NSLog(@"ReverseObjectEnumerator:%@",[[reversedArray objectAtIndex:i] objectForKey:@"parentidv"]);
        
        backidValues= [[mu_backmove objectAtIndex:i] objectForKey:@"parentidv"];
    }
    [self whootingGetFiles:backidValues];
    [self.tableView reloadData];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
   // NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:mu_idfile];
   // myArray = [[NSMutableArray alloc]initWithArray:[mySet array]];
    /*NSArray *copy = [mu_idfile copy];
    NSInteger index = [copy count] - 1;
    for (id object in [copy reverseObjectEnumerator]) {
        if ([mu_idfile indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [mu_idfile removeObjectAtIndex:index];
        }
        index--;
    }*/
   /* NSLog(@"mu_idfile:%@",mu_idfile);
    [myArray removeLastObject];
    NSLog(@"Parent_Id:%@",myArray);

    NSLog(@"Rows_Id didcount :%d",didcount);
    if (valcheck==YES)
    {
        didcount--;
        [self deleteDataFromDB];
        [mu_fileNames_send_Second removeAllObjects];
        for (int i=0; i<[myArray count]; i++)
        {
            NSLog(@"JSON ID ALL Values:%@",[myArray objectAtIndex:i]);
        }
        if (didcount !=-1)
        {*/
            //[self whootingChecking:[myArray objectAtIndex:didcount]];
            //[self whootingChecking:_str_parentId];
            
            /*self.idValue = [myArray objectAtIndex:didcount];
            [self whootingGetFiles:self.idValue];
        }
        else
        {
            valcheck=NO;
            [self dismissViewControllerAnimated:YES completion:nil];
       }
        [self.tableView reloadData];
        self.idValue = [mu_idfile lastObject];
        [self whootingGetFiles:self.idValue];
        //[self whootinFolder:[mu_idfile lastObject]];
        NSLog(@"Laset Object:%@",[mu_idfile lastObject]);
       
    }
    else if (valcheck==NO)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (valcheck!=YES&&valcheck!=NO)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }*/
    //NSLog(@"Count Values Whootin Names:>>>>>>%@",[self SelectedDataFromWhootinName_Tbl]);
    [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_Tbl]];
    [self deleteTableBackWhootin_Tbl:[self backSelectedDataFromWhootinName_Tbl]];
    [_tableViewPath reloadData];
    [_str_parentId stringByAppendingFormat:@""];
}
-(void)backComingFolder
{
    //[self SelectDataFromDbForSendMeFilesIds];
    NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:mu_idfile];
    myArray = [[NSMutableArray alloc]initWithArray:[mySet array]];
    /*NSArray *copy = [mu_idfile copy];
     NSInteger index = [copy count] - 1;
     for (id object in [copy reverseObjectEnumerator]) {
     if ([mu_idfile indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
     [mu_idfile removeObjectAtIndex:index];
     }
     index--;
     }*/
    NSLog(@"%@",mu_idfile);
    NSLog(@"Parent_Id:%@",myArray);
    // NSLog(@"Rows_Id:%@",[[mu_tweetarrayrow objectAtIndex:0] objectForKey:@"rowids"]);
    NSLog(@"Rows_Id didcount :%d",didcount);
    if (valcheck==YES)
    {
        didcount--;
        [self deleteDataFromDB];
        [mu_fileNames_send_Second removeAllObjects];
        for (int i=0; i<[myArray count]; i++)
        {
            NSLog(@"JSON ID ALL Values:%@",[myArray objectAtIndex:i]);
        }
        if (didcount !=-1)
        {
            [self whootingChecking:[myArray objectAtIndex:didcount]];
            //[self whootingChecking:_str_parentId];
        }
        else
        {
            valcheck=NO;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [self.tableView reloadData];
        [self whootinFolder:[mu_idfile lastObject]];
        NSLog(@"Laset Object:%@",[mu_idfile lastObject]);
        if([self.idValue isEqualToString:[NSString stringWithFormat:@"%@",[mu_idfile lastObject]]])
        {
            [mu_idfile removeAllObjects];
        }
    }
    else if (valcheck==NO)
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (valcheck!=YES&&valcheck!=NO)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [_str_parentId stringByAppendingFormat:@""];

}
-(void)deleteDatawhootintemp_id
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootintemp_id"];
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
-(void)deleteTableIndex:(NSString *)indes
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinsecond_tbl where whootin_id=\"%@\"",indes];
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
#pragma mark **********Whooting Getting Files**********
-(void)whootinFileDeleting
{
    NSLog(@"Whootin Post Calling");
    NSString *fl = [NSString stringWithFormat:@"%@",_fileId];
    NSLog(@"URlllll:%@",fl);
    NSURL *postURL;
    
    if ( [_filetypes isEqualToString:@"folder"])
    {
        postURL  = [[NSURL alloc]initWithString: [NSString stringWithFormat:@"http://whootin.com/api/v1/folders/destroy/%@",fl]];
        NSLog(@"folders");
    }
    else
    {
        postURL = [[NSURL alloc]initWithString: [NSString stringWithFormat:@"http://whootin.com/api/v1/files/destroy/%@",fl]];
        NSLog(@"FIles");
    }
    NSLog(@"URlllll:%@",postURL);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    NSMutableData *postBody = [NSMutableData data];
    NSLog(@"add Image");
    //image
    NSString *flk = [NSString stringWithFormat:@"%@",_fileId];
    NSString *folderNames = [NSString stringWithFormat:@"Content-Disposition: form-data;name=DELETE; DELETE=%@",flk];
    NSLog(@"Folder %@",folderNames);
    [postBody appendData:[folderNames dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSLog(@"just sent request");
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            // convert data into string
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"Data ResponseValues:%@",responseString);
            
            if (responseString) {
                
            }
            else
            {
                
            }
        });
    });
    [self deleteTableIndex:_fileId];
    [self.tableView reloadData];
}
-(void)pathStorageUsesDB:(NSString *)name IDS:(NSString *)whootin_ids
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
    {
      NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootinnames_tbl (whootin_name,whootin_id)VALUES(\"%@\",\"%@\")",name,whootin_ids];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"SIGN UP SAVEDiop->>>->>>");
        }
        else
        {
            NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [insertSQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
            NSLog(@"SIGN UP FAIL TO SAVEDklll");
        }
    }
}
-(void)whootingGetFiles :(NSString *)idval
{
    //[self whootinIds:self.idValue];
    //ContentValuesInsertedValues
    [self deleteDataFromDB];
    [mu_fileNames_send_Second removeAllObjects];
    [mu_fileId_send_Second removeAllObjects];
    //[mu_idfile addObject:[NSString stringWithFormat:@"%@",_lbl_parentID.text]];
    [mu_idfile addObject:idval];
    //_lbl_parentID.text=idval;
    NSLog(@"IDValues:%@",idval);
    NSURL *postURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://whootin.com/api/v1/files.json?count=30&folder_id=%@",idval]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
	//NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
	NSLog(@"body set");
	NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
	NSError* error = [[NSError alloc] init] ;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *newStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *json=[newStr JSONValue];
    //NSArray *JsonDict = [newStr JSONValue];
    @try
    {
    mu_fileNames_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"name"]];
    mu_fileId_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"id"]];
    mu_fileType_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"type"]];
    mu_filesize_Con_Second =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"file_size"]];
    mu_filecreated_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"created_at"]];
    mu_fileUrl_Con_Second =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"short_url"]];
    mu_fileDownUrl_con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"url"]];
    mu_fileParent_con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"parent_id"]];
        
        NSLog(@"ID Value From Heres%@",mu_fileUrl_Con_Second);
   
        for(int i=0;i<mu_fileNames_Con_Second.count;i++)
        {
            [self whootinValuesInsert:mu_fileNames_Con_Second[i] ID:mu_fileId_Con_Second[i] TYPE:mu_fileType_Con_Second[i] SIZES:mu_filesize_Con_Second[i] CREATED:mu_filecreated_Con_Second[i] SHORTURL:mu_fileUrl_Con_Second[i] DOWNLOADURL:mu_fileDownUrl_con_Second[i] PARENTID:mu_fileParent_con_Second[i] BOOLCHECKING:[self countDataFromDB:mu_fileId_Con_Second[i] ]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception Occur:%@",exception);
    }
    @finally
    {
        
    }
    [self.tableView reloadData];
}
-(void)whootinFileUploading :(UIImage *)img fileName:(NSString *)fnames
{
    NSString *sUserDefault =kAccessToken;
    NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/files/new.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    
    NSLog(@"Post Comment is:%@",_fileIdFormtb);
    NSString *idfolder;
    
    if(mu_tweetarray.count==0)
    {
         idfolder =  [NSString stringWithFormat:@"%@",self.idValue];
    }
    else
    {
    if(_fileIdFormtb.length==0)
    {
        idfolder =  [NSString stringWithFormat:@"%@",self.idValue];
    }
    else
    {
        idfolder = [NSString stringWithFormat:@"%@",_fileIdFormtb];
    }
    }
    
    NSLog(@"Post Comment is->>>:%@",idfolder);
    //change type to POST  (default is GET)
    [request setHTTPMethod:@"POST"];
    
    //just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    
    //header Value
    NSString *headerBoundary= [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                               stringBoundary];
    // set header
    [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    //add body
    NSMutableData *postBody = [NSMutableData data];
    NSLog(@"body made");
    //wigi access token
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"folder_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[idfolder dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"add Image");
    //image
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddhhmms"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fnams;
    BOOL  strs = [self FolderNameChecking:fnames names:@"file"];
    if(strs==YES)
    {
        NSArray *assestSp = [fnames componentsSeparatedByString:@"."];
        fnams = [NSString stringWithFormat:@"%@%@.%@",assestSp[0],dateString,assestSp[1]];
    }
    else
    {
        fnams = [NSString stringWithFormat:@"%@",fnames];
    }
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *appData = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fnams];
    [postBody appendData:[appData dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/png\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //get the image data from main bundle directly into NSData object
    NSData *imgData123=UIImageJPEGRepresentation(img, 1.0);
    //add it to body
    [postBody appendData:imgData123];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"message added");
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // add body to post
    [request setHTTPBody:postBody];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", sUserDefault] forHTTPHeaderField:@"Authorization"];
    NSLog(@"body set");
    // pointers to some necessary objects
    //  NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
    //  NSError* error = [[NSError alloc] init] ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"just sent request");
    //this will set the image when loading is finished
    // convert data into string
         dispatch_async(dispatch_get_main_queue(), ^{
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                      encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    NSLog(@"File Id 107458 :%@",_fileIdFormtb);
         });
    });
     //[self whootingGetFiles:_fileIdFormtb];
}
-(void)whootinValuesInsert:(NSString *)name ID:(NSString *)ids TYPE:(NSString *)type SIZES:(NSString *)sizes CREATED:(NSString *)created  SHORTURL:(NSString *)shorturl DOWNLOADURL:(NSString *)downloadurl PARENTID:(NSString *)parentid  BOOLCHECKING:(BOOL)returnValue
{
    //NSLog( @"MMMMMDSFDFSDF>>>>>%@",[self countDataFromDB]);
    //ID==ids
    //NAME==name
    //TYPE==type
    //SIZE==sizes
    //CREATING==created
    //SHORTURL==shorturl
    //DOWNLOADURL==download
    
    if(returnValue==true)
    {
        NSLog(@"Poooo");
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE whootinsecond_tbl SET whootin_id=\"%@\",whootin_name=\"%@\",whootin_type=\"%@\",whootin_size=\"%@\",whootin_creating=\"%@\",whootin_shorturl=\"%@\",whootin_downloadurl=\"%@\", whootin_parentid=\"%@\" WHERE whootin_id=\"%@\"",ids,name,type,sizes,created,shorturl,downloadurl,parentid,ids];
            NSLog(@"Query:%@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"SIGN UP SAVED");
            }
            else
            {
                NSLog(@"SIGN UP FAIL TO SAVED fffff ff");
            }
        }
    }
    else
    {
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootinsecond_tbl (whootin_id,whootin_name,whootin_type,whootin_size,whootin_creating,whootin_shorturl,whootin_downloadurl,whootin_parentid)VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",ids,name,type,sizes,created,shorturl,downloadurl,parentid];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"SIGN UP SAVEDiop");
            }
            else
            {
                NSLog(@"Prepare-error #%i: %s", (sqlite3_prepare_v2(contactDB, [insertSQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
                NSLog(@"SIGN UP FAIL TO SAVEDklll");
            }
        }
    }
}
-(BOOL)countDataFromDB:(NSString *)values
{
    BOOL isValid=false;
    NSString *status;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT whootin_id FROM whootinsecond_tbl where whootin_id=\"%@\"",values];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                status=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSLog(@"Value:%@",status);
                
                if([status integerValue]==[values integerValue])
                {
                    isValid= true;
                }
                else
                {
                    isValid=false;
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return  isValid;
}
-(void)SelectDataFromDbFOrSendMeFilesAligments
{
    {
        [mu_fileNames_send_Second removeAllObjects];
        [mu_fileId_send_Second removeAllObjects];
        [mu_fileType_send_Second removeAllObjects];
        [mu_filesize_send_Second removeAllObjects];
        [mu_filecreated_send_Second removeAllObjects];
        [mu_fileParentId_send_Second removeAllObjects];
        
        [mu_FolderAndFileCombDownload_send removeAllObjects];
        [mu_notFolderDownload_send removeAllObjects];
        [mu_tweetarray removeAllObjects];
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT whootin_id,whootin_name,whootin_type,whootin_size,whootin_creating,whootin_shorturl,whootin_downloadurl,whootin_parentid FROM whootinsecond_tbl ORDER BY whootin_type DESC"];
            const char *query_stmt = [querySQL UTF8String];
            
            if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
            
                    NSMutableDictionary *temp = [NSMutableDictionary new];
                    NSMutableDictionary *temp1 =[NSMutableDictionary new];
                    NSMutableDictionary *temp2 = [NSMutableDictionary new];
                    
                    const char*Rnumber=(const char *) sqlite3_column_text(statement, 6);
                    NSString *rowid = Rnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumber];
                    
                    const char*parentnumber=(const char *) sqlite3_column_text(statement, 7);
                    NSString *parentid = parentnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:parentnumber];
                    
                    const char*FID=(const char *) sqlite3_column_text(statement, 0);
                    NSString *fid= FID == NULL ? nil : [[NSString alloc] initWithUTF8String:FID];
                    
                    const char*Fname=(const char *) sqlite3_column_text(statement, 1);
                    NSString *filename = Fname == NULL ? nil : [[NSString alloc] initWithUTF8String:Fname];
                    
                    const char*FType=(const char *) sqlite3_column_text(statement, 2);
                    NSString *fileType = FType == NULL ? nil : [[NSString alloc] initWithUTF8String:FType];
                    
                    const char*FSizes=(const char *) sqlite3_column_text(statement, 3);
                    NSString *fileSize = FSizes == NULL ? nil : [[NSString alloc] initWithUTF8String:FSizes];
                    const char*FCreated=(const char *) sqlite3_column_text(statement, 4);
                    NSString *fileCreated = FCreated == NULL ? nil : [[NSString alloc] initWithUTF8String:FCreated];
                    const char*FSharingURl=(const char *) sqlite3_column_text(statement, 5);
                    NSString *fileSharingURL = FSharingURl == NULL ? nil : [[NSString alloc] initWithUTF8String:FSharingURl];
                    
                    
                    if (boalignalpha==YES)
                    {
                        if ([fileType isEqualToString:@"folder"])
                        {
                            
                            [temp1 setObject:filename forKey:@"name"];
                            [temp1 setObject:fid forKey:@"id"];
                            [temp1 setObject:fileType forKey:@"type"];
                            [temp1 setObject:fileSize forKey:@"size"];
                            [temp1 setObject:fileCreated forKey:@"created"];
                            [temp1 setObject:fileSharingURL forKey:@"url"];
                            [temp1 setObject:parentid forKey:@"parentid"];
                            [temp1 setObject:rowid forKey:@"rowid"];
                            
                           
                            
                            NSSortDescriptor *sortDescriptor;
                            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                            [mu_FolderAndFileCombDownload_send sortUsingDescriptors:sortDescriptors];
                            
                             [mu_FolderAndFileCombDownload_send addObject:temp1];
                            
                        }
                        else
                        {
                            [temp2 setObject:filename forKey:@"name"];
                            [temp2 setObject:fid forKey:@"id"];
                            [temp2 setObject:fileType forKey:@"type"];
                            [temp2 setObject:fileSize forKey:@"size"];
                            [temp2 setObject:fileCreated forKey:@"created"];
                            [temp2 setObject:fileSharingURL forKey:@"url"];
                            [temp2 setObject:parentid forKey:@"parentid"];
                            [temp2 setObject:rowid forKey:@"rowid"];
                            
                            
                            
                            NSSortDescriptor *sortDescriptor;
                            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                            [mu_notFolderDownload_send sortUsingDescriptors:sortDescriptors];
                            
                            [mu_notFolderDownload_send addObject:temp2];
                            
                        }
                        
                        mu_tweetarray =[NSMutableArray arrayWithArray:[mu_FolderAndFileCombDownload_send arrayByAddingObjectsFromArray:mu_notFolderDownload_send]];
                    }
                    else if (boaligntime==YES)
                    {
                        if([fileType isEqualToString:@"folder"])
                        {
                            /*NSString *dateGetFromWoo = [NSString stringWithFormat:@"%@",fileCreated];
                             arayCreated = [dateGetFromWoo componentsSeparatedByString:@"T"];
                             NSString *value2 = [NSString stringWithFormat:@"%@",arayCreated[0]];
                             NSString *value3 = [NSString stringWithFormat:@"%@",arayCreated[1]];
                             arayCreatedZ =[value3 componentsSeparatedByString:@"Z"];
                             NSString *dateOne = [NSString stringWithFormat:@"%@ %@",value2,arayCreatedZ[0]];
                             NSDateFormatter *df= [[NSDateFormatter alloc] init];
                             [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                             NSDate *today = [NSDate date]; // it will give you current date
                             NSDate *newDate = [df dateFromString:[NSString stringWithFormat:@"%@ %@",value2,arayCreatedZ[0]]]; // your date
                             NSLog(@"NOw Dates:%@",today);
                             
                             NSComparisonResult result = [newDate compare:newDate];
                             
                             switch (result)
                             {
                             case NSOrderedAscending:
                             
                             NSLog(@"%@ is greater than %@", newDate, today);
                             
                             break;
                             
                             case NSOrderedDescending:
                             
                             NSLog(@"%@ is less %@", newDate, today);
                             
                             break;
                             
                             case NSOrderedSame:
                             NSLog(@"%@ is equal to %@", newDate, today);
                             break;
                             
                             default:
                             NSLog(@"erorr dates %@, %@", newDate, today);
                             break;
                             }
                             
                             
                             NSLog(@"Date And Time%@",newDate);*/
                            [temp1 setObject:filename forKey:@"name"];
                            [temp1 setObject:fid forKey:@"id"];
                            [temp1 setObject:fileType forKey:@"type"];
                            [temp1 setObject:fileSize forKey:@"size"];
                            [temp1 setObject:fileCreated forKey:@"created"];
                            [temp1 setObject:fileSharingURL forKey:@"url"];
                            [temp1 setObject:parentid forKey:@"parentid"];
                            [temp1 setObject:rowid forKey:@"rowid"];
                            
                            
                            
                            NSSortDescriptor *sortDescriptor;
                            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                            [mu_FolderAndFileCombDownload_send sortUsingDescriptors:sortDescriptors];
                            
                            [mu_FolderAndFileCombDownload_send addObject:temp1];
                        }
                        else
                        {
                            [temp2 setObject:filename forKey:@"name"];
                            [temp2 setObject:fid forKey:@"id"];
                            [temp2 setObject:fileType forKey:@"type"];
                            [temp2 setObject:fileSize forKey:@"size"];
                            [temp2 setObject:fileCreated forKey:@"created"];
                            [temp2 setObject:fileSharingURL forKey:@"url"];
                            [temp2 setObject:parentid forKey:@"parentid"];
                            [temp2 setObject:rowid forKey:@"rowid"];
                            
                            
                            
                            NSSortDescriptor *sortDescriptor;
                            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                            [mu_notFolderDownload_send sortUsingDescriptors:sortDescriptors];
                            
                            [mu_notFolderDownload_send addObject:temp2];
                        }
                        mu_tweetarray =[NSMutableArray arrayWithArray:[mu_FolderAndFileCombDownload_send arrayByAddingObjectsFromArray:mu_notFolderDownload_send]];
                    }
                    else if (boaligntype==YES)
                    {
                        if ([fileType isEqualToString:@"folder"])
                        {
                            [temp1 setObject:filename forKey:@"name"];
                            [temp1 setObject:fid forKey:@"id"];
                            [temp1 setObject:fileType forKey:@"type"];
                            [temp1 setObject:fileSize forKey:@"size"];
                            [temp1 setObject:fileCreated forKey:@"created"];
                            [temp1 setObject:fileSharingURL forKey:@"url"];
                            [temp1 setObject:parentid forKey:@"parentid"];
                            [temp1 setObject:rowid forKey:@"rowid"];
                            
                           
                            
                            NSSortDescriptor *sortDescriptor;
                            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                            [mu_FolderAndFileCombDownload_send sortUsingDescriptors:sortDescriptors];
                            
                             [mu_FolderAndFileCombDownload_send addObject:temp1];
                            
                        }
                        else
                        {
                            [temp2 setObject:filename forKey:@"name"];
                            [temp2 setObject:fid forKey:@"id"];
                            [temp2 setObject:fileType forKey:@"type"];
                            [temp2 setObject:fileSize forKey:@"size"];
                            [temp2 setObject:fileCreated forKey:@"created"];
                            [temp2 setObject:fileSharingURL forKey:@"url"];
                            [temp2 setObject:parentid forKey:@"parentid"];
                            [temp2 setObject:rowid forKey:@"rowid"];
                            
                            NSSortDescriptor *sortDescriptor;
                            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                            [mu_notFolderDownload_send sortUsingDescriptors:sortDescriptors];
                            
                            [mu_notFolderDownload_send addObject:temp2];
                            
                        }
                        mu_tweetarray =[NSMutableArray arrayWithArray:[mu_FolderAndFileCombDownload_send arrayByAddingObjectsFromArray:mu_notFolderDownload_send]];
                        
                    }
                    else
                    {
                        
                        [filesharingurl_send_Second addObject:rowid];
                        [mu_fileNames_send_Second addObject:filename];
                        [mu_fileId_send_Second addObject:fid];
                        [mu_fileType_send_Second addObject:fileType];
                        [mu_filesize_send_Second addObject:fileSize];
                        [mu_filecreated_send_Second addObject:fileCreated];
                        [mu_filedownload_send_Second addObject:fileSharingURL];
                        [mu_fileParentId_send_Second addObject:parentid];
                        
                        
                        [temp setObject:filename forKey:@"name"];
                        [temp setObject:fid forKey:@"id"];
                        [temp setObject:fileType forKey:@"type"];
                        [temp setObject:fileSize forKey:@"size"];
                        [temp setObject:fileCreated forKey:@"created"];
                        [temp setObject:fileSharingURL forKey:@"url"];
                        [temp setObject:parentid forKey:@"parentid"];
                        [temp setObject:rowid forKey:@"rowid"];
                        
                        [mu_tweetarray addObject:temp];
                        
                        
                        // _tweetsArray = [NSMutableArray arrayWithObjects:dict1, nil];
                    }
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
    }
    
    [self.tableView reloadData];
}
-(void)SelectDataFromDbForSendMeFiles
{
    [mu_fileNames_send_Second removeAllObjects];
    [mu_fileId_send_Second removeAllObjects];
    [mu_fileType_send_Second removeAllObjects];
    [mu_filesize_send_Second removeAllObjects];
    [mu_filecreated_send_Second removeAllObjects];
    [mu_fileParentId_send_Second removeAllObjects];
    
    [mu_FolderAndFileCombDownload_send removeAllObjects];
    [mu_notFolderDownload_send removeAllObjects];
    [mu_tweetarray removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT whootin_id,whootin_name,whootin_type,whootin_size,whootin_creating,whootin_shorturl,whootin_downloadurl,whootin_parentid FROM whootinsecond_tbl ORDER BY whootin_type DESC"];
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSMutableDictionary *temp = [NSMutableDictionary new];
                NSMutableDictionary *temp1 =[NSMutableDictionary new];
                NSMutableDictionary *temp2 = [NSMutableDictionary new];
                
                const char*Rnumber=(const char *) sqlite3_column_text(statement, 6);
                NSString *rowid = Rnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumber];
                
                const char*parentnumber=(const char *) sqlite3_column_text(statement, 7);
                NSString *parentid = parentnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:parentnumber];
                
                const char*FID=(const char *) sqlite3_column_text(statement, 0);
                NSString *fid= FID == NULL ? nil : [[NSString alloc] initWithUTF8String:FID];
                
                const char*Fname=(const char *) sqlite3_column_text(statement, 1);
                NSString *filename = Fname == NULL ? nil : [[NSString alloc] initWithUTF8String:Fname];
               
                const char*FType=(const char *) sqlite3_column_text(statement, 2);
                NSString *fileType = FType == NULL ? nil : [[NSString alloc] initWithUTF8String:FType];
                
                const char*FSizes=(const char *) sqlite3_column_text(statement, 3);
                NSString *fileSize = FSizes == NULL ? nil : [[NSString alloc] initWithUTF8String:FSizes];
                const char*FCreated=(const char *) sqlite3_column_text(statement, 4);
                NSString *fileCreated = FCreated == NULL ? nil : [[NSString alloc] initWithUTF8String:FCreated];
                const char*FSharingURl=(const char *) sqlite3_column_text(statement, 5);
                NSString *fileSharingURL = FSharingURl == NULL ? nil : [[NSString alloc] initWithUTF8String:FSharingURl];
                if (boalignalpha==YES)
                {
                    if ([fileType isEqualToString:@"folder"])
                    {
                        [temp1 setObject:filename forKey:@"name"];
                        [temp1 setObject:fid forKey:@"id"];
                        [temp1 setObject:fileType forKey:@"type"];
                        [temp1 setObject:fileSize forKey:@"size"];
                        [temp1 setObject:fileCreated forKey:@"created"];
                        [temp1 setObject:fileSharingURL forKey:@"url"];
                        [temp1 setObject:parentid forKey:@"parentid"];
                        [temp1 setObject:rowid forKey:@"rowid"];
                        
                        
                        [mu_FolderAndFileCombDownload_send addObject:temp1];
                        
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        [mu_FolderAndFileCombDownload_send sortUsingDescriptors:sortDescriptors];
                        
                        
                        
                    }
                    else
                    {
                        [temp2 setObject:filename forKey:@"name"];
                        [temp2 setObject:fid forKey:@"id"];
                        [temp2 setObject:fileType forKey:@"type"];
                        [temp2 setObject:fileSize forKey:@"size"];
                        [temp2 setObject:fileCreated forKey:@"created"];
                        [temp2 setObject:fileSharingURL forKey:@"url"];
                        [temp2 setObject:parentid forKey:@"parentid"];
                        [temp2 setObject:rowid forKey:@"rowid"];
                        
                         [mu_notFolderDownload_send addObject:temp2];
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        [mu_notFolderDownload_send sortUsingDescriptors:sortDescriptors];
                        
                       
                        
                    }
                    
                    mu_tweetarray =[NSMutableArray arrayWithArray:[mu_FolderAndFileCombDownload_send arrayByAddingObjectsFromArray:mu_notFolderDownload_send]];
                }
                else if (boaligntime==YES)
                {
                    if([fileType isEqualToString:@"folder"])
                    {
                        /*NSString *dateGetFromWoo = [NSString stringWithFormat:@"%@",fileCreated];
                         arayCreated = [dateGetFromWoo componentsSeparatedByString:@"T"];
                         NSString *value2 = [NSString stringWithFormat:@"%@",arayCreated[0]];
                         NSString *value3 = [NSString stringWithFormat:@"%@",arayCreated[1]];
                         arayCreatedZ =[value3 componentsSeparatedByString:@"Z"];
                         NSString *dateOne = [NSString stringWithFormat:@"%@ %@",value2,arayCreatedZ[0]];
                         NSDateFormatter *df= [[NSDateFormatter alloc] init];
                         [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                         NSDate *today = [NSDate date]; // it will give you current date
                         NSDate *newDate = [df dateFromString:[NSString stringWithFormat:@"%@ %@",value2,arayCreatedZ[0]]]; // your date
                         NSLog(@"NOw Dates:%@",today);
                         
                         NSComparisonResult result = [newDate compare:newDate];
                         
                         switch (result)
                         {
                         case NSOrderedAscending:
                         
                         NSLog(@"%@ is greater than %@", newDate, today);
                         
                         break;
                         
                         case NSOrderedDescending:
                         
                         NSLog(@"%@ is less %@", newDate, today);
                         
                         break;
                         
                         case NSOrderedSame:
                         NSLog(@"%@ is equal to %@", newDate, today);
                         break;
                         
                         default:
                         NSLog(@"erorr dates %@, %@", newDate, today);
                         break;
                         }
                         
                         
                         NSLog(@"Date And Time%@",newDate);*/
                        [temp1 setObject:filename forKey:@"name"];
                        [temp1 setObject:fid forKey:@"id"];
                        [temp1 setObject:fileType forKey:@"type"];
                        [temp1 setObject:fileSize forKey:@"size"];
                        [temp1 setObject:fileCreated forKey:@"created"];
                        [temp1 setObject:fileSharingURL forKey:@"url"];
                        [temp1 setObject:parentid forKey:@"parentid"];
                        [temp1 setObject:rowid forKey:@"rowid"];
                        
                        [mu_FolderAndFileCombDownload_send addObject:temp1];
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        [mu_FolderAndFileCombDownload_send sortUsingDescriptors:sortDescriptors];
                        
                        
                    }
                    else
                    {
                        [temp2 setObject:filename forKey:@"name"];
                        [temp2 setObject:fid forKey:@"id"];
                        [temp2 setObject:fileType forKey:@"type"];
                        [temp2 setObject:fileSize forKey:@"size"];
                        [temp2 setObject:fileCreated forKey:@"created"];
                        [temp2 setObject:fileSharingURL forKey:@"url"];
                        [temp2 setObject:parentid forKey:@"parentid"];
                        [temp2 setObject:rowid forKey:@"rowid"];
                        
                        [mu_notFolderDownload_send addObject:temp2];
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        [mu_notFolderDownload_send sortUsingDescriptors:sortDescriptors];
                        
                        
                    }
                    mu_tweetarray =[NSMutableArray arrayWithArray:[mu_FolderAndFileCombDownload_send arrayByAddingObjectsFromArray:mu_notFolderDownload_send]];
                }
                else if (boaligntype==YES)
                {
                    if ([fileType isEqualToString:@"folder"])
                    {
                        [temp1 setObject:filename forKey:@"name"];
                        [temp1 setObject:fid forKey:@"id"];
                        [temp1 setObject:fileType forKey:@"type"];
                        [temp1 setObject:fileSize forKey:@"size"];
                        [temp1 setObject:fileCreated forKey:@"created"];
                        [temp1 setObject:fileSharingURL forKey:@"url"];
                        [temp1 setObject:parentid forKey:@"parentid"];
                        [temp1 setObject:rowid forKey:@"rowid"];
                        
                        [mu_FolderAndFileCombDownload_send addObject:temp1];
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        [mu_FolderAndFileCombDownload_send sortUsingDescriptors:sortDescriptors];
                        
                        
                        
                    }
                    else
                    {
                        [temp2 setObject:filename forKey:@"name"];
                        [temp2 setObject:fid forKey:@"id"];
                        [temp2 setObject:fileType forKey:@"type"];
                        [temp2 setObject:fileSize forKey:@"size"];
                        [temp2 setObject:fileCreated forKey:@"created"];
                        [temp2 setObject:fileSharingURL forKey:@"url"];
                        [temp2 setObject:parentid forKey:@"parentid"];
                        [temp2 setObject:rowid forKey:@"rowid"];
                        
                         [mu_notFolderDownload_send addObject:temp2];
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        [mu_notFolderDownload_send sortUsingDescriptors:sortDescriptors];
                        
                       
                        
                    }
                    mu_tweetarray =[NSMutableArray arrayWithArray:[mu_FolderAndFileCombDownload_send arrayByAddingObjectsFromArray:mu_notFolderDownload_send]];
                    
                }
                else
                {
                    
                    [filesharingurl_send_Second addObject:rowid];
                    [mu_fileNames_send_Second addObject:filename];
                    [mu_fileId_send_Second addObject:fid];
                    [mu_fileType_send_Second addObject:fileType];
                    [mu_filesize_send_Second addObject:fileSize];
                    [mu_filecreated_send_Second addObject:fileCreated];
                    [mu_filedownload_send_Second addObject:fileSharingURL];
                    [mu_fileParentId_send_Second addObject:parentid];
                    
                    
                    [temp setObject:filename forKey:@"name"];
                    [temp setObject:fid forKey:@"id"];
                    [temp setObject:fileType forKey:@"type"];
                    [temp setObject:fileSize forKey:@"size"];
                    [temp setObject:fileCreated forKey:@"created"];
                    [temp setObject:fileSharingURL forKey:@"url"];
                    [temp setObject:parentid forKey:@"parentid"];
                    [temp setObject:rowid forKey:@"rowid"];

                    [mu_tweetarray addObject:temp];
                    // _tweetsArray = [NSMutableArray arrayWithObjects:dict1, nil];
                }
                
                
                    // _tweetsArray = [NSMutableArray arrayWithObjects:dict1, nil];
                

            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}
-(void)SelectDataFromDbForSendMeFilesIds
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT id FROM whootintemp_id"];
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *tempid = [NSMutableDictionary new];
                
                const char*Rnumber=(const char *) sqlite3_column_text(statement, 0);
                NSString *rowid = Rnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumber];
                

                [tempid setObject:rowid forKey:@"rowids"];
                
                [mu_tweetarrayrow addObject:tempid];
                
            }
            
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
}
-(BOOL)FolderNameChecking:(NSString *)values names:(NSString *)fileNames
{
    BOOL isValid=false;
    NSString *status;
    NSString *names;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;
        querySQL = [NSString stringWithFormat:@"SELECT whootin_name,whootin_type FROM whootinsecond_tbl where whootin_name=\"%@\" AND whootin_type=\"%@\"",values,fileNames];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                status=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                names = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSLog(@"Value:%@",status);
                
                if(([status integerValue]==[values integerValue])&&([fileNames isEqualToString:names]))
                {
                    isValid= true;
                }
                else
                {
                    isValid=false;
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return  isValid;
}
-(void)whootinIds:(NSString *)ids BOOLCHECKING:(NSString *)returnValue
{
    NSLog(@"ID :%@",ids);
    if([returnValue isEqual:@"trues"])
    {
        NSLog(@"Poooo");
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE whootintemp_id SET id=\"%@\" WHERE id=\"%@\"",ids,ids];
            NSLog(@"Query:%@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"SIGN UP SAVED");
            }
            else
            {
                NSLog(@"SIGN UP FAIL TO SAVED fffff ff");
            }
        }
    }
       else
    {
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootintemp_id (id)VALUES(\"%@\")",ids];
            NSLog(@"Prepare-error #%i: %s", (sqlite3_prepare_v2(contactDB, [insertSQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"SIGN UP SAVEDiop");
            }
            else
            {
                NSLog(@"Prepare-error #%i: %s", (sqlite3_prepare_v2(contactDB, [insertSQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
                NSLog(@"SIGN UP FAIL TO SAVEDklll");
            }
        }
    }
 
}
-(void)DeleteUnValues:(NSString *)idsvalues
{
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootintemp_id where id<>\"%@\"",idsvalues];
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
-(NSString *)countDataFromDBIds:(NSString *)values
{
    NSString * isValid;
    NSString *status;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id FROM whootintemp_id where id=\"%@\"",values];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                status=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSLog(@"Value:%@",status);
                
                if([status integerValue]==[values integerValue])
                {
                    isValid= @"trues";
                }
                else
                {
                    isValid= @"false";
                }
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return  isValid;
}
-(void)whootinFolder:(NSString *)pl
{
    //[self whootinFileShowing];
    [self deleteDataFromDB];
    [mu_fileNames_send_Second removeAllObjects];
    [mu_fileId_send_Second removeAllObjects];
    valuesForFolderreturn = YES;
    //NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
    NSURL *postURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://whootin.com/api/v1/files.json?count=30&&folder_id=%@",pl]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    // just some random text that will never occur in the body
NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
	// header value
NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
	NSLog(@"body set");
	// pointers to some necessary objects
	NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
	NSError* error = [[NSError alloc] init] ;
	// synchronous filling of data from HTTP POST response
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *newStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *json=[newStr JSONValue];
    NSArray *JsonDict = [newStr JSONValue];
    @try
    {
       [mu_idfile addObject:self.idValue];
        for (int i=0; i<[JsonDict count]; i++)
        {
    mu_fileNames_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"name"]];
    mu_fileId_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"id"]];
    mu_fileType_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"type"]];
    mu_filesize_Con_Second =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"file_size"]];
    mu_filecreated_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"created_at"]];
    mu_fileUrl_Con_Second =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"short_url"]];
    mu_fileDownUrl_con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"url"]];
    mu_fileParent_con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"parent_id"]];
    [mu_idfile addObject:[[JsonDict lastObject] objectForKey:@"parent_id"]];
            for(int i=0;i<mu_fileNames_Con_Second.count;i++)
            {
               [self whootinValuesInsert:mu_fileNames_Con_Second[i] ID:mu_fileId_Con_Second[i] TYPE:mu_fileType_Con_Second[i] SIZES:mu_filesize_Con_Second[i] CREATED:mu_filecreated_Con_Second[i] SHORTURL:mu_fileUrl_Con_Second[i] DOWNLOADURL:mu_fileDownUrl_con_Second[i] PARENTID:mu_fileParent_con_Second[i] BOOLCHECKING:[self countDataFromDB:mu_fileId_Con_Second[i] ]];
            }
        }
        NSLog(@"File ID%@",json);
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}
-(void)whootingChecking:(NSString *)idBack
{
    valuesForFolderreturn=YES;
    NSLog(@"Hi:%@",idBack);
    NSURL *postURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://whootin.com/api/v1/files.json?count=30&folder_id=%@",idBack]];
     NSLog(@"Hi URl:%@",postURL);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                    timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    // just some random text that will never occur in the body
	NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
	// header value
	NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
	NSLog(@"body set");
	// pointers to some necessary objects
	NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
	NSError* error = [[NSError alloc] init] ;
	// synchronous filling of data from HTTP POST response
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *newStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    @try
    {
        NSString *json=[newStr JSONValue];
        // NSArray *JsonDict = [newStr JSONValue];
        NSArray *JsonDict = [newStr JSONValue];
        
        for (int i=0; i<[JsonDict count]; i++)
        {
            mu_fileNames_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"name"]];
            mu_fileId_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"id"]];
            
            mu_fileType_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"type"]];
            mu_filesize_Con_Second =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"file_size"]];
            mu_filecreated_Con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"created_at"]];
            
            mu_fileUrl_Con_Second =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"short_url"]];
            
            mu_fileDownUrl_con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"url"]];
            
            mu_fileParent_con_Second = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"parent_id"]];
            [mu_idfile addObject:[[JsonDict objectAtIndex:i] objectForKey:@"parent_id"]];

            //[mu_idfile addObject:[json valueForKey:@"parent_id"]];
            for(int i=0;i<mu_fileNames_Con_Second.count;i++)
            {
                [self whootinValuesInsert:mu_fileNames_Con_Second[i] ID:mu_fileId_Con_Second[i] TYPE:mu_fileType_Con_Second[i] SIZES:mu_filesize_Con_Second[i] CREATED:mu_filecreated_Con_Second[i] SHORTURL:mu_fileUrl_Con_Second[i] DOWNLOADURL:mu_fileDownUrl_con_Second[i] PARENTID:mu_fileParent_con_Second[i] BOOLCHECKING:[self countDataFromDB:mu_fileId_Con_Second[i] ]];
            }
        }
        NSLog(@"Whooting Checking:%@",json);
    }
    @catch (NSException *exception)
    {

    }
    @finally
    {
    
    }
}
-(void)deleteDataFromDB
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinsecond_tbl"];
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
-(void)btn_Arrow :(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    UIView *view = button.superview;
    while (view && ![view isKindOfClass:[UITableViewCell self]]) view = view.superview;
    UITableViewCell *cell = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"row FFFFFFFF_________FFFFFFF %d",indexPath.row);
    NSLog(@"Short URl Valuw:%@",[NSString stringWithFormat:@"%@",[filesharingurl_send_Second objectAtIndex:indexPath.row]]);
    CGPoint pointInSuperview = [button.superview convertPoint:button.center toView:self.tableView];
    // Infer Index Path
    NSIndexPath *indexPaths = [self.tableView indexPathForRowAtPoint:pointInSuperview];
    // Log to Console
    NSLog(@"Converstpath7787878787778787878787:%d", indexPaths.row);
    
    /* [temp setObject:filename forKey:@"name"];
     [temp setObject:fid forKey:@"id"];
     [temp setObject:fileType forKey:@"type"];
     [temp setObject:fileSize forKey:@"size"];
     [temp setObject:fileCreated forKey:@"created"];
     [temp setObject:fileSharingURL forKey:@"url"];
     [temp setObject:parentid forKey:@"parentid"];
     [temp setObject:rowid forKey:@"rowid"];*/
    
    
    /*[filesharingurl_send_Second addObject:rowid];
    [mu_fileNames_send_Second addObject:filename];
    [mu_fileId_send_Second addObject:fid];
    [mu_fileType_send_Second addObject:fileType];
    [mu_filesize_send_Second addObject:fileSize];
    [mu_filecreated_send_Second addObject:fileCreated];
    [mu_filedownload_send_Second addObject:fileSharingURL];
    [mu_fileParentId_send_Second addObject:parentid];*/

    
    _strs = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"rowid"]];
    
    _fileId = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    

    _filetypes = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"type"]];
    
    _fileNames = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    _fileDownload = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"url"]];
    NSLog(@"Value:%@",_fileDownload);
    
    /*if([_filetypes isEqualToString:@"folder"])
    {
        [self showGrid:YES];
    }
    else
    {
        [self showGrid:NO];
    }*/
    
    if(bosharedel==YES)
    {
        viw_sharedel.hidden=NO;
        if ([_filetypes isEqualToString:@"folder"])
        {
            _btn_main_share.hidden=YES;
            _btn_main_delete.hidden=NO;
            _btn_main_rename.hidden=NO;
            _btn_main_export.hidden=YES;
            
        }
        else
        {
            _btn_main_share.hidden=NO;
            _btn_main_delete.hidden=NO;
            _btn_main_rename.hidden=NO;
            _btn_main_export.hidden=NO;
            
        }

        bosharedel = NO;
    }
    else
    {
        viw_sharedel.hidden=YES;
        bosharedel = YES;
    }
    
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self showGridWithHeaderFromPoint:[longPress locationInView:self.view]];
    }
}
#pragma mark <<<<<<<_______Action Sheets_______>>>>>>>>
- (void)showListView {
    lplv = [[LeveyPopListView alloc] initWithTitle:@"Wootin files" options:_options handler:^(NSInteger anIndex) {
        //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@", _options[anIndex]];
    }];
    lplv.delegate = self;
    //lplv.frame = CGRectMake(0, 0, , )
    [lplv showInView:self.view animated:YES];
}
#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex {
    
    NSLog(@"FIc");
    
    switch (anIndex) {
		case 0:
		{
            NSLog(@"Item A Selected");
            viw_sharedlink.hidden = NO;
    
        break;
		}
		case 1:
		{
			NSLog(@"Item B Selected");
           _lbl_Deleted_view.text =[NSString stringWithFormat:@"%@",_fileNames];
			break;
		}
		case 2:
		{
			NSLog(@"Item C Selected");
            [self renameViewWithtextBox];
            _txt_view_Rename.text= [NSString stringWithFormat:@"%@",_fileNames];
			break;
		}
        case 3:
		{
			NSLog(@"Item D Selected");
            
            viw_Export.hidden=NO;
            [self fileExposed:_fileDownload];
            
			break;
		}
	}
    //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@",_options[anIndex]];
}
-(void)renameViewWithtextBox
{
    [_txt_view_Rename.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_txt_view_Rename.layer setBorderWidth:2.0];
    [_txt_extenison.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_txt_extenison.layer setBorderWidth:2.0];
}
-(void)renameViewCreations
{
    NSLog(@"Whootin Post Calling");
    NSString *fl = [NSString stringWithFormat:@"%@",_fileId];
    NSString* sUserDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"ACCESS_TOKEN"];
    NSURL *strUrl=[NSURL URLWithString:[ NSString stringWithFormat:@"http://whootin.com/api/v1/files/rename/%@.json",fl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:strUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    // header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    // set header
    [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    //add body
    NSMutableData *postBody = [NSMutableData data];
    NSLog(@"body made");
    //wigi access token
    NSString *pComment=[NSString stringWithFormat:@"%@",_txt_view_Rename.text];
    if ([_txt_extenison.text isEqualToString:@""])
    {
        pComment=[NSString stringWithFormat:@"%@",_txt_view_Rename.text];
    }
    else
    {
        pComment=[NSString stringWithFormat:@"%@.%@",_txt_view_Rename.text,_txt_extenison.text];
    }
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[pComment dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // add body to post
    [request setHTTPBody:postBody];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", sUserDefault] forHTTPHeaderField:@"Authorization"];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"just sent request");
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]length:[responseData length]encoding:NSUTF8StringEncoding] ;
    NSLog(@"%@",responseString);
    [self whootingGetFiles:self.idValue];
    [_tableView reloadData];
    viw_Rename.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_sendmyfile_second:(id)sender
{
    [ self backBtn];
}
#pragma mark ??????_____Sharing Section____??????
-(void)facebooked
{
    NSLog(@"JIJ");
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:_fileDownload];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    [Share_Views removeFromSuperview];
}
-(void)twitterpost
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:_fileDownload];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    [Share_Views removeFromSuperview];
}
-(void)mailPost:(NSString *)urlNames
{
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    // NSArray *toRecipents = [NSArray arrayWithObject:@"support@ap"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:urlNames isHTML:NO];
    //[mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    [Share_Views removeFromSuperview];
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
- (IBAction)btn_mail:(id)sender
{
    [self mailPost:_fileDownload];
    Share_Views.hidden=YES;
    
}
- (IBAction)btn_facebook:(id)sender
{
    [self facebooked];
     Share_Views.hidden=YES;
}
- (IBAction)btn_tiwtter:(id)sender
{
    [self twitterpost];
    Share_Views.hidden = YES;
}
- (IBAction)btn_send_cancel:(id)sender
{
     viw_sharedlink.hidden = YES;
}
- (IBAction)btn_Deleted_del:(id)sender
{
    [self whootinFileDeleting];
    viw_Deleted.hidden = YES;
}
- (IBAction)btn_Deleted_no:(id)sender
{
    viw_Deleted.hidden = YES;
}
- (IBAction)btn_rename_cancel:(id)sender
{
    viw_Rename.hidden = YES;
}

- (IBAction)btn_rename_ren:(id)sender
{
    [self renameViewCreations];
}
-(void)fileExposed:(NSString *)fileURL
{
    NSLog(@"RemavURL:%@",fileURL);
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    UIImage *viewImage = [UIImage imageWithData:data]; // --- mine was made from drawing context
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[viewImage CGImage] orientation:(ALAssetOrientation)[viewImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"error");
        } else {
            NSLog(@"url %@", assetURL);
        }
    }];
}
- (IBAction)btn_Export_InStore:(id)sender
{
    viw_Export.hidden = YES;
}
- (IBAction)btn_Export_Email:(id)sender
{
    [self  mailPost:_fileDownload];
    viw_Export.hidden = YES;
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
- (IBAction)tn_newFolder_secondtbl:(id)sender
{
    
}
- (IBAction)btn_Upload_secondtbl:(id)sender
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    NSString *idfolder;
    if(_fileIdFormtb.length==0)
    {
        idfolder =  [NSString stringWithFormat:@"%@",self.idValue];
    }
    else
    {
        idfolder = [NSString stringWithFormat:@"%@",_fileIdFormtb];
    }
     NSLog(@"Images: ooppp lll%@",[NSString stringWithFormat:@"%@",self.idValue]);
    NSLog(@"Images:%@",idfolder);
    imagePickerController.folderId = idfolder;
    imagePickerController.folderKeys = @"second";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    //[[UINavigationBar appearance] setTintColor:[UIColor re]];
    [self.navigationController setTitle:@"Whootin Files"];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
#pragma mark - QBImagePickerControllerDelegate
- (void)dismissImagePickerController
{
    if (self.presentedViewController)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        [self.navigationController popToViewController:self animated:YES];
    }
    valuesForFolderreturn=YES;
}
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    [self dismissImagePickerController];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** >>>>>>>>>>>>>>>>>>>>>>imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self performSelector:@selector(dismissImagePickerController) withObject:self afterDelay:4.0];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [_labelCell addOperation:[NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(),^{
            NSLog(@"Uploading Loop Calling");
            for (int i = 0; i <[assets count]; i++)
            {
                ALAsset *asset = [assets objectAtIndex:i];
                NSLog(@"INDDDS>>>>>>*********:%@",[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]);
                
                NSString *filename = [NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]];
                
                [self whootinFileUploading:[self getImageFromAsset:assets[i] type:ASSET_PHOTO_SCREEN_SIZE] fileName:filename];
            }
        });
    }]];
    
    
    int delaytimes = [assets count];
    double first;
    double second;
    if (delaytimes==1)
    {
        first =20;
        second = 20;
    }
    else if (delaytimes==2)
    {
        first =30;
        second = 30;
    }
    else if (delaytimes==3)
    {
        first =40;
        second = 40;
    }
    else if (delaytimes==4)
    {
        first =50;
        second = 50;
    }
    else {
        first =100;
        second = 100;
    }
    
    [self SelectDataFromDbForSendMeFiles];
    [self performSelector:@selector(dismissImagePickerController) withObject:self afterDelay:first];
    [self performSelector:@selector(reloadDataselect) withObject:self afterDelay:second];
}
-(void)imagePickerControllerFolder:(QBImagePickerController *)imagePickerController didBoolSelect:(BOOL)cancelbool
{
[self performSelector:@selector(dismissImagePickerController) withObject:self afterDelay:20.0];
[self performSelector:@selector(reloadDataselect) withObject:self afterDelay:20.0];
}
-(void)reloadDataselect
{
   
    [self.tableView reloadData];
}
- (IBAction)btn_alpha:(id)sender
{
    boalignalpha=YES;
    boaligntime=NO;
    boaligntype=NO;
     [self.tableView reloadData];
    [self SelectDataFromDbFOrSendMeFilesAligments];
   
}
- (IBAction)btn_time:(id)sender
{
    boaligntime=YES;
    boalignalpha=NO;
    boaligntype=NO;
    [self SelectDataFromDbFOrSendMeFilesAligments];
    [self.tableView reloadData];
}
- (IBAction)btn_type:(id)sender
{
    boaligntype=YES;
    boalignalpha=NO;
    boaligntime=NO;
    [self SelectDataFromDbFOrSendMeFilesAligments];
    [self.tableView reloadData];
}

- (IBAction)btn_tigalignment_viw:(id)sender
{
    if(boviepopupRed==YES)
    {
         viw_alignment.hidden=NO;
        [UIView animateWithDuration:0.25 animations:^{
            viw_alignment.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
        boviepopupRed = NO;
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            [viw_alignment setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [viw_alignment setHidden:YES];
        }];
        boviepopupRed = YES;
    }
    
}
#pragma mark - Privat
#pragma mark - RNGridMenuDelegate
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    
    switch (itemIndex) {
        case 0:
        {
            NSLog(@"Item A Selected");
            viw_sharedlink.hidden = NO;
            break;
        }
        case 1:
        {
            NSLog(@"Item B Selected");
            _lbl_Deleted_view.text =[NSString stringWithFormat:@"%@",_fileNames];
            break;
        }
        case 2:
        {
            NSLog(@"Item C Selected");
            [self renameViewWithtextBox];
            _txt_view_Rename.text= [NSString stringWithFormat:@"%@",_fileNames];
            break;
        }
        case 3:
        {
            NSLog(@"Item D Selected");
            viw_Export.hidden=NO;
            [self fileExposed:_fileDownload];
            break;
        }
    }
}
- (void)showImagesOnly {
    NSInteger numberOfOptions = 4;
    NSArray *images = @[@"Share",@"Attach",@"Delete",@"Rename",@"Export",];
    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
- (void)showList {
    NSInteger numberOfOptions = 4;
    NSArray *options = @[
                         @"Share",
                         @"Attach",
                         @"Delete",
                         @"Rename",
                         @"Export",
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
- (void)showGrid:(BOOL)setoff
{
    NSInteger numberOfOptions=0;
    NSArray *items;
    if (setoff==YES)
    {
        numberOfOptions = 2;
        items  = @[
                   [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_delete"] title:@"Delete"],
                   [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_rename"] title:@"Rename"]
                   ];
    }
    else
    {
        numberOfOptions = 4;
        items  = @[
                   [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] title:@"Share"],
                   [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_delete"] title:@"Delete"],
                   [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_rename"] title:@"Rename"],
                   [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_export"] title:@"Export"],
                   ];
    }
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
- (void)showGridWithHeaderFromPoint:(CGPoint)point {
    NSInteger numberOfOptions = 4;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] title:@"Share"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_delete"] title:@"Delete"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_rename"] title:@"Rename"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_export"] title:@"Export"],
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.bounces = NO;
    av.animationDuration = 0.2;
    av.blurExclusionPath = [UIBezierPath bezierPathWithOvalInRect:self.imageView.frame];
    av.backgroundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, av.itemSize.width*3, av.itemSize.height*3)];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    header.text = @"Example Header";
    header.font = [UIFont boldSystemFontOfSize:18];
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    // av.headerView = header;
    
    [av showInViewController:self center:point];
}
- (void)showGridWithPath {
    NSInteger numberOfOptions = 4;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] title:@"Share"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_delete"] title:@"Delete"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_rename"] title:@"Rename"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ic_export"] title:@"Export"],
                       ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType
{
    CGImageRef iRef = nil;
    if (nType == ASSET_PHOTO_THUMBNAIL)
        iRef = [asset thumbnail];
    else if (nType == ASSET_PHOTO_ASPECT_THUMBNAIL)
        iRef = [asset aspectRatioThumbnail];
    else if (nType == ASSET_PHOTO_SCREEN_SIZE)
        iRef = [asset.defaultRepresentation fullScreenImage];
    else if (nType == ASSET_PHOTO_FULL_RESOLUTION)
    {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            iRef = [asset.defaultRepresentation fullResolutionImage];
            return [UIImage imageWithCGImage:iRef scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        }
        else
        {
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error)
            {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            for (CIFilter *filter in filterArray)
            {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            return iImage;
        }
    }
    return [UIImage imageWithCGImage:iRef];
}
- (NSString *)timeAgoSinceDate:(NSDate *)date numericDates:(BOOL)useNumericDates{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    [dateComponents setHour:-5];
    [dateComponents setMinute:-30];
    [dateComponents setMinute:-5];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    NSDate *earliest = [[NSDate date] earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self.selectedDate toDate:[NSDate date] options:0];
    
    //Not Yet Implemented/Optional
    //The following strings are present in the translation files but lack logic as of 2014.04.05
    //@"Today", @"This week", @"This month", @"This year"
    //and @"This morning", @"This afternoon"
    
    
    int weeksInBetween = [components week];
    int monthInBetween = [components month];
    int dayInBetween = [components day];
    int secondInBetween = fabs([components second])- 5;
    int minInBetween = fabs([components minute])- 30;
    int hourInBetween = fabs([components hour])-5;
    
    NSLog(@"secondsInBetween))))))):%d",secondInBetween);
    NSLog(@"Week Finder)))))))):%d",monthInBetween);
    NSLog(@"Mintues Finder)))))))))):%d",minInBetween);
    NSLog(@"Day Finder))))))):%d",dayInBetween);
    NSLog(@"Hour Finder))))))):%d",hourInBetween);
    NSLog(@"Month Finder))))))))):%d",monthInBetween);
    

    if (components.year >= 2) {
        return  [self logicLocalizedStringFromFormat:@"%%d %@years ago" withValue:components.year];
    }
    else if (components.year >= 1) {
        
        if (useNumericDates) {
            return DateToolsLocalizedStrings(@"1 year ago");
        }
        
        return DateToolsLocalizedStrings(@"1 year ago");
    }
    else if (components.month >= 2) {
        return [self logicLocalizedStringFromFormat:@"%%d %@months ago" withValue:components.month];
    }
    else if (components.month >= 1) {
        
        if (useNumericDates) {
            return DateToolsLocalizedStrings(@"1 month ago");
        }
        
        return DateToolsLocalizedStrings(@"1 month ago");
    }
    else if (components.week >= 2) {
        return [self logicLocalizedStringFromFormat:@"%%d %@weeks ago" withValue:components.week];
    }
    else if (components.week >= 1) {
        
        if (useNumericDates) {
            return DateToolsLocalizedStrings(@"1 week ago");
        }
        
        return DateToolsLocalizedStrings(@"1 week ago");
    }
    else if (components.day >= 2) {
        return [self logicLocalizedStringFromFormat:@"%%d %@days ago" withValue:components.day];
    }
    else if (components.day >= 1) {
        
        if (useNumericDates) {
            return DateToolsLocalizedStrings(@"1 day ago");
        }
        
        return DateToolsLocalizedStrings(@"1 day ago");
    }
    else if (fabs([components hour])-5 >= 2) {
        return [self logicLocalizedStringFromFormat:@"%%d %@hours ago" withValue:fabs([components hour])-5];
    }
    else if (fabs([components hour])-5 >= 1) {
        return DateToolsLocalizedStrings(@"1 hour ago");
    }
    else if (fabs([components minute])- 30 >= 2) {
        return [self logicLocalizedStringFromFormat:@"%%d %@minutes ago" withValue:fabs([components minute])- 30];
    }
    else if (fabs([components minute])- 30 >= 1) {
        return DateToolsLocalizedStrings(@"1 minute ago");
    }
    else if (fabs([components second])- 5 >= 3) {
        return [self logicLocalizedStringFromFormat:@"%%d %@seconds ago" withValue:fabs([components second])- 5];
    }
    else {
        return DateToolsLocalizedStrings(@"Just now");
    }
}
- (NSString *) logicLocalizedStringFromFormat:(NSString *)format withValue:(NSInteger)value{
    NSString * localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];
    return [NSString stringWithFormat:DateToolsLocalizedStrings(localeFormat), value];
}

- (NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    NSString *localeCode = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    // Russian (ru) and Ukrainian (uk)
    if([localeCode isEqual:@"ru"] || [localeCode isEqual:@"uk"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15))
        {
            return @"";
        }
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))
        {
            return @"_";
        }
        if(Y == 1 && XY != 11)
        {
            return @"__";
        }
    }
    // Add more languages here, which are have specific translation rules...
    return @"";
}

- (IBAction)btn_upgrade_20gbclose:(id)sender
{
    viw_upgrade_20gb.hidden=YES;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
}

- (IBAction)btn_main_rename:(id)sender
{
    
        NSLog(@"Item C Selected");
    viw_Rename.hidden = NO;
    viw_sharedel.hidden=YES;
    bosharedel = YES;

        [self renameViewWithtextBox];
    
    
    NSString *ext = [NSString stringWithFormat:@"%@",_fileNames];
    aray = [ext componentsSeparatedByString:@"."];
    NSString *fileex;
    if(aray.count==1)
    {
        [_txt_extenison setHidden:true];
    }
    if(aray.count>=2)
    {
        [_txt_extenison setHidden:false];
        _txt_extenison.enabled=NO;
        //NSLog(@"Fixing:%@",aray[1] );
        _txt_extenison.text = [NSString stringWithFormat:@"%@",aray[1]];
    }
    //_txt_whootin_rename.text = [NSString stringWithFormat:@"%@",aray[0]];
     _txt_view_Rename.text= [NSString stringWithFormat:@"%@",aray[0]];
}
- (IBAction)btn_main_share:(id)sender
{
     viw_sharedlink.hidden = NO;
    viw_sharedel.hidden=YES;
    bosharedel = YES;
}
- (IBAction)btn_main_delete:(id)sender
{
    NSLog(@"Item B Selected");
    viw_Deleted.hidden = NO;
    viw_sharedel.hidden=YES;
    bosharedel = YES;
   _lbl_Deleted_view.text =[NSString stringWithFormat:@"%@",_fileNames];
}
- (IBAction)btn_main_export:(id)sender
{
viw_Export.hidden=NO;
viw_sharedel.hidden=YES;
bosharedel = YES;
[self fileExposed:_fileDownload];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*[temp setObject:filename forKey:@"name"];
     [temp setObject:fid forKey:@"id"];
     [temp setObject:fileType forKey:@"type"];
     [temp setObject:fileSize forKey:@"size"];
     [temp setObject:fileCreated forKey:@"created"];
     [temp setObject:fileSharingURL forKey:@"url"];*/
    /*if([[segue identifier] isEqualToString:@"senddata"])
    {
        [self SelectDataFromDbForSendMeFiles];
        self.secondviewController = [segue destinationViewController];
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        self.secondviewController.idValue = [[mu_tweetarray objectAtIndex:indexpath.row-1]objectForKey:@"id"];
    }
    else*/
    
    //[self.folderKeys isEqualToString:@"first"][self.folderKeys isEqualToString:@"second"]
    NSString *idfolder;
    if(mu_tweetarray.count==0)
    {
        idfolder =  [NSString stringWithFormat:@"%@",self.idValue];
    }
    else
    {
    if(_fileIdFormtb.length==0)
    {
        idfolder =  [NSString stringWithFormat:@"%@",self.idValue];
    }
    else
    {
        idfolder = [NSString stringWithFormat:@"%@",_fileIdFormtb];
    }
    }
    
    if ([[segue identifier]isEqualToString:@"SecondView"])
    {
        popfolderview = [segue destinationViewController];
        popfolderview.folderId = idfolder;
        popfolderview.folderKeys = @"second";
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        popfolderview.idValuesecond=idfolder;
    }
}
-(void)SelectDataFromWHootinName_tbl
{
    
    [mu_dirnames removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT whootin_name,whootin_id FROM whootinnames_tbl"];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [querySQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                 NSMutableDictionary *temp = [NSMutableDictionary new];
                
                const char*Rnumber=(const char *) sqlite3_column_text(statement, 0);
                NSString *rowid = Rnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumber];
                const char*Rid=(const char *) sqlite3_column_text(statement, 1);
                NSString *dirids = Rid == NULL ? nil : [[NSString alloc] initWithUTF8String:Rid];
                
                [temp setObject:rowid forKey:@"fname"];
                [temp setObject:dirids forKey:@"rowid"];
                [mu_dirnames addObject:temp];

                
                
                
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
    
   

}
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}
//Horiz
- (NSInteger) numberOfColumnsInListView:(SListView *) listView
{
    //[self SelectDataFromWHootinName_tbl];
    
    NSLog(@"COunt Pages:%d",mu_dirnames.count);
    
    return 5;
}
- (CGFloat) widthForColumnAtIndex:(NSInteger) index
{
   NSLog(@"COunt Pages:%d",mu_dirnames.count);
    
    if (index % 2== 0)
    {
        return 90;
    }
    else
        return  90;
}
- (SListViewCell *) listView:(SListView *)listView viewForColumnAtIndex:(NSInteger) index {
    static NSString * CELL = @"CELL";
    SListViewCell * cell;
    cell = [listView dequeueReusableCellWithIdentifier:CELL];
    if (!cell) {
        cell = [[SListViewCell alloc] initWithReuseIdentifier:CELL];
        
    }
   
    //cell.alpha = 0.5;
    //cell.backgroundColor = [UIColor yellowColor];
    cell.backgroundColor = [UIColor clearColor];
    
   if(index==0)
    {
        cell.smallImage.frame = CGRectMake(1,5,20, 20);
        [cell.smallImage setImage:[UIImage imageNamed:@"Shape-4.png"] forState:UIControlStateNormal];
        cell.nameslabels.frame = CGRectMake(28, 0,80,30);
        cell.nameslabels.text = @"Home";
    }
    else
    {
        [self SelectDataFromWHootinName_tbl];
        cell.smallImage.frame = CGRectMake(1,5,20, 20);
        [cell.smallImage setImage:[UIImage imageNamed:@"Shape-2.png"] forState:UIControlStateNormal];
        cell.nameslabels.frame = CGRectMake(28, 0,80,30);
        cell.nameslabels.text = [NSString stringWithFormat:@"%@",[mu_dirnames objectAtIndex:0]];
    
    }
    
    return  cell;
}

- (void) listView:(SListView *)listView didSelectColumnAtIndex:(NSInteger)index
{
    
}
-(NSString *)SelectedDataFromWhootinName_Tbl
{
    NSString *records;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
     NSString *querySQL = [NSString stringWithFormat: @"SELECT count(whootin_name) FROM whootinnames_tbl"];
        const char *query_stmt = [querySQL UTF8String];
         NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [querySQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char*Rnumber=(const char *) sqlite3_column_text(statement, 0);
                NSString *rowid = Rnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumber];
                
                records = [NSString stringWithFormat:@"%@",rowid];
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
    return records ;
}
-(void)deleteTableWhootin_Tbl:(NSString *)indes
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinnames_tbl where rowid=\"%@\"",indes];
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
-(NSString *)backSelectedDataFromWhootinName_Tbl
{
    NSString *records;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT count(whootin_id) FROM whootinbacknav_tbl"];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [querySQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char*Rnumber=(const char *) sqlite3_column_text(statement, 0);
                NSString *rowid = Rnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumber];
                
                records = [NSString stringWithFormat:@"%@",rowid];
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
    return records ;
}

-(void)deleteTableBackWhootin_Tbl:(NSString *)indes
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinbacknav_tbl where rowid=\"%@\"",indes];
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

//SwipViewers
- (NSInteger)numberOfItemsInSwipeView:(__unused SwipeView *)swipeView
{
    return (NSInteger)[self.colors count];
}

- (UIView *)swipeView:(__unused SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    
    //create or reuse view
    if (view == nil)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        view = label;
    }
    
    //configure view
    label.backgroundColor = (self.colors)[index];
    label.text = [NSString stringWithFormat:@"%i", index];
    
    //return view
    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    //update page control page
    //self.pageControl.currentPage = swipeView.currentPage;
}

- (void)swipeView:(__unused SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Selected item at index %i", index);
}
-(void)deleteDataFromDBPOP
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootintemp_tbl"];
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
-(void)pathStorageUsesDBs:(NSString *)name IDS:(NSString *)whootin_ids
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootintemps_tbl (whootin_name,whootin_id)VALUES(\"%@\",\"%@\")",name,whootin_ids];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"SIGN UP SAVEDiop->>>->>>");
        }
        else
        {
            NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [insertSQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
            NSLog(@"SIGN UP FAIL TO SAVEDklll");
        }
    }
}
-(void)backStorageUsesDBs:(NSString *)name IDS:(NSString *)whootin_ids BOOLCHECKING:(BOOL)returnValue
{
    if(returnValue==true)
    {
        NSLog(@"Poooo");
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE whootinbacknav_tbl SET whootin_id=\"%@\" WHERE whootin_id=\"%@\"",name,name];
            NSLog(@"Query:%@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"SIGN UP SAVED");
            }
            else
            {
                NSLog(@"SIGN UP FAIL TO SAVED fffff ff");
            }
        }
    }
    else
    {
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootinbacknav_tbl (whootin_id,whootin_parentid)VALUES(\"%@\",\"%@\")",name,whootin_ids];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"SIGN UP SAVEDiop->>>->>>");
            }
            else
            {
                NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [insertSQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
                NSLog(@"SIGN UP FAIL TO SAVEDklll");
            }
        }
    }
    
}
-(BOOL)countDataFromDBBack:(NSString *)values
{
    BOOL isValid=false;
    NSString *status;
    NSString *names;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT whootin_id FROM whootinbacknav_tbl where whootin_id=\"%@\"",values];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                status=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                NSLog(@"Value:%@",status);
                
                if([status isEqualToString:values])
                {
                    isValid= true;
                }
                else
                {
                    isValid=false;
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return  isValid;
}
-(void)SelectDataFromDbForSendMeFilesIdsBack
{
    [mu_backmove removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT whootin_id,whootin_parentid FROM whootinbacknav_tbl"];
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *tempid = [NSMutableDictionary new];
                
                const char*Rnumber=(const char *) sqlite3_column_text(statement, 0);
                NSString *rowid = Rnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumber];
                
                const char*Rnumberv=(const char *) sqlite3_column_text(statement, 1);
                NSString *rowidv = Rnumberv == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumberv];

                
                [tempid setObject:rowid forKey:@"idv"];
                [tempid setObject:rowidv forKey:@"parentidv"];
                
                [mu_backmove addObject:tempid];
                
            }
            
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
}
#pragma mark ***FolderBackupViews****
-(void)backFolderStorageUsesDBs:(NSString *)name IDS:(NSString *)whootin_ids BOOLCHECKING:(BOOL)returnValue
{
    if(returnValue==true)
    {
        NSLog(@"Poooo");
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE whootinbacknavfolder_tbl SET whootin_id=\"%@\" WHERE whootin_id=\"%@\"",name,name];
            NSLog(@"Query:%@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"SIGN UP SAVED");
            }
            else
            {
                NSLog(@"SIGN UP FAIL TO SAVED fffff ff");
            }
        }
    }
    else
    {
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootinbacknavfolder_tbl (whootin_id,whootin_parentid)VALUES(\"%@\",\"%@\")",name,whootin_ids];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"SIGN UP SAVEDiop->>>->>>");
            }
            else
            {
                NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [insertSQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
                NSLog(@"SIGN UP FAIL TO SAVEDklll");
            }
        }
    }
    
}
-(BOOL)countDataFromDBBackFolder:(NSString *)values
{
    BOOL isValid=false;
    NSString *status;
    NSString *names;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT whootin_id FROM whootinbacknavfolder_tbl where whootin_id=\"%@\"",values];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                status=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                NSLog(@"Value:%@",status);
                
                if([status isEqualToString:values])
                {
                    isValid= true;
                }
                else
                {
                    isValid=false;
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return  isValid;
}
- (IBAction)btn_cancel_export:(id)sender
{
    viw_Export.hidden=YES;
}

- (IBAction)returnToStepTwo:(UIStoryboardSegue *)segue
{
    
}

@end
