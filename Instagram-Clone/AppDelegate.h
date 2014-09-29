//
//  AppDelegate.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 26/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSString *)parseQueryString:(NSString *)query;

@end

