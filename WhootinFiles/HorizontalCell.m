//Om Sri Sai Ram
//  HorizontalCell.m
//  HorizontalTable
//
//  Created by PrasadBabu KN on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HorizontalCell.h"

@implementation HorizontalCell

static CGSize onLoadSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ArrowimageView = [[UIImageView alloc]init];
        self.textLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        //self.textLabel.textAlignment=UITextAlignmentCenter;
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.ArrowimageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(CGSizeZero.width==onLoadSize.width && CGSizeZero.height==onLoadSize.height)
    {
        onLoadSize=self.contentView.bounds.size;
    }
    self.textLabel.frame = CGRectMake(0,20,onLoadSize.width,onLoadSize.height);
    self.selectedBackgroundView.frame=self.textLabel.frame;
    self.imageView.frame = CGRectMake(5,0,20, 20);
    self.ArrowimageView.frame = CGRectMake(0,0,20, 20);
    [self.contentView addSubview:ArrowimageView];
}
@end
