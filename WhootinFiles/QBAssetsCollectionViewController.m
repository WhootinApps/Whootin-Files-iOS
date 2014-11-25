//
//  QBAssetsCollectionViewController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewController.h"
#import "Datamodel.h"
// Views
#import "QBAssetsCollectionViewCell.h"
#import "QBAssetsCollectionFooterView.h"
#import "WMFPopViewController.h"

@interface QBAssetsCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end

@implementation QBAssetsCollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        // View settings
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        // Register cell class
        [self.collectionView registerClass:[QBAssetsCollectionViewCell class]
                forCellWithReuseIdentifier:@"AssetsCell"];
        [self.collectionView registerClass:[QBAssetsCollectionFooterView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:@"FooterView"];
    }
    
    return self;
}
-(void)viewDidLoad
{
    
    mu_fileUrl_Select_Con = [[NSMutableArray alloc]init];
    mu_fileDownUrl_con= [[NSMutableArray alloc]init];
    
    //Sqlite
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    firstview = [[UIView alloc]init];
    secondview = [[UIView alloc]init];
    txtfoldername = [[UITextField alloc]init];
    lbl = [[UILabel alloc]init];
    btnsend = [[UIButton alloc]init];
    btnclose = [[UIButton alloc]init];
    txt_Rename = [[UITextField alloc]init];
    im_secondview = [[UIImageView alloc]init];
    im_secondview_sendlogo = [[UIImageView alloc]init];
    btnsendfilecreation = [[UIButton alloc]init];
    
    NSLog(@"Folder id:%@",self.folderId);
    UIView *header;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {  CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height==568)
        {
        
            header = [[UIView alloc] initWithFrame:CGRectMake(0,510, 320, 60.0)];
            
        }
        else
        {
            header = [[UIView alloc] initWithFrame:CGRectMake(0,420, 320, 60.0)];
        }
    }
    else
    {
         header = [[UIView alloc] initWithFrame:CGRectMake(0,973,767,50)];
    }
    header.backgroundColor = [UIColor clearColor];
    header.userInteractionEnabled = YES;
    [header setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    //ADDING IMAGE VIEW
    UIImageView *image;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60.0)];
    }
    else
    {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 767, 70)];
    }
    
    
    image.image = [UIImage imageNamed:@"tab_bar.png"];
    [image setUserInteractionEnabled:TRUE];
    [header addSubview:image];
    //ADDING BUTTON
   placeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [placeBtn addTarget:self
                 action:@selector(done:)
       forControlEvents:UIControlEventTouchUpInside];
    
    placeBtn.backgroundColor = [UIColor clearColor];
    [placeBtn setBackgroundImage:[UIImage imageNamed:@"btn_upload1.png"] forState:UIControlStateNormal];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
    placeBtn.frame = CGRectMake(185,15,117,33);
    }
    else
    {
    placeBtn.frame = CGRectMake(630,7.5,117,33);
    }
    [header addSubview:placeBtn];
    
    [self.view addSubview:header];
    
    UIButton *placeBtnFolder = [UIButton buttonWithType:UIButtonTypeCustom];
    [placeBtnFolder addTarget:self
                 action:@selector(btndone)
       forControlEvents:UIControlEventTouchUpInside];
    
    placeBtnFolder.backgroundColor = [UIColor clearColor];
    [placeBtnFolder setBackgroundImage:[UIImage imageNamed:@"btn_newfolder.png"] forState:UIControlStateNormal];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
       placeBtnFolder.frame = CGRectMake(15,15, 117,33);
    }
    else
    {
        
        placeBtnFolder.frame = CGRectMake(19,7.5,117,33);
        
    }

    [header addSubview:placeBtnFolder];
    
    [self.view addSubview:header];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(10,15, 34, 34);
    //[button setTitle:@"Green" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissImagePickerController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];

    // Scroll to bottom --- iOS 7 differences
    CGFloat topInset;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        topInset = ((self.edgesForExtendedLayout && UIRectEdgeTop) && (self.collectionView.contentInset.top == 0)) ? (20.0 + 44.0) : 0.0;
    } else {
        topInset = (self.collectionView.contentInset.top == 0) ? (20.0 + 44.0) : 0.0;
    }
    
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.collectionViewLayout.collectionViewContentSize.height - self.collectionView.frame.size.height + topInset)
                                 animated:NO];
    // Validation
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.imagePickerController.selectedAssetURLs.count];
    }
}
#pragma mark----____-----____-----____------FileSharing Creation----____-----____-----____------
-(void)btndone
{
    /* rename_views.frame = CGRectMake(17, 150, 287, 230);
     txt_Rename.frame =CGRectMake(50,60,200,34);
     txt_Rename.delegate = self;
     [rename_views  setBackgroundColor:[UIColor colorWithRed:78/255.0 green:71/255.0 blue:154/255.0 alpha:1]];
     [rename_views.layer setCornerRadius:5.0f];
     [rename_views.layer setShadowColor:[UIColor blackColor].CGColor];
     [rename_views.layer setShadowOpacity:0.8];
     [rename_views.layer setShadowRadius:3.0];
     [rename_views.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
     
     [txt_Rename.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
     [txt_Rename.layer setBorderWidth:2.0];
     
     btnsend.frame = CGRectMake(80,120,100,30);
     [btnsend setBackgroundColor:[UIColor colorWithRed:78/255.0 green:71/255.0 blue:154/255.0 alpha:1]];
     [btnsend setTitle:@"Rename" forState:UIControlStateNormal];
     [btnsend addTarget:self action:@selector(btnsendNameChange) forControlEvents:UIControlEventTouchUpInside];
     
     btnclose.frame = CGRectMake(264, -6, 28, 31);
     [btnclose setBackgroundImage:[UIImage imageNamed:@"Blackclose.png"] forState:UIControlStateNormal];
     [btnclose addTarget:self action:@selector(btncloseviewRename) forControlEvents:UIControlEventTouchUpInside];
     secondview.frame = CGRectMake(8, 7, 271, 210);
     [secondview setBackgroundColor:[UIColor whiteColor]];
     [secondview addSubview:btnclose];
     [secondview addSubview:btnsend];
     [rename_views addSubview:secondview];
     [rename_views addSubview:txt_Rename];
     [self.view addSubview:rename_views];*/
    if ([self.folderIdFolding isEqualToString:@"newfolder"])
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyMMddhhmms"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        for (int i=0; i<mu_fileDownUrl_con.count; i++)
        {
            ALAsset *asset = [mu_fileDownUrl_con objectAtIndex:i];
            NSLog(@"INDDDS>>>>>>:%@",[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]);
            BOOL  strs = [self FolderNameChecking:[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]] names:@"file"];
            [self ValueInsertedAssest:[NSString stringWithFormat:@"%@",asset]];
            if(strs==YES)
            {
            NSArray *assestSp = [[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]] componentsSeparatedByString:@"."];
            NSString *valuesSp = [NSString stringWithFormat:@"%@%@.%@",assestSp[0],dateString,assestSp[1]];
            [self ValueInserted:valuesSp];
            }
            else
            {
            [self ValueInserted:[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]];

            }
        }
        if(mu_fileDownUrl_con.count!=0)
        {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"popview" forKey:@"pop"];
        [prefs synchronize];
        }
        [self dismissImagePickerController];
    }
    else
    {
        //newfolder
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
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            //CGFloat scale = [UIScreen mainScreen].scale;
            //result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height==568)
            {
               popfolderview = [mainStoryboard instantiateViewControllerWithIdentifier:@"newfolders"];
            }
            else
            {
                NSLog(@"gj");
               popfolderview = [mainStoryboard instantiateViewControllerWithIdentifier:@"newfolder"];
            }
        }
        else
        {
            popfolderview = [mainStoryboard instantiateViewControllerWithIdentifier:@"newfolders"];
        }
        
        
        popfolderview.folderKeys = self.folderKeys;
        popfolderview.folderId = self.folderId;
        [self presentViewController:popfolderview animated:YES completion:nil];
    }
    /*firstview.frame = CGRectMake(20, 100, 280,192);
    [firstview  setBackgroundColor:[UIColor colorWithRed:77/255.0 green:170/255.0 blue:223/255.0 alpha:1]];
    [firstview.layer setCornerRadius:5.0f];
    [firstview.layer setShadowColor:[UIColor blackColor].CGColor];
    [firstview.layer setShadowOpacity:0.8];
    [firstview.layer setShadowRadius:3.0];
    [firstview.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    txt_Rename.frame =CGRectMake(14,90,240,30);
    txt_Rename.delegate = self;
    btnclose.frame = CGRectMake(7,143,134,40);
    btnsendfilecreation.frame = CGRectMake(141, 143, 132, 39);
    [txt_Rename.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [txt_Rename.layer setBorderWidth:2.0];
    [btnsendfilecreation addTarget:self action:@selector(whootinFileUploading) forControlEvents:UIControlEventTouchUpInside];
    [btnclose addTarget:self action:@selector(btnclose) forControlEvents:UIControlEventTouchUpInside];
    
    secondview.frame = CGRectMake(7, 6, 266, 179);
    im_secondview.frame =CGRectMake(0, 0, 266, 179);
    im_secondview_sendlogo.frame = CGRectMake(10,8,204,45);
    [im_secondview setImage:[UIImage imageNamed:@"popup_folder.png"]];
    [im_secondview_sendlogo setImage:[UIImage imageNamed:@"sendmyfilename.png"]];
    [secondview setBackgroundColor:[UIColor whiteColor]];
    
    
    [firstview addSubview:secondview];
    [secondview addSubview:im_secondview];
    [secondview addSubview:btnclose];
    [im_secondview addSubview:im_secondview_sendlogo];
    [secondview addSubview:txt_Rename];
    [secondview addSubview:btnsendfilecreation];
    [self.view addSubview:firstview];*/
    
}
#pragma mark _-_-_TextDelegatesMethod_-_-_
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}
-(void)btnclose
{
    [firstview removeFromSuperview];
}
#pragma mark - Accessors
- (void)setFilterType:(QBImagePickerControllerFilterType)filterType
{
    _filterType = filterType;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Set title
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    // Get the number of photos and videos
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    self.numberOfPhotos = self.assetsGroup.numberOfAssets;
    
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
    self.numberOfVideos = self.assetsGroup.numberOfAssets;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
    // Load assets
    self.assets = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [weakSelf.assets addObject:result];
        }
    }];
    // Update view
    [self.collectionView reloadData];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    self.collectionView.allowsMultipleSelection = allowsMultipleSelection;
    
    // Show/hide done button
    if (allowsMultipleSelection) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
        
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
        
    }
}
- (BOOL)allowsMultipleSelection
{
    return self.collectionView.allowsMultipleSelection;
}
#pragma mark - Actions
- (void)done:(id)sender
{
    // Delegate
    //[mu_fileDownUrl_con removeAllObjects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewControllerDidFinishSelection:)])
    {
        [self.delegate assetsCollectionViewControllerDidFinishSelection:self];
    }
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
    NSURL *assetURL = [_assetssValues valueForProperty:ALAssetsGroupPropertyName];
    popview.mu_name =[[NSMutableArray alloc]init];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddhhmms"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    for (int i=0; i<mu_fileDownUrl_con.count; i++)
    {
     ALAsset *asset = [mu_fileDownUrl_con objectAtIndex:i];
     NSLog(@"INDDDS>>>>>>:%@",[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]);
     BOOL  strs = [self FolderNameChecking:[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]] names:@"file"];
        if(strs==YES)
        {
            NSArray *assestSp = [[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]] componentsSeparatedByString:@"."];
            
            NSString *valuesSp = [NSString stringWithFormat:@"%@%@.%@",assestSp[0],dateString,assestSp[1]];
           [self ValueInserted:valuesSp];
        }
        else
        {
          [self ValueInserted:[NSString stringWithFormat:@"%@",[[asset defaultRepresentation] filename]]];
        }
    }
    [popview name:mu_fileDownUrl_con];
    //popview.assests = _assetssValues;
    NSLog(@"mu_fileDownUrl_con>>>:%@",mu_fileDownUrl_con);
    popview.newvFolderId = [NSString stringWithFormat:@"%@",_folderIdFolding];
    popview.nsname=[NSString stringWithFormat:@"%@",[[_assetssValues defaultRepresentation] filename]];
    if(mu_fileDownUrl_con.count!=0)
    {
        [self presentViewController:popview animated:YES completion:nil];
        [self performSelector:@selector(ContentValuesInsertedValuesrrrr) withObject:self afterDelay:20.0];
        //[self performSelector:@selector(whootingGetFiles:) withObject:_folderId afterDelay:20.0];
    }
    else
    {
        showAlert(@"Select some images");
    }
      /*hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Uploading";
    [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    [hud show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
    dispatch_async(downloadQueue, ^{[NSThread sleepForTimeInterval:25];
        dispatch_async(dispatch_get_main_queue(),^{
            [hud hide:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
            NSLog(@"Sorry for working");
        });
    });*/
    
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



