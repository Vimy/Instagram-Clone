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
    __block NSDictionary *jsonResults;

   // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae"]];
   // https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=6a88d49716fd4e0ba375cb784b9d9915"]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSMutableArray *images = [[NSMutableArray alloc]init];
         
         
         NSArray *results = [responseObject valueForKey:@"data"];
         
         for (NSDictionary *imagesDic in results)
         {
             InstaMedia *media = [[InstaMedia alloc]init];
             
             for (NSString *key in imagesDic)
             {
                 if([media respondsToSelector:NSSelectorFromString(key)])
                 {
                     [media setValue:[imagesDic valueForKey:key forKey:key]];
                 }
             }
             
             [images addObject:media];
         }
         
         /*
         
         NSMutableArray *arr = [responseObject valueForKeyPath:@"data.images.thumbnail.url"];
         NSMutableArray *arr2 = [responseObject valueForKeyPath:@"data.images.standard_resolution.url"];
         NSMutableArray *arr3 = [responseObject valueForKeyPath:@"data.likes.count"];
         NSMutableArray *arr4 = [responseObject valueForKeyPath:@"data.caption.from.profile_picture"];
          NSMutableArray *arr5 = [responseObject valueForKeyPath:@"data.caption.from.username"];
         NSMutableArray *arr6 = [responseObject valueForKeyPath:@"data.created_time"];
         
       //  NSLog(@"[InstaClient]Arr: %@", arr);
        
         NSMutableArray *tempArray = [[NSMutableArray alloc]init];
         for (int i = 0;[arr count]>=1;i++)
         {
             NSString *str = [arr objectAtIndex:i];
             InstaMedia *media = [[InstaMedia alloc]init];
             NSURL *url = [NSURL URLWithString:str];
             NSURL *urlFullImage = [NSURL URLWithString:[arr2 objectAtIndex:i]];
             NSURL *profileURL = [NSURL URLWithString:[arr4 objectAtIndex:i]];
             media.profilePictureUrl = profileURL;
             NSLog(@"[InstaClient]profileURL: %@", profileURL);
             media.instaImageURLThumbnail = url;
             media.instaImageURLFull = urlFullImage;
          //   media.likes = [arr3 objectAtIndex:i];
           //  NSLog(@"MEDIA-LIKES: %@", media.likes);
            // media.createdTime = [NSNumber num][arr6 objectAtIndex:i];
             NSData *profileImageData = [NSData dataWithContentsOfURL:profileURL];
             media.username = [arr5 objectAtIndex:i];
             media.profileImage = [UIImage imageWithData:profileImageData];
             NSData *imageData = [NSData dataWithContentsOfURL:url];
             media.instaImage = [UIImage imageWithData:imageData];
             [tempArray addObject:media];
             NSLog(@"[InstaClient]media.InstaIMageUrlThumbnail: %@", media.instaImageURLThumbnail);
            if (i == 18)
             {
                 break;
             }
         }
         
      */
         
    //     NSLog(@"[InstaClient]self.imagesArray: %@", self.imagesArray);
         
        // self.imagesArray = [[NSMutableArray alloc]initWithArray: tempArray];
         
        NSDictionary *tempDict3 = [jsonResults valueForKey:@"url"];
        self.imagesDict = tempDict3;
        
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Oopsie: %@", [error localizedDescription]);
     }];
    
    [operation start];
    
       return self.imagesArray;
    
}

