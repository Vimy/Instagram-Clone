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
    
    
   
  
 // http://stackoverflow.com/questions/5210535/passing-data-between-view-controllers
// http://stackoverflow.com/questions/15540120/passing-data-to-container-view
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    client = [InstaClient sharedClient];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished)
                                                 name:@"userInfo" object:nil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(getMedia:)
                                                   name:@"changeToView" object:nil];
    
    if (self.navigationController.tabBarController.selectedIndex == 4)
    {
        [client downloadUserInfo:@"self"];
    }
    else
    {
     
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ResuableTableViewController *childController  = [sb instantiateViewControllerWithIdentifier:@"MainFeed"];
        
        childController.username = self.media.caption [@"from"][@"id"];
        childController.mediaSegue = self.mediaArray;
        childController.isUserView = YES;
        childController.feedArray = self.mediaArray;
        //  [client downloadUserFeed:self.media.caption [@"from"][@"id"]];
        
        
        [client downloadUserInfo:self.media.caption [@"from"][@"id"]];
        
        
        [self addChildViewController:childController];
        childController.view.frame = self.containerView.bounds; // set the frame any way you want
        [self.containerView addSubview:childController.view];
        [childController didMoveToParentViewController:self];
        
        
        
        
        // NSLog(@"[USERPRF]Nu werkt het!");
      
    }
}

-(void)setUserID:(NSString *)userID
{
    _userID = userID;
    [client downloadUserFeed:userID];
    NSLog(@"userID set");
}

- (void)downloadFinished
{

    
    
    self.mediaArray = client.personalImagesArray;
    NSLog(@"Setup UI called");
    [self setupUI];

}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMedia:) name:@"changeToView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished)
                                                 name:@"userInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished)
                                                 name:@"userFeedDownload" object:nil];
  
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
           // newVC.mediaSegue = self.mediaArray;
            newVC.isInUserView = YES;
            [client downloadUserFeed:self.media.caption [@"from"][@"id"]];
            UIViewController *vc = self.childViewControllers[0];
        
            [self swapFromViewController:vc toViewController:newVC ];
    }
    else if(sender.selectedSegmentIndex == 2)
    {
        MapViewController *newVC;
        newVC = [sb instantiateViewControllerWithIdentifier:@"mapView"];
        newVC.photosByUser = self.mediaArray;
        UIViewController *vc = self.childViewControllers[0];
        [self swapFromViewController:vc toViewController:newVC];
    }
    
   
    
    
}

- (void)getMedia:(NSNotification *)notification
{
  //  NSLog(@"[USERPRF]Nu werkt het!");
    InstaMedia *media = [[notification userInfo] valueForKey:@"media"];
    self.media = media;
    //[self setupUI];
}

- (void)setupUI
{
    InstaUser *user = client.userInfoArray[0];
     self.usernameLabel.text = user.username;
    

    NSURL *url = [NSURL URLWithString:user.profilePictureUrl];
    
    [self.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"none.gif"]];
    self.userFollowersCountLabel.text = [user.followedByCount stringValue];
    self.userMediaCountLabel.text = [user.mediaCount stringValue];
    self.userFollowingCountLabel.text = [user.followsCount stringValue];
    self.userOnderschriftLabel.text = user.bio;
  
    

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

@end
