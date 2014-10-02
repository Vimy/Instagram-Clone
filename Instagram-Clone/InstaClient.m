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
    
   // NSString *fullURl = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=38ce63e055ce48cd8f37aee2d0fe73f6&redirect_uri=instaklone://&response_type=code"];

  
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authCode = [defaults stringForKey:@"auth_code"];
    
   // if (![[NSUserDefaults standardUserDefaults] valueForKey:@"auth_code"])
    if (authCode)
    {
        NSLog(@"Key exists");
        NSLog(@"Key:%@", authCode);
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=38ce63e055ce48cd8f37aee2d0fe73f6&redirect_uri=instaklone://&response_type=code"]];
        NSLog(@"Key doesn't exists");
    }
}

- (NSArray *)startConnectionPopulairFeed
{
    __block NSDictionary *jsonResults;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=38ce63e055ce48cd8f37aee2d0fe73f6"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableArray *arr = [responseObject valueForKeyPath:@"data.images.thumbnail.url"];
         NSMutableArray *arr2 = [responseObject valueForKeyPath:@"data.images.standard_resolution"];
         
       //  NSLog(@"[InstaClient]Arr: %@", arr);
        
         NSMutableArray *tempArray = [[NSMutableArray alloc]init];
         for (NSString *str in arr)
         {
             InstaUser *user = [[InstaUser alloc]init];
            
             InstaMedia *media = [[InstaMedia alloc]init];
             NSURL *url = [NSURL URLWithString:str];
             user.media.instaImageURLThumbnail = url;
             user.media.instaImageURLFull = url;
             
             NSData *imageData = [NSData dataWithContentsOfURL:url];
             user.media.instaImage = [UIImage imageWithData:imageData];
             [tempArray addObject:user];
           NSLog(@"[InstaClient]media.InstaIMageUrlThumbnail: %@", user.media.instaImageURLThumbnail);
             
         }
         
      
    //     NSLog(@"[InstaClient]self.imagesArray: %@", self.imagesArray);
         
         self.imagesArray = tempArray;
         
        NSDictionary *tempDict3 = [jsonResults valueForKey:@"url"];
        self.imagesDict = tempDict3;
        
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Oopsie: %@", [error localizedDescription]);
     }];
    
    [operation start];
    
       return self.imagesArray;
    
}

- (void)searchForKeyWords:(NSString *)keywords
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/tags/%@/media/recent?client_id=38ce63e055ce48cd8f37aee2d0fe73f6", keywords]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
       //  NSLog (@"[InstaClient]SearchJSON: %@", responseObject);
         
         NSMutableArray *arr = [responseObject valueForKeyPath:@"data.images.thumbnail.url"];
        // NSLog(@"[InstaClient]Arr: %@", arr);
         NSMutableArray *tempArray = [[NSMutableArray alloc]init];
         
         for (NSString *str in arr)
         {
             
             InstaMedia *media = [[InstaMedia alloc]init];

             NSURL *url = [NSURL URLWithString:str];
             media.instaImageURLThumbnail = url;
             NSData *imageData = [NSData dataWithContentsOfURL:url];
             media.instaImage = [UIImage imageWithData:imageData];
             [tempArray addObject:media];
         }
         
          NSLog(@"[InstaClient]self.searchImagesArray: %@", self.searchImagesArray);
         self.searchImagesArray = tempArray;
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         NSLog(@"Oopsie: %@", [error localizedDescription]);
     }];
    
    [operation start];

}


@end
