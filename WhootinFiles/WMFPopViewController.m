//
//  WMFPopViewController.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 5/20/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "WMFPopViewController.h"
#import "Datamodel.h"
// ViewControllers
#import "QBAssetsCollectionViewController.h"
#import "HorizontalCell.h"
@interface WMFPopViewController ()
@property NSTimer *updateTimer;
@end

@implementation WMFPopViewController

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
    mu_names = [[NSMutableArray alloc]init];
    mu_names_files = [[NSMutableArray alloc]init];
	// Do any additional setup after loading the view.
    NSLog(@"Counts>>>>>:%@",_nsname);
    NSLog(@"Initialization:%@",mu_names);
    NSLog(@"Initialization1");
    NSLog(@"Initialization2");
    NSLog(@"Initialization3");
    
    
   /* UIImage *thumbImage = [UIImage imageNamed:@"line_thumb.png"];
    UIImage *sliderMinimum = [[UIImage imageNamed:@"volume_green.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    [slider_animation setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
    UIImage *sliderMaximum = [[UIImage imageNamed:@"volume_white.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    [slider_animation setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
    
    UIImage *sliderThumb = [UIImage imageNamed:@"line_thumb.png"];
    [slider_animation setThumbImage:sliderThumb forState:UIControlStateNormal];
    [slider_animation setThumbImage:sliderThumb forState:UIControlStateHighlighted];*/
    [[UISlider appearance] setMinimumTrackImage:[[UIImage imageNamed:@"volume_green.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    
    [[UISlider appearance] setMaximumTrackImage:[[UIImage imageNamed:@"volume_white.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"line_thumb.png"] forState:UIControlStateNormal];

    textFont=[UIFont fontWithName:@"Helvetica" size:15.0];
    { //Rotate the table view
        CGPoint oldCenter=_tableViewPath.center;
        _tableViewPath.frame=CGRectMake(0.0, 0.0, _tableViewPath.bounds.size.height-20, _tableViewPath.bounds.size.width);
        _tableViewPath.transform=CGAffineTransformMakeRotation(-M_PI_2);
        _tableViewPath.center=oldCenter;
    }
    _tableViewPath.showsVerticalScrollIndicator = NO;
    _tableViewPath.separatorStyle=UITableViewCellSeparatorStyleNone;
   [self pathGettings];
    
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
-(void)updateTimeAgoLabels
{
    [mu_names removeObject:0];
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
     [self selectPathNameFrom];
    lbels = [[UILabel alloc]initWithFrame:CGRectMake(20, 372, 270, 30)];
    NSString *StringValues = [[NSString alloc]init];
    NSString *a = [[NSString alloc]init];
    for (int i=0;i<mu_names_files.count;i++)
    {
        
        a = [StringValues stringByAppendingString:[[mu_names_files objectAtIndex:i]objectForKey:@"Fname"]];
        
        //[lbels setText:[[mu_names_files objectAtIndex:i]objectForKey:@"Fname"]];
        NSLog(@">>>>>>>>>>*****:%@",[NSString stringWithFormat:@"%@",[[mu_names_files objectAtIndex:i]objectForKey:@"Fname"]]);
        
        
        NSString *origText = lbels.text;
        lbels.text = [origText stringByAppendingString:[[mu_names_files objectAtIndex:i]objectForKey:@"Fname"]];
        
    }
    NSLog(@">>>>>>>>>>*****:%@",[NSString stringWithFormat:@"%@",a]);
    //[lbels setText:[NSString stringWithFormat:@"%@",a]];
    
    [self.view addSubview:lbels];
    NSString *temp=@"";
    for(int i=0;i<mu_names_files.count;i++)
    {
        
        //eventName=[[arr2 objectAtIndex:i]objectForKey:@"Code"];
        temp=[temp stringByAppendingString:[[mu_names_files objectAtIndex:i]objectForKey:@"Fname"]];
        
        if ([[[mu_names_files objectAtIndex:i]objectForKey:@"Fname"] isEqualToString:@"Home"])
        {
             temp=[temp stringByAppendingString:@"->>"];
        }
        else
        {
             temp=[temp stringByAppendingString:@"/"];
        }
    }
    //temp = [temp substringToIndex:[temp length]-1];
    _lbl_pathNames.text=[NSString stringWithFormat:@"%@",temp ];
    [self Upde];
    //[mu_names_files objectAtIndex:1]
    //slider_animation
}
-(void)pathGettings
{
/*[self selectPathNameFrom];
    NSLog(@"%@",[mu_names_files objectAtIndex:1]);
    
    
    for (_txt_pathnames in mu_names_files) {
        //pass label to function
        _txt_pathnames.text = [NSString stringWithFormat:@"%@",[mu_names_files objectForKey:@"Fname"];
    }
    
    for (int i=0;i<mu_names_files.count;i++)
    {
        NSLog(@"INddddd_>_>->_>->:%@",[[mu_names_files objectAtIndex:i]objectForKey:@"Fname"]);
        
        NSString *strs =[[mu_names_files objectAtIndex:i]objectForKey:@"Fname"];
        [self valuesPassings:strs];
    }*/
    if ([_checkpoint isEqualToString:@"one"])
    {
        [self.delegate WMFPopViewControllerDidFinishSelection:self ];
    }
}
- (void)Upde
{
   self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
}
- (void)updateCurrentTime
{
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(),
                       ^{

    NSString *selc = [NSString stringWithFormat:@"%@",[self SelectedDataFromWhootinName_Tbl]];
    slider_animation.value +=6.20f;
    if (slider_animation.value>=100)
    {
        slider_animation.value = 0.20f;
        
        if ([_allFilesUploads isEqualToString:@"all"])
        {
            //[self dismissingPopView];
            
            [self dismissingMainViews];
            
        }
        else if ([_allFilesUploads isEqualToString:@"alls"])
        {
            //[self dismissingPopSecondsView];
            [self dismissingMainViews];
            
        }
        if(![selc isEqualToString:@"1"])
        {
            [self deleteTableWhootin_Tbl:[self SelectedDataFromWhootinName_Tbl]];
            [_tableView reloadData];
        }

    }
                       });
    });
    NSLog(@"Slider%f",slider_animation.value);
}
-(void)valuesPassings :(NSString *)strjio
{
     _txt_pathnames.text = strjio;
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(self.updateTimer)
    {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    }
    NSLog(@"Dismissing Invalidate->>>>>>>>>>>>>-<<<<>>>>>>");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}
-(void)name:(NSMutableArray *)jj
{
    NSLog(@"INddddd:%@",jj);
    
    for (int i=0; i<jj.count; i++)
    {
    ALAsset *asset = [jj objectAtIndex:i];
    NSLog(@"INDDDS>>>>>>:%@",[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]);
    //[self ValueInserted:[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]];
    }
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
-(void)SelectDataFromDbForSendMeFilesValues
{
    [mu_names removeAllObjects];
  const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSString *querySQL;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        querySQL = [NSString stringWithFormat: @"SELECT * FROM whootintemp_tbl"];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"Prepare-error #%i: %s", (sqlite3_prepare_v2(contactDB, [ querySQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *temp = [NSMutableDictionary new];
                const char*whname=(const char *) sqlite3_column_text(statement, 0);
                NSString *name = whname == NULL ? nil : [[NSString alloc] initWithUTF8String:whname];

                [temp setObject:name forKey:@"name"];
                
                NSLog(@"Vali Retrive:%@",name);
                
                [mu_names addObject:temp];
                
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
}
-(void)selectPathNameFrom
{
    [mu_names_files removeAllObjects];
    
    
    if ([_newvFolderId isEqualToString:@"newfolder"])
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
         NSString *name;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT whootin_name FROM whootintemps_tbl"];
            const char *query_stmt = [querySQL UTF8String];
            NSLog(@"Prepare-error->>>->>> #%i: %s", (sqlite3_prepare_v2(contactDB, [querySQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
            if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                     NSMutableDictionary *temp = [NSMutableDictionary new];
                    const char*whname=(const char *) sqlite3_column_text(statement, 0);
                    name = whname == NULL ? nil : [[NSString alloc] initWithUTF8String:whname];
                    
                    [temp setObject:name forKey:@"Fname"];
                    [mu_names_files addObject:temp];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);

    }
    else
    {
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSString *querySQL;
    NSString *name;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        querySQL = [NSString stringWithFormat: @"SELECT * FROM whootinnames_tbl"];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"Prepare-error #%i: %s", (sqlite3_prepare_v2(contactDB, [ querySQL  UTF8String], -1, &statement, NULL) == SQLITE_OK), sqlite3_errmsg(contactDB));
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *temp = [NSMutableDictionary new];
                const char*whname=(const char *) sqlite3_column_text(statement, 0);
                name = whname == NULL ? nil : [[NSString alloc] initWithUTF8String:whname];
                
                [temp setObject:name forKey:@"Fname"];
                [mu_names_files addObject:temp];
    
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableViewPath)
    {
        return 80.0f;
        // NSString *strCellText=[mu_dirnames objectAtIndex:indexPath.row];
        //return 50+[strCellText sizeWithFont:textFont].width;
    }
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_tableViewPath)
    {
        [self selectPathNameFrom];
        return mu_names_files.count;
    }
    [self SelectDataFromDbForSendMeFilesValues];
    return  mu_names.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==_tableViewPath)
    {
            static NSString *identifier=@"reusableIdentifier";
            HorizontalCell *cell=(HorizontalCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            if(nil==cell)
            {
                cell=[[HorizontalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                //[[NSBundle mainBundle] loadNibNamed:@"CellsCreations" owner:self options:nil];
                cell.textLabel.frame = CGRectMake(0, 0,20,20);
                cell.textLabel.font=textFont;
            }
        cell.textLabel.text= [NSString stringWithFormat:@"%@/",[[mu_names_files objectAtIndex:indexPath.row]objectForKey:@"Fname"]];
            NSString *homes = [mu_names_files objectAtIndex:indexPath.row];
            NSString *lastOb = [NSString stringWithFormat:@"%d",[mu_names_files count]-1];
            NSString *indexGet = [NSString stringWithFormat:@"%d",indexPath.row];
            NSLog(@"ValuesKKKKK::::::KK%@",indexGet);
            NSLog(@"ValuesKKKKK::::::KKPPPP%@",lastOb);
            /*if([homes isEqualToString:@"Home"])
            {
                cell.imageView.image = [UIImage imageNamed:@"Shape-4.png"];
            }
            else if ([indexGet isEqualToString:lastOb])
            {
                cell.imageView.image = [UIImage imageNamed:@"Shape-3.png"];
            }
            else if (![indexGet isEqualToString:lastOb])
            {
                cell.imageView.image = [UIImage imageNamed:@"Shape-2.png"];
            }*/
            return cell;
        
    }
static NSString *CellIdentifier = @"Cell";
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel *gallery_subname = (UILabel *)[cell viewWithTag:1];
    UIImageView *imageviw = (UIImageView *)[cell viewWithTag:3];
    UIButton *btnShare = (UIButton *)[cell viewWithTag:12];
    [self SelectDataFromDbForSendMeFilesValues];
    /*UILabel *gallery_name = (UILabel *)[cell viewWithTag:10];
    NSLog(@"Counts>>>>>:%@",_nsname);
    gallery_name.text = [[mu_names objectAtIndex:indexPath.row]objectForKey:@"name"];*/
    gallery_subname.text = [[mu_names objectAtIndex:indexPath.row]objectForKey:@"name"];
    _lbl_name.text = [[mu_names objectAtIndex:0]objectForKey:@"name"];
     cell.imageView.image = [UIImage imageNamed:@"file.png"];
  //  self.updateTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updateTimeAgoLabels) userInfo:nil repeats:NO];
    //[[NSRunLoop mainRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];

    return cell;
}
#pragma mark **************Status Bar Hidden**************
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(NSString *)SelectedDataFromWhootinName_Tbl
{
    NSString *records;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT count(whootin_name) FROM whootintemp_tbl"];
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
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM whootintemp_tbl where rowid=\"%@\"",indes];
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
-(void)dismissingPopView
{
    [self performSegueWithIdentifier:@"dismissingPopviews" sender:self];
}
-(void)dismissingPopSecondsView
{
    
    [self performSegueWithIdentifier:@"dismissingSecondPopviews" sender:self];
}
-(void)dismissingMainViews
{
    [self performSegueWithIdentifier:@"dismissMain" sender:self];
}
@end
