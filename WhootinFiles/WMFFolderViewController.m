//
//  WMFFolderViewController.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 6/5/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "WMFFolderViewController.h"
#import "NSDate+DateTools.h"
#import "QBImagePickerController.h"
#import "WMFSecondFolderViewController.h"
#import "HorizontalCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Toast.h"

@interface WMFFolderViewController ()
@property NSDate *selectedDate;
@property NSDateFormatter *formatter;
@end

@implementation WMFFolderViewController
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
    textFont=[UIFont fontWithName:@"Helvetica" size:15.0];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {  CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height==568)
        {
            CGPoint oldCenter=_tableViewPaths.center;
            _tableViewPaths.frame=CGRectMake(0.0, 0.0, _tableViewPaths.bounds.size.height-1000, _tableViewPaths.bounds.size.width);
            _tableViewPaths.transform=CGAffineTransformMakeRotation(-M_PI_2);
            _tableViewPaths.center=oldCenter;
        }
        else
        {
            CGPoint oldCenter=_tableViewPaths.center;
            _tableViewPaths.frame=CGRectMake(0.0, 0.0, _tableViewPaths.bounds.size.height-20, _tableViewPaths.bounds.size.width);
            _tableViewPaths.transform=CGAffineTransformMakeRotation(-M_PI_2);
            _tableViewPaths.center=oldCenter;
        }
    }
    else
    {
        CGPoint oldCenter=_tableViewPaths.center;
        _tableViewPaths.frame=CGRectMake(0.0, 0.0, _tableViewPaths.bounds.size.height-1000, _tableViewPaths.bounds.size.width);
        _tableViewPaths.transform=CGAffineTransformMakeRotation(-M_PI_2);
        _tableViewPaths.center=oldCenter;
    }
    _tableViewPaths.showsVerticalScrollIndicator = NO;
    _tableViewPaths.separatorStyle=UITableViewCellSeparatorStyleNone;
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    /* NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
     [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
     refreshControl.attributedTitle = refreshString; */
    [self.tableView addSubview:refreshControl];
    NSLog(@"Folder Keys:%@",self.folderKeys);
	//Do any additional setup after loading the view.
    _labelCell = [[NSOperationQueue alloc]init];
    [_labelCell setMaxConcurrentOperationCount:1];
    mu_tweetarray =[[NSMutableArray alloc]init];
    mu_AssestValues = [[NSMutableArray alloc]init];
    mu_dirnames = [[NSMutableArray alloc]init];
    mu_backmovefolders = [[NSMutableArray alloc]init];
    viw_folderLow.hidden=NO;
    viw_NewFolder_Creations.hidden=NO;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"upgrades"];
    NSLog(@"NSUserDefaults:%@",myString);
    if ([myString isEqualToString:@"one"])
    {
        viw_20gbupgrade.hidden=NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
        viw_20gbupgrade.hidden=YES;
    }

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
-(void)reloadDatas
{
    //update here...
    
    [self.tableView reloadData];
    [_tableViewPaths reloadData];
    [refreshControl endRefreshing];
}
-(void)viewDidAppear:(BOOL)animated
{
    nonClicking = NO;
    viw_folderLow.hidden=NO;
    viw_NewFolder_Creations.hidden=NO;
    //[self deleteWhootinNames_tbls];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"upgrades"];
    NSLog(@"NSUserDefaults:%@",myString);
    if ([myString isEqualToString:@"one"])
    {
        viw_20gbupgrade.hidden=NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
        viw_20gbupgrade.hidden=YES;
    }
    if ([self.folderKeys isEqualToString:@"second"])
    {
    NSLog(@"Checking FOlder Pass OR Not Dynamically Values>>>>>:%@",self.idValuesecond);//107458
    [self whootingGetFiles:self.idValuesecond];
        [self.tableView reloadData];
        [_tableViewPaths reloadData];
    _fileIdFormtb = self.idValuesecond;
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
            [_tableViewPaths reloadData];
           // [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    });
    }
    else
    {
        //[self performSelectorOnMainThread:@selector(whootinFilesFromFirstTableView)
                              // withObject:nil waitUntilDone:YES];
        
        [self whootinFilesFromFirstTableView];
        [self.tableView reloadData];
        [_tableViewPaths reloadData];
        hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = @"Please Wait";
        [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
        [hud show:YES];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
        dispatch_async(downloadQueue, ^{[NSThread sleepForTimeInterval:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [self.tableView reloadData];
                [_tableViewPaths reloadData];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
        });

    }
    
}
/*-(void)viewWillAppear:(BOOL)animated
{
    
}*/
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
#pragma mark #######SecondView
- (void)doSomeFunkyStuff{
    float progress = 0.0;
    
    while (progress < 1.0) {
        progress += 0.01;
        hud.progress = progress;
        usleep(50000);
    }
}
-(void)whootingGetFiles :(NSString *)idval
{
    //[self whootinIds:self.idValue];
    //ContentValuesInsertedValues
    if ([self.folderKeys isEqualToString:@"second"])
    {
        [self deleteDataFromDB];
        [mu_fileNames_send_Second removeAllObjects];
        [mu_fileId_send_Second removeAllObjects];
        [mu_idfile addObject:idval];
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
        NSArray *JsonDict = [newStr JSONValue];
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
            //[mu_idfile addObject:[[NSMutableArray alloc]initWithArray:[JsonDict valueForKey:@"parent_id"]]];
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
    }
}
-(void)whootinFilesFromFirstTableView
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/files.json?count=30"];
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
            
            for(int i=0;i<mu_fileNames_Con.count;i++)
            {
                [self whootinValuesInserts:mu_fileNames_Con[i] ID:mu_fileId_Con[i] TYPE:mu_fileType_Con[i] SIZES:mu_filesize_Con[i] CREATED:mu_filecreated_Con[i] SHORTURL:mu_fileUrl_Con[i] DOWNLOADURL:mu_fileDownUrl_con[i] BOOLCHECKING:[self countDataFromDBs:mu_fileId_Con[i] names:mu_fileNames_Con[i]]];
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception Occur:%@",exception);
        }
        @finally
        {
            
        }
        dispatch_semaphore_signal(semaphore);
        });
}
-(BOOL)countDataFromDBs:(NSString *)values names:(NSString *)fileNames
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

