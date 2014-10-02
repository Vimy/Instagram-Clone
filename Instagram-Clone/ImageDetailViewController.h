//
//  ImageDetailViewController.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 1/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailViewController : UIViewController

@property  UILabel *tiet;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@end
