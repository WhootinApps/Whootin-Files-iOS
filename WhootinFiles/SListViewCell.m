//
//  SListViewCell.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SListViewCell.h"

@implementation SListViewCell
@synthesize separatorView = _separatorView1;
@synthesize smallImage = _smallImage;
@synthesize arrowlabels = _arrowlabels;
@synthesize nameslabels = _nameslabels;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.reuseIdentifier = reuseIdentifier;
        _separatorView1 = [[UIView alloc] init];
        _smallImage = [[UIButton alloc]init];
        _arrowlabels = [[UILabel alloc]init];
        _nameslabels = [[UILabel alloc]init];
        [self addSubview:_separatorView1];
        [self  addSubview:_smallImage];
        [self addSubview:_arrowlabels];
        [self addSubview:_nameslabels];
    }
    return self;
}

@end
