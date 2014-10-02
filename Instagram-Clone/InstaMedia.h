//
//  InstaMedia.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 27/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstaMedia : NSObject
@property (strong, nonatomic) UIImage *instaImage;
@property (strong, nonatomic) NSURL *instaImageURLFull;
@property (strong, nonatomic) NSURL *instaImageURLThumbnail;


@end
