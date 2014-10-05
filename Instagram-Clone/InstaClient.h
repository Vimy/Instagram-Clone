//
//  InstaClient.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 27/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define kCLIENTID @"6a88d49716fd4e0ba375cb784b9d9915"
#define kCLIENTSECRET @"ed816557f3874e5aaec633e2535e4c88"
#define kREDIRECTURI @"instaklone://"

@interface InstaClient : NSObject
@property (nonatomic, strong) NSString *instaToken;
@property  (nonatomic, strong) __block NSDictionary *imagesDict;
@property (nonatomic, strong) __block NSMutableArray *imagesArray;
@property (nonatomic, strong) __block NSMutableArray *searchImagesArray;
@property (nonatomic, strong) __block NSMutableArray *personalImagesArray;


- (void)searchForKeyWords:(NSString *)keywords;
- (void)startConnection;
- (NSArray *)startConnectionPopulairFeed;
- (NSArray *)startPersonalFeed;
+(id)sharedClient;


@end
