//
//  WMFFIrstTableViewController.m
//  WHOOTIN:-)
//
//  Created by Nua sk i7 on 5/16/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//
#import "WMFFIrstTableViewController.h"
#import "WMFViewController.h"
#import "QBAssetsCollectionViewController.h"
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import "NSDate+DateTools.h"
#import <Social/Social.h>


#define NUMBER_OF_STATIC_CELLS 1
@interface WMFFIrstTableViewController ()
@property NSDate *selectedDate;
@property NSDateFormatter *formatter;
@property NSTimer *updateTimer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WMFFIrstTableViewController
@synthesize infoLabel = _infoLabel;
@synthesize options = _options;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
        /*SListView * listView = [[SListView alloc] initWithFrame:CGRectMake(0, 200, 320, 500)];
        listView.delegate = self;
        listView.dataSource = self;
        
        [viw_HorizontalList addSubview:listView];*/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //NSOperationQueue
    //Horiz View
   /*SListView * listView = [[SListView alloc] initWithFrame:CGRectMake(0,0,200,30)];
    listView.delegate = self;
    listView.dataSource = self;*/
    //[viw_HorizontalList addSubview:listView];
    
    //viw_line =[UIColor blackColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    /* NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
     [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
     refreshControl.attributedTitle = refreshString; */
    [self.tableView addSubview:refreshControl];
    if (![QBImagePickerController isAccessible])
    {
        NSLog(@"Error: Source is not accessible.");
    }
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.cornerRadius = CGRectGetHeight(self.imageView.bounds) / 2;
    self.imageView.clipsToBounds = YES;
    //RNLongPressGestureRecognizer *longPress = [[RNLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    //[self.view addGestureRecognizer:longPress];
    _labelCell = [[NSOperationQueue alloc]init];
    [_labelCell setMaxConcurrentOperationCount:1];
    mu_fileNames_send = [[NSMutableArray alloc]init];
    mu_fileId_send = [[NSMutableArray alloc]init];
    mu_fileType_send = [[NSMutableArray alloc]init];
    mu_filesize_send = [[NSMutableArray alloc]init];
    mu_filecreated_send = [[NSMutableArray alloc]init];
    mu_filedownload_send = [[NSMutableArray alloc]init];
    filesharingurl_send = [[NSMutableArray alloc]init];
    mu_notFolder_send = [[NSMutableArray alloc]init];
    mu_FolderAndFileComb_Send= [[NSMutableArray alloc]init];
    storeFiles = [[NSMutableDictionary alloc] init];

    mu_notFolderId_send= [[NSMutableArray alloc]init];
    mu_FolderAndFileCombId_send= [[NSMutableArray alloc]init];
    
    mu_notFolderType_send= [[NSMutableArray alloc]init];
    mu_FolderAndFileCombType_send= [[NSMutableArray alloc]init];
    
    mu_notFolderSize_send= [[NSMutableArray alloc]init];
    mu_FolderAndFileCombSize_send= [[NSMutableArray alloc]init];
    
    mu_notFolderCreated_send= [[NSMutableArray alloc]init];
    mu_FolderAndFileCombCreated_send= [[NSMutableArray alloc]init];
    
    mu_notFolderDownload_send= [[NSMutableArray alloc]init];
    mu_FolderAndFileCombDownload_send= [[NSMutableArray alloc]init];
    
    mu_notFolderURL_send= [[NSMutableArray alloc]init];
    mu_FolderAndFileCombURL_send= [[NSMutableArray alloc]init];
    
    
    mu_notFolderTime_send = [[NSMutableArray alloc]init];
    
    mu_tweetarray =[[NSMutableArray alloc]init];
    
    dict = [[NSMutableDictionary alloc]init];

    secondviews =[[UIView alloc]init];
    im_secondview  = [[UIImageView alloc]init];
    
    btn_mail_pop = [[UIButton alloc ]init];
    btn_facebook_pop = [[UIButton alloc ]init];
    btn_tweet_pop = [[UIButton alloc ]init];
    boviepopupRed=YES;
    viwsharing_check=YES;
    NSUserDefaults *prefsr = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *myString = [prefsr stringForKey:@"upgrades"];
    if ([myString isEqualToString:@"one"])
    {
        viw_20sharing.hidden=NO;
    }
    else
    {
        viw_20sharing.hidden=YES;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
    }
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 30)];
    _infoLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_infoLabel];
    _options = [NSArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ic_share.png"],@"img",@"Share",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ic_delete.png"],@"img",@"Delete",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ic_rename.png"],@"img",@"Rename",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ic_export.png"],@"img",@"Export",@"text", nil],
                nil];

        //DB Configuration
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
    //[self whootingGetFiles];
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([self internetConnection]==YES)
    {
        [self showAlertView:@"Internet Connection"  Message:@"No Internet Connection"];
    }
    else
    {
    // _btn_newfolder_firstviw.enabled = NO
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"upgrades"];
    NSString *updateString = [prefs stringForKey:@"update"];
    NSLog(@"NSUserDefaults:%@",myString);
    /*if([updateString isEqualToString:@"update"])
    {
        viw_20sharing.hidden=YES;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
    }
    else
    {
        viw_20sharing.hidden=NO;
    }*/
    if ([myString isEqualToString:@"one"])
    {
        viw_20sharing.hidden=NO;
    }
    else
    {
        viw_20sharing.hidden=YES;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
    }
    [self deleteDataFromDBSecond];
    [self deleteDataFromDBPOP];
    [self deleteDatawhootintemp_id];
    [self deleteWhootinNames_tbls];
    [self deleteWhootinNamesPath_tbls];
    [self deleteDatawhootintemp_idFolder];
    [self deleteDatawhootintemp_idFolderTwo];
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
            [self.tableView reloadData];
            //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    });
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performSelectorOnMainThread:@selector(whootingGetFiles) withObject:nil waitUntilDone:YES];
    });*/
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^(void)
    {
      [self whootingGetFiles];
        
    });
    
    
    
    //[self whootingGetFiles];
    [self.tableView reloadData];
    [self pathStorageUsesDB:@"Home" IDS:@"0"];
    [self pathStorageUsesDBs:@"Home" IDS:@"0"];
    }
   }
