//
//  UserProfileViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 14/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "UserProfileViewController.h"
#import "MainFeedViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *username;

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMedia:) name:@"changeToView" object:nil];

 // http://stackoverflow.com/questions/5210535/passing-data-between-view-controllers

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMedia:(NSNotification *)notification
{
    InstaMedia *media = [[notification userInfo] valueForKey:@"media"];
    self.media = media;
    [self setupUI];
}

- (void)setupUI
{
    NSString *username = self.media.caption [@"from"][@"username"]; //[tiet objectForKey:@"username"];
    self.username.text = username;
    NSLog(@"USERPRF]username: %@", username);
    
    NSURL *url = [NSURL URLWithString:self.media.caption [@"from"][@"profile_picture"]];
    NSLog(@"[USERPRF]url: %@", url);
    // NSData *data = [NSData dataWithContentsOfURL:url];
    // UIImage *image = [UIImage imageWithData:data];
    // cell.usernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"none.gif"]];
    
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.layer.borderWidth = 1.0f;
    // self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
