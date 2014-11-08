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
#import "NSDictionary+NullReplacement.h"
#import "NSArray+NullReplacement.h"


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



// http://stackoverflow.com/questions/13281084/whats-a-redirect-uri-how-does-it-apply-to-ios-app-for-oauth2-0
- (void)startConnection
{
    
    //experiment
    /* curl \-F 'client_id=CLIENT-ID' \
     -F 'client_secret=CLIENT-SECRET' \
     -F 'grant_type=authorization_code' \
     -F 'redirect_uri=YOUR-REDIRECT-URI' \
     -F 'code=CODE' \https://api.instagram.com/oauth/access_token
     */
    
    //https://gist.github.com/mombrea/8467128
    
    
    //Figured it out.  Apparently instagram doesn't support sending the params as url params, rather they must be sent as the body content of the post.
    
    
    
    
   /*
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    [defaults2 removeObjectForKey:@"auth_code"];
    [defaults2 synchronize];
    */
  
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authCode = [defaults stringForKey:@"auth_code"];
  
   // NSLog(@"AUTHCODE: %@", authCode);
    if (authCode)
    {
    // http://nsscreencast.com/episodes/41-authentication-with-afnetworking
    
        if (![defaults stringForKey:@"instatoken"])
        {
            NSDictionary *params = @{@"client_id":kCLIENTID, @"client_secret":kCLIENTSECRET, @"grant_type":@"authorization_code",@"redirect_uri":kREDIRECTURI, @"code":authCode};
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager]; //mister manager :p
            [manager POST:@"https://api.instagram.com/oauth/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Responseobject AFNETWORKING: %@", responseObject);
                self.instaToken = responseObject[@"access_token"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error AFNETWORKING: %@", error);
            }];
            
            NSLog(@"InstaToken: %@", self.instaToken);
            [defaults setValue:self.instaToken forKey:@"instatoken"];
            [defaults synchronize];
            
            /*
            
            //  NSLog(@"Test");
            NSString *parameterData = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",kCLIENTID,kCLIENTSECRET,kREDIRECTURI,authCode];
            NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[parameterData dataUsingEncoding:NSUTF8StringEncoding]];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
            
            NSDictionary *params = @{@"client_id:%@", kCLIENTID}
            
            
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://samwize.com/"]];
            [httpClient setParameterEncoding:AFFormURLParameterEncoding];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                    path:@"http://samwize.com/api/pig/"
                                                              parameters:@{@"name":@"piggy"}];

          
            //NSURLConnection
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
          //  NSLog(@"JSON response: %@", json);
            
            */
          /*  AFHTTPSessionManager *httpManager =
            
            //AFNetworking
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id result)
             {
            //     NSLog(@"Test!");
                 NSLog(@"JSON response: %@", result);
             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NSLog(@"Error: %@", [error localizedDescription]);
                 NSLog(@"No token from instagram. :sadface:");
             }];
            [operation start];*/
       }

        self.instaToken = [defaults stringForKey:@"instatoken"];
        
    }
    else
    {

        NSString *urlstring =[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code", kCLIENTID,kREDIRECTURI];
        NSString *escaped = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
      
     //   NSLog(@"Url string: %@",escaped);
       // https://api.instagram.com/oauth/authorize/?client_id=6a88d49716fd4e0ba375cb784b9d9915&redirect_uri=instaklone://&response_type=code
       // NSLog(@"Key doesn't exists");
    }
}

- (NSArray *)startConnectionPopulairFeed
{
 
    NSString *urlstring =[NSString stringWithFormat:@"https://api.instagram.com/v1/media/popular?client_id=%@", kCLIENTID];
    NSString *escaped = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:escaped]];
    
    self.imagesArray = [self startDownload:request forDownloadType:@"populairFeedDownload"];
    return self.imagesArray;
}

- (NSArray *)startPersonalFeed
{
    
    NSString *urlstring =[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@",self.instaToken];
    NSString *escaped = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:escaped]] ;
    // https://api.instagram.com/v1/users/self/feed?access_token=687802.6a88d49.78af428cbc2947d4951bcfb72116b7ae
    //  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=38ce63e055ce48cd8f37aee2d0fe73f6"]];
   
    
   self.personalImagesArray = [self startDownload:request forDownloadType:@"personalFeedDownload"];
    return self.personalImagesArray;
   

}


- (void)searchForKeyWords:(NSString *)keywords
{
    NSString *urlstring =[NSString stringWithFormat: @"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@", keywords, kCLIENTID];
    NSString *escaped = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:escaped]];
    self.searchImagesArray = [self startDownload:request forDownloadType:@"searchDownload"];
    
}

- (void)downloadUserFeed:(NSString *)username
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@", username, self.instaToken]]];
   // NSLog(@"self.instatoken : %@", self.instaToken);
    self.personalImagesArray = [self startDownload:request forDownloadType:@"userFeedDownload"];
}

