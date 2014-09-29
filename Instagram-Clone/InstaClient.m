//
//  InstaClient.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 27/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "InstaClient.h"

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
    /*
    NSString *fullURl = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=38ce63e055ce48cd8f37aee2d0fe73f6&redirect_uri=instaklone://&response_type=code"];
    NSURL *url = [NSURL URLWithString:fullURl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //[[NSURLConnection alloc]initWithRequest:request delegate:nil startImmediately:YES];
    
    
    if (data)
    {
        NSLog(@"Connectie gestart");
        NSError *Jerror = nil;
        
        NSDictionary* json =[NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&Jerror];
        
        NSLog(@"Data: %@",json);
    }
    else
    {
        NSLog(@"Fail!");
    }
     */
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=38ce63e055ce48cd8f37aee2d0fe73f6&redirect_uri=instaklone://&response_type=code"]];
}
@end