-(void)reloadDatas
{
//update here...
[self.tableView reloadData];
[refreshControl endRefreshing];
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
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)Upde
{
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark **********Whooting Getting Files**********
-(void)whootingGetFiles
{
    //ContentValuesInsertedValues
  
    //this will start the image loading in bg
    /*dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/files.json?count=50"];
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
    @try
    {
        mu_fileNames_Con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"name"]];
        mu_fileId_Con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"id"]];
        mu_fileType_Con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"type"]];
        mu_filesize_Con =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"file_size"]];
        mu_filecreated_Con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"created_at"]];
        mu_fileUrl_Con =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"short_url"]];
        mu_fileDownUrl_con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"url"]];
        NSLog(@"URl Values:%@",mu_fileDownUrl_con);
        
        for(int i=0;i<mu_fileNames_Con.count;i++)
        {
            [self whootinValuesInsert:mu_fileNames_Con[i] ID:mu_fileId_Con[i] TYPE:mu_fileType_Con[i] SIZES:mu_filesize_Con[i] CREATED:mu_filecreated_Con[i] SHORTURL:mu_fileUrl_Con[i] DOWNLOADURL:mu_fileDownUrl_con[i] BOOLCHECKING:[self countDataFromDB:mu_fileId_Con[i] names:mu_fileNames_Con[i]]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception Occur:%@",exception);
    }
    @finally
    {
        
    }
            //dispatch_semaphore_signal(semaphore);
      //});
}
-(void)whootinValuesInsert:(NSString *)name ID:(NSString *)ids TYPE:(NSString *)type SIZES:(NSString *)sizes CREATED:(NSString *)created  SHORTURL:(NSString *)shorturl DOWNLOADURL:(NSString *)downloadurl BOOLCHECKING:(BOOL)returnValue
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
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE whootinfirst_tbl SET whootin_id=\"%@\",whootin_name=\"%@\",whootin_type=\"%@\",whootin_size=\"%@\",whootin_creating=\"%@\",whootin_shorturl=\"%@\",whootin_downloadurl=\"%@\" WHERE whootin_id=\"%@\" AND whootin_name=\"%@\"",ids,name,type,sizes,created,shorturl,downloadurl,ids,name];
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
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootinfirst_tbl (whootin_id,whootin_name,whootin_type,whootin_size,whootin_creating,whootin_shorturl,whootin_downloadurl)VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",ids,name,type,sizes,created,shorturl,downloadurl];
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

-(BOOL)countDataFromDB:(NSString *)values names:(NSString *)fileNames
{
    BOOL isValid=false;
    NSString *status;
    NSString *names;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT whootin_id,whootin_name FROM whootinfirst_tbl where whootin_id=\"%@\" AND whootin_name=\"%@\"",values,fileNames];
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
-(void)SelectDataFromDbForSendMeFiles
{
    [mu_fileNames_send removeAllObjects];
    [mu_fileId_send removeAllObjects];
    [mu_fileType_send removeAllObjects];
    [mu_filesize_send removeAllObjects];
    [mu_filecreated_send removeAllObjects];
    [mu_FolderAndFileComb_Send removeAllObjects];
    [mu_FolderAndFileCombDownload_send removeAllObjects];
    [mu_notFolderDownload_send removeAllObjects];
    [mu_notFolder_send removeAllObjects];
    [mu_tweetarray removeAllObjects];
    
    NSString *fileType;
    NSString *filename;
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSString *querySQL;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
             querySQL = [NSString stringWithFormat: @"SELECT whootin_id,whootin_name,whootin_type,whootin_size,whootin_creating,whootin_shorturl,whootin_downloadurl FROM whootinfirst_tbl ORDER BY whootin_type DESC"];
       // }
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
                const char*Fname=(const char *) sqlite3_column_text(statement, 1);
                filename = Fname == NULL ? nil : [[NSString alloc] initWithUTF8String:Fname];
                const char*FID=(const char *) sqlite3_column_text(statement, 0);
                NSString *fid= FID == NULL ? nil : [[NSString alloc] initWithUTF8String:FID];
                const char*FType=(const char *) sqlite3_column_text(statement, 2);
                fileType = FType == NULL ? nil : [[NSString alloc] initWithUTF8String:FType];
                const char*FSizes=(const char *) sqlite3_column_text(statement, 3);
                NSString *fileSize = FSizes == NULL ? nil : [[NSString alloc] initWithUTF8String:FSizes];
                const char*FCreated=(const char *) sqlite3_column_text(statement, 4);
                NSString *fileCreated = FCreated == NULL ? nil : [[NSString alloc] initWithUTF8String:FCreated];
                const char*FSharingURl=(const char *) sqlite3_column_text(statement, 6);
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
                        
                        
                       [mu_FolderAndFileCombDownload_send addObject:temp1];
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        [mu_FolderAndFileCombDownload_send sortUsingDescriptors:sortDescriptors];
                        
                        
                        
                        
                        //mu_FolderAndFileCombDownload_send = [sortDescriptors copy];
                        
                    }
                    else
                    {
                        [temp2 setObject:filename forKey:@"name"];
                        [temp2 setObject:fid forKey:@"id"];
                        [temp2 setObject:fileType forKey:@"type"];
                        [temp2 setObject:fileSize forKey:@"size"];
                        [temp2 setObject:fileCreated forKey:@"created"];
                        [temp2 setObject:fileSharingURL forKey:@"url"];
                        
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
                    [mu_filedownload_send addObject:rowid];
                    [mu_fileNames_send addObject:filename];
                    [mu_fileId_send addObject:fid];
                    [mu_fileType_send addObject:fileType];
                    [mu_filesize_send addObject:fileSize];
                    [mu_filecreated_send addObject:fileCreated];
                    [filesharingurl_send addObject:fileSharingURL];
                    
                    [storeFiles setValue:filename forKey:@"name"];
                    [storeFiles setValue:fid forKey:@"rowid"];
                    [storeFiles setValue:fileType forKey:@"type"];
                    [storeFiles setValue:fileSize forKey:@"size"];
                    [storeFiles setValue:fileCreated forKey:@"created"];
                    [storeFiles setValue:fileSharingURL forKey:@"url"];
                    
                    [temp setObject:filename forKey:@"name"];
                    [temp setObject:fid forKey:@"id"];
                    [temp setObject:fileType forKey:@"type"];
                    [temp setObject:fileSize forKey:@"size"];
                    [temp setObject:fileCreated forKey:@"created"];
                    [temp setObject:fileSharingURL forKey:@"url"];
                    
                    [mu_tweetarray addObject:temp];
                    
                  //_tweetsArray = [NSMutableArray arrayWithObjects:dict1, nil];
            }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}
-(void)whootinFileUploading :(UIImage *)img fileName:(NSString *)fnames
{
    NSURL *postURL = [[NSURL alloc]initWithString: @"http://whootin.com/api/v1/files/new.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    // change type to POST (default is GET)
    [request setHTTPMethod:@"POST"];
    // just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    // header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    //add body
    NSMutableData *postBody = [NSMutableData data];
    [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    NSLog(@"add Image");
    //image
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    NSArray *link = [fnames componentsSeparatedByString:@"."];
    NSString *types = [NSString stringWithFormat:@"%@",link[1]];
    NSString *appData = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fnams];
    [postBody appendData:[appData dataUsingEncoding:NSUTF8StringEncoding]];
    //[postBody appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"itemkop.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    if([types isEqualToString:@"MOV"])
    {
         [postBody appendData:[@"Content-Type: video/quicktime\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
       [postBody appendData:[@"Content-Type: image/png\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    imgData =UIImageJPEGRepresentation(img, 1.0);
    [postBody appendData:  imgData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // add body to post
    [request setHTTPBody:postBody];
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
            if (responseString)
            {
                
            }
            else
            {
                
            }
        });
    });
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
        
            querySQL= [NSString stringWithFormat:@"SELECT whootin_name,whootin_type FROM whootinfirst_tbl where whootin_name=\"%@\" AND whootin_type=\"%@\"",values,fileNames];
       
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
    hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Deleting";
    [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    [hud show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSLog(@"just sent request");
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            // convert data into string
            [hud hide:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"Data ResponseValues:%@",responseString);
            if (responseString)
            {
                
            }
            else
            {
                
            }
           
        });
    });
    [self deleteTableIndex:_fileId];
    [self.tableView reloadData];
}
- (void)doSomeFunkyStuff
{
    float progress = 0.0;
    while (progress < 1.0)
    {
        progress += 0.01;
        hud.progress = progress;
        usleep(80000);
    }
}
#pragma mark ************Rotate**************
-(BOOL)shouldAutorotate
{
    return NO;
}
#pragma mark **************Status Bar Hidden**************
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark ***********Table View Creation************
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        
        return 1;
        
    }
    else
        return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:
(NSInteger)section {
    
    switch(section) {
        case 0:
            return @"";
        case 1:
            return @"";
        default:
            return @"";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else
    {
    [self SelectDataFromDbForSendMeFiles];
    NSLog(@"COuntValue:%u",mu_fileId_send.count);
    return mu_tweetarray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TableCellForRowIndexPath");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel *gallery_name = (UILabel *)[cell viewWithTag:1];
    UILabel *gallery_subname = (UILabel *)[cell viewWithTag:6];
    UIImageView *imageviw = (UIImageView *)[cell viewWithTag:2];
    UIButton *btnShare = (UIButton *)[cell viewWithTag:12];
    UILabel *shareUrl = (UILabel *)[cell viewWithTag:60];
    
    UIView *line = (UIView *)[cell viewWithTag:10];
    
    [line setBackgroundColor:[UIColor blackColor]];
    gallery_name.text =@" ";
    gallery_subname.text=@" ";
    btnShare.tag = indexPath.row;
    
    gallery_name.font = [UIFont fontWithName:@"Segoe UI" size:500];
    gallery_subname.font = [UIFont fontWithName:@"Segoe UI" size:500];
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        gallery_name.text = @"Gallery Uploads";
        gallery_subname.text=@" ";
        shareUrl.text = @"";
            
            /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {*/
                //UIStoryboard *storyBoard;
                imageviw.image = [UIImage imageNamed:@"ico_gallery.png"];
           /* }
            else
            {
                imageviw.image = [UIImage imageNamed:@"Ipad_ic_gallary.png"];
            }*/
        
        [btnShare removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        }
    }
   else  if(indexPath.section==1)
   {
       /* if (boalignalpha==YES)
        {
            [self SelectDataFromDbForSendMeFilesAlignTypes];
        }
        else
        {*/
       [btnShare addTarget:self action:@selector(btn_Arrow:) forControlEvents:UIControlEventTouchUpInside];
       [self SelectDataFromDbForSendMeFiles];
      //}
       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
        @try
        {
            //NSLog(@"Vammmmmm:%@",[[mu_tweetarray objectAtIndex:indexPath.row-1]objectForKey:@"name"]);
           // NSLog(@"VammmmSIxe:%@",[[mu_tweetarray objectAtIndex:indexPath.row-1]objectForKey:@"id"]);
            gallery_name.text=[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                //UIStoryboard *storyBoard;
                imageviw.image = [UIImage imageNamed:@"ico_folder.png"];
            }
            else
            {
               imageviw.image = [UIImage imageNamed:@"Ipad_ico_folder.png"];
            }
            //NSLog(@"Names:%@",mu_fileNames_send);
            NSString *ext = [NSString stringWithFormat:@"%@",gallery_name.text];
            aray = [ext componentsSeparatedByString:@"."];
            NSString *fileex;
            if(aray.count>=2)
            {
                //NSLog(@"Fixing:%@",aray[1] );
                fileex = [NSString stringWithFormat:@"%@",aray[1]];
            }
            //DateGetFromWoo
            NSString *dateGetFromWoo = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"created"]];
        
            arayCreated = [dateGetFromWoo componentsSeparatedByString:@"T"];
            //NSLog(@"ArrayCreates:%@",arayCreated[0]);
            NSString *value3 = [NSString stringWithFormat:@"%@",arayCreated[0]];
            NSString *value4    = [NSString stringWithFormat:@"%@",arayCreated[1]];
            arayCreatedZ = [value4 componentsSeparatedByString:@"Z"];
            NSString *value5 =[ NSString stringWithFormat:@"%@",arayCreatedZ[0]];
            NSString *valu3 = [NSString stringWithFormat:@"%@ %@",value3,value5];
            //NSLog(@"Value^^^^^^^^^^:%@",valu3);
             self.formatter = [[NSDateFormatter alloc] init];
            [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             self.selectedDate = [self.formatter dateFromString:valu3];
            
            NSDateFormatter *first_fi = [[NSDateFormatter alloc]init];
            NSDateFormatter *second_fi =[[NSDateFormatter alloc]init];
            
            [first_fi setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [second_fi setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
            NSDate *nos = [NSDate date];
            NSDate *fos = [second_fi dateFromString:value3];
            
            NSLog(@"Nows Date: %@ ",nos);
            NSLog(@"Nows Date 2: %@",fos);
            
            NSDate *now = [NSDate date];
            NSCalendar *calendarf = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *componentsf = [calendarf components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
            [componentsf setHour:5.50];
            NSDate *today10am = [calendarf dateFromComponents:componentsf];
            NSLog(@"Nows Date: %@ ",today10am);
            
            NSDate* sourceDate_time = [NSDate date];
            NSTimeZone* sourceTimeZone_time  = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            NSTimeZone* destinationTimeZone_time  = [NSTimeZone systemTimeZone];
            
            NSInteger sourceGMTOffset_time  = [sourceTimeZone_time  secondsFromGMTForDate:sourceDate_time];
            NSInteger destinationGMTOffset_time  = [destinationTimeZone_time  secondsFromGMTForDate:sourceDate_time ];
            NSTimeInterval interval_time  = destinationGMTOffset_time  - sourceGMTOffset_time ;
            
            NSDate* destinationDate_time  = [[NSDate alloc] initWithTimeInterval:interval_time  sinceDate:sourceDate_time ];
            
            NSLog(@"check today time: %@ ",destinationDate_time);
    
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            
           //NSLog(@"TOday R %@", [NSString stringWithFormat:@"%@",[self timeAgoSinceDate:self.selectedDate numericDates:NO]]);
            
            if([fileex isEqualToString:@""])
            {
                imageviw.image = [UIImage imageNamed:@"ico_folder.png"];
            }
          else if([fileex isEqualToString:@"jpg"]||[fileex isEqualToString:@"JPG"]||[fileex isEqualToString:@"png"]||[fileex isEqualToString:@"PNG"]||[fileex isEqualToString:@"jpeg"]||[fileex isEqualToString:@"JPEG"]||[fileex isEqualToString:@"bmp"]||[fileex isEqualToString:@"BMP"]||[fileex isEqualToString:@"svg"]||[fileex isEqualToString:@"SVG"])
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
            /*else
            {
                if (![fileex isEqualToString:@""])
                {
                     imageviw.image = [UIImage imageNamed:@"file.png"];
                }
            }*/
            if([fileex isEqualToString:@"png"]||[fileex isEqualToString:@"jpg"]||[fileex isEqualToString:@"pdf"]||[fileex isEqualToString:@"mp4"]||[fileex isEqualToString:@"PNG"]||[fileex isEqualToString:@"JPG"]||[fileex isEqualToString:@"PDF"]||[fileex isEqualToString:@"MP4"]||[fileex isEqualToString:@"xlsx"]||[fileex isEqualToString:@"XLSX"]||[fileex isEqualToString:@"xls"]||[fileex isEqualToString:@"XLS"]||[fileex isEqualToString:@"xlam"]||[fileex isEqualToString:@"XLAM"]||[fileex isEqualToString:@"xltm"]||[fileex isEqualToString:@"XLTM"]||[fileex isEqualToString:@"xlsm"]||[fileex isEqualToString:@"XLSM"]||[fileex isEqualToString:@"mp3"]||[fileex isEqualToString:@"MP3"]||[fileex isEqualToString:@"mp2"]||[fileex isEqualToString:@"MP2"]||[fileex isEqualToString:@"WAV"]||[fileex isEqualToString:@"wav"]||[fileex isEqualToString:@"aac"]||[fileex isEqualToString:@"AAC"]||[fileex isEqualToString:@"ac3"]||[fileex isEqualToString:@"AC3"]||[fileex isEqualToString:@"avi"]||[fileex isEqualToString:@"AVI"]||[fileex isEqualToString:@"flv"]||[fileex isEqualToString:@"FLV"]||[fileex isEqualToString:@"3gp"]||[fileex isEqualToString:@"3GP"]||[fileex isEqualToString:@"MPEG"]||[fileex isEqualToString:@"mpeg"]||[fileex isEqualToString:@"mkv"]||[fileex isEqualToString:@"MKV"]||[fileex isEqualToString:@"mov"]||[fileex isEqualToString:@"MOV"]||[fileex isEqualToString:@"WMV"]||[fileex isEqualToString:@"WMV"]||[fileex isEqualToString:@"ASF"]||[fileex isEqualToString:@"ASF"]||[fileex isEqualToString:@"ppt"]||[fileex isEqualToString:@"PPT"]||[fileex isEqualToString:@"pptx"]||[fileex isEqualToString:@"PPTX"]||[fileex isEqualToString:@"pptm"]||[fileex isEqualToString:@"PPTM"]||[fileex isEqualToString:@"pot"]||[fileex isEqualToString:@"POT"]||[fileex isEqualToString:@"potx"]||[fileex isEqualToString:@"POTX"]||[fileex isEqualToString:@"pps"]||[fileex isEqualToString:@"PPSX"]||[fileex isEqualToString:@"ppsm"]||[fileex isEqualToString:@"PPSM"]||[fileex isEqualToString:@"bmp"]||[fileex isEqualToString:@"BMP"]||[fileex isEqualToString:@"svg"]||[fileex isEqualToString:@"SVG"]||[fileex isEqualToString:@"DOC"]||[fileex isEqualToString:@"doc"]||[fileex isEqualToString:@"csv"]||[fileex isEqualToString:@"zip"]||[fileex isEqualToString:@"ZIP"]||[fileex isEqualToString:@"XML"]||[fileex isEqualToString:@"xml"]||[fileex isEqualToString:@"HTML"]||[fileex isEqualToString:@"html"]||[fileex isEqualToString:@"a"]||[fileex isEqualToString:@"A"]||[fileex isEqualToString:@"class"]||[fileex isEqualToString:@"CLASS"]||[fileex isEqualToString:@"js"]||[fileex isEqualToString:@"JS"]||[fileex isEqualToString:@"3dm"]||[fileex isEqualToString:@"3DM"]||[fileex isEqualToString:@"bin"]||[fileex isEqualToString:@"BIN"]||[fileex isEqualToString:@"p12"]||[fileex isEqualToString:@"P12"]||[fileex isEqualToString:@"TALK"]||[fileex isEqualToString:@"talk"]||[fileex isEqualToString:@"ZOO"]||[fileex isEqualToString:@"zoo"]||[fileex isEqualToString:@"z"]||[fileex isEqualToString:@"Z"]||[fileex isEqualToString:@"ZSH"]||[fileex isEqualToString:@"zsh"]||[fileex isEqualToString:@"xyz"]||[fileex isEqualToString:@"XYZ"]||[fileex isEqualToString:@"xpix"]||[fileex isEqualToString:@"XPIX"]||[fileex isEqualToString:@"xlm"]||[fileex isEqualToString:@"XLM"]||[fileex isEqualToString:@"XLS"]||[fileex isEqualToString:@"xls"]||[fileex isEqualToString:@"xmz"]||[fileex isEqualToString:@"XMZ"]||[fileex isEqualToString:@"wrz"]||[fileex isEqualToString:@"WRZ"]||[fileex isEqualToString:@"wp5"]||[fileex isEqualToString:@"WP5"]||[fileex isEqualToString:@"wp6"]||[fileex isEqualToString:@"WP6"]||[fileex isEqualToString:@"vrm"]||[fileex isEqualToString:@"VRM"]||[fileex isEqualToString:@"voc"]||[fileex isEqualToString:@"VOC"]||[fileex isEqualToString:@"UUE"]||[fileex isEqualToString:@"uue"]||[fileex isEqualToString:@"aab"]||[fileex isEqualToString:@"AAB"]||[fileex isEqualToString:@"aam"]||[fileex isEqualToString:@"AAM"]||[fileex isEqualToString:@"ABC"]||[fileex isEqualToString:@"abc"]||[fileex isEqualToString:@"ACGI"]||[fileex isEqualToString:@"acgi"]||[fileex isEqualToString:@"AF1"]||[fileex isEqualToString:@"af1"]||[fileex isEqualToString:@"aim"]||[fileex isEqualToString:@"AIM"]||[fileex isEqualToString:@"aip"]||[fileex isEqualToString:@"AIP"]||[fileex isEqualToString:@"ANI"]||[fileex isEqualToString:@"ani"]||[fileex isEqualToString:@"AOS"]||[fileex isEqualToString:@"aos"]||[fileex isEqualToString:@"APS"]||[fileex isEqualToString:@"aps"]||[fileex isEqualToString:@"AI"]||[fileex isEqualToString:@"ai"]||[fileex isEqualToString:@"aif"]||[fileex isEqualToString:@"AIF"]||[fileex isEqualToString:@"AIFC"]||[fileex isEqualToString:@"aifc"]||[fileex isEqualToString:@"aiff"]||[fileex isEqualToString:@"AIFF"]||[fileex isEqualToString:@"AIP"]||[fileex isEqualToString:@"aip"]||[fileex isEqualToString:@"ARC"]||[fileex isEqualToString:@"arc"]||[fileex isEqualToString:@"ARJ"]||[fileex isEqualToString:@"arj"]||[fileex isEqualToString:@"ASM"]||[fileex isEqualToString:@"asm"]||[fileex isEqualToString:@"asp"]||[fileex isEqualToString:@"ASP"]||[fileex isEqualToString:@"asx"]||[fileex isEqualToString:@"ASX"]||[fileex isEqualToString:@"au"]||[fileex isEqualToString:@"AU"]||[fileex isEqualToString:@"avs"]||[fileex isEqualToString:@"AVS"]||[fileex isEqualToString:@"bcpio"]||[fileex isEqualToString:@"BCPIO"]||[fileex isEqualToString:@"BOOK"]||[fileex isEqualToString:@"book"]||[fileex isEqualToString:@"BOZ"]||[fileex isEqualToString:@"boz"]||[fileex isEqualToString:@"bsh"]||[fileex isEqualToString:@"BSH"]||[fileex isEqualToString:@"c++"]||[fileex isEqualToString:@"C++"]||[fileex isEqualToString:@"c"]||[fileex isEqualToString:@"C"]||[fileex isEqualToString:@"CAT"]||[fileex isEqualToString:@"cat"]||[fileex isEqualToString:@"CC"]||[fileex isEqualToString:@"cc"]||[fileex isEqualToString:@"CCAD"]||[fileex isEqualToString:@"ccad"]||[fileex isEqualToString:@"COM"]||[fileex isEqualToString:@"com"]||[fileex isEqualToString:@"CHAT"]||[fileex isEqualToString:@"chat"]||[fileex isEqualToString:@"CHA"]||[fileex isEqualToString:@"cha"]||[fileex isEqualToString:@"CER"]||[fileex isEqualToString:@"cer"]||[fileex isEqualToString:@"CDF"]||[fileex isEqualToString:@"cdf"]||[fileex isEqualToString:@"CCO"]||[fileex isEqualToString:@"cco"]||[fileex isEqualToString:@"CRT"]||[fileex isEqualToString:@"crt"]||[fileex isEqualToString:@"CSH"]||[fileex isEqualToString:@"csh"]||[fileex isEqualToString:@"CSS"]||[fileex isEqualToString:@"css"]||[fileex isEqualToString:@"dcr"]||[fileex isEqualToString:@"DCR"]||[fileex isEqualToString:@"dp"]||[fileex isEqualToString:@"DP"]||[fileex isEqualToString:@"dvi"]||[fileex isEqualToString:@"DVI"]||[fileex isEqualToString:@"DWG"]||[fileex isEqualToString:@"dwg"]||[fileex isEqualToString:@"DXF"]||[fileex isEqualToString:@"dxf"]||[fileex isEqualToString:@"el"]||[fileex isEqualToString:@"EL"]||[fileex isEqualToString:@"ELC"]||[fileex isEqualToString:@"elc"]||[fileex isEqualToString:@"evy"]||[fileex isEqualToString:@"EVY"]||[fileex isEqualToString:@"crl"]||[fileex isEqualToString:@"CRL"]||[fileex isEqualToString:@"cpt"]||[fileex isEqualToString:@"CPT"]||[fileex isEqualToString:@"CPIO"]||[fileex isEqualToString:@"cpio"]||[fileex isEqualToString:@"wiz"]||[fileex isEqualToString:@"WIZ"]||[fileex isEqualToString:@"ustar"]||[fileex isEqualToString:@"USTAR"]||[fileex isEqualToString:@"UNV"]||[fileex isEqualToString:@"unv"]||[fileex isEqualToString:@"UNIS"]||[fileex isEqualToString:@"unis"]||[fileex isEqualToString:@"UNI"]||[fileex isEqualToString:@"uni"]||[fileex isEqualToString:@"TR"]||[fileex isEqualToString:@"tr"]||[fileex isEqualToString:@"UIL"]||[fileex isEqualToString:@"uil"]||[fileex isEqualToString:@"tsv"]||[fileex isEqualToString:@"TSV"]||[fileex isEqualToString:@"tsp"]||[fileex isEqualToString:@"TSP"]||[fileex isEqualToString:@"TEX"]||[fileex isEqualToString:@"tex"]||[fileex isEqualToString:@"SSI"]||[fileex isEqualToString:@"ssi"]||[fileex isEqualToString:@"SRC"]||[fileex isEqualToString:@"src"]||[fileex isEqualToString:@"TCSH"]||[fileex isEqualToString:@"tcsh"]||[fileex isEqualToString:@"SCM"]||[fileex isEqualToString:@"scm"]||[fileex isEqualToString:@"S"]||[fileex isEqualToString:@"s"]||[fileex isEqualToString:@"RNX"]||[fileex isEqualToString:@"rnx"]||[fileex isEqualToString:@"rng"]||[fileex isEqualToString:@"RNG"]||[fileex isEqualToString:@"rmp"]||[fileex isEqualToString:@"RMP"]||[fileex isEqualToString:@"rmm"]||[fileex isEqualToString:@"RMM"]||[fileex isEqualToString:@"RM"]||[fileex isEqualToString:@"rm"]||[fileex isEqualToString:@"rexx"]||[fileex isEqualToString:@"REXX"]||[fileex isEqualToString:@"ras"]||[fileex isEqualToString:@"RAS"]||[fileex isEqualToString:@"RAM"]||[fileex isEqualToString:@"ram"]||[fileex isEqualToString:@"ra"]||[fileex isEqualToString:@"RA"]||[fileex isEqualToString:@"QTC"]||[fileex isEqualToString:@"qtc"]||[fileex isEqualToString:@"QT"]||[fileex isEqualToString:@"qt"]||[fileex isEqualToString:@"PY"]||[fileex isEqualToString:@"py"]||[fileex isEqualToString:@"PYC"]||[fileex isEqualToString:@"pyc"]||[fileex isEqualToString:@"PSD"]||[fileex isEqualToString:@"psd"]||[fileex isEqualToString:@"POT"]||[fileex isEqualToString:@"pot"]||[fileex isEqualToString:@"PNM"]||[fileex isEqualToString:@"pnm"]||[fileex isEqualToString:@"PM4"]||[fileex isEqualToString:@"pm4"]||[fileex isEqualToString:@"PL"]||[fileex isEqualToString:@"pl"]||[fileex isEqualToString:@"PKO"]||[fileex isEqualToString:@"pko"]||[fileex isEqualToString:@"PKG"]||[fileex isEqualToString:@"pkg"]||[fileex isEqualToString:@"PFUNK"]||[fileex isEqualToString:@"pfunk"]||[fileex isEqualToString:@"PDB"]||[fileex isEqualToString:@"pdb"]||[fileex isEqualToString:@"PAS"]||[fileex isEqualToString:@"pas"]||[fileex isEqualToString:@"PART"]||[fileex isEqualToString:@"part"]||[fileex isEqualToString:@"P7R"]||[fileex isEqualToString:@"p7r"]||[fileex isEqualToString:@"P7S"]||[fileex isEqualToString:@"p7s"]||[fileex isEqualToString:@"P7M"]||[fileex isEqualToString:@"p7m"]||[fileex isEqualToString:@"P7C"]||[fileex isEqualToString:@"p7c"]||[fileex isEqualToString:@"P7A"]||[fileex isEqualToString:@"p7a"]||[fileex isEqualToString:@"P10"]||[fileex isEqualToString:@"p10"]||[fileex isEqualToString:@"OMCR"]||[fileex isEqualToString:@"omcr"]||[fileex isEqualToString:@"OMCD"]||[fileex isEqualToString:@"omcd"]||[fileex isEqualToString:@"OMC"]||[fileex isEqualToString:@"omc"]||[fileex isEqualToString:@"ODA"]||[fileex isEqualToString:@"oda"]||[fileex isEqualToString:@"O"]||[fileex isEqualToString:@"o"]||[fileex isEqualToString:@"NVD"]||[fileex isEqualToString:@"nvd"]||[fileex isEqualToString:@"NIF"]||[fileex isEqualToString:@"nif"]||[fileex isEqualToString:@"NCM"]||[fileex isEqualToString:@"ncm"]||[fileex isEqualToString:@"NC"]||[fileex isEqualToString:@"nc"]||[fileex isEqualToString:@"MZZ"]||[fileex isEqualToString:@"mzz"]||[fileex isEqualToString:@"MY"]||[fileex isEqualToString:@"my"]||[fileex isEqualToString:@"MV"]||[fileex isEqualToString:@"mv"]||[fileex isEqualToString:@"MS"]||[fileex isEqualToString:@"ms"]||[fileex isEqualToString:@"MRC"]||[fileex isEqualToString:@"mrc"]||[fileex isEqualToString:@"MPX"]||[fileex isEqualToString:@"mpx"]||[fileex isEqualToString:@"MPV"]||[fileex isEqualToString:@"mpv"]||[fileex isEqualToString:@"MPC"]||[fileex isEqualToString:@"mpc"]||[fileex isEqualToString:@"MPEG"]||[fileex isEqualToString:@"mpeg"]||[fileex isEqualToString:@"MOVIE"]||[fileex isEqualToString:@"movie"]||[fileex isEqualToString:@"MOOV"]||[fileex isEqualToString:@"moov"]||[fileex isEqualToString:@"MOD"]||[fileex isEqualToString:@"mod"]||[fileex isEqualToString:@"MME"]||[fileex isEqualToString:@"mme"]||[fileex isEqualToString:@"MM"]||[fileex isEqualToString:@"mm"]||[fileex isEqualToString:@"MIF"]||[fileex isEqualToString:@"mif"]||[fileex isEqualToString:@"MID"]||[fileex isEqualToString:@"mid"]||[fileex isEqualToString:@"MAR"]||[fileex isEqualToString:@"mar"]||[fileex isEqualToString:@"MAP"]||[fileex isEqualToString:@"map"]||[fileex isEqualToString:@"MAN"]||[fileex isEqualToString:@"man"]||[fileex isEqualToString:@"M3U"]||[fileex isEqualToString:@"m3u"]||[fileex isEqualToString:@"M2V"]||[fileex isEqualToString:@"m2v"]||[fileex isEqualToString:@"M2A"]||[fileex isEqualToString:@"m2a"]||[fileex isEqualToString:@"M1V"]||[fileex isEqualToString:@"m1v"]||[fileex isEqualToString:@"M"]||[fileex isEqualToString:@"m"]||[fileex isEqualToString:@"LZX"]||[fileex isEqualToString:@"lzx"]||[fileex isEqualToString:@"LZH"]||[fileex isEqualToString:@"lzh"]||[fileex isEqualToString:@"LTX"]||[fileex isEqualToString:@"ltx"]||[fileex isEqualToString:@"LSP"]||[fileex isEqualToString:@"lsp"]||[fileex isEqualToString:@"LOG"]||[fileex isEqualToString:@"log"]||[fileex isEqualToString:@"LMA"]||[fileex isEqualToString:@"lma"]||[fileex isEqualToString:@"LIST"]||[fileex isEqualToString:@"list"]||[fileex isEqualToString:@"LHX"]||[fileex isEqualToString:@"lhx"]||[fileex isEqualToString:@"LHA"]||[fileex isEqualToString:@"lha"]||[fileex isEqualToString:@"LA"]||[fileex isEqualToString:@"la"]||[fileex isEqualToString:@"KSH"]||[fileex isEqualToString:@"ksh"]||[fileex isEqualToString:@"KAR"]||[fileex isEqualToString:@"kar"]||[fileex isEqualToString:@"IV"]||[fileex isEqualToString:@"iv"]||[fileex isEqualToString:@"IT"]||[fileex isEqualToString:@"it"]||[fileex isEqualToString:@"ISU"]||[fileex isEqualToString:@"isu"]||[fileex isEqualToString:@"IP"]||[fileex isEqualToString:@"ip"]||[fileex isEqualToString:@"INS"]||[fileex isEqualToString:@"ins"]||[fileex isEqualToString:@"INF"]||[fileex isEqualToString:@"inf"]||[fileex isEqualToString:@"HTA"]||[fileex isEqualToString:@"hta"]||[fileex isEqualToString:@"HQX"]||[fileex isEqualToString:@"hqx"]||[fileex isEqualToString:@"HH"]||[fileex isEqualToString:@"hh"]||[fileex isEqualToString:@"HGL"]||[fileex isEqualToString:@"hgl"]||[fileex isEqualToString:@"HELP"]||[fileex isEqualToString:@"help"]||[fileex isEqualToString:@"HDF"]||[fileex isEqualToString:@"hdf"]||[fileex isEqualToString:@"H"]||[fileex isEqualToString:@"h"]||[fileex isEqualToString:@"GSM"]||[fileex isEqualToString:@"gsm"]||[fileex isEqualToString:@"g"]||[fileex isEqualToString:@"G"]||[fileex isEqualToString:@"FOR"]||[fileex isEqualToString:@"for"]||[fileex isEqualToString:@"java"]||[fileex isEqualToString:@"JAVA"]||[fileex isEqualToString:@"jar"]||[fileex isEqualToString:@"JAR"])
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
                    //NSLog(@"Rounded total: %@", [NSString stringWithFormat:@"%@MB,modified %.0fmins ago",strOnceAgain,-timeSince/1000]);
                    NSString *bitadd;
                                        bitadd = [NSString stringWithFormat:@"%@MB, modified %@",strOnceAgain,[self timeAgoSinceDate:self.selectedDate numericDates:NO]];
                    gallery_subname.text= [NSString stringWithFormat:@"%@",bitadd];
                }
                else if ([lenfind length]>=5||[lenfind length]>=4||[lenfind length]>=3||[lenfind length]>=2)
                {
                    NSString *str = [NSString stringWithFormat:@"%.2f",[[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"size"] doubleValue]];
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
                    //NSLog(@"Rounded total: %@", total);
                    NSString *bitadd;
                    bitadd = [NSString stringWithFormat:@"%@KB, modified %@",total,[self timeAgoSinceDate:self.selectedDate numericDates:NO]];
                    gallery_subname.text= [NSString stringWithFormat:@"%@",bitadd];
                }
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception Occur123456:%@",exception);
        }
        @finally
        {
        }
            });
        });
   }
