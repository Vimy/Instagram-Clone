//
//  UserProfileViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 14/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ResuableTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "VerkennenViewController.h"
#import "ImageDetailViewController.h"
#import "MapViewController.h"
#import "InstaClient.h"

@interface UserProfileViewController ()
{
    NSString *username;
    InstaClient *client;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    
    
    //https://www.crowleyworks.com/mobile/appendix/container_view_controllers
    [super viewDidLoad];
    
    
    client = [InstaClient sharedClient];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ResuableTableViewController *childController  = [sb instantiateViewControllerWithIdentifier:@"MainFeed"];
    
    childController.username = self.media.caption [@"from"][@"id"];
    childController.mediaSegue = self.mediaArray;
    childController.isUserView = YES;
    childController.feedArray = self.mediaArray;
    [client downloadUserFeed:self.media.caption [@"from"][@"id"]];
    
    
    [self addChildViewController:childController];
    childController.view.frame = self.containerView.bounds; // set the frame any way you want
    [self.containerView addSubview:childController.view];
    [childController didMoveToParentViewController:self];
    
    
    
    
   // NSLog(@"[USERPRF]Nu werkt het!");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMedia:) name:@"changeToView" object:nil];
    [self setupUI];
 // http://stackoverflow.com/questions/5210535/passing-data-between-view-controllers
// http://stackoverflow.com/questions/15540120/passing-data-to-container-view
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMedia:) name:@"changeToView" object:nil];
  //   NSLog(@"[USERPRF]Nu werkt viewWillAppear!");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchViews:(UISegmentedControl *)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if(sender.selectedSegmentIndex == 0)
    {
        
        ResuableTableViewController *newVC;
        newVC = [sb instantiateViewControllerWithIdentifier:@"MainFeed"];
        newVC.mediaSegue = self.mediaArray;
        newVC.isUserView = YES;
        newVC.feedArray = self.mediaArray;
        UIViewController *vc = self.childViewControllers[0];
       // [client downloadUserFeed:self.media.caption [@"from"][@"username"]];
        [self swapFromViewController:vc toViewController:newVC ];
    }
   else if(sender.selectedSegmentIndex == 1)
    {
            VerkennenViewController *newVC;
            newVC = [sb instantiateViewControllerWithIdentifier:@"collectionView"];
            newVC.mediaSegue = self.mediaArray;
            UIViewController *vc = self.childViewControllers[0];
        
            [self swapFromViewController:vc toViewController:newVC ];
    }
    else if(sender.selectedSegmentIndex == 2)
    {
        MapViewController *newVC;
        newVC = [sb instantiateViewControllerWithIdentifier:@"mapView"];
        UIViewController *vc = self.childViewControllers[0];
        [self swapFromViewController:vc toViewController:newVC];
    }
    
   
    
    
}

- (void)getMedia:(NSNotification *)notification
{
  //  NSLog(@"[USERPRF]Nu werkt het!");
    InstaMedia *media = [[notification userInfo] valueForKey:@"media"];
    self.media = media;
    [self setupUI];
}

- (void)setupUI
{
    username = self.media.caption [@"from"][@"username"];
    self.usernameLabel.text = username;
 //   NSLog(@"USERPRF]username: %@", username);
    
    NSURL *url = [NSURL URLWithString:self.media.caption [@"from"][@"profile_picture"]];
 
    [self.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"none.gif"]];
    
   self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
   self.profileImage.layer.borderWidth = 0.5f;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
}


- (void)swapFromViewController:(UIViewController *)oldVC toViewController:(UIViewController *)newVC
{
    newVC.view.frame = oldVC.view.frame;
    [oldVC willMoveToParentViewController:nil];
    [self addChildViewController:newVC];
    [self transitionFromViewController:oldVC toViewController:newVC duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
    } completion:^(BOOL finished){
        [oldVC removeFromParentViewController];
        [newVC didMoveToParentViewController:self];
    }];
    
}
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
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
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
