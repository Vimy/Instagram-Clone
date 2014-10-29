//
//  InstaUser.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 27/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstaUser : NSObject
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSURL *website;
@property (strong, nonatomic) NSURL *profilePictureUrl;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSDictionary *counts;

@property  (strong, nonatomic) NSNumber *mediaCount;
@property  (strong, nonatomic) NSNumber *followsCount;
@property  (strong, nonatomic) NSNumber *followedByCount;
@end
