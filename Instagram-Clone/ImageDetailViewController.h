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

@property (nonatomic, weak) NSString *titleLabelvar;
@property (strong, nonatomic)  UIImage *imagevar;
@property (strong, nonatomic)  UIImage *profileImagevar;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
