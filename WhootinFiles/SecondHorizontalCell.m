//
//  SecondHorizontalCell.m
//  WHOOTIN:-)
//
//  Created by Nua i7 on 6/19/14.
//  Copyright (c) 2014 NuaTransMedia. All rights reserved.
//

#import "SecondHorizontalCell.h"

@implementation SecondHorizontalCell

static CGSize onLoadSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.textLabel.textAlignment=UITextAlignmentCenter;
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
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
    self.textLabel.frame = CGRectMake(0, 0, onLoadSize.width, onLoadSize.height);
    self.selectedBackgroundView.frame=self.textLabel.frame;
    self.imageView.frame = CGRectMake(0,-1,20, 20);
    
}

@end
