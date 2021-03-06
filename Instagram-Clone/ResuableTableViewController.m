//
//  MainFeedViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 4/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "ResuableTableViewController.h"
#import "InstaClient.h"
#import "InstaMedia.h"
#import "CustomHeaderViewCell.h"
#import "CustomFooterViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MainCell.h"
#import "TLYShyNavBarManager.h"
#import "UserProfileViewController.h"

@interface ResuableTableViewController () <UserProfileViewControllerDelegate>
{
    
    InstaClient *client;
    InstaMedia  *media;
    InstaMedia *mediaHeader;
    InstaMedia *mediaFooter;
    InstaMedia *tempMedia;
    NSString *userID;
}
@end
//http://stackoverflow.com/questions/19819165/imitate-ios-7-facebook-hide-show-expanding-contracting-navigation-bar
@implementation ResuableTableViewController

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
  //  NSLog(@"viewDidLoad");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished)
                                                 name:@"personalFeedDownload" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished)
                                                 name:@"userFeedDownload" object:nil];

 
    client = [InstaClient sharedClient];

    
    
   [client startConnection];
     // [client startPersonalFeed];
   
  
    self.isFeedView = YES;
    

  
    
    //navbar omhoog duwen
    self.shyNavBarManager.scrollView = self.tableView;
    
    
    //http://stackoverflow.com/questions/19819165/imitate-ios-7-facebook-hide-show-expanding-contracting-navigation-bar
    //http://stackoverflow.com/questions/17499391/ios-nested-view-controllers-view-inside-uiviewcontrollers-view
    [self.tableView registerNib:[UINib nibWithNibName:@"headerCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"footerCell" bundle:nil] forCellReuseIdentifier:@"footerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"mainCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
  //  [client addObserver:self forKeyPath:@"personalImagesArray" options:0 context:NULL];
   
}
/*
- (void)viewWillDisappear:(BOOL)animated
{
    self.feedArray = nil;
    [self.tableView reloadData];
    NSLog(@"View gaat weg!");
}
*/

- (void)authenticateWithInstagram
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self; //delegate gebruiken van navigationController zodat willShowViewController kan gebruikt worden
  /*
    NSLog(@"viewDidAppear");
    NSLog(@"TABBAR: %lu", (unsigned long)   self.navigationController.tabBarController.selectedIndex);
    NSLog(@"isUserView");
    NSLog(self.isUserView ? @"Yes" : @"No");
    NSLog(@"sImageDetailView");
    NSLog(self.isImageDetailView ? @"Yes" : @"No");
    NSLog(@"isFeedView");
    NSLog(self.isFeedView ? @"Yes" : @"No");*/
    if (self.isImageDetailView)
    {
        _feedArray = self.mediaSegue;
        NSLog(@"segue nu!");
    }
    else
    {
        switch (self.navigationController.tabBarController.selectedIndex)
        {
            case 0:
                NSLog(self.isUserView ? @"Yes" : @"No");
                self.isUserView ? [client downloadUserFeed:self.username] : [client startPersonalFeed];
                self.isUserView = NO;
                break;
            case 3:
                [client downloadUserFeed:@"self"];
            default:
                break;
        }

    }

}
-  (void)viewWillAppear:(BOOL)animated
{
  //  NSLog(@"viewWillAppear");
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    self.isUserView = NO;
}

- (void)downloadFinished
{
    self.feedArray = client.personalImagesArray;
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
/*
/*
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
    NSLog(@"SECTON: %li", (long)section);
   
    mediaHeader = [_feedArray objectAtIndex:section];
    tempMedia = [_feedArray objectAtIndex:section]; // mediaHeader;
    if (tempMedia)
    {
    }
    CustomHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    if (cell==nil) {
        cell = [[CustomHeaderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        NSLog(@"Cell is nil");
    }
    cell.delegate = self;
    
    
    cell.usernameButton.tag = section;
    
    NSLog(@"Latitude: %@", mediaHeader.latitude);
     NSLog(@"Longitude: %@", mediaHeader.longitude);
    
    UILabel *likesLabel = (UILabel *) [cell viewWithTag:10];
    
    NSString *likes =[mediaHeader.likes objectForKey:@"count"];
    NSString *likesTekst = [NSString stringWithFormat:@"vind-ik-leuks"];
    likesLabel.text = [NSString stringWithFormat:@"%@ %@", likes, likesTekst];
   
    
    NSString *inStr = [NSString stringWithFormat: @"%ld", (long)section];
    cell.sectionTestLabel.text = inStr;
    
    NSString *username = mediaHeader.caption [@"from"][@"username"];
    userID = mediaHeader.caption [@"from"][@"id"];
    
    
    NSURL *url = [NSURL URLWithString:mediaHeader.caption [@"from"][@"profile_picture"]];
      [cell.usernameButton setTitle:username forState:UIControlStateNormal];
    [cell.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"none.gif"]];
  
    NSTimeInterval timeInterval = (NSTimeInterval)mediaHeader.created_time;
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDate *now = [NSDate date];
   
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian  ];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitDay;
    NSDateComponents *components = [myCalendar components:unitFlags
                                                 fromDate:timestamp
                                                   toDate:now options:0];

  // NSLog(@"Tijd gepasseerd in dagen: %ld | Tijd gepasseerd in uren: %ld ", (long)[components day], (long)[components hour]);
  
    if ([components day] > 0)
    {
        cell.time.text = [NSString stringWithFormat:@"%ldd",(long)[components day] ];
      //  NSLog(@"Meer dan een dag");
    }
    else
    {
        cell.time.text = [NSString stringWithFormat:@"%ldu",(long)[components hour] ];

    }
  
    
   // cell.time.text = [NSString stringWithFormat:@"%ld u",(long)[components hour] ];

    cell.profileImage.clipsToBounds = YES;
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
    cell.profileImage.layer.borderWidth = 2.0f;
    cell.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    return cell;
 
}
//http://www.reddit.com/r/iOSProgramming/comments/2jcboi/the_best_way_to_get_notified_when_the_data_is/


-(void)loadNewScreen:(UserProfileViewController *)controller fromSection:(NSInteger )section
{
    
    //cell delegate
  //  NSLog(@"WEEEERKT DIT WEEEEELLLL????");
    tempMedia = [_feedArray objectAtIndex:section];
    
    // NSLog(@"FeedArray: %@", self.feedArray);
    NSString *logString= tempMedia.caption [@"from"][@"username"];
    NSLog(@"Name: %@", logString);
    
    NSDictionary *dic = @{@"media":tempMedia };
    controller.delegate = self;
    controller.media = tempMedia ;
    controller.mediaArray = @[tempMedia ];
    controller.userID = userID;
    self.isUserView = YES;
    self.feedArray = nil;
    [self.tableView reloadData];
   [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"changeToView" object:nil userInfo:dic]];
    [self.navigationController pushViewController:controller animated:YES];
    
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
        
        NSString *likes =[[media.likes objectForKey:@"count"]stringValue];
        NSLog(@"Likes: %@", [media.likes objectForKey:@"count"]);
        NSString *likesTekst = [NSString stringWithFormat:@"vind-ik-leuks"];
        cell.likesCountLabel.text = [NSString stringWithFormat:@"%@ %@", likes, likesTekst];
        NSString *username = media.caption [@"from"][@"username"];
        NSString *tekst = media.caption [@"text"];
     //   NSLog(@"ONderschrift: %@", media.caption);
        NSLog(@"Username: %@", media.username);
        cell.onderschriftLabel.text = [NSString stringWithFormat:@"%@ %@", username, tekst];
       
        
    }

       return cell;
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Test");
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