- (void)downloadUserInfo:(NSString *)username
{
    //https://api.instagram.com/v1/users/1574083/?access_token=ACCESS-TOKEN
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/?access_token=%@", username, self.instaToken]]];
    self.userInfoArray = [self startDownload:request forDownloadType:@"userInfo"];
    
}

- (NSArray *)startDownload:(NSURLRequest  *)request forDownloadType:(NSString *)downloadType
{
    __block NSMutableArray *images = [[NSMutableArray alloc]init];

   //  NSLog(@"self.instatoken : %@", self.instaToken);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         NSArray *results = [responseObject valueForKey:@"data"];
        // NSDictionary *nullDic = [responseObject valueForKey:@"data"];
         NSArray *resultsWithoutNull = [results arrayByReplacingNullsWithBlanks];
        NSLog(@"Results: %@", resultsWithoutNull[0]);
         
         if ([downloadType isEqualToString:@"userInfo"])
         {
             
            
             
          //   NSLog(@"[InstaClient]results: %@", resultsDic);
            
          //   NSLog(@"crasht het hier?");
                 InstaUser *user = [[InstaUser alloc]init];
 
             for (NSDictionary *resultsDic in resultsWithoutNull)
             {
                 
             
             
                 for (NSString *key in resultsDic)
                 {
                    
                     if([user respondsToSelector:NSSelectorFromString(key)])
                     {
                         
                    [user setValue:[resultsDic valueForKey:key ] forKey:key];
                      
                         
                     }
                 }
          
                 user.profilePictureUrl = resultsDic[@"profile_picture"];
                 user.fullName = resultsDic[@"full_name"];
                 user.counts = resultsDic[@"counts"];
                 user.mediaCount = resultsDic[@"counts"][@"media"];
                 user.followedByCount = resultsDic[@"counts"][@"followed_by"];
                 user.followsCount = resultsDic[@"counts"][@"follows"];
                 [images addObject:user];
             }
             
         }
         else
         {
             
             for (NSDictionary *imagesDic in resultsWithoutNull)
             {
                 InstaMedia *media = [[InstaMedia alloc]init];
                 
                 for (NSString *key in imagesDic)
                 {
                     if([media respondsToSelector:NSSelectorFromString(key)])
                     {
                         
                         
                         if  ([imagesDic valueForKey:key])
                         {
                             /*if ([key isEqualToString:@"location"])
                             {
                                 NSLog(@"imagesDic: %@", imagesDic);
                                 
                                 media.latitude = imagesDic[@"location"][@"latitude"];
                                 media.longitude = imagesDic[@"location"][@"longtitude"];
                                 NSString *string = imagesDic[@"location"][@"latitude"];
                                 media.latitude = string;
                                 NSString *string2 = imagesDic[@"location"][@"longtitude"];
                                 media.longitude = string2;
                          //       NSLog(@"string: %@", string);
                             }
                             else
                             {
                             */
                                 //([imagesDic valueForKey:key] && (![[imagesDic valueForKey:key] isEqual:[NSNull null]]) && (![[imagesDic valueForKey:key] isEqual:@"<null>"]))
                                 [media setValue:[imagesDic valueForKey:key ] forKey:key];
                            // }
                             
                         }
                         else
                         {
                             continue;
                         }
                         
                     }
                     
                     
                     
                     
                 }
                 
                 
                 
                 
                 
                 [images addObject:media];
             }

             
             
             
         }
         
         
         
         
         
         
         [[NSNotificationCenter defaultCenter] postNotification:
          [NSNotification notificationWithName:downloadType object:nil]];
      
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error bij download:%@ - %@",downloadType, [error localizedDescription]);
     }];
    [operation start];
    return images;
}

/*
- (void)parseJson:(NSArray *)json withObject:(id*)userClass andPutInArray:(NSMutableArray *)array
{
    
    for (NSDictionary *imagesDic in json)
    {
        
        
        
        for (NSString *key in imagesDic)
        {
            if([userClass respondsToSelector:NSSelectorFromString(key)])
            {
                
                if  ([imagesDic valueForKey:key] && (![[imagesDic valueForKey:key] isEqual:[NSNull null]]) && (![[imagesDic valueForKey:key] isEqual:@"<null>"]))
                {
                    //([[imagesDic valueForKey:key] isKindOfClass:[NSNull class]]) check
                    [id setValue:[imagesDic valueForKey:key ] forKey:key];
                }
                else
                {
                    continue;
                }
                
            }
        }
        [array addObject:media];
    }

}
*/

- (void)handleOAuthCallbackWithUrl:(NSURL *)url
{
   // NSLog(@"AuthCode: %@", [self parseQueryString:[url absoluteString]]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"auth_code"];
    [defaults setValue:[self parseQueryString:[url absoluteString]] forKey:@"auth_code"];
    [defaults synchronize];
    [self startConnection];
}

- (NSString *)parseQueryString:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"="];
    NSString *string = pairs[1];
  //  NSLog(@"string pair: %@", string);
    return string;
}
@end
