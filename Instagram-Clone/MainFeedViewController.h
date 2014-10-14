//
//  MainFeedViewController.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 4/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaMedia.h"

@interface MainFeedViewController : UITableViewController

//@property (nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) NSArray *mediaSegue;
@property BOOL isUserView;
@property (strong, nonatomic) NSString *username;

@end