return  cell;
}

-(NSString *)getMinutes:(NSString *)seconds
{
    int minitues=[seconds intValue]/60;
    int second=[seconds intValue]-(minitues*60);
    NSString *sec;
    if (second<10)
    {
        sec=[NSString stringWithFormat:@"0%d",second];
    }
    else
    {
        sec=[NSString stringWithFormat:@"%d",second];
    }
    //return [NSString stringWithFormat:@"%d",minitues];
    return [NSString stringWithFormat:@"%.f", fabs(minitues/60)];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   vie_popupRed.hidden=YES;
    
    //CollectionView
    if(indexPath.section==0)
    {
        //#####QBIMagePickerController####
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.folderId = @"";
        imagePickerController.folderKeys = @"first";
        if (indexPath.section == 0 && indexPath.row == 1)
        {
            [self.navigationController pushViewController:imagePickerController animated:YES];
        }
        else
        {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            //[[UINavigationBar appearance] setTintColor:[UIColor re]];
            [self.navigationController setTitle:@"Send My Files"];
            [self presentViewController:navigationController animated:YES completion:NULL];
        }
    }
    else
    {
        @try
        {
            if ([[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"type"] isEqualToString:@"folder"])
            {
                [self pathStorageUsesDB:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];
                [self pathStorageUsesDBs:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];
                [self performSegueWithIdentifier:@"senddata" sender:nil];
            
            }
            else
            {
                NSLog(@"Nothing folders ");
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception Occur:%@",exception);
        }
        @finally
        {
            
        }
    }
}
#pragma mark **************Logout button**************
- (IBAction)btn_logout:(id)sender
{
    UIAlertView *alertSignOut = [[UIAlertView alloc]initWithTitle:@"Log out" message:@"Do you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alertSignOut show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1)
    {
        // do something here...
        [self backBtnLogout];
    }
}

-(void)backBtnLogout
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ACCESS_TOKEN"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserId"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Username"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ProfileImg"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Name"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    //loginViews
UIStoryboard* storyboard = nil;
    
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
WMFViewController *smfviewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViews"];
    popfolderview.folderKeys = @"first";
    popfolderview.folderId = @"";
   //[self deleteDataFromDBFirst];
    [self presentViewController:smfviewController animated:YES completion:nil];
    [self deleteDataFromDBFirst];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    /*[temp setObject:filename forKey:@"name"];
     [temp setObject:fid forKey:@"id"];
     [temp setObject:fileType forKey:@"type"];
     [temp setObject:fileSize forKey:@"size"];
     [temp setObject:fileCreated forKey:@"created"];
     [temp setObject:fileSharingURL forKey:@"url"];*/
    //[self.folderKeys isEqualToString:@"first"][self.folderKeys isEqualToString:@"second"]
    if([[segue identifier] isEqualToString:@"senddata"])
    {
        [self SelectDataFromDbForSendMeFiles];
        self.secondviewController = [segue destinationViewController];
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        self.secondviewController.idValue = [[mu_tweetarray objectAtIndex:indexpath.row]objectForKey:@"id"];
    }
   /* else if ([[segue identifier]isEqualToString:@"FirstView"])
    {
        popfolderview = [segue destinationViewController];
        popfolderview.folderKeys = @"first";
        popfolderview.folderId = @"";
    }*/
}
#pragma mark - QBImagePickerControllerDelegate
- (void)dismissImagePickerController
{
    if (self.presentedViewController)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);

    _checkValueSet=YES;
    [self performSelector:@selector(dismissImagePickerController) withObject:self afterDelay:4.0];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** imagePickerController:didSelectAssets:");
    NSLog(@"AsswssValiiiiiiï:%@", assets);
    
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    popview = [storyboard instantiateViewControllerWithIdentifier:@"popview"];
    [self presentViewController:popview animated:YES completion:nil];*/
    
    [_labelCell addOperation:[NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(),^{
            NSLog(@"Uploading Loop Calling");
            for (int i = 0; i <[assets count]; i++)
            {
                ALAsset *asset = [assets objectAtIndex:i];
                NSLog(@"INDDDS>>>>>>??????????????:%@",[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]);
                
                NSString *filename = [NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]];

                [self whootinFileUploading:[self getImageFromAsset:assets[i] type:ASSET_PHOTO_SCREEN_SIZE] fileName:filename];
            }
        });
    }]];
    [self SelectDataFromDbForSendMeFiles];
    [self performSelector:@selector(dismissImagePickerController) withObject:self afterDelay:25.0];
    [self performSelector:@selector(reloadDataselect) withObject:self afterDelay:25.0];
}
-(void)reloadDataselect
{
    [self.tableView reloadData];
}
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    [self dismissImagePickerController];
}
-(void)imagePickerControllerFolder:(QBImagePickerController *)imagePickerController didBoolSelect:(BOOL)cancelbool
{
    //viw_sharingDelete.hidden=NO;
[self performSelector:@selector(dismissImagePickerController) withObject:self afterDelay:20.0];
[self performSelector:@selector(reloadDataselect) withObject:self afterDelay:20.0];
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
-(void)btn_Arrow :(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    UIView *view = button.superview;
    while (view && ![view isKindOfClass:[UITableViewCell self]]) view = view.superview;
    UITableViewCell *cell = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"row FFFFFFFF_________FFFFFFF %d",indexPath.row);
    NSLog(@"Short URl Valuw:%@",[NSString stringWithFormat:@"%@",[filesharingurl_send objectAtIndex:indexPath.row]]);
    CGPoint pointInSuperview = [button.superview convertPoint:button.center toView:self.tableView];
    // Infer Index Path
    NSIndexPath *indexPaths = [self.tableView indexPathForRowAtPoint:pointInSuperview];
    // Log to Console
    NSLog(@"Converstpath7787878787778787878787:%d", indexPaths.row);

    _strs = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"rowid"]];
    
    _fileId = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    _filetypes = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"type"]];
    
    _fileNames = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    _fileDownload = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"url"]];
    NSLog(@"Frame Get_______++++:%d",indexPath.row*80);
    
    NSLog(@"Frame Get fileDownload_______++++:%@",mu_tweetarray);
    
    //[self showListView];
   /*  if([_filetypes isEqualToString:@"folder"])
    {
        [self showGrid:YES];
    }
    else
    {
        [self showGrid:NO];
    }*/
    
    
    if (viwsharing_check==YES)
    {
        viw_shaDelrenexport.hidden = NO;
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
        viwsharing_check = NO;
    }
    else
    {
        viw_shaDelrenexport.hidden = YES;
        viwsharing_check = YES;
    }
    
    //viw_sharingDelete.hidden = NO;
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
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
    switch (anIndex)
    {
		case 0:
		{
            NSLog(@"Item A Selected");
            NSLog(@"Short URl Valuw:%@",_strs);
            /*Share_Views= [[UIView alloc]init];
            Share_Views.frame = CGRectMake(20,200, 280,192);
            btnsharingCancel.frame = CGRectMake(0,190,290,35);
            [Share_Views  setBackgroundColor:[UIColor colorWithRed:77/255.0 green:170/255.0 blue:223/255.0 alpha:1]];
            // border radius
            [Share_Views.layer setCornerRadius:5.0f];
            // drop shadow
            [Share_Views.layer setShadowColor:[UIColor blackColor].CGColor];
            [Share_Views.layer setShadowOpacity:0.8];
            [Share_Views.layer setShadowRadius:3.0];
            [Share_Views.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

            secondviews.frame = CGRectMake(7, 6, 266, 179);
            im_secondview.frame =CGRectMake(7, 6, 266, 179);
            im_secondview_sendlogo.frame = CGRectMake(10,8,204,45);
            [im_secondview setImage:[UIImage imageNamed:@"popup_sendlink.png"]];
            [im_secondview_sendlogo setImage:[UIImage imageNamed:@"sendmyfilename.png"]];
            [secondviews setBackgroundColor:[UIColor whiteColor]];

            btn_mail_pop.frame = CGRectMake(15,65,60,60);
            [btn_mail_pop setImage:[UIImage imageNamed:@"ic_mail.png"] forState:UIControlStateNormal];
            [btn_mail_pop addTarget:self action:@selector(mailPost) forControlEvents:UIControlEventTouchUpInside];

            btn_facebook_pop.frame = CGRectMake(110,65,60,60);
            [btn_facebook_pop setImage:[UIImage imageNamed:@"ic_fb.png"] forState:UIControlStateNormal];
            //[btn_facebook_pop addTarget:self action:@selector(facebooked) forControlEvents:UIControlEventTouchUpInside];
            
            [btn_facebook_pop addTarget:self action:@selector(facebooked) forControlEvents:UIControlEventTouchUpInside];
            
            btn_tweet_pop.frame = CGRectMake(205,65,60,60);
            [btn_tweet_pop setImage:[UIImage imageNamed:@"ic_twitter.png"] forState:UIControlStateNormal];
            [btn_tweet_pop addTarget:self action:@selector(twitterpost) forControlEvents:UIControlEventTouchUpInside];
            
            [btnsharingCancel setTitle:@"Cancel" forState:UIControlStateNormal];
            [btnsharingCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnsharingCancel addTarget:self action:@selector(sharingFaceAndTwitterAndMail) forControlEvents:UIControlEventTouchUpInside];
            
            [Share_Views addSubview:secondviews];
            [Share_Views addSubview:im_secondview];
            [Share_Views addSubview:btn_mail_pop];
            
            [Share_Views addSubview:btn_facebook_pop];
            [Share_Views addSubview:btn_tweet_pop];
            [Share_Views addSubview:btnsharingCancel];
            [self.tableView addSubview:Share_Views];*/
            //[self leveyPopListViewDidCancel];
            viw_sharing.hidden = NO;
			break;
		}
		case 1:
		{
			NSLog(@"Item B Selected");
           _lbl_delete_name.text = [NSString stringWithFormat:@"%@",_fileNames];
            [self viewdeletefunc];
			break;
		}
		case 2:
		{
			NSLog(@"Item C Selected");
            [self renameViewWithtextBox];
            _txt_whootin_rename.text = [NSString stringWithFormat:@"%@",_fileNames];
			break;
		}
        case 3:
		{
			NSLog(@"Item D Selected");
            viw_whootinexports.hidden=NO;
			break;
		}
	}
    //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@",_options[anIndex]];
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
    else
    {
        showAlert(@"Please Signin facebook in settings");
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
    else
    {
        showAlert(@"Please Signin facebook in settings");
    }

    [Share_Views removeFromSuperview];
}
-(void)mailPost:(NSString *)urlNames
{
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    //NSString *messageBody = @"iOS programming is so fun!";
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:urlNames isHTML:NO];
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
-(void)sharingFaceAndTwitterAndMail
{
    [Share_Views removeFromSuperview];
}
-(void)renameViewWithtextBox
{
    [_txt_whootin_rename.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_txt_whootin_rename.layer setBorderWidth:2.0];
    
    [_txt_extbox.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_txt_extbox.layer setBorderWidth:2.0];
    
    viw_whootinfiles.hidden=NO;
}
//secondviewController
- (IBAction)btn_whootinrename_cancel:(id)sender
{
    viw_whootinfiles.hidden = YES;
}
- (IBAction)btn_whootinrename_rename:(id)sender
{
    [self renameViewCreations];
}
-(void)renameViewCreations
{
    
    NSLog(@"Whootin Post Calling");
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_async(concurrentQueue, ^{
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
    NSString *pComment;
    if ([_txt_extbox.text isEqualToString:@""])
    {
      pComment=[NSString stringWithFormat:@"%@",_txt_whootin_rename.text];
    }
    else
    {
      pComment=[NSString stringWithFormat:@"%@.%@",_txt_whootin_rename.text,_txt_extbox.text];
    }
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[pComment dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // add body to post NSString* myString;
    NSString *myString;
    myString = [[NSString alloc] initWithData:postBody encoding:NSASCIIStringEncoding];
    NSLog(@"TRY One Finding:%@",myString);
    [request setHTTPBody:postBody];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", sUserDefault] forHTTPHeaderField:@"Authorization"];
         dispatch_async(dispatch_get_main_queue(), ^{
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"just sent request");
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]length:[responseData length]encoding:NSUTF8StringEncoding] ;
    NSLog(@"%@",responseString);
             [self deleteTableIndexs:_fileNames];
             [self whootingGetFiles];
             [self SelectDataFromDbForSendMeFiles];
             [self.tableView reloadData];
             _txt_extbox.text =@"";
             
         });
         
     });

    
   /* hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Update";
    [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    [hud show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
    dispatch_async(downloadQueue, ^{[NSThread sleepForTimeInterval:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        });
    });*/
    
    
    viw_whootinfiles.hidden = YES;
}
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}
-(void)viewdeletefunc
{
    viw_whootindelete.hidden = NO;
}
- (IBAction)btn_delete_no:(id)sender
{
    viw_whootindelete.hidden = YES;
}
- (IBAction)btn_delete_del:(id)sender
{
     [self whootinFileDeleting];
    viw_whootindelete.hidden = YES;
}
-(void)fileExposed:(NSString *)fileURL
{
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
- (IBAction)btn_save_file:(id)sender
{
     [self fileExposed:_fileDownload];
      viw_whootinexports.hidden=YES;
}
- (IBAction)btn_save_Email:(id)sender
{
    [self mailPost:_fileDownload];
      viw_whootinexports.hidden=YES;
}
-(void)deleteWhootinNamesPath_tbls
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootintemps_tbl"];
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
-(void)deleteDatawhootintemp_idFolder
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinbacknavfolder_tbl"];
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
-(void)deleteDatawhootintemp_idFolderTwo
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinbacknav_tbl"];
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

-(void)deleteWhootinNames_tbls
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinnames_tbl"];
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
-(void)deleteDataFromDBSecond
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
-(void)deleteTableIndex:(NSString *)indes
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinfirst_tbl where whootin_id=\"%@\"",indes];
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
-(void)deleteTableIndexs:(NSString *)delNames
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinfirst_tbl where  whootin_name=\"%@\"",delNames];
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
- (IBAction)btn_newfolder_firstviw:(id)sender
{
    hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Please Wait";
    [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    [hud show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
    dispatch_async(downloadQueue, ^{[NSThread sleepForTimeInterval:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    });
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
    popfolderview = [storyboard instantiateViewControllerWithIdentifier:@"newfolders"];
    popfolderview.folderKeys = @"first";
    popfolderview.folderId = @"";
   [self presentViewController:popfolderview animated:YES completion:NULL];
}
- (IBAction)btn_Upload_firstviw:(id)sender
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.folderId = @"";
    imagePickerController.folderKeys = @"first";
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        //[[UINavigationBar appearance] setTintColor:[UIColor re]];
        
        [self.navigationController setTitle:@"Whootin Files"];
        [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)btn_align_alpha:(id)sender
{
    boalignalpha=YES;
    boaligntime=NO;
    boaligntype=NO;
    [self SelectDataFromDbForSendMeFiles];
    [self.tableView reloadData];
}
- (IBAction)btn_align_Time:(id)sender
{
    boaligntime=YES;
    boalignalpha=NO;
    boaligntype=NO;
    [self SelectDataFromDbForSendMeFilesAlignTypes];
    [self.tableView reloadData];
}
- (IBAction)btn_align_filetype:(id)sender
{
    boaligntype=YES;
    boalignalpha=NO;
    boaligntime=NO;
    [self SelectDataFromDbForSendMeFilesAlignTypes];
    [self.tableView reloadData];
}
-(void)SelectDataFromDbForSendMeFilesAlignTypes
{
    [mu_fileNames_send removeAllObjects];
    [mu_fileId_send removeAllObjects];
    [mu_fileType_send removeAllObjects];
    [mu_filesize_send removeAllObjects];
    [mu_filecreated_send removeAllObjects];
    [mu_FolderAndFileComb_Send removeAllObjects];
    [mu_FolderAndFileCombDownload_send removeAllObjects];
    [mu_notFolderDownload_send removeAllObjects];
    [mu_notFolder_send removeAllObjects];
    [mu_tweetarray removeAllObjects];
    
    NSString *fileType;
    NSString *filename;
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSString *querySQL;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        querySQL = [NSString stringWithFormat: @"SELECT whootin_id,whootin_name,whootin_type,whootin_size,whootin_creating,whootin_shorturl,whootin_downloadurl FROM whootinfirst_tbl ORDER BY whootin_type DESC"];
        // }
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
                const char*Fname=(const char *) sqlite3_column_text(statement, 1);
                filename = Fname == NULL ? nil : [[NSString alloc] initWithUTF8String:Fname];
                const char*FID=(const char *) sqlite3_column_text(statement, 0);
                NSString *fid= FID == NULL ? nil : [[NSString alloc] initWithUTF8String:FID];
                const char*FType=(const char *) sqlite3_column_text(statement, 2);
                fileType = FType == NULL ? nil : [[NSString alloc] initWithUTF8String:FType];
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
                        
                        
                         [mu_FolderAndFileCombDownload_send addObject:temp1];
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        [mu_FolderAndFileCombDownload_send sortUsingDescriptors:sortDescriptors];
                    
                        
                        //mu_FolderAndFileCombDownload_send = [sortDescriptors copy];
                        
                    }
                    else
                    {
                        [temp1 setObject:filename forKey:@"name"];
                        [temp1 setObject:fid forKey:@"id"];
                        [temp1 setObject:fileType forKey:@"type"];
                        [temp1 setObject:fileSize forKey:@"size"];
                        [temp1 setObject:fileCreated forKey:@"created"];
                        [temp1 setObject:fileSharingURL forKey:@"url"];
                        
                        [mu_notFolderDownload_send addObject:temp1];
                        
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
                    
                    [mu_filedownload_send addObject:rowid];
                    [mu_fileNames_send addObject:filename];
                    [mu_fileId_send addObject:fid];
                    [mu_fileType_send addObject:fileType];
                    [mu_filesize_send addObject:fileSize];
                    [mu_filecreated_send addObject:fileCreated];
                    [filesharingurl_send addObject:fileSharingURL];
                    
                    [storeFiles setValue:filename forKey:@"name"];
                    [storeFiles setValue:fid forKey:@"rowid"];
                    [storeFiles setValue:fileType forKey:@"type"];
                    [storeFiles setValue:fileSize forKey:@"size"];
                    [storeFiles setValue:fileCreated forKey:@"created"];
                    [storeFiles setValue:fileSharingURL forKey:@"url"];
                    
                    [temp setObject:filename forKey:@"name"];
                    [temp setObject:fid forKey:@"id"];
                    [temp setObject:fileType forKey:@"type"];
                    [temp setObject:fileSize forKey:@"size"];
                    [temp setObject:fileCreated forKey:@"created"];
                    [temp setObject:fileSharingURL forKey:@"url"];

                    [mu_tweetarray addObject:temp];
                    
                    //_tweetsArray = [NSMutableArray arrayWithObjects:dict1, nil];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
   
}
- (IBAction)btn_trigger_align:(id)sender
{
    if(boviepopupRed==YES)
    {
        vie_popupRed.hidden=NO;
        [UIView animateWithDuration:0.25 animations:^{
            vie_popupRed.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
        boviepopupRed = NO;
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            [vie_popupRed setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [vie_popupRed setHidden:YES];
        }];
        boviepopupRed = YES;
    }
}
- (IBAction)btn_mail:(id)sender
{
    [self mailPost:_fileDownload];
    viw_sharing.hidden=YES;
    
}
- (IBAction)btn_facebook:(id)sender
{
    [self facebooked];
    viw_sharing.hidden=YES;
}
- (IBAction)btn_tiwtter:(id)sender
{
    [self  twitterpost];
    viw_sharing.hidden = YES;
}
- (IBAction)btn_send_cancel:(id)sender
{
    viw_sharing.hidden = YES;
}
#pragma mark ********PopUpView***************
#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    vie_popupRed.hidden=YES;
    switch (itemIndex)
    {
    case 0:
		{
            NSLog(@"Item A Selected");
            NSLog(@"Short URl Valuw:%@",_strs);
            viw_sharing.hidden = NO;
			break;
		}
		case 1:
		{
			NSLog(@"Item B Selected");
            _lbl_delete_name.text = [NSString stringWithFormat:@"%@",_fileNames];
            [self viewdeletefunc];
			break;
		}
		case 2:
		{
			NSLog(@"Item C Selected");
            [self renameViewWithtextBox];
            NSString *ext = [NSString stringWithFormat:@"%@",_fileNames];
            aray = [ext componentsSeparatedByString:@"."];
            NSString *fileex;
            if(aray.count==1)
            {
                [_txt_extbox setHidden:true];
            }
            if(aray.count>=2)
            {
                 [_txt_extbox setHidden:false];
                _txt_extbox.enabled=NO;
                //NSLog(@"Fixing:%@",aray[1] );
               _txt_extbox.text = [NSString stringWithFormat:@"%@",aray[1]];
            }
            _txt_whootin_rename.text = [NSString stringWithFormat:@"%@",aray[0]];
			break;
		}
        case 3:
		{
			NSLog(@"Item D Selected");
            viw_whootinexports.hidden=NO;
			break;
		}
	}
}
#pragma mark - Private
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
- (void)showGridWithPath
{
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
- (IBAction)btn_main_share:(id)sender
{
     vie_popupRed.hidden=YES;
    viw_shaDelrenexport.hidden = YES;
    viw_sharing.hidden = NO;
    viwsharing_check = YES;
}
- (IBAction)btn_main_delete:(id)sender
{
     vie_popupRed.hidden=YES;viw_shaDelrenexport.hidden = YES;viwsharing_check = YES;
    _lbl_delete_name.text = [NSString stringWithFormat:@"%@",_fileNames];
    [self viewdeletefunc];
}
- (IBAction)btn_main_rename:(id)sender
{
     vie_popupRed.hidden=YES;viw_shaDelrenexport.hidden = YES;viwsharing_check = YES;
    [self renameViewWithtextBox];
    NSString *ext = [NSString stringWithFormat:@"%@",_fileNames];
    aray = [ext componentsSeparatedByString:@"."];
    NSString *fileex;
    if(aray.count==1)
    {
        [_txt_extbox setHidden:true];
    }
    if(aray.count>=2)
    {
        [_txt_extbox setHidden:false];
        _txt_extbox.enabled=NO;
        //NSLog(@"Fixing:%@",aray[1] );
        _txt_extbox.text = [NSString stringWithFormat:@"%@",aray[1]];
    }
    _txt_whootin_rename.text = [NSString stringWithFormat:@"%@",aray[0]];
}
- (IBAction)btn_main_export:(id)sender
{
     vie_popupRed.hidden=YES;
    viw_shaDelrenexport.hidden = YES;
    viwsharing_check = YES;
    viw_whootinexports.hidden=NO;
}
- (IBAction)btn_20Gb_Close:(id)sender
{
        
   
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
- (IBAction)btn_cancel_upgrade:(id)sender
{
    viw_20sharing.hidden=YES;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];

}
- (void)handleOpenURL:(NSURL *)url
{
    //NSString *fileString = [NSString stringWithContentsOfURL:url
                                            //encoding:NSUTF8StringEncoding error:&outError];
    NSLog(@"url recieved:->>>>> %@", url);
    NSLog(@"query string:->>>>> %@", [url query]);
    NSLog(@"host:->>>>>> %@", [url host]);
    NSLog(@"url path:->>>>>>> %@", [url path]);
    NSLog(@"File Path:%@",[self findFiles:[NSString stringWithFormat:@"%@",url]]);
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.chooseLocation = [storyboard instantiateViewControllerWithIdentifier:@"savetoDropbox"];
    self.chooseLocation.fileLocations = [NSString stringWithFormat:@"%@",url];
    self.chooseLocation.fileLocationsUrl = url;
    [self presentViewController:self.chooseLocation animated:NO completion:nil];
    NSLog(@"<<<<<<<-URL Values->>>>>>>>>");
    //[self.tableView reloadData];
}
-(NSArray *)findFiles:(NSString *)extension{
    
    NSMutableArray *matches = [[NSMutableArray alloc]init];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *item;
    NSArray *contents = [fManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    
    // >>> this section here adds all files with the chosen extension to an array
    for (item in contents){
        if ([[item pathExtension] isEqualToString:extension]) {
            [matches addObject:item];
        }
    }
    return matches;
}
//Horiz
/*- (NSInteger) numberOfColumnsInListView:(SListView *) listView
{
    return 50;
}
- (CGFloat) widthForColumnAtIndex:(NSInteger) index
{
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
    cell.alpha = 0.5;
    cell.backgroundColor = [UIColor yellowColor];
    return  cell;
}

- (void) listView:(SListView *)listView didSelectColumnAtIndex:(NSInteger)index
{
    
}
*/
- (IBAction)btn_cancel_export:(id)sender
{
    viw_whootinexports.hidden = YES;
}

- (IBAction)btn_barSettings:(id)sender
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
    popSettings = [storyboard instantiateViewControllerWithIdentifier:@"whootinsettings"];
    [self presentViewController:popSettings animated:YES completion:NULL];
    
    
    vie_popupRed.hidden=YES;

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
        viw_20sharing.hidden=YES;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
        
    }
    
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

- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue
{
    
}

@end