- (NSArray *)startPersonalFeed
{
   
    __block NSDictionary *jsonResults;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae"]];
    // https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae
    //  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=38ce63e055ce48cd8f37aee2d0fe73f6"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableArray *arr = [responseObject valueForKeyPath:@"data.images.thumbnail.url"];
         NSMutableArray *arr2 = [responseObject valueForKeyPath:@"data.images.standard_resolution.url"];
         NSMutableArray *arr3 = [responseObject valueForKeyPath:@"data.likes.count"];
         NSMutableArray *arr4 = [responseObject valueForKeyPath:@"data.caption.from.profile_picture"];
         NSMutableArray *arr5 = [responseObject valueForKeyPath:@"data.caption.from.username"];
         NSMutableArray *arr6 = [responseObject valueForKeyPath:@"data.created_time"];
          NSLog(@"PersonalFeed started");
         //  NSLog(@"[InstaClient]Arr: %@", arr);
         
         NSMutableArray *tempArray = [[NSMutableArray alloc]init];
         for (int i = 0;[arr count]>=1;i++)
         {
             NSString *str = [arr objectAtIndex:i];
             InstaMedia *media = [[InstaMedia alloc]init];
             NSURL *url = [NSURL URLWithString:str];
             NSURL *urlFullImage = [NSURL URLWithString:[arr2 objectAtIndex:i]];
             NSURL *profileURL = [NSURL URLWithString:[arr4 objectAtIndex:i]];
             media.profilePictureUrl = profileURL;
          //   NSLog(@"[InstaClient]profileURL: %@", profileURL);
             media.instaImageURLThumbnail = url;
             media.instaImageURLFull = urlFullImage;
             media.likes = [arr3 objectAtIndex:i];
          //   NSLog(@"MEDIA-LIKES: %@", media.likes);
             // media.createdTime = [NSNumber num][arr6 objectAtIndex:i];
             NSData *profileImageData = [NSData dataWithContentsOfURL:profileURL];
             media.username = [arr5 objectAtIndex:i];
             media.profileImage = [UIImage imageWithData:profileImageData];
             NSData *imageData = [NSData dataWithContentsOfURL:url];
             media.instaImage = [UIImage imageWithData:imageData];
             [tempArray addObject:media];
             //  NSLog(@"[InstaClient]media.InstaIMageUrlThumbnail: %@", media.instaImageURLThumbnail);
             if (i == 19)
             {
                 break;
             }
         }
         
         NSLog(@"TEmpArray: %@", tempArray);
         //     NSLog(@"[InstaClient]self.imagesArray: %@", self.imagesArray);
         self.personalImagesArray = [[NSMutableArray alloc]init];
         self.personalImagesArray = tempArray;
         NSLog(@"PersonalArray: %@", self.personalImagesArray);
         NSDictionary *tempDict3 = [jsonResults valueForKey:@"url"];
         self.imagesDict = tempDict3;
         
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Oopsie: %@", [error localizedDescription]);
     }];
    
    [operation start];
    
    return self.personalImagesArray;
    
}


- (void)searchForKeyWords:(NSString *)keywords
{
    __block NSDictionary *jsonResults;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@", keywords, kCLIENTID]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableArray *arr = [responseObject valueForKeyPath:@"data.images.thumbnail.url"];
         NSMutableArray *arr2 = [responseObject valueForKeyPath:@"data.images.standard_resolution.url"];
         NSMutableArray *arr3 = [responseObject valueForKeyPath:@"data.likes"];
         NSMutableArray *arr4 = [responseObject valueForKeyPath:@"data.caption.from.profile_picture"];
         NSMutableArray *arr5 = [responseObject valueForKeyPath:@"data.caption.from.username"];
         //  NSLog(@"[InstaClient]Arr: %@", arr);
         
         NSMutableArray *tempArray = [[NSMutableArray alloc]init];
         for (int i = 0;[arr count]>=1;i++)
         {
             NSString *str = [arr objectAtIndex:i];
             InstaMedia *media = [[InstaMedia alloc]init];
             NSURL *url = [NSURL URLWithString:str];
             NSURL *urlFullImage = [NSURL URLWithString:[arr2 objectAtIndex:i]];
             NSURL *profileURL = [NSURL URLWithString:[arr4 objectAtIndex:i]];
             media.profilePictureUrl = profileURL;
             NSLog(@"[InstaClient]profileURL: %@", profileURL);
             media.instaImageURLThumbnail = url;
             media.instaImageURLFull = urlFullImage;
             NSData *profileImageData = [NSData dataWithContentsOfURL:profileURL];
             media.username = [arr5 objectAtIndex:i];
             media.profileImage = [UIImage imageWithData:profileImageData];
             NSData *imageData = [NSData dataWithContentsOfURL:url];
             media.instaImage = [UIImage imageWithData:imageData];
             [tempArray addObject:media];
             //  NSLog(@"[InstaClient]media.InstaIMageUrlThumbnail: %@", media.instaImageURLThumbnail);
             if (i == 19)
             {
                 break;
             }
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

}


@end