-(void)whootinValuesInserts:(NSString *)name ID:(NSString *)ids TYPE:(NSString *)type SIZES:(NSString *)sizes CREATED:(NSString *)created  SHORTURL:(NSString *)shorturl DOWNLOADURL:(NSString *)downloadurl BOOLCHECKING:(BOOL)returnValue
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
-(void)deleteDataFromDBPopViews
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinasses_tbl"];
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

-(void)selectDataFormDB
{
    [mu_tweetarray removeAllObjects];
    if([self.folderKeys isEqualToString:@"first"])
    {
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
                    
                    [temp setObject:filename forKey:@"name"];
                    [temp setObject:fid forKey:@"id"];
                    [temp setObject:fileType forKey:@"type"];
                    [temp setObject:fileSize forKey:@"size"];
                    [temp setObject:fileCreated forKey:@"created"];
                    [temp setObject:fileSharingURL forKey:@"url"];
    
                    [mu_tweetarray addObject:temp];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    else if ([self.folderKeys isEqualToString:@"second"])
    {
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
                    
                    [temp setObject:filename forKey:@"name"];
                    [temp setObject:fid forKey:@"id"];
                    [temp setObject:fileType forKey:@"type"];
                    [temp setObject:fileSize forKey:@"size"];
                    [temp setObject:fileCreated forKey:@"created"];
                    [temp setObject:fileSharingURL forKey:@"url"];
                    [temp setObject:parentid forKey:@"parentid"];
                    [temp setObject:rowid forKey:@"rowid"];
                    
                    [mu_tweetarray addObject:temp];
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==_tableViewPaths)
    {
        //return 100.0f;
        NSString *strCellText=[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"];
        return 50+[strCellText sizeWithFont:textFont].width;
    }
    
    return 60.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_tableViewPaths)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableViewPaths)
    {
        [self SelectDataFromWHootinName_tbl];
        
        
        if([mu_dirnames count]==0)
        {
            return 1;
        }
        else
        return mu_dirnames.count;
    }

    if (section==0)
    {
        return 1;
    }
    else
    {
    [self selectDataFormDB];
    return  mu_tweetarray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==_tableViewPaths)
    {
        static NSString *identifier=@"reusableIdentifier";
        HorizontalCell *cell=(HorizontalCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(nil==cell)
        {
            cell=[[HorizontalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.font=textFont;
        }
        if([mu_dirnames count]==0)
        {
            cell.textLabel.text= @"Home >";
            cell.imageView.image = [UIImage imageNamed:@"Shape-4.png"];
            
        }
        else
        {
        
        NSString *homes = [[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"];
        NSString *lastOb = [NSString stringWithFormat:@"%d",[mu_dirnames count]-1];
        NSString *indexGet = [NSString stringWithFormat:@"%d",indexPath.row];
        NSLog(@"ValuesKKKKK::::::KK%@",indexGet);
        NSLog(@"ValuesKKKKK::::::KKPPPP%@",lastOb);
            
        if([homes isEqualToString:@"Home"])
        {
            cell.imageView.image = [UIImage imageNamed:@"Shape-4.png"];
            cell.textLabel.text=[NSString stringWithFormat:@"%@ >",[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"]];
        }
        else if ([indexGet isEqualToString:lastOb])
        {
            cell.imageView.image = [UIImage imageNamed:@"Shape-3.png"];
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"]];
            
        }
        else if (![indexGet isEqualToString:lastOb])
        {
            
            cell.imageView.image = [UIImage imageNamed:@"Shape-2.png"];
            cell.textLabel.text=[NSString stringWithFormat:@"%@ >",[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"]];
        }
        
        }
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel *gallery_subname = (UILabel *)[cell viewWithTag:2];
    UIImageView *imageviw = (UIImageView *)[cell viewWithTag:1];
    UILabel *gallery_name = (UILabel *)[cell viewWithTag:3];
    //UIButton *btnShare = (UIButton *)[cell viewWithTag:12];
    UIView *line = (UIView *)[cell viewWithTag:10];
    [line setBackgroundColor:[UIColor blackColor]];
    
    gallery_name.font = [UIFont fontWithName:@"Segoe UI" size:500];
    gallery_subname.font = [UIFont fontWithName:@"Segoe UI" size:500];
    
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            imageviw.image = [UIImage imageNamed:@"btn_uparrow.png"];
            gallery_subname.text = @"Up to Whootin Files";
            gallery_name.text = @" ";
        }
    }
    else if(indexPath.section==1)
    {
    @try {
    [self selectDataFormDB];
    gallery_subname.text = [[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"];
    gallery_name .text  = @" ";
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //UIStoryboard *storyBoard;
            imageviw.image = [UIImage imageNamed:@"ico_folder.png"];
        }
        else
        {
            imageviw.image = [UIImage imageNamed:@"Ipad_ico_folder.png"];
        }

    NSString *ext = [NSString stringWithFormat:@"%@",gallery_subname.text];
    aray = [ext componentsSeparatedByString:@"."];
    NSString *fileex;
    if(aray.count>=2)
    {
        //NSLog(@"Fixing:%@",aray[1] );
        fileex = [NSString stringWithFormat:@"%@",aray[1]];
    }
    NSString *dateGetFromWoo = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"created"]];
    arayCreated = [dateGetFromWoo componentsSeparatedByString:@"T"];
    //NSLog(@"ArrayCreates:%@",arayCreated[0]);
    NSString *value3 = [NSString stringWithFormat:@"%@",arayCreated[0]];
    NSString *value4    = [NSString stringWithFormat:@"%@",arayCreated[1]];
    arayCreatedZ = [value4 componentsSeparatedByString:@"Z"];
    NSString *value5 =[ NSString stringWithFormat:@"%@",arayCreatedZ[0]];
    NSString *valu3 = [NSString stringWithFormat:@"%@ %@",value3,value5];
    NSString *fileIds =[NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"parentid"]];
        if([fileIds isEqualToString:@""])
        {
            _fileIdFormtb =  [NSString stringWithFormat:@"%@",self.idValuesecond];
        }
        else
        {
            _fileIdFormtb = [NSString stringWithFormat:@"%@",[[mu_tweetarray objectAtIndex:indexPath.row] objectForKey:@"parentid"]];
        }
        
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
        
        imageviw.image = [UIImage imageNamed:@"ico_xls.png"];
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
            bitadd = [NSString stringWithFormat:@"%@MB,modified %@",strOnceAgain,[self timeAgoSinceDate:self.selectedDate numericDates:NO]];
            gallery_name.text= [NSString stringWithFormat:@"%@",bitadd];
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
            bitadd = [NSString stringWithFormat:@"%@KB,modified %@",total,[self timeAgoSinceDate:self.selectedDate numericDates:NO]];
            gallery_name.text= [NSString stringWithFormat:@"%@",bitadd];
        }
    }
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableViewPaths)
    {
    
        NSString *lastOb = [NSString stringWithFormat:@"%d",[mu_dirnames count]-1];
        NSString *indexGet = [NSString stringWithFormat:@"%d",indexPath.row];
        if ([indexGet isEqualToString:lastOb])
        {
            [self.tableView reloadData];
            [_tableViewPaths reloadData];
        }
        else
        {
            
            [self whootingGetFiles:[[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"rowidk"]];
            [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_TblPaths]];
            [self.tableView reloadData];
            [_tableViewPaths reloadData];
        }
        NSString *homes = [[mu_dirnames objectAtIndex:indexPath.row]objectForKey:@"fname"];
        if([homes isEqualToString:@"Home"])
        {
            [self performSegueWithIdentifier:@"Firstfolder" sender:self];
        }
    }
    else
    {
   if(indexPath.section==0)
   {
       if(indexPath.row==0)
       {
       /*if ([self.folderKeys isEqualToString:@"second"])
       {
           [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_TblPaths]];
           [self performSegueWithIdentifier:@"Secondfolder" sender:self];
       }
       else
       {
           [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_TblPaths]];
           [self performSegueWithIdentifier:@"Firstfolder" sender:self];
       }*/
           if ([self.folderKeys isEqualToString:@"second"])
           {
               [self SelectDataFromDbForSendMeFilesIdsBackFolder];
               if([mu_backmovefolders count]>0)
               {
                   NSString *backidValues;
                   for (int i=0; i<[mu_backmovefolders count]; i++)
                   {
                       //NSLog(@"ReverseObjectEnumerator:%@",[[reversedArray objectAtIndex:i] objectForKey:@"parentidv"]);
                       backidValues= [[mu_backmovefolders objectAtIndex:i] objectForKey:@"parentidv"];
                   }
                   NSLog(@"BockIDValues%@",backidValues);
                   if([backidValues isEqualToString:@"(null)"])
                   {
                       [self dismissViewControllerAnimated:YES completion:nil];
                   }
                   else
                   {
                       
                       [self whootingGetFiles:backidValues];
                       [self.tableView reloadData];
                       
                   }
               }
               else
               {
                   //[self dismissViewControllerAnimated:YES completion:nil];
                   [self performSegueWithIdentifier:@"Firstfolder" sender:self];
               }
               
               
           }
           else
           {
               [self deleteWhootinNamesPath_tbls:[self SelectedDataFromWhootinName_Tbl]];
               [self performSegueWithIdentifier:@"Firstfolder" sender:self];
               
           }
         if([mu_backmovefolders count]>0)
        {
           [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_Tbl]];
           }
           [self deleteTableBackWhootin_Tbl:[self backSelectedDataFromWhootinName_Tbl]];
           [_tableViewPaths reloadData];
       }
   }
    else if(indexPath.section==1)
    {
       [self selectDataFormDB];
        UIStoryboard* storyboard =nil;
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
        
        if ([[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"type"] isEqualToString:@"folder"])
        {
        
      WMFSecondFolderViewController *WMFSecondTable = [storyboard instantiateViewControllerWithIdentifier:@"SecondFolder"];
        //NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        WMFSecondTable.idValue = [[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"];
        //[self pathStorageUsesDBs:@"Home" IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];
        [self pathStorageUsesDBs:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"] BOOLCHECKING:[self countDataFromDBPath:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"]]];
        [self backFolderStorageUsesDBs:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"] BOOLCHECKING:[self countDataFromDBBackFolder:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]]];
        if(nonClicking==YES)
        {
            WMFSecondTable.idValue =[NSString stringWithFormat:@"%@",_IdOfAllValues];
        }
        [self presentViewController:WMFSecondTable animated:YES completion:nil];
        }
    }
    }
 //[self dismissingMethods];
}
-(void)whootinfolderUpl
{
        NSString *fl = [NSString stringWithFormat:@"%@",_txt_folderId_view.text];
    NSString *idValuesStore;
    NSString *parentids;
        if ([self.folderId isEqualToString:@""])
        {
            NSLog(@"Whootin Post Calling");
            NSURL *postURL = [[NSURL alloc]initWithString: @"http://whootin.com/api/v1/folders/new.json"];
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
            NSLog(@"add Image");
            //image
            NSString *folderNames = [NSString stringWithFormat:@"Content-Disposition: form-data;name=name; name=%@",fl];
            NSLog(@"Folder %@",folderNames);
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[folderNames dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:postBody];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *newStr=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSString *json=[newStr JSONValue];
            NSLog(@"JSON:%@",[json valueForKey:@"id"]);
            
            idValuesStore = [NSString stringWithFormat:@"%@",[json valueForKey:@"id"]];
            parentids= [NSString stringWithFormat:@"%@",[json valueForKey:@"parent_id"]];
            //self.idValue = [NSString stringWithFormat:@"%@",[json valueForKey:@"id"]];
           // _fileIdFormtb=self.idValue;
          //[self whootingGetFiles:self.idValue];
         //[self whootinFilesFromFirstTableView];
            
           // [self pathStorageUsesDBs:[NSString stringWithFormat:@"%@",fl] IDS:@"0" BOOLCHECKING:[self countDataFromDBPath:[NSString stringWithFormat:@"%@",fl]]];
            
            
            
            
            UIStoryboard* storyboard =nil;
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
            WMFSecondFolderViewController *WMFSecondTable = [storyboard instantiateViewControllerWithIdentifier:@"SecondFolder"];
            
            //NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
           
           /* [self pathStorageUsesDBs:@"Home" IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];
            [self pathStorageUsesDBs:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];*/
            
    
           //WMFSecondFolderViewController *pops = [[WMFSecondFolderViewController alloc]init];
          // pops.idValue = [json valueForKey:@"id"];
             WMFSecondTable.idValue = [json valueForKey:@"id"];
            NSLog(@"SSSSSIŠ:%@",[json valueForKey:@"id"]);
            
            NSString *Values = [json valueForKey:@"id"];
            //[self folderCreationAlerts:];
            //[self showAlertfunction:@"Folder" MessageName:[NSString stringWithFormat:@"%@ folder create successfully",fl]];
           

            nonClicking = YES;
            folderCreateornot = YES;
            _IdOfAllValues = [NSString stringWithFormat:@"%@",[json valueForKey:@"id"]];
            
            
            if(nonClicking==YES)
            {
                WMFSecondTable.idValue =[NSString stringWithFormat:@"%@",_IdOfAllValues];
            }

           // [self.view makeToast:@"Successfully folder created"
                      //  duration:2.0
                       // position:@"center"
                        //   title:@""];
             [self presentViewController:WMFSecondTable animated:NO completion:nil];
        }
        else
        {
            NSString *sUserDefault =kAccessToken;
            NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/folders/new.json"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:30.0];
            NSLog(@"Post Comment is[[[[>>>>>>>>>]]]]:%@",_fileIdFormtb);
            //change type to POST  (default is GET)
            [request setHTTPMethod:@"POST"];
            NSLog(@"body made");
            //NSString *fl = [NSString stringWithFormat:@"%@",_txt_folderUpload.text];
            NSString *params=[NSString stringWithFormat:@"name=%@&folder_id=%@",fl,_fileIdFormtb];
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
            NSLog(@"JSON:%@",[json valueForKey:@"id"]);
            idValuesStore = [NSString stringWithFormat:@"%@",[json valueForKey:@"id"]];
            parentids= [NSString stringWithFormat:@"%@",[json valueForKey:@"parent_id"]];
            self.idValue = [NSString stringWithFormat:@"%@",[json valueForKey:@"id"]];
            _fileIdFormtb=self.idValue;
            self.idValuesecond = [NSString stringWithFormat:@"%@",[json valueForKey:@"id"]];
           // NSString *Values = [json valueForKey:@"id"];
            // [self showAlertfunction:@"Folder" MessageName:[NSString stringWithFormat:@"%@ folder create successfully",fl]];
           
        }
    //[self pathStorageUsesDBs:[NSString stringWithFormat:@"%@",fl]];
    [self whootingGetFiles:self.idValue];
    [self pathStorageUsesDBs:[NSString stringWithFormat:@"%@",fl] IDS:idValuesStore BOOLCHECKING:[self countDataFromDBPath:[NSString stringWithFormat:@"%@",fl]]];
    [self backFolderStorageUsesDBs:idValuesStore IDS:[NSString stringWithFormat:@"%@",parentids] BOOLCHECKING:[self countDataFromDBBackFolder:idValuesStore]];
    [self.tableView reloadData];
    [self.tableViewPaths reloadData];
   // [self.view makeToast:@"Successfully folder created"
               // duration:2.0
              //  position:@"center"
                //   title:@""];
    [self selectDataFormDB];
}
-(void)pathStorageUsesDB:(NSString *)name
{
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootinnames_tbl (whootin_name)VALUES(\"%@\")",name];
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
-(void)folderCreationAlerts:(NSString *)Values
{
    if(![Values isEqualToString:@""])
    {
        showAlert(@"Successfully folder Created");
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------------------TEXT FIELD DELEGATES-----------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGRect frame;
    if ([textField isEqual:_txt_folderId_view])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {  CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height==568)
            {
                frame=[viw_folderLow frame];
                frame.origin.y=482;
            }
            else
            {
                frame=[viw_folderLow frame];
                frame.origin.y=392;
            }
        }
        else
        {
            frame=[viw_folderLow frame];
            frame.origin.y=936;
        }
        [self slideUpDown:viw_folderLow withFrame:frame];
    }
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)textFieldBecomeFirstResponder:(id)sender
{
    CGRect frame;
    if ([sender tag]==30)
    {
        frame =[self.view  frame];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            frame.origin.y=180;
        }
        else
        {
            frame.origin.y=680;
        }
        
        
        [self slideUpDown:viw_folderLow withFrame:frame];
    }
}
- (void)slideUpDown:(UIView*)view withFrame:(CGRect)frame
{
    //Sliding the View Up or Down
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [view setFrame:frame];
    [UIView commitAnimations];
}
#pragma mark **************Status Bar Hidden**************
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (IBAction)btn_folder_Done:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.folderKeys isEqualToString:@"second"])
    {
        [self SelectDataFromDbForSendMeFilesIdsBackFolder];
        if([mu_backmovefolders count]>0)
        {
            NSString *backidValues;
            for (int i=0; i<[mu_backmovefolders count]; i++)
            {
                //NSLog(@"ReverseObjectEnumerator:%@",[[reversedArray objectAtIndex:i] objectForKey:@"parentidv"]);
                backidValues= [[mu_backmovefolders objectAtIndex:i] objectForKey:@"parentidv"];
            }
            NSLog(@"BockIDValues%@",backidValues);
            if([backidValues isEqualToString:@"(null)"])
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                
                [self whootingGetFiles:backidValues];
                [self.tableView reloadData];
                [_tableViewPaths reloadData];
                
            }
        }
        else
        {
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"Firstfolder" sender:self];
        }
        

    }
    else
    {
        [self deleteWhootinNamesPath_tbls:[self SelectedDataFromWhootinName_Tbl]];
        [self performSegueWithIdentifier:@"Firstfolder" sender:self];

    }
    if([mu_backmovefolders count]>0)
    {
    [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_Tbl]];
     }
    [self deleteTableBackWhootin_Tbl:[self backSelectedDataFromWhootinName_Tbl]];
    [_tableViewPaths reloadData];
   

   }
