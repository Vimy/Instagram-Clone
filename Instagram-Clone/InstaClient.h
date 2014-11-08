//
//  InstaClient.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 27/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define kCLIENTID @"38ce63e055ce48cd8f37aee2d0fe73f6"
#define kCLIENTSECRET @"023772c25df742868e280ac8a1e0e0f4"
#define kREDIRECTURI @"instaklone://"

@interface InstaClient : NSObject
@property (nonatomic, strong) __block NSString *instaToken;
@property (nonatomic, strong) __block NSArray *imagesArray;
@property (nonatomic, strong) __block NSArray *searchImagesArray;
@property (nonatomic, strong) __block NSArray *personalImagesArray;
@property (nonatomic, strong) __block NSArray *userInfoArray;

+(id)sharedClient;
- (void)searchForKeyWords:(NSString *)keywords;
- (void)startConnection;
- (NSArray *)startConnectionPopulairFeed;
- (NSArray *)startPersonalFeed;
- (void)downloadUserFeed:(NSString *)username;
- (void)handleOAuthCallbackWithUrl:(NSURL *)url;
- (NSString *)parseQueryString:(NSString *)query;
- (void)downloadUserInfo:(NSString *)username;

//https://www.youtube.com/watch?v=vv2i8PuGkF8
@end
