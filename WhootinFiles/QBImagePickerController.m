//
//  QBImagePickerController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Datamodel.h"
// Views
#import "QBImagePickerGroupCell.h"
#import "QBAssetsCollectionViewLayout.h"

// ViewControllers
#import "QBAssetsCollectionViewController.h"

ALAssetsFilter * ALAssetsFilterFromQBImagePickerControllerFilterType(QBImagePickerControllerFilterType type) {
    switch (type) {
        case QBImagePickerControllerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
            
        case QBImagePickerControllerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
            
        case QBImagePickerControllerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}

@interface QBImagePickerController () <QBAssetsCollectionViewControllerDelegate>

@property (nonatomic, strong, readwrite) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, copy, readwrite) NSArray *assetsGroups;
@property (nonatomic, strong, readwrite) NSMutableSet *selectedAssetURLs;

@end

@implementation QBImagePickerController

+ (BOOL)isAccessible
{
    return ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]);
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        // Property settings
        self.selectedAssetURLs = [NSMutableSet set];
        
        self.groupTypes = @[
                            @(ALAssetsGroupSavedPhotos),
                            @(ALAssetsGroupPhotoStream),
                            @(ALAssetsGroupAlbum)
                            ];
        self.filterType = QBImagePickerControllerFilterTypeNone;
        self.showsCancelButton = YES;
        
        // View settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // Create assets library instance
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.assetsLibrary = assetsLibrary;
        
        // Register cell classes
        [self.tableView registerClass:[QBImagePickerGroupCell class] forCellReuseIdentifier:@"GroupCell"];
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    _checkValueSet = YES;
    
    
    /*UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60.0)];
    header.backgroundColor = [UIColor clearColor];
    header.userInteractionEnabled = YES;
    [header setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    
    
    //ADDING IMAGE VIEW
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60.0)];
    image.image = [UIImage imageNamed:@"nav_bar_sendmyfile_1.png"];
    [image setUserInteractionEnabled:TRUE];
    [header addSubview:image];
    
    
    //ADDING BUTTON
    UIButton *placeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [placeBtn addTarget:self
                 action:@selector(backBtn)
       forControlEvents:UIControlEventTouchUpInside];
    
    placeBtn.backgroundColor = [UIColor clearColor];
    [placeBtn setBackgroundImage:[UIImage imageNamed:@"btn_logout.png"] forState:UIControlStateNormal];
    
    placeBtn.frame = CGRectMake(10,15, 34, 34);
    [header addSubview:placeBtn];
    
    
    
    [self.view addSubview:header];*/


    
    // View controller settings
    self.title = NSLocalizedStringFromTable(@"Gallary", @"QBImagePickerController", nil);
    
      
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load assets groups
    [self loadAssetsGroupsWithTypes:self.groupTypes
                         completion:^(NSArray *assetsGroups) {
                             self.assetsGroups = assetsGroups;
                             
                             [self.tableView reloadData];
                         }];
    
    // Validation
    self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
}


#pragma mark - Accessors

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = YES;
    
    // Show/hide cancel button
    if (showsCancelButton) {
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
        button.frame=CGRectMake(10,15, 34, 34);
        //[button setTitle:@"Green" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    
        //[cancelButton setImage:[UIImage imageNamed:@"btn_logout.png"]];
        
       
        
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    // Show/hide done button
    if (allowsMultipleSelection) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        
        [[UIBarButtonItem appearance] setTintColor:[UIColor greenColor]];
        
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}


#pragma mark - Actions

- (void)done:(id)sender
{
    
    [self passSelectedAssetsToDelegate];
    
}

- (void)cancel:(id)sender
{  // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}
#pragma mark - Validating Selections
- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    // Check the number of selected assets
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}


#pragma mark - Managing Assets

- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in types) {
        __weak typeof(self) weakSelf = self;
        
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  // Filter the assets group
                                                  [assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(weakSelf.filterType)];
                                                  
                                                  if (assetsGroup.numberOfAssets > 0) {
                                                      // Add assets group
                                                      [assetsGroups addObject:assetsGroup];
                                                  }
                                              } else {
                                                  numberOfFinishedTypes++;
                                              }
                                              
                                              // Check if the loading finished
                                              if (numberOfFinishedTypes == types.count) {
                                                  // Sort assets groups
                                                  NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:types];
                                                  
                                                  // Call completion block
                                                  if (completion) {
                                                      completion(sortedAssetsGroups);
                                                  }
                                              }
                                          } failureBlock:^(NSError *error) {
                                              NSLog(@"Error: %@", [error localizedDescription]);
                                          }];
    }
}

- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder
{
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroup in assetsGroups) {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++) {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = [sortedAssetsGroups objectAtIndex:i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType) {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    return [sortedAssetsGroups copy];
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
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didSelectAssets:)]) {
                                        [self.delegate imagePickerController:self didSelectAssets:[assets copy]];
                                       
                                    }
                                }
                            } failureBlock:^(NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    cell.assetsGroup = assetsGroup;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBAssetsCollectionViewController *assetsCollectionViewController = [[QBAssetsCollectionViewController alloc] initWithCollectionViewLayout:[QBAssetsCollectionViewLayout layout]];
    assetsCollectionViewController.imagePickerController = self;
    assetsCollectionViewController.filterType = self.filterType;
    assetsCollectionViewController.allowsMultipleSelection = self.allowsMultipleSelection;
    assetsCollectionViewController.minimumNumberOfSelection = self.minimumNumberOfSelection;
    assetsCollectionViewController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    assetsCollectionViewController.folderId = self.folderId;
    assetsCollectionViewController.folderKeys = self.folderKeys;
    assetsCollectionViewController.folderIdFolding = self.folderIdFolding;
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    assetsCollectionViewController.delegate = self;
    assetsCollectionViewController.assetsGroup = assetsGroup;
    
    for (NSURL *assetURL in self.selectedAssetURLs) {
        [assetsCollectionViewController selectAssetHavingURL:assetURL];
    }
    
    [self.navigationController pushViewController:assetsCollectionViewController animated:YES];
}

#pragma mark - QBAssetsCollectionViewControllerDelegate
- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didSelectAsset:(ALAsset *)asset
{
    if (self.allowsMultipleSelection) {
        // Add asset URL
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [self.selectedAssetURLs addObject:assetURL];
        
        // Validation
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
    } else {
        // Delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didSelectAsset:)]) {
            [self.delegate imagePickerController:self didSelectAsset:asset];
        }
    }
}
- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didDeselectAsset:(ALAsset *)asset
{
    if (self.allowsMultipleSelection) {
        // Remove asset URL
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [self.selectedAssetURLs removeObject:assetURL];
        
        // Validation
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
    }
}
- (void)assetsCollectionViewControllerDidFinishSelection:(QBAssetsCollectionViewController *)assetsCollectionViewController
{
    [self passSelectedAssetsToDelegate];
}

-(void)assetsCollectionViewControllerFolder:(QBAssetsCollectionViewController *)imagePickerController didBoolSelect:(BOOL)cancelbool
{
    
    [self.delegate imagePickerControllerFolder:self didBoolSelect:cancelbool];
    
    
}
#pragma mark **************Status Bar Hidden**************
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