-(void)SelectDataFromDbForSendMeFilesIdsBackFolder
{
    [mu_backmovefolders removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT whootin_id,whootin_parentid FROM whootinbacknavfolder_tbl"];
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
                
                [mu_backmovefolders addObject:tempid];
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
}

-(void)dismissingMethods
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btn_ok_folder:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"lock" forKey:@"lock"];
    [prefs synchronize];

    
    [self folderCreationMethods];

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
        
        if ([self.folderId isEqualToString:@""])
        {
        querySQL= [NSString stringWithFormat:@"SELECT whootin_name,whootin_type FROM whootinfirst_tbl where whootin_name=\"%@\" AND whootin_type=\"%@\"",values,fileNames];
        }
        else
        {
        querySQL = [NSString stringWithFormat:@"SELECT whootin_name,whootin_type FROM whootinsecond_tbl where whootin_name=\"%@\" AND whootin_type=\"%@\"",values,fileNames];
        }
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
- (IBAction)btn_ok_Upload:(id)sender
{
    //[viw_NewFolder_Creations removeFromSuperview];
    
    viw_NewFolder_Creations.hidden = YES;
}
- (void)WMFPopViewControllerDidFinishSelection:(WMFPopViewController *)assetsCollectionViewController
{
    [self whootingpostingSingleClick];
    [self performSelector:@selector(dismissImagePickerControllers) withObject:self afterDelay:3.0];
}
- (void)dismissImagePickerControllers
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pop"];
    [self deleteDataFromDBPopViews];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)whootingpostingSingleClick
{
     [self SelectDataFromDbForSendMeFilesValues];
    
    //ALAsset - Type:Photo, URLs:assets-library://asset/asset.JPG?id=2571674F-37B0-4A91-A9FC-A26E104D0471&ext=JPG
    
   // ALAsset - Type:Photo, URLs:assets-library://asset/asset.JPG?id=39EBC21A-AC6E-4E37-B7B7-3EEA3F2FBA4A&ext=JPG
    
    for (int i=0; i<[mu_AssestValues count]; i++)
    {
        NSLog(@"INDDDS>>>>>>*********:%@",[NSString stringWithFormat:@"%@",[[mu_AssestValues objectAtIndex:i]objectForKey:@"assest"]]);
        
        NSURL *asseturl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mu_AssestValues objectAtIndex:i]objectForKey:@"assest"]]];
        
        ALAsset *als = (ALAsset *)[NSString stringWithFormat:@"%@",asseturl];
      
       // NSLog(@"UDDI->>>>>%@",[NSString stringWithFormat:@"%@",[[als defaultRepresentation] filename]]);
        
       // NSURL *assetURL = [(ALAsset *)asset valueForProperty:ALAssetPropertyAssetURL];
        
       //NSLog(@"UDDI->>>>>%@",[NSString stringWithFormat:@"%@",[[_assetssValues defaultRepresentation] filename]])
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        __block UIImage *returnValue = nil;
        [library assetForURL:asseturl resultBlock:^(ALAsset *asset) {
            returnValue = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
            NSLog(@"Follwings>>>>>>*********:%@",[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]);

            
        } failureBlock:^(NSError *error) {
            NSLog(@"error : %@", error);
        }];
        
        
        
       // ALAsset *asset = [[mu_AssestValues objectAtIndex:i]objectForKey:@"assest"];
        //NSLog(@"INDDDS>>>>>>*********:%@",[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]);
        
        //NSString *filename = [NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]];
       // [self whootinFileUploading:[self getImageFromAsset:[[mu_AssestValues objectAtIndex:i]objectForKey:@"assest"] type:ASSET_PHOTO_SCREEN_SIZE] fileName:@"12"];
    }
    
    
    
}
-(void)SelectDataFromDbForSendMeFilesValues
{
    //[mu_AssestValues removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSString *querySQL;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        querySQL = [NSString stringWithFormat: @"SELECT * FROM whootinasses_tbl"];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"Prepare-error #%i: %s", (sqlite3_prepare_v2(contactDB, [ querySQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *temp = [NSMutableDictionary new];
                const char*whname=(const char *) sqlite3_column_text(statement, 0);
                NSString *name = whname == NULL ? nil : [[NSString alloc] initWithUTF8String:whname];
                
                [temp setObject:name forKey:@"assest"];
                
                NSLog(@"Vali Retrive:%@",name);
                
                [mu_AssestValues addObject:temp];
                
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
}

