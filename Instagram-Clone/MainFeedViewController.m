//
//  MainFeedViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 26/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "MainFeedViewController.h"
#import "InstaClient.h"

@interface MainFeedViewController ()
{
    InstaClient *client;
}
@end

@implementation MainFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   client = [InstaClient sharedClient];
    [client startPersonalFeed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished)
                                                 name:@"personalFeedDownload" object:nil];
    // Do any additional setup after loading the view.
}
- (void)downloadFinished
{
    self.feedArray = client.personalImagesArray;
    [self.tableView reloadData];
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
