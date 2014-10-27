//
//  MainFeedViewController.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 4/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaMedia.h"

@interface ResuableTableViewController : UITableViewController

//@property (nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) NSArray *mediaSegue;
@property BOOL isUserView;
@property BOOL isImageDetailView;
@property BOOL isFeedView;
@property (strong, nonatomic) NSString *username;
@property (nonatomic, copy) NSArray *feedArray;
@end
