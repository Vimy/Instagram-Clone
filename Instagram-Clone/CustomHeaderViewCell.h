//
//  CustomHeaderViewCell.h
//  
//
//  Created by Matthias Vermeulen on 4/10/14.
//
//

#import <UIKit/UIKit.h>
#import "UserProfileViewController.h"

@protocol changeViewcontrollerProtocol <NSObject>
- (void)loadNewScreen:(UserProfileViewController *)controller;
@end

@interface CustomHeaderViewCell : UITableViewCell


@property (retain, nonatomic) id<changeViewcontrollerProtocol> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *usernameButton;

@end
