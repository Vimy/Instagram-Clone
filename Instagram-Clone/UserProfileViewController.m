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
#import "VerkennenViewController.h"
#import "ImageDetailViewController.h"

@interface UserProfileViewController ()
{
    NSString *username;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    MainFeedViewController *childController = [[MainFeedViewController alloc]init];
    [self addChildViewController:childController];
    childController.view.frame = self.userFeedView.bounds; // set the frame any way you want
    [self.userFeedView addSubview:childController.view];
    [childController didMoveToParentViewController:self];
    
    
    self.userCollectionView.hidden = YES;
    NSLog(@"[USERPRF]Nu werkt het!");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMedia:) name:@"changeToView" object:nil];
    [self setupUI];
 // http://stackoverflow.com/questions/5210535/passing-data-between-view-controllers
// http://stackoverflow.com/questions/15540120/passing-data-to-container-view
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMedia:) name:@"changeToView" object:nil];
     NSLog(@"[USERPRF]Nu werkt viewWillAppear!");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchViews:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.userFeedView.hidden = NO;
            self.userCollectionView.hidden = YES;
            break;
        case 1:
            self.userFeedView.hidden = YES;
            self.userCollectionView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)getMedia:(NSNotification *)notification
{
    NSLog(@"[USERPRF]Nu werkt het!");
    InstaMedia *media = [[notification userInfo] valueForKey:@"media"];
    self.media = media;
    [self setupUI];
}

- (void)setupUI
{
    username = self.media.caption [@"from"][@"username"]; //[tiet objectForKey:@"username"];
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
   self.profileImage.layer.borderWidth = 0.5f;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (IBAction)ActionMan:(UIButton *)sender
{
    ImageDetailViewController *vc = [[ImageDetailViewController alloc]init];
    MainFeedViewController *oldVC = self.childViewControllers[0];
    
    vc.view.frame = oldVC.view.frame;
    
    [oldVC willMoveToParentViewController:nil];
    [self addChildViewController:vc];
    [self transitionFromViewController:oldVC toViewController:vc duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
    } completion:^(BOOL finished){
        [oldVC removeFromParentViewController];
        [vc didMoveToParentViewController:self];
    }];
    
    
   
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showUserFeed"])
    {
        NSLog(@"segue WERKT");
        MainFeedViewController *vc = (MainFeedViewController *)segue.destinationViewController;
        vc.username = self.media.caption [@"from"][@"id"];
        vc.mediaSegue = self.mediaArray;
        vc.isUserView = YES;
        vc.feedArray = self.mediaArray;
    }
    else if ([segue.identifier isEqualToString:@"showUserFeedCollection"])
    {
        NSLog(@"segue WERKT");
        VerkennenViewController *vc = (VerkennenViewController *)segue.destinationViewController;
        vc.mediaSegue = self.mediaArray;
       
    }
    else if ([segue.identifier isEqualToString:@"showUserMap"])
    {
        NSLog(@"segue WERKT");
        VerkennenViewController *vc = (VerkennenViewController *)segue.destinationViewController;
        
    }

    
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
