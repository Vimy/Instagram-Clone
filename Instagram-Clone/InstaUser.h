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
@property (strong, nonatomic) NSURL *profilePictureUrl;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *fullName;
@end
