//
//  SListViewCell.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 参照 UITableViewCell
@interface SListViewCell : UITableViewCell

@property (nonatomic, copy) NSString * reuseIdentifier;
@property (nonatomic, readonly) UIView * separatorView;
@property (nonatomic,strong) UIButton *smallImage;
@property (nonatomic,strong)UILabel *arrowlabels;
@property (nonatomic,strong)UILabel *nameslabels;

- (id)initWithReuseIdentifier:(NSString *) reuseIdentifier;

@end