- (IBAction)btn_upgradeUp:(id)sender
{
    
}
- (IBAction)btn_upgradeClose:(id)sender
{
    viw_20gbupgrade.hidden = YES;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
}
- (NSString *)timeAgoSinceDate:(NSDate *)date numericDates:(BOOL)useNumericDates
{
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   /* if ([[segue identifier]isEqualToString:@"innewfolder"])
    {
        NSLog(@"Call Heres");
        [self selectDataFormDB];//tableView
       WMFSecondFolderViewController *pops = [segue destinationViewController];
       // popfolderview.folderId = idfolder;
       // popfolderview.folderKeys = @"second";
                NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        pops.idValue = [[mu_tweetarray objectAtIndex:indexpath.row]objectForKey:@"id"];
        [self pathStorageUsesDBs:@"Home" IDS:[[mu_tweetarray objectAtIndex:indexpath.row]objectForKey:@"id"]];
        [self pathStorageUsesDBs:[[mu_tweetarray objectAtIndex:indexpath.row]objectForKey:@"name"] IDS:[[mu_tweetarray objectAtIndex:indexpath.row]objectForKey:@"id"]];
        if(nonClicking==YES)
        {
            pops.idValue =[NSString stringWithFormat:@"%@",_IdOfAllValues];
        }
    }*/
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
-(void)pathStorageUsesDBs:(NSString *)name IDS:(NSString *)whootin_ids BOOLCHECKING:(BOOL)returnValue
{
    if(returnValue==true)
    {
        NSLog(@"Poooo");
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE whootintemps_tbl SET whootin_name=\"%@\" WHERE whootin_name=\"%@\"",name,name];
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
}
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    [self dismissImagePickerController];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** >>>>>>>>>>>>>>>>>>>>>>1122124imagePickerController:didSelectAsset:");
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
    [self selectDataFormDB];
    [self performSelector:@selector(dismissImagePickerController) withObject:self afterDelay:25.0];
    [self performSelector:@selector(reloadDataselect) withObject:self afterDelay:25.0];
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
-(void)whootinFileUploading :(UIImage *)img fileName:(NSString *)fnames
{
    NSString *sUserDefault =kAccessToken;
    NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/files/new.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    
    NSLog(@"{{{{{{{{Post Comment is}}}}}}}}}:%@",_fileIdFormtb);
    NSString *idfolder;
    
       if(_fileIdFormtb.length==0)
    {
        idfolder =  [NSString stringWithFormat:@"%@",self.idValuesecond];
    }
    else
    {
        idfolder = [NSString stringWithFormat:@"%@",_fileIdFormtb];
    }
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
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *appData = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fnames];
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
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"just sent request");
    //this will set the image when loading is finished
    // convert data into string
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                      encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    NSLog(@"File Id 107458 :%@",_fileIdFormtb);
}

