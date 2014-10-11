//
//  InstaClient.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 27/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "InstaClient.h"
#import "InstaMedia.h"
#import "InstaUser.h"
#import "AFOAuth2Client.h"
#import "NSNull+JSON.h"


@implementation InstaClient


+ (id)sharedClient
{
    static InstaClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken , ^{
        sharedClient = [[self alloc]init];
    });
    
    return sharedClient;
}

- (id)init
{
    self.imagesArray = [[NSMutableArray alloc]init];
    self.searchImagesArray = [[NSMutableArray alloc]init];
    return self;
    
}


- (void)setinstaToken:(NSString *)tokenString
{
    if (_instaToken != tokenString)
    {
        _instaToken = nil;
        _instaToken = tokenString;
         NSLog(@"Dit is het token: %@", _instaToken);
    }
}
// http://stackoverflow.com/questions/13281084/whats-a-redirect-uri-how-does-it-apply-to-ios-app-for-oauth2-0
- (void)startConnection
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authCode = [defaults stringForKey:@"auth_code"];
       if (authCode)
    {
    
        
        
        NSString *parameterData = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",kCLIENTID,kCLIENTSECRET,kREDIRECTURI,authCode];
       
        NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"];
         NSLog(@"Dit is de url :%@", url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameterData dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id result)
         {
             NSLog(@"JSON response: %@", result);
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", [error localizedDescription]);
         }];
    
        
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=6a88d49716fd4e0ba375cb784b9d9915&redirect_uri=instaklone://&response_type=code"]];
        NSLog(@"Key doesn't exists");
    }
}

- (NSArray *)startConnectionPopulairFeed
{

   // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae"]];
   // https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=6a88d49716fd4e0ba375cb784b9d9915"]];
    
        self.imagesArray = [self startDownload:request];
    
       return self.imagesArray;
    
}

- (NSArray *)startPersonalFeed
{
   
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae"]];
    // https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae
    //  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=38ce63e055ce48cd8f37aee2d0fe73f6"]];
   
    
   self.personalImagesArray = [self startDownload:request];
    NSLog(@"PersonalFeed: %@", self.personalImagesArray);
    return self.personalImagesArray;
    
}


- (void)searchForKeyWords:(NSString *)keywords
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@", keywords, kCLIENTID]]];
   
    self.searchImagesArray = [self startDownload:request];

    
    

}

- (NSArray *)startDownload:(NSURLRequest  *)request
{
    __block NSMutableArray *images = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
        // NSDictionary *dic = [self nullFreeDictionaryWithDictionary:responseObject];
         
        // NSArray *results = [dic valueForKey:@"data"];
         NSArray *results = [responseObject valueForKey:@"data"];
         //NSArray *results = responseObject;
        
         
         
         for (NSDictionary *imagesDic in results)
                 {
                           InstaMedia *media = [[InstaMedia alloc]init];
                
                          for (NSString *key in imagesDic)
                                 {
                                     if([media respondsToSelector:NSSelectorFromString(key)])
                                            {
                                                    [media setValue:[imagesDic valueForKey:key ] forKey:key];
                                         //       NSLog(@"Key: %@", key);
                                       //         NSLog(@"VALUE FOR KEY: %@",[imagesDic valueForKey:key ] );
                                              }
                                   }
                     
                            [images addObject:media];
               //      NSLog(@"Media: %@", media);
                        }
        
         //json null check
         
         
         /*
         
         for (NSDictionary *imagesDic in results)
         {
            NSLog(@"[INSTACLIENT]imagesDic: %@", imagesDic);
             InstaMedia *media = [[InstaMedia alloc]init];
             
             // NSLog(@"Key:%@", key);
             NSURL *standardResURL = [NSURL URLWithString:[imagesDic valueForKeyPath:@"images.standard_resolution.url"]];
             NSURL *thumbResURL = [NSURL URLWithString:[imagesDic valueForKeyPath:@"images.thumbnail.url"]];
             NSURL *profilePictureURL = [NSURL URLWithString:[imagesDic valueForKeyPath:@"caption.from.profile_picture"]];
             media.likesCount = [imagesDic valueForKeyPath:@"likes.count"];
             NSTimeInterval interval = [[imagesDic valueForKeyPath:@"created_time"]doubleValue];
             media.createdTime = [NSDate dateWithTimeIntervalSince1970:interval];
             NSLog(@"[INSTACLIENT]Date: %@", media.createdTime);
             //media.instaImageURLFull = standardResURL;
             NSData *imageData = [NSData dataWithContentsOfURL:thumbResURL];
             media.instaImageThumb = [UIImage imageWithData:imageData];
             imageData = [NSData dataWithContentsOfURL:standardResURL];
             media.instaImage = [UIImage imageWithData:imageData];
             imageData = [NSData dataWithContentsOfURL:profilePictureURL];
             media.profileImage = [UIImage imageWithData:imageData];
             media.username = [imagesDic valueForKeyPath:@"caption.from.username"];
             media.instaImageURLFull = standardResURL;
             media.instaImageURLThumbnail = thumbResURL;
             //[NSURL URLWithString:[imagesDic valueForKeyPath:@"images.standard_resolution.url"]];
             
             
             
             
             [images addObject:media];
             
          
             
         }
         */
         
         
         [[NSNotificationCenter defaultCenter] postNotification:
          [NSNotification notificationWithName:@"downloadFinished" object:nil]];
        // self.imagesDict = tempDict3;
         
         
         //self.imagesArray = images;
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Oopsie: %@", [error localizedDescription]);
     }];
    
    [operation start];
    
    
    return images;
   // return self.imagesArray;

}

- (NSDictionary *)nullFreeDictionaryWithDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    // Iterate through each key-object pair.
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        // If object is a dictionary, recursively remove NSNull from dictionary.
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *innerDict = object;
            replaced[key] = [self nullFreeDictionaryWithDictionary:innerDict];
        }
        // If object is an array, enumerate through array.
        else if ([object isKindOfClass:[NSArray class]]) {
            NSMutableArray *nullFreeRecords = [NSMutableArray array];
            for (id record in object) {
                // If object is a dictionary, recursively remove NSNull from dictionary.
                if ([record isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *nullFreeRecord = [self nullFreeDictionaryWithDictionary:record];
                    [nullFreeRecords addObject:nullFreeRecord];
                }
                else {
                    if (object == [NSNull null]) {
                        [nullFreeRecords addObject:@""];
                    }
                    else {
                        [nullFreeRecords addObject:record];
                    }
                }
            }
            replaced[key] = nullFreeRecords;
        }
        else {
            // Replace [NSNull null] with nil string "" to avoid having to perform null comparisons while parsing.
            if (object == [NSNull null]) {
                replaced[key] = @"";
            }
        }
    }];
    
    return [NSDictionary dictionaryWithDictionary:replaced];
}

@end
