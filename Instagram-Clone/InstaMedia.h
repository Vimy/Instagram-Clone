//
//  InstaMedia.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 27/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaUser.h"

@interface InstaMedia : NSObject
@property (readonly, nonatomic) InstaUser *user;
@property (strong, nonatomic) UIImage *instaImage;
@property (strong, nonatomic) UIImage *instaImageThumb;
@property (strong, nonatomic) NSURL *instaImageURLFull;
@property (strong, nonatomic) NSURL *instaImageURLThumbnail;
@property  double created_time;
@property (strong, nonatomic) NSDictionary *caption;
@property (nonatomic) NSNumber *likesCount;
@property (strong, nonatomic) NSDictionary *likes;
@property ( nonatomic) NSInteger *commentCount;
@property (strong, nonatomic) NSDictionary *images;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *filter;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSURL *profilePictureUrl;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) NSDictionary *location;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;


@end
