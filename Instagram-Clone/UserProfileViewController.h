//
//  UserProfileViewController.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 14/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaMedia.h"

@protocol UserProfileViewControllerDelegate <NSObject>

@required
- (void)dataFromController:(InstaMedia *)media;

@end


@interface UserProfileViewController : UIViewController
//http://stackoverflow.com/questions/16330195/change-container-view-content-with-tabs-in-ios
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) InstaMedia *media;
@property (nonatomic, weak) id<UserProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userMediaCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *userFollowingCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *userFollowersCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *userOnderschriftLabel;
@property (strong, nonatomic) NSArray *mediaArray;
@end
