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
@property (nonatomic, strong) NSString *instaToken;
@property  (nonatomic, strong) __block NSDictionary *imagesDict;
@property (nonatomic, strong) __block NSMutableArray *imagesArray;
@property (nonatomic, strong) __block NSMutableArray *searchImagesArray;


- (void)searchForKeyWords:(NSString *)keywords;
- (void)startConnection;
- (NSDictionary *)startConnectionPopulairFeed;
+(id)sharedClient;


@end
