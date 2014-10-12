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
@property (strong, nonatomic) UIImage *instaImageThumb;
@property (strong, nonatomic) NSURL *instaImageURLFull;
@property (strong, nonatomic) NSURL *instaImageURLThumbnail;
@property  NSDate *created_time;
@property (strong, nonatomic) NSDictionary *caption;
@property NSInteger likesCount;
@property (strong, nonatomic) NSDictionary *likes;
@property  NSInteger *commentCount;
@property (strong, nonatomic) NSDictionary *images;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *filter;
@property (strong, nonatomic ) NSString *text;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSURL *profilePictureUrl;
@property (strong, nonatomic) NSString *username;


@end
