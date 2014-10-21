//
//  MainFeedViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 4/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "MainFeedViewController.h"
#import "InstaClient.h"
#import "InstaMedia.h"
#import "CustomHeaderViewCell.h"
#import "CustomFooterViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MainCell.h"
#import "TLYShyNavBarManager.h"
#import "UserProfileViewController.h"

@interface MainFeedViewController () <UserProfileViewControllerDelegate>
{
    
    InstaClient *client;
    InstaMedia  *media;
    InstaMedia *mediaHeader;
    InstaMedia *mediaFooter;
    InstaMedia *tempMedia;
  
}
@end
//http://stackoverflow.com/questions/19819165/imitate-ios-7-facebook-hide-show-expanding-contracting-navigation-bar
@implementation MainFeedViewController

- (void)viewDidLoad
{
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished)
                                                 name:@"personalFeedDownload" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished)
                                                 name:@"userFeedDownload" object:nil];

    
 
    client = [InstaClient sharedClient];

    [super viewDidLoad];
    [client startConnection];
    
    //navbar omhoog duwen
    //self.shyNavBarManager.scrollView = self.tableView;
    
    
    //http://stackoverflow.com/questions/19819165/imitate-ios-7-facebook-hide-show-expanding-contracting-navigation-bar
    //http://stackoverflow.com/questions/17499391/ios-nested-view-controllers-view-inside-uiviewcontrollers-view
    [self.tableView registerNib:[UINib nibWithNibName:@"headerCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"footerCell" bundle:nil] forCellReuseIdentifier:@"footerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"mainCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
  //  [client addObserver:self forKeyPath:@"personalImagesArray" options:0 context:NULL];
   
  
    
    
}


-  (void)viewWillAppear:(BOOL)animated
{
   // NSLog(@"TABBAR: %lu", (unsigned long)[self.tabBarController selectedIndex]);
    if(self.tabBarController.selectedIndex == 3)
    {
        [client downloadUserFeed:@"self"];
        NSLog(@"HOIIIII!");
    }
    else
    {
        
        if (!self.mediaSegue)
        {
            dispatch_queue_t backGroundQue = dispatch_queue_create("instaqueue", NULL);
            
            dispatch_sync(backGroundQue, ^{
                
                [client startPersonalFeed];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
            
        }
        else
        {
            if (self.isImageDetailView)
            {
                _feedArray = self.mediaSegue;
            }
            else
            {
                [client downloadUserFeed:self.username];
            }
        }

    
    
    
    }

    

}

- (void)dataFromController:(InstaMedia *)media
{
    
}
- (void)downloadFinished
{
    self.feedArray = client.personalImagesArray;
    NSLog(@"Dit gebeurd nu!");
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    //KVO checken per property & juiste actie nemen
    if ([keyPath isEqual:@"personalImagesArray"])
    {
        NSLog(@"Keypath is: %@", keyPath);
        NSLog(@"[VKViewController]personalImagesArray called");
     //   feedArray = [[NSMutableArray alloc]init];
        feedArray = client.personalImagesArray;
        NSLog(@"FeedArray: %@", feedArray);
        [self.tableView reloadData];
    }
   
}
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_feedArray)
    {
        return [_feedArray count];
    }
    else
    {
        return 10;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
        return 1 ;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    mediaFooter = [feedArray objectAtIndex:section];
    
    
    CustomFooterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"footerCell"];
    if (cell==nil) {
        cell = [[CustomFooterViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footerCell"];
    //    NSLog(@"Footercell is nil");
    }
  //  NSLog(@"We zijn er mee bezig! -- FooterCell");

    return cell;
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    mediaHeader = [_feedArray objectAtIndex:section];
    tempMedia = [_feedArray objectAtIndex:section]; // mediaHeader;
    if (tempMedia)
    {
   //     NSLog(@"TEMPMEDIA IS VOL");
    }
    CustomHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    if (cell==nil) {
        cell = [[CustomHeaderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        NSLog(@"Cell is nil");
    }
    cell.delegate = self;
    
    UILabel *likesLabel = (UILabel *) [cell viewWithTag:10];
    
    NSString *likes =[mediaHeader.likes objectForKey:@"count"];
    NSString *likesTekst = [NSString stringWithFormat:@"vind-ik-leuks"];
    likesLabel.text = [NSString stringWithFormat:@"%@ %@", likes, likesTekst];
    
    
    NSString *username = mediaHeader.caption [@"from"][@"username"];
    
    
    NSURL *url = [NSURL URLWithString:mediaHeader.caption [@"from"][@"profile_picture"]];
      [cell.usernameButton setTitle:username forState:UIControlStateNormal];
    [cell.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"none.gif"]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH"];
    
    NSTimeInterval timeInterval = (NSTimeInterval)mediaHeader.created_time;
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDate *now = [NSDate date];
   
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian  ];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitDay;
    NSDateComponents *components = [myCalendar components:unitFlags
                                                 fromDate:timestamp
                                                   toDate:now options:0];

   NSLog(@"Tijd gepasseerd in dagen: %ld | Tijd gepasseerd in uren: %ld ", (long)[components day], (long)[components hour]);
  
    if ([components hour] > 24)
    {
        cell.time.text = [NSString stringWithFormat:@"%ld u",(long)[components day] ];
    }
    else
    {
        cell.time.text = [NSString stringWithFormat:@"%ld u",(long)[components hour] ];

    }
  
    
    cell.time.text = [NSString stringWithFormat:@"%ld u",(long)[components hour] ];

    cell.profileImage.clipsToBounds = YES;
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
    cell.profileImage.layer.borderWidth = 2.0f;
    cell.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    return cell;
 
}
//http://www.reddit.com/r/iOSProgramming/comments/2jcboi/the_best_way_to_get_notified_when_the_data_is/

-(void)loadNewScreen:(UserProfileViewController *)controller
{
    //cell delegate
    NSLog(@"WEEEERKT DIT WEEEEELLLL????");
      [self.navigationController pushViewController:controller animated:YES];
        NSDictionary *dic = @{@"media":tempMedia };
    controller.delegate = self;
    controller.media = tempMedia;
    controller.mediaArray = @[tempMedia];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"changeToView" object:nil userInfo:dic]];

 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (cell==nil) {
        cell = [[MainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
        NSLog(@"Cell is nil");
    }

    if (_feedArray)
    {
        media = [_feedArray objectAtIndex:indexPath.section];
        NSURL *url = [NSURL URLWithString:media.images[@"standard_resolution"][@"url"]];
        [ cell.mainImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"graybox.jpg"]];
        
        NSString *likes =[mediaHeader.likes objectForKey:@"count"];
        NSString *likesTekst = [NSString stringWithFormat:@"vind-ik-leuks"];
        cell.likesCountLabel.text = [NSString stringWithFormat:@"%@ %@", likes, likesTekst];
        
       
        
    }

       return cell;
}






/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
