//
//  ImageDetailViewController.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 1/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaMedia.h"
@interface ImageDetailViewController : UIViewController

@property  UILabel *tiet;
@property (strong, nonatomic) InstaMedia *media;

@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;

@property (nonatomic, weak) NSString *titleLabelvar;
@property (strong, nonatomic)  UIImage *imagevar;
@property (strong, nonatomic)  UIImage *profileImagevar;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@property (strong, nonatomic) NSURL *fullImageURL;
@property (strong, nonatomic) NSURL *profileImageURL;

@property (strong, nonatomic) IBOutlet UILabel *likesCount;

@end
