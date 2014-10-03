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
   // NSString *fullURl = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=38ce63e055ce48cd8f37aee2d0fe73f6&redirect_uri=instaklone://&response_type=code"];
    /*
    NSString *parameterData = [NSString stringWithFormat:@"client_id=38ce63e055ce48cd8f37aee2d0fe73f6&client_secret=023772c25df742868e280ac8a1e0e0f4&grant_type=authorization_code&redirect_uri=instaklone://&code=%@",authCode];
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"];
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
    id response;
    NSError *error;
    
    NSMutableData* result = [[NSURLConnection sendSynchronousRequest:request   returningResponse:&response error:&error] mutableCopy];
    NSLog(@"Data: %@", result);
    NSError *localError;
    NSString* newStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"Data!!!!: %@", newStr);
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:result options:0 error:&localError];
    
    NSLog(@"ParsedObject: %@", parsedObject);
*/
    
    
   // if (![[NSUserDefaults standardUserDefaults] valueForKey:@"auth_code"])
    if (authCode)
    {
        /*NSLog(@"Key exists");
        NSLog(@"Key:%@", authCode);
        NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/oauth/"];
        AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:kCLIENTID secret:kCLIENTSECRET];
        [oauthClient authenticateUsingOAuthWithURLString:@"access_token/" code:authCode redirectURI:kREDIRECTURI success:^(AFOAuthCredential *credential)
         {
             NSLog(@"Credential: %@", credential);
         }failure:^(NSError *error){
             NSLog(@"Error: %@", [error localizedDescription]);
         }];
         */
        
        
        
        NSString *parameterData = [NSString stringWithFormat:@"client_id=6a88d49716fd4e0ba375cb784b9d9915&client_secret=ed816557f3874e5aaec633e2535e4c88&grant_type=authorization_code&redirect_uri=instaklone://&code=%@",authCode];
        NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"];
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
        id response;
        NSError *error;
        
        NSMutableData* result = [[NSURLConnection sendSynchronousRequest:request   returningResponse:&response error:&error] mutableCopy];
        NSLog(@"Data: %@", result);
        NSError *localError;
        NSString* newStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"Data!!!!: %@", newStr);
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:result options:0 error:&localError];
        
        NSLog(@"ParsedObject: %@", parsedObject);

        
        
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

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae"]];
   // https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae
  //  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=38ce63e055ce48cd8f37aee2d0fe73f6"]];
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
            
             InstaMedia *media = [[InstaMedia alloc]init];
             NSURL *url = [NSURL URLWithString:str];
             media.instaImageURLThumbnail = url;
             media.instaImageURLFull = url;
             
             NSData *imageData = [NSData dataWithContentsOfURL:url];
             media.instaImage = [UIImage imageWithData:imageData];
             [tempArray addObject:media];
           NSLog(@"[InstaClient]media.InstaIMageUrlThumbnail: %@", media.instaImageURLThumbnail);
             
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
