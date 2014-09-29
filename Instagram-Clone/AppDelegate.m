//
//  AppDelegate.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 26/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "AppDelegate.h"
#import "InstaClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"Deze url krijgen we: %@", url);
    NSLog(@"Dit is de query url: %@", [url query]);
    
    //experiment
   /* curl \-F 'client_id=CLIENT-ID' \
    -F 'client_secret=CLIENT-SECRET' \
    -F 'grant_type=authorization_code' \
    -F 'redirect_uri=YOUR-REDIRECT-URI' \
    -F 'code=CODE' \https://api.instagram.com/oauth/access_token
*/
    
    //https://gist.github.com/mombrea/8467128
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/access_token/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"38ce63e055ce48cd8f37aee2d0fe73f6" forHTTPHeaderField:@"client_id"];
    [request setValue:@"023772c25df742868e280ac8a1e0e0f4" forHTTPHeaderField:@"client_secret"];
    [request setValue:[self parseQueryString:[url absoluteString]] forHTTPHeaderField:@"grant_type"];
    [request setValue:@"instaklone://" forHTTPHeaderField:@"redirect_uri" ];
    NSURLConnection *instaConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSLog(@"url called");
    
    
    InstaClient *sharedClient = [InstaClient sharedClient];
    
    [sharedClient setInstaToken:[self parseQueryString:[url absoluteString]]];

    return YES;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *instaData = [[NSMutableData alloc]init];
    [instaData appendData:data];
    NSError *error;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:instaData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"Json is: %@", json);
   NSLog(@"Data is: %@", instaData);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connectie fail: %@", [error localizedDescription]);
}
- (NSString *)parseQueryString:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"="];
    NSLog(@"Array: %@", pairs);
    
    NSString *string = pairs[1];
    NSLog(@"string: %@", string);
    return string;
    
    
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
