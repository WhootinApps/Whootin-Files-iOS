//
//  WMFChooseLocationViewController.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 6/11/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "WMFChooseLocationViewController.h"
#import "NSDate+DateTools.h"
#import "WMFSecondChooseLocationViewController.h"
@interface WMFChooseLocationViewController ()
@property NSDate *selectedDate;
@property NSDateFormatter *formatter;
@end

@implementation WMFChooseLocationViewController

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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSArray *arraysValues = [_fileLocations componentsSeparatedByString:@"/"];
    NSLog(@"File Here->>>>>>>>>>>>********<<<<<<<-%@",_fileLocations);
    NSLog(@"Last Values:%@",[arraysValues lastObject]);
    
    _labelCell = [[NSOperationQueue alloc]init];
    [_labelCell setMaxConcurrentOperationCount:1];
    mu_tweetarray =[[NSMutableArray alloc]init];
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"upgrades"];
    NSLog(@"NSUserDefaults:%@",myString);
    
    if ([myString isEqualToString:@"one"])
    {
        viw_upgrade_20gbs.hidden=NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
        viw_upgrade_20gbs.hidden=YES;
        
    }
    [self whootingGetFiles];
     //[self pathStorageUsesDB:@"Home" IDS:@"0"];
    //[self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
   
}
- (void)updateCurrentTime
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        [UIView transitionWithView:_img_upgrade_20gb duration:20 options:UIViewAnimationOptionTransitionCrossDissolve   animations:^{
            _img_upgrade_20gb.image = [UIImage imageNamed:@"upgradecancel-20GB.png"];
        } completion:^(BOOL done){
            [UIView transitionWithView:_img_upgrade_20gb duration:20 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _img_upgrade_20gb.image = [UIImage imageNamed:@"upgradecancel-100GB.png"];
            } completion:^(BOOL done){
                [UIView transitionWithView:_img_upgrade_20gb duration:20 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    
                    _img_upgrade_20gb.image = [UIImage imageNamed:@"upgradecancel-1TB.png"];
                    
                } completion:^(BOOL done){
                    [self updateCurrentTime];
                }];
            }];
        }];
    }
    else
    {
        [UIView transitionWithView:_img_upgrade_20gb duration:20 options:UIViewAnimationOptionTransitionCrossDissolve   animations:^{
            _img_upgrade_20gb.image = [UIImage imageNamed:@"ipad_upgrade20_cancel.png"];
        } completion:^(BOOL done){
            [UIView transitionWithView:_img_upgrade_20gb duration:20 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _img_upgrade_20gb.image = [UIImage imageNamed:@"ipad_upgrade100_cancel.png"];
            } completion:^(BOOL done){
                [UIView transitionWithView:_img_upgrade_20gb duration:20 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    
                    _img_upgrade_20gb.image = [UIImage imageNamed:@"ipad_upgrade1tb_cancel.png"];
                    
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
#pragma mark **************Status Bar Hidden**************
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark **********Whooting Getting Files**********
-(void)whootingGetFiles
{
    //ContentValuesInsertedValues
    
    //this will start the image loading in bg
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
                    
                    //_tweetsArray = [NSMutableArray arrayWithObjects:dict1, nil];
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
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
   
    [self SelectDataFromDbForSendMeFiles];
    return mu_tweetarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _stringCheckings = nil;
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
    UIView *line = (UIView *)[cell viewWithTag:10];
    [line setBackgroundColor:[UIColor blackColor]];
   

    
    {
        /* if (boalignalpha==YES)
         {
         [self SelectDataFromDbForSendMeFilesAlignTypes];
         }
         else
         {*/
        [self SelectDataFromDbForSendMeFiles];
        //}
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                @try
                {
                    gallery_name.text=[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"];
                    gallery_subname.text = @" ";
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
                        imageviw.image = [UIImage imageNamed:@"ico_doc.png"];
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
                    /*else
                     {
                     if ([fileex isEqualToString:@""])
                     {
                     imageviw.image = [UIImage imageNamed:@"ico_folder.png"];
                     }
                     else
                     {
                     imageviw.image = [UIImage imageNamed:@"file.png"];
                     }
                     
                     }*/
                    if([fileex isEqualToString:@"png"]||[fileex isEqualToString:@"jpg"]||[fileex isEqualToString:@"pdf"]||[fileex isEqualToString:@"mp4"]||[fileex isEqualToString:@"PNG"]||[fileex isEqualToString:@"JPG"]||[fileex isEqualToString:@"PDF"]||[fileex isEqualToString:@"MP4"]||[fileex isEqualToString:@"xlsx"]||[fileex isEqualToString:@"XLSX"]||[fileex isEqualToString:@"xls"]||[fileex isEqualToString:@"XLS"]||[fileex isEqualToString:@"xlam"]||[fileex isEqualToString:@"XLAM"]||[fileex isEqualToString:@"xltm"]||[fileex isEqualToString:@"XLTM"]||[fileex isEqualToString:@"xlsm"]||[fileex isEqualToString:@"XLSM"]||[fileex isEqualToString:@"mp3"]||[fileex isEqualToString:@"MP3"]||[fileex isEqualToString:@"mp2"]||[fileex isEqualToString:@"MP2"]||[fileex isEqualToString:@"WAV"]||[fileex isEqualToString:@"WAV"]||[fileex isEqualToString:@"aac"]||[fileex isEqualToString:@"AAC"]||[fileex isEqualToString:@"ac3"]||[fileex isEqualToString:@"AC3"]||[fileex isEqualToString:@"avi"]||[fileex isEqualToString:@"AVI"]||[fileex isEqualToString:@"flv"]||[fileex isEqualToString:@"FLV"]||[fileex isEqualToString:@"3gp"]||[fileex isEqualToString:@"3GP"]||[fileex isEqualToString:@"MPEG"]||[fileex isEqualToString:@"mpeg"]||[fileex isEqualToString:@"mkv"]||[fileex isEqualToString:@"MKV"]||[fileex isEqualToString:@"mov"]||[fileex isEqualToString:@"MOV"]||[fileex isEqualToString:@"WMV"]||[fileex isEqualToString:@"WMV"]||[fileex isEqualToString:@"ASF"]||[fileex isEqualToString:@"ASF"]||[fileex isEqualToString:@"ppt"]||[fileex isEqualToString:@"PPT"]||[fileex isEqualToString:@"pptx"]||[fileex isEqualToString:@"PPTX"]||[fileex isEqualToString:@"pptm"]||[fileex isEqualToString:@"PPTM"]||[fileex isEqualToString:@"pot"]||[fileex isEqualToString:@"POT"]||[fileex isEqualToString:@"potx"]||[fileex isEqualToString:@"POTX"]||[fileex isEqualToString:@"pps"]||[fileex isEqualToString:@"PPSX"]||[fileex isEqualToString:@"ppsm"]||[fileex isEqualToString:@"PPSM"]||[fileex isEqualToString:@"bmp"]||[fileex isEqualToString:@"BMP"]||[fileex isEqualToString:@"svg"]||[fileex isEqualToString:@"SVG"]||[fileex isEqualToString:@"DOC"]||[fileex isEqualToString:@"doc"]||[fileex isEqualToString:@"csv"]||[fileex isEqualToString:@"zip"]||[fileex isEqualToString:@"ZIP"]||[fileex isEqualToString:@"XML"]||[fileex isEqualToString:@"xml"]||[fileex isEqualToString:@"HTML"]||[fileex isEqualToString:@"html"]||[fileex isEqualToString:@"a"]||[fileex isEqualToString:@"A"]||[fileex isEqualToString:@"class"]||[fileex isEqualToString:@"CLASS"]||[fileex isEqualToString:@"js"]||[fileex isEqualToString:@"JS"]||[fileex isEqualToString:@"3dm"]||[fileex isEqualToString:@"3DM"]||[fileex isEqualToString:@"bin"]||[fileex isEqualToString:@"BIN"]||[fileex isEqualToString:@"p12"]||[fileex isEqualToString:@"P12"]||[fileex isEqualToString:@"TALK"]||[fileex isEqualToString:@"talk"]||[fileex isEqualToString:@"ZOO"]||[fileex isEqualToString:@"zoo"]||[fileex isEqualToString:@"z"]||[fileex isEqualToString:@"Z"]||[fileex isEqualToString:@"ZSH"]||[fileex isEqualToString:@"zsh"]||[fileex isEqualToString:@"xyz"]||[fileex isEqualToString:@"XYZ"]||[fileex isEqualToString:@"xpix"]||[fileex isEqualToString:@"XPIX"]||[fileex isEqualToString:@"xlm"]||[fileex isEqualToString:@"XLM"]||[fileex isEqualToString:@"XLS"]||[fileex isEqualToString:@"xls"]||[fileex isEqualToString:@"xmz"]||[fileex isEqualToString:@"XMZ"]||[fileex isEqualToString:@"wrz"]||[fileex isEqualToString:@"WRZ"]||[fileex isEqualToString:@"wp5"]||[fileex isEqualToString:@"WP5"]||[fileex isEqualToString:@"wp6"]||[fileex isEqualToString:@"WP6"]||[fileex isEqualToString:@"vrm"]||[fileex isEqualToString:@"VRM"]||[fileex isEqualToString:@"voc"]||[fileex isEqualToString:@"VOC"]||[fileex isEqualToString:@"UUE"]||[fileex isEqualToString:@"uue"]||[fileex isEqualToString:@"aab"]||[fileex isEqualToString:@"AAB"]||[fileex isEqualToString:@"aam"]||[fileex isEqualToString:@"AAM"]||[fileex isEqualToString:@"ABC"]||[fileex isEqualToString:@"abc"]||[fileex isEqualToString:@"ACGI"]||[fileex isEqualToString:@"acgi"]||[fileex isEqualToString:@"AF1"]||[fileex isEqualToString:@"af1"]||[fileex isEqualToString:@"aim"]||[fileex isEqualToString:@"AIM"]||[fileex isEqualToString:@"aip"]||[fileex isEqualToString:@"AIP"]||[fileex isEqualToString:@"ANI"]||[fileex isEqualToString:@"ani"]||[fileex isEqualToString:@"AOS"]||[fileex isEqualToString:@"aos"]||[fileex isEqualToString:@"APS"]||[fileex isEqualToString:@"aps"]||[fileex isEqualToString:@"AI"]||[fileex isEqualToString:@"ai"]||[fileex isEqualToString:@"aif"]||[fileex isEqualToString:@"AIF"]||[fileex isEqualToString:@"AIFC"]||[fileex isEqualToString:@"aifc"]||[fileex isEqualToString:@"aiff"]||[fileex isEqualToString:@"AIFF"]||[fileex isEqualToString:@"AIP"]||[fileex isEqualToString:@"aip"]||[fileex isEqualToString:@"ARC"]||[fileex isEqualToString:@"arc"]||[fileex isEqualToString:@"ARJ"]||[fileex isEqualToString:@"arj"]||[fileex isEqualToString:@"ASM"]||[fileex isEqualToString:@"asm"]||[fileex isEqualToString:@"asp"]||[fileex isEqualToString:@"ASP"]||[fileex isEqualToString:@"asx"]||[fileex isEqualToString:@"ASX"]||[fileex isEqualToString:@"au"]||[fileex isEqualToString:@"AU"]||[fileex isEqualToString:@"avs"]||[fileex isEqualToString:@"AVS"]||[fileex isEqualToString:@"bcpio"]||[fileex isEqualToString:@"BCPIO"]||[fileex isEqualToString:@"BOOK"]||[fileex isEqualToString:@"book"]||[fileex isEqualToString:@"BOZ"]||[fileex isEqualToString:@"boz"]||[fileex isEqualToString:@"bsh"]||[fileex isEqualToString:@"BSH"]||[fileex isEqualToString:@"c++"]||[fileex isEqualToString:@"C++"]||[fileex isEqualToString:@"c"]||[fileex isEqualToString:@"C"]||[fileex isEqualToString:@"CAT"]||[fileex isEqualToString:@"cat"]||[fileex isEqualToString:@"CC"]||[fileex isEqualToString:@"cc"]||[fileex isEqualToString:@"CCAD"]||[fileex isEqualToString:@"ccad"]||[fileex isEqualToString:@"COM"]||[fileex isEqualToString:@"com"]||[fileex isEqualToString:@"CHAT"]||[fileex isEqualToString:@"chat"]||[fileex isEqualToString:@"CHA"]||[fileex isEqualToString:@"cha"]||[fileex isEqualToString:@"CER"]||[fileex isEqualToString:@"cer"]||[fileex isEqualToString:@"CDF"]||[fileex isEqualToString:@"cdf"]||[fileex isEqualToString:@"CCO"]||[fileex isEqualToString:@"cco"]||[fileex isEqualToString:@"CRT"]||[fileex isEqualToString:@"crt"]||[fileex isEqualToString:@"CSH"]||[fileex isEqualToString:@"csh"]||[fileex isEqualToString:@"CSS"]||[fileex isEqualToString:@"css"]||[fileex isEqualToString:@"dcr"]||[fileex isEqualToString:@"DCR"]||[fileex isEqualToString:@"dp"]||[fileex isEqualToString:@"DP"]||[fileex isEqualToString:@"dvi"]||[fileex isEqualToString:@"DVI"]||[fileex isEqualToString:@"DWG"]||[fileex isEqualToString:@"dwg"]||[fileex isEqualToString:@"DXF"]||[fileex isEqualToString:@"dxf"]||[fileex isEqualToString:@"el"]||[fileex isEqualToString:@"EL"]||[fileex isEqualToString:@"ELC"]||[fileex isEqualToString:@"elc"]||[fileex isEqualToString:@"evy"]||[fileex isEqualToString:@"EVY"]||[fileex isEqualToString:@"crl"]||[fileex isEqualToString:@"CRL"]||[fileex isEqualToString:@"cpt"]||[fileex isEqualToString:@"CPT"]||[fileex isEqualToString:@"CPIO"]||[fileex isEqualToString:@"cpio"]||[fileex isEqualToString:@"wiz"]||[fileex isEqualToString:@"WIZ"]||[fileex isEqualToString:@"ustar"]||[fileex isEqualToString:@"USTAR"]||[fileex isEqualToString:@"UNV"]||[fileex isEqualToString:@"unv"]||[fileex isEqualToString:@"UNIS"]||[fileex isEqualToString:@"unis"]||[fileex isEqualToString:@"UNI"]||[fileex isEqualToString:@"uni"]||[fileex isEqualToString:@"TR"]||[fileex isEqualToString:@"tr"]||[fileex isEqualToString:@"UIL"]||[fileex isEqualToString:@"uil"]||[fileex isEqualToString:@"tsv"]||[fileex isEqualToString:@"TSV"]||[fileex isEqualToString:@"tsp"]||[fileex isEqualToString:@"TSP"]||[fileex isEqualToString:@"TEX"]||[fileex isEqualToString:@"tex"]||[fileex isEqualToString:@"SSI"]||[fileex isEqualToString:@"ssi"]||[fileex isEqualToString:@"SRC"]||[fileex isEqualToString:@"src"]||[fileex isEqualToString:@"TCSH"]||[fileex isEqualToString:@"tcsh"]||[fileex isEqualToString:@"SCM"]||[fileex isEqualToString:@"scm"]||[fileex isEqualToString:@"S"]||[fileex isEqualToString:@"s"]||[fileex isEqualToString:@"RNX"]||[fileex isEqualToString:@"rnx"]||[fileex isEqualToString:@"rng"]||[fileex isEqualToString:@"RNG"]||[fileex isEqualToString:@"rmp"]||[fileex isEqualToString:@"RMP"]||[fileex isEqualToString:@"rmm"]||[fileex isEqualToString:@"RMM"]||[fileex isEqualToString:@"RM"]||[fileex isEqualToString:@"rm"]||[fileex isEqualToString:@"rexx"]||[fileex isEqualToString:@"REXX"]||[fileex isEqualToString:@"ras"]||[fileex isEqualToString:@"RAS"]||[fileex isEqualToString:@"RAM"]||[fileex isEqualToString:@"ram"]||[fileex isEqualToString:@"ra"]||[fileex isEqualToString:@"RA"]||[fileex isEqualToString:@"QTC"]||[fileex isEqualToString:@"qtc"]||[fileex isEqualToString:@"QT"]||[fileex isEqualToString:@"qt"]||[fileex isEqualToString:@"PY"]||[fileex isEqualToString:@"py"]||[fileex isEqualToString:@"PYC"]||[fileex isEqualToString:@"pyc"]||[fileex isEqualToString:@"PSD"]||[fileex isEqualToString:@"psd"]||[fileex isEqualToString:@"POT"]||[fileex isEqualToString:@"pot"]||[fileex isEqualToString:@"PNM"]||[fileex isEqualToString:@"pnm"]||[fileex isEqualToString:@"PM4"]||[fileex isEqualToString:@"pm4"]||[fileex isEqualToString:@"PL"]||[fileex isEqualToString:@"pl"]||[fileex isEqualToString:@"PKO"]||[fileex isEqualToString:@"pko"]||[fileex isEqualToString:@"PKG"]||[fileex isEqualToString:@"pkg"]||[fileex isEqualToString:@"PFUNK"]||[fileex isEqualToString:@"pfunk"]||[fileex isEqualToString:@"PDB"]||[fileex isEqualToString:@"pdb"]||[fileex isEqualToString:@"PAS"]||[fileex isEqualToString:@"pas"]||[fileex isEqualToString:@"PART"]||[fileex isEqualToString:@"part"]||[fileex isEqualToString:@"P7R"]||[fileex isEqualToString:@"p7r"]||[fileex isEqualToString:@"P7S"]||[fileex isEqualToString:@"p7s"]||[fileex isEqualToString:@"P7M"]||[fileex isEqualToString:@"p7m"]||[fileex isEqualToString:@"P7C"]||[fileex isEqualToString:@"p7c"]||[fileex isEqualToString:@"P7A"]||[fileex isEqualToString:@"p7a"]||[fileex isEqualToString:@"P10"]||[fileex isEqualToString:@"p10"]||[fileex isEqualToString:@"OMCR"]||[fileex isEqualToString:@"omcr"]||[fileex isEqualToString:@"OMCD"]||[fileex isEqualToString:@"omcd"]||[fileex isEqualToString:@"OMC"]||[fileex isEqualToString:@"omc"]||[fileex isEqualToString:@"ODA"]||[fileex isEqualToString:@"oda"]||[fileex isEqualToString:@"O"]||[fileex isEqualToString:@"o"]||[fileex isEqualToString:@"NVD"]||[fileex isEqualToString:@"nvd"]||[fileex isEqualToString:@"NIF"]||[fileex isEqualToString:@"nif"]||[fileex isEqualToString:@"NCM"]||[fileex isEqualToString:@"ncm"]||[fileex isEqualToString:@"NC"]||[fileex isEqualToString:@"nc"]||[fileex isEqualToString:@"MZZ"]||[fileex isEqualToString:@"mzz"]||[fileex isEqualToString:@"MY"]||[fileex isEqualToString:@"my"]||[fileex isEqualToString:@"MV"]||[fileex isEqualToString:@"mv"]||[fileex isEqualToString:@"MS"]||[fileex isEqualToString:@"ms"]||[fileex isEqualToString:@"MRC"]||[fileex isEqualToString:@"mrc"]||[fileex isEqualToString:@"MPX"]||[fileex isEqualToString:@"mpx"]||[fileex isEqualToString:@"MPV"]||[fileex isEqualToString:@"mpv"]||[fileex isEqualToString:@"MPC"]||[fileex isEqualToString:@"mpc"]||[fileex isEqualToString:@"MPEG"]||[fileex isEqualToString:@"mpeg"]||[fileex isEqualToString:@"MOVIE"]||[fileex isEqualToString:@"movie"]||[fileex isEqualToString:@"MOOV"]||[fileex isEqualToString:@"moov"]||[fileex isEqualToString:@"MOD"]||[fileex isEqualToString:@"mod"]||[fileex isEqualToString:@"MME"]||[fileex isEqualToString:@"mme"]||[fileex isEqualToString:@"MM"]||[fileex isEqualToString:@"mm"]||[fileex isEqualToString:@"MIF"]||[fileex isEqualToString:@"mif"]||[fileex isEqualToString:@"MID"]||[fileex isEqualToString:@"mid"]||[fileex isEqualToString:@"MAR"]||[fileex isEqualToString:@"mar"]||[fileex isEqualToString:@"MAP"]||[fileex isEqualToString:@"map"]||[fileex isEqualToString:@"MAN"]||[fileex isEqualToString:@"man"]||[fileex isEqualToString:@"M3U"]||[fileex isEqualToString:@"m3u"]||[fileex isEqualToString:@"M2V"]||[fileex isEqualToString:@"m2v"]||[fileex isEqualToString:@"M2A"]||[fileex isEqualToString:@"m2a"]||[fileex isEqualToString:@"M1V"]||[fileex isEqualToString:@"m1v"]||[fileex isEqualToString:@"M"]||[fileex isEqualToString:@"m"]||[fileex isEqualToString:@"LZX"]||[fileex isEqualToString:@"lzx"]||[fileex isEqualToString:@"LZH"]||[fileex isEqualToString:@"lzh"]||[fileex isEqualToString:@"LTX"]||[fileex isEqualToString:@"ltx"]||[fileex isEqualToString:@"LSP"]||[fileex isEqualToString:@"lsp"]||[fileex isEqualToString:@"LOG"]||[fileex isEqualToString:@"log"]||[fileex isEqualToString:@"LMA"]||[fileex isEqualToString:@"lma"]||[fileex isEqualToString:@"LIST"]||[fileex isEqualToString:@"list"]||[fileex isEqualToString:@"LHX"]||[fileex isEqualToString:@"lhx"]||[fileex isEqualToString:@"LHA"]||[fileex isEqualToString:@"lha"]||[fileex isEqualToString:@"LA"]||[fileex isEqualToString:@"la"]||[fileex isEqualToString:@"KSH"]||[fileex isEqualToString:@"ksh"]||[fileex isEqualToString:@"KAR"]||[fileex isEqualToString:@"kar"]||[fileex isEqualToString:@"IV"]||[fileex isEqualToString:@"iv"]||[fileex isEqualToString:@"IT"]||[fileex isEqualToString:@"it"]||[fileex isEqualToString:@"ISU"]||[fileex isEqualToString:@"isu"]||[fileex isEqualToString:@"IP"]||[fileex isEqualToString:@"ip"]||[fileex isEqualToString:@"INS"]||[fileex isEqualToString:@"ins"]||[fileex isEqualToString:@"INF"]||[fileex isEqualToString:@"inf"]||[fileex isEqualToString:@"HTA"]||[fileex isEqualToString:@"hta"]||[fileex isEqualToString:@"HQX"]||[fileex isEqualToString:@"hqx"]||[fileex isEqualToString:@"HH"]||[fileex isEqualToString:@"hh"]||[fileex isEqualToString:@"HGL"]||[fileex isEqualToString:@"hgl"]||[fileex isEqualToString:@"HELP"]||[fileex isEqualToString:@"help"]||[fileex isEqualToString:@"HDF"]||[fileex isEqualToString:@"hdf"]||[fileex isEqualToString:@"H"]||[fileex isEqualToString:@"h"]||[fileex isEqualToString:@"GSM"]||[fileex isEqualToString:@"gsm"]||[fileex isEqualToString:@"g"]||[fileex isEqualToString:@"G"]||[fileex isEqualToString:@"FOR"]||[fileex isEqualToString:@"for"]||[fileex isEqualToString:@"java"]||[fileex isEqualToString:@"JAVA"]||[fileex isEqualToString:@"jar"]||[fileex isEqualToString:@"JAR"])
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        if ([[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"type"] isEqualToString:@"folder"])
        {
        
            
            [self pathStorageUsesDB:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"name"] IDS:[[mu_tweetarray objectAtIndex:indexPath.row]objectForKey:@"id"]];
            [self performSegueWithIdentifier:@"secondchooselocation" sender:nil];
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
        return DateToolsLocalizedStrings(@"An hour ago");
    }
    else if (fabs([components minute])- 30 >= 2) {
        return [self logicLocalizedStringFromFormat:@"%%d %@minutes ago" withValue:fabs([components minute])- 30];
    }
    else if (fabs([components minute])- 30 >= 1) {
        return DateToolsLocalizedStrings(@"A minute ago");
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
    if([[segue identifier] isEqualToString:@"secondchooselocation"])
    {
        NSArray *arraysValues = [_fileLocations componentsSeparatedByString:@"/"];
        NSLog(@"File Here->>>>>>>>>>>>********<<<<<<<-%@",_fileLocations);
        NSLog(@"Last Values:%@",[arraysValues lastObject]);
        NSString *sliptImage = [NSString stringWithFormat:@"%@",[arraysValues lastObject]];
        
        [self SelectDataFromDbForSendMeFiles];
        pops = [segue destinationViewController];
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        if([_stringCheckings isEqualToString:@"folders"])
        {
            pops.idValue = _idValuesStore;
        }
        else
        {
           pops.idValue = [[mu_tweetarray objectAtIndex:indexpath.row]objectForKey:@"id"];
        }
        pops.dataValues = [self loaddata];
        pops.dataNameValues = [NSString stringWithFormat:@"%@",sliptImage];

    }
    
}

- (IBAction)btn_dismiss:(id)sender
{
    //exit(0);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btn_upgrade:(id)sender
{
    
}
- (IBAction)btn_upgrade_cancel:(id)sender
{
    viw_upgrade_20gbs.hidden=YES;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"upgrades"];
}
-(void)whootinFileUploading :(NSMutableData *)img fileName:(NSString *)fnames fullname:(NSString *)fullname
{
    
    NSLog(@"Whootin Tigger Name:%@",fnames);
    NSLog(@"Whootin Tigger Name Exe:%@",fullname);

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
    NSString *appData = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fnams];
    [postBody appendData:[appData dataUsingEncoding:NSUTF8StringEncoding]];
    //[postBody appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"itemkop.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *link = [fnames componentsSeparatedByString:@"."];
    NSString *types = [NSString stringWithFormat:@"%@",link[1]];
    /*if([types isEqualToString:@"avi"])
    {
        [postBody appendData:[@"Content-Type:video/avi\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    else if([types isEqualToString:@"html"])
    {
        [postBody appendData:[@"Content-Type:text/html\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if([types isEqualToString:@"mp3"])
    {
        [postBody appendData:[@"Content-Type:audio/mpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }*/
    [postBody appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //imgData =UIImageJPEGRepresentation(img, 1.0);
    [postBody appendData:img];
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
        dispatch_async(dispatch_get_main_queue(),
                       ^{
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
    //[self performSelector:@selector(dismissingPopView) withObject:self afterDelay:5.0];
    [self SelectDataFromDbForSendMeFiles];
    [self performSelector:@selector(reloadDataselect) withObject:self afterDelay:10.0];
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

- (IBAction)btn_add_whootin:(id)sender
{
       // NSLog(@"data: %@", [NSData dataWithContentsOfURL:_fileLocationsUrl]);
 
    //this will start the image loading in bg
    
    NSArray *arraysValues = [_fileLocations componentsSeparatedByString:@"/"];
    NSLog(@"File Here->>>>>>>>>>>>********<<<<<<<-%@",_fileLocations);
    NSLog(@"Last Values:%@",[arraysValues lastObject]);
    
    NSString *sliptImage = [NSString stringWithFormat:@"%@",[arraysValues lastObject]];

    
    
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

    
    popview = [storyboard instantiateViewControllerWithIdentifier:@"popview"];//newfolder
    popview.allFilesUploads = @"all";
    [self ValueInserted:sliptImage];
    [self presentViewController:popview animated:YES completion:nil];
    
    [self whootinFileUploading:[self loaddata] fileName:sliptImage fullname:sliptImage];
   // [self whootinFileUploading:body fileName:sliptImage fullname:sliptImage];
    NSLog(@"url length immediate: %lu", (unsigned long)[[NSData dataWithContentsOfURL:_fileLocationsUrl] length]);
}
-(void)ValueInserted :(NSString *)name
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootintemp_tbl (whootin_name)VALUES(\"%@\")",name];
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

-(void)reloadDataselect
{
    [self whootingGetFiles];
     //[self dismissingPopView];
    [self.tableView reloadData];
}
-(NSMutableData *)loaddata
{
    
    NSArray *arraysValues = [_fileLocations componentsSeparatedByString:@"/"];
    NSLog(@"File Here->>>>>>>>>>>>********<<<<<<<-%@",_fileLocations);
    NSLog(@"Last Values:%@",[arraysValues lastObject]);
    
    NSString *sliptImage = [NSString stringWithFormat:@"%@",[arraysValues lastObject]];
    
    //NSArray *fileExtenison = [sliptImage componentsSeparatedByString:@"."];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[arraysValues lastObject]]];
    //NSData *data = [getImagePath dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *body  = [NSData dataWithContentsOfURL:_fileLocationsUrl];
    
    
    return body;

}


- (IBAction)btn_cancel_whootin:(id)sender
{
    
}

- (IBAction)btn_foldercreations:(id)sender
{
    
    //NSString *fl = [NSString stringWithFormat:@"%@",_txt_folderId_view.text];
    
    viw_folder_creation.hidden = NO;
    
}
- (IBAction)btn_no_folder:(id)sender
{
    viw_folder_creation.hidden = YES;
}
- (IBAction)btn_yes_folder:(id)sender
{
    
    _stringCheckings = @"folders";
    NSString *fl = [NSString stringWithFormat:@"%@",_txt_folder_name.text];
    NSString *parentids;
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
    
    _idValuesStore = [NSString stringWithFormat:@"%@",[json valueForKey:@"id"]];
    parentids= [NSString stringWithFormat:@"%@",[json valueForKey:@"parent_id"]];
    
    [self pathStorageUsesDB:[NSString stringWithFormat:@"%@",[json valueForKey:@"name"]] IDS:_idValuesStore];
    viw_folder_creation.hidden = YES;
    [self performSegueWithIdentifier:@"secondchooselocation" sender:nil];

}
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}
- (IBAction)btn_cancel_mainView:(id)sender
{
    [self performSegueWithIdentifier:@"stepfirstCancel" sender:self];
}
- (IBAction)returnToStepPopViews:(UIStoryboardSegue *)segue
{
    
}

@end