- (void)passSelectedAssetsToDelegate
{
    // Load assets from URLs
    __block NSMutableArray *assets = [NSMutableArray array];
    
    for (NSURL *selectedAssetURL in self.selectedAssetURLs) {
        __weak typeof(self) weakSelf = self;
        [self.assetsLibrary assetForURL:selectedAssetURL
                            resultBlock:^(ALAsset *asset) {
                                // Add asset
                                [assets addObject:asset];
                                
                                // Check if the loading finished
                                if (assets.count == weakSelf.selectedAssetURLs.count) {
                                    // Delegate
                                    
                                    [assets copy];
                                    
                                }
                            } failureBlock:^(NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];
    }
}

- (void)doSomeFunkyStuff {
    float progress = 0.0;
    
    while (progress < 1.0) {
        progress += 0.01;
        hud.progress = progress;
        usleep(200000);
    }
}

#pragma mark - Managing Selection
- (void)selectAssetHavingURL:(NSURL *)URL
{
    for (NSInteger i = 0; i < self.assets.count; i++) {
        ALAsset *asset = [self.assets objectAtIndex:i];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        if ([assetURL isEqual:URL]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            return;
        }
    }
}
#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}
- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        return (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return YES;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsGroup.numberOfAssets;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QBAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetsCell" forIndexPath:indexPath];
    cell.showsOverlayViewWhenSelected = self.allowsMultipleSelection;
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
       // NSLog(@"FaceBook:%@",asset);
    
    cell.asset = asset;
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 46.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        QBAssetsCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                      withReuseIdentifier:@"FooterView"
                                                                                             forIndexPath:indexPath];
        
        switch (self.filterType) {
            case QBImagePickerControllerFilterTypeNone:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_photos_and_videos",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfPhotos,
                                             self.numberOfVideos
                                             ];
                break;
            case QBImagePickerControllerFilterTypePhotos:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_photos",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfPhotos
                                             ];
                break;
            case QBImagePickerControllerFilterTypeVideos:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_videos",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfVideos
                                             ];
                break;
        }
        
        return footerView;
    }
    return nil;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(77.5, 77.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self validateMaximumNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
     _assetssValues = [self.assets objectAtIndex:indexPath.row];
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    [self.selectedAssetURLs addObject:assetURL];
    
    [mu_fileDownUrl_con addObject:_assetssValues];
    
    // Validation
    if (self.allowsMultipleSelection)
    {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
    }
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didSelectAsset:)])
    {
        [self.delegate assetsCollectionViewController:self didSelectAsset:asset];
    }
    //popview.mu_name =
   }
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    _assetssValues = [self.assets objectAtIndex:indexPath.row];
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    [self.selectedAssetURLs removeObject:assetURL];
    
    [mu_fileDownUrl_con removeObject:_assetssValues];
    
    // Validation
    if (self.allowsMultipleSelection)
    {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count - 1)];
    }
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didDeselectAsset:)]) {
        [self.delegate assetsCollectionViewController:self didDeselectAsset:asset];
    }
}
//Close Valuws
- (void)dismissImagePickerController
{
        [self dismissViewControllerAnimated:YES completion:NULL];
        [self.navigationController popToViewController:self animated:YES];
}
#pragma mark __--__--__--__Whooting__--__--__--__
-(void)ContentValuesInsertedValuesrrrr
{
   // dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/files.json?count=50"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
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
    @try
    {
        /*NSDictionary *dict = [json valueForKey:@"name"];
         NSDictionary *iddict = [json valueForKey:@"id"];
         NSDictionary *iddictypes = [json valueForKey:@"type"];
         NSDictionary *fileSizes = [json valueForKey:@"file_size"];
         NSDictionary *fileCreated = [json valueForKey:@"created_at"];*/
        
        mu_fileNames_Con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"name"]];
        mu_fileId_Con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"id"]];
        
        mu_fileType_Con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"type"]];
        
        mu_filesize_Con =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"file_size"]];
        
        mu_filecreated_Con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"created_at"]];
        
        mu_fileUrl_Con =[[NSMutableArray alloc]initWithArray:[json valueForKey:@"short_url"]];
        
        mu_fileDownUrl_con = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"url"]];
        for(int i=0;i<mu_fileNames_Con.count;i++)
        {
            [self whootinValuesInsert:mu_fileNames_Con[i] ID:mu_fileId_Con[i] TYPE:mu_fileType_Con[i] SIZES:mu_filesize_Con[i] CREATED:mu_filecreated_Con[i] SHORTURL:mu_fileUrl_Con[i] DOWNLOADURL:mu_fileDownUrl_con[i] BOOLCHECKING:[self isNotDataAddedBefore:mu_fileId_Con[i] ]];
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
-(BOOL)isNotDataAddedBefore:(NSString *)values
{
    BOOL isValid=NO;
    NSString *status;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT whootin_id FROM whootinfirst_tbl where whootin_id=\"%@\"",values];
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                status=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                [mu_fileUrl_Select_Con addObject:status];
                
                NSLog(@"Value:%@",status);
                
                if([status integerValue]==[values integerValue])
                {
                    isValid= true;
                    
                    NSLog(@"______________Tru_____%hhd",isValid);
                }
                else
                {
                    isValid=false;
                    NSLog(@"______________Flas_____%hhd",isValid);
                }
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return isValid;
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
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE whootinfirst_tbl SET whootin_id=\"%@\",whootin_name=\"%@\",whootin_type=\"%@\",whootin_size=\"%@\",whootin_creating=\"%@\",whootin_shorturl=\"%@\",whootin_downloadurl=\"%@\" WHERE whootin_id=\"%@\"",ids,name,type,sizes,created,shorturl,downloadurl,ids];
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
-(void)whootinFileUploading
{
    NSString *fl = [NSString stringWithFormat:@"%@",txt_Rename.text];
    
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
    else
    {
        NSString *sUserDefault = kAccessToken;
        NSURL *postURL = [[NSURL alloc]initWithString: @"http://whootin.com/api/v1/folders/new.json"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:30.0];
        
        [request setHTTPMethod:@"POST"];
        NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
        // header value
       
        //add body

        NSMutableData *postBody = [NSMutableData data];
        
        
         NSString *folderNames = [NSString stringWithFormat:@"Content-Disposition: form-data;name=name; name=%@",fl];
        
        [postBody appendData:[[NSString stringWithFormat:@"---%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //[postBody appendData:[@"Content-Disposition: form-data;name=\"name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //[postBody appendData:[[NSString stringWithFormat:@"%@",fl] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[folderNames dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"---%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Disposition: form-data;name=\"folder_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[self.folderId dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //[postBody appendData:[[NSString stringWithFormat:@"---%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:postBody];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@", sUserDefault] forHTTPHeaderField:@"Authorization"];
        
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSLog(@"just sent request");
        //this will set the image when loading is finished
        // convert data into string
        NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                            length:[responseData length]
                                                          encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responseString);
        NSLog(@"File Id 107458 :%@",self.folderId);
  
    }
    [self performSelector:@selector(ContentValuesInsertedValuesrrrr) withObject:self afterDelay:20.0];
    //[self performSelector:@selector(whootingGetFiles:) withObject:_folderId afterDelay:20.0];
    hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Creating..";
    [hud showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    [hud show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
    dispatch_async(downloadQueue, ^{[NSThread sleepForTimeInterval:20];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            NSLog(@"Sorry for working");
        });
    });
    // Delegate
    [self.delegate assetsCollectionViewControllerFolder:self didBoolSelect:true];
    
    [firstview removeFromSuperview];

}
-(void)whootingGetFiles :(NSString *)idval
{
    //[self whootinIds:self.idValue];
    //ContentValuesInsertedValues
    [self deleteDataFromDB];
    //[mu_idfile addObject:[NSString stringWithFormat:@"%@",_lbl_parentID.text]];
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
        
        NSLog(@"ID Value From Heres%@",[[NSMutableArray alloc]initWithArray:[json valueForKey:@"id"]]);
        
        for(int i=0;i<mu_fileNames_Con_Second.count;i++)
        {
            [self whootinValuesInserte:mu_fileNames_Con_Second[i] ID:mu_fileId_Con_Second[i] TYPE:mu_fileType_Con_Second[i] SIZES:mu_filesize_Con_Second[i] CREATED:mu_filecreated_Con_Second[i] SHORTURL:mu_fileUrl_Con_Second[i] DOWNLOADURL:mu_fileDownUrl_con_Second[i] PARENTID:mu_fileParent_con_Second[i] BOOLCHECKING:[self countDataFromDB:mu_fileId_Con_Second[i] ]];
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

-(void)whootinValuesInserte:(NSString *)name ID:(NSString *)ids TYPE:(NSString *)type SIZES:(NSString *)sizes CREATED:(NSString *)created  SHORTURL:(NSString *)shorturl DOWNLOADURL:(NSString *)downloadurl PARENTID:(NSString *)parentid  BOOLCHECKING:(BOOL)returnValue
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


-(void)ValueInsertedAssest :(NSString *)name
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB)== SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO whootinasses_tbl (name)VALUES(\"%@\")",name];
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

#pragma mark **************Status Bar Hidden**************
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
