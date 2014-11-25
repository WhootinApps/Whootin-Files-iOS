//
//  QBAssetsCollectionFooterView.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionFooterView.h"

@interface QBAssetsCollectionFooterView ()

@property (nonatomic, strong, readwrite) UILabel *textLabel;

@end

@implementation QBAssetsCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a label
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.font = [UIFont systemFontOfSize:17];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:textLabel];
        //self.textLabel = textLabel;
        
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60.0)];
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

        
        
        //[self addSubview:header];
        
       //self.header = header;
        
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout text label
    self.textLabel.frame = CGRectMake(0,
                                      (self.bounds.size.height - 21.0) / 2.0,
                                      self.bounds.size.width,
                                      21.0);
    
   // self.header.frame = CGRectMake(0,
                                   //215,
                                   //self.bounds.size.width,
                                  // 21.0);

    
}

@end
