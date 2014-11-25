//Om Sri Sai Ram
//  HorizontalCell.h
//  HorizontalTable
//
//  Created by PrasadBabu KN on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalCell : UITableViewCell
{
   UIImageView *ArrowimageView; 
}


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *ArrowimageView;

@property (weak, nonatomic) IBOutlet UIView *contentViews;

@end