-(void)showAlertfunction :(NSString *)headingName MessageName:(NSString *)messagenames
{
    UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:headingName message:messagenames delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alerts show];
}
- (IBAction)btn_uploadsAfter_Cancel:(id)sender
{
    [self uploadingFiles];
}
- (IBAction)btn_createAfter_Cancel:(id)sender
{
    //[self folderCreationMethods];
    
    viw_NewFolder_Creations.hidden = NO;
}

//FolderCreation
-(void)folderCreationMethods
{
    [_txt_folderId_view resignFirstResponder];
    NSString *fl = [NSString stringWithFormat:@"%@",_txt_folderId_view.text];
    BOOL folderNamesChecking= [self FolderNameChecking:[NSString stringWithFormat:@"%@",_txt_folderId_view.text] names:@"folder"];
    if (fl.length!=0)
    {
        if (folderNamesChecking==YES)
        {
            [self showAlertfunction:@"Folder" MessageName:[NSString stringWithFormat:@"%@ folder already exits",fl]];
        }
        else
        {
            [self whootinfolderUpl];
            _txt_folderId_view.text=@"";
            viw_folderLow.hidden = YES;
            viw_NewFolder_Creations.hidden=YES;
        }
    }
    else
    {
        [self showAlertfunction:@"Folder" MessageName:@"please enter your folder name"];
    }
    //482
     CGRect frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {  CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height==568)
        {
            frame=[viw_folderLow frame];
            frame.origin.y=482;
        }
        else
        {
            frame=[viw_folderLow frame];
            frame.origin.y=392;
        }
    
    }
    else
    {
        frame=[viw_folderLow frame];
        frame.origin.y=936;

    }
    [self slideUpDown:viw_folderLow withFrame:frame];
}
//UploaderFiles
-(void)uploadingFiles
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *pops = [prefs stringForKey:@"pop"];
    if([pops isEqualToString:@"popview"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        popview = [storyboard instantiateViewControllerWithIdentifier:@"popview"];
        popview.delegate = self;
        popview.checkpoint = @"one";
        [self presentViewController:popview animated:YES completion:nil];
    }
    else
    {
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.folderId = @"";
        imagePickerController.folderKeys = @"first";
        imagePickerController.folderIdFolding = @"newfolder";
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        //[[UINavigationBar appearance] setTintColor:[UIColor re]];
        [self.navigationController setTitle:@"Whootin Files"];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}
-(void)SelectDataFromWHootinName_tbl
{
    [mu_dirnames removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM whootintemps_tbl"];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [querySQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *temp = [NSMutableDictionary new];
                
                const char*Rnumber=(const char *) sqlite3_column_text(statement, 0);
                NSString *rowid = Rnumber == NULL ? nil : [[NSString alloc] initWithUTF8String:Rnumber];
                
                const char*idV=(const char *) sqlite3_column_text(statement, 1);
                NSString *rowidv = idV == NULL ? nil : [[NSString alloc] initWithUTF8String:idV];
                
                [temp setObject:rowid forKey:@"fname"];
                [temp setObject:rowidv forKey:@"rowidk"];
                [mu_dirnames addObject:temp];
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
}
-(void)deleteWhootinNames_tbls
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
-(void)deleteWhootinNamesPath_tbls:(NSString *)indes
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
         NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinnames_tbl where rowid<>\"%@\"",indes];
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
-(BOOL)countDataFromDBPath:(NSString *)values
{
    BOOL isValid=false;
    NSString *status;
    NSString *names;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT whootin_name FROM whootinnames_tbl where whootin_name=\"%@\"",values];
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
#pragma mark ***FolderBackOptions******
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
-(void)deleteTableWhootin_Tbl:(NSString *)indes
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootintemps_tbl where rowid=\"%@\"",indes];
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
-(NSString *)SelectedDataFromWhootinName_TblPaths
{
    NSString *records;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT count(whootin_name) FROM whootintemps_tbl"];
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
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootinbacknavfolder_tbl where rowid=\"%@\"",indes];
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
        NSString *querySQL = [NSString stringWithFormat: @"SELECT count(whootin_id) FROM whootinbacknavfolder_tbl"];
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

@end
