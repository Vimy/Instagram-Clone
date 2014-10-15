//
//  ImageDetailViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 1/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "ImageDetailViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "AFNetworking.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   NSString *likes = [[self.media.likes objectForKey:@"count"]stringValue];
    NSString *likesTekst = [NSString stringWithFormat:@"vind-ik-leuks"];
    self.likesCount.text = [NSString stringWithFormat:@"%@ %@", likes, likesTekst];
    NSLog(@"[IDVC]Likes: %@", [self.media.likes objectForKey:@"count"] );
    
    NSDictionary *tiet = [self.media.images objectForKey:@"standard_resolution"];
    
    NSURL *url = [NSURL URLWithString:[tiet objectForKey:@"url"]];
    
    NSDictionary *userDict = [self.media.caption objectForKey:@"from"];
    NSString *username = [userDict  objectForKey:@"username"];
    NSLog(@"[VKVC]userDict: %@", userDict);
    
    NSURL *urlProfilePic = [NSURL URLWithString:[userDict objectForKey:@"profile_picture"]];
    NSLog(@"[VKVC]profileURL: %@", urlProfilePic);
    NSData *dataProfilePic = [NSData dataWithContentsOfURL:urlProfilePic];
    UIImage *imageProfilePic = [UIImage imageWithData:dataProfilePic];
    self.profileImage.image = imageProfilePic;
    self.imageProfile.image = imageProfilePic;
    self.titleLabel.text = username;

    
    NSURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:request2];
    operation2.responseSerializer = [AFImageResponseSerializer serializer];
    [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        self.mainImage.image = responseObject;
        NSLog(@"ResponseObject: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];


    [operation2 start];
    
    if (self.profileImage.image)
    {
        NSLog(@"het werkt");
    }
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 0.5f;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.imageProfile.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.imageProfile.clipsToBounds = YES;
    self.imageProfile.layer.borderWidth = 0.5f;
    self.imageProfile.layer.borderColor = [UIColor whiteColor].CGColor;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
