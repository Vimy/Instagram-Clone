//
//  AppDelegate.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 26/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "AppDelegate.h"
#import "InstaClient.h"
#import "AFNetworking.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"Deze url krijgen we: %@", url);
    NSLog(@"Dit is de query url: %@", [url query]);
    
    InstaClient *client = [InstaClient sharedClient];
    [client handleOAuthCallbackWithUrl:url];
    
    return YES;
    
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x0517fa4)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, -1); //[NSValue valueWithUIOffset:UIOffsetMake(0, -1)]
    
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                           NSShadowAttributeName:shadow ,
                                                           NSFontAttributeName: [UIFont fontWithName:@"Billabong" size:40.0],
                                                           }];    // Override point for customization after application launch.
    
    [[UITabBar appearance] setBarTintColor:UIColorFromRGB(0x0515151)];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
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
