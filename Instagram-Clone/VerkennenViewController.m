//
//  VerkennenViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 29/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "VerkennenViewController.h"
#import "InstaClient.h"
#import "InstaMedia.h"
#import "ImageDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ResuableTableViewController.h"

@interface VerkennenViewController ()
{
    __block NSDictionary *jsonPopulairImages;
    NSArray *imagesArray;
    InstaClient *client;
    InstaMedia  *media;
    UIActivityIndicatorView *activityView;
    NSMutableArray *testArray;
}
@end

@implementation VerkennenViewController


- (void)viewDidLoad
{
    
    //http://canvaspod.io/
    
    [super viewDidLoad];
    self.collectionView.bounds = self.view.bounds;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished:)
                                                 name:@"populairFeedDownload" object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished:)
                                                 name:@"searchDownload" object:nil];
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished:)
                                                 name:@"userFeedDownload" object:nil];

    client = [InstaClient sharedClient];
    
    //[client searchForKeyWords:@"booty"];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes

  //  [client addObserver:self forKeyPath:@"imagesArray" options:0 context:NULL];
   // [client addObserver:self forKeyPath:@"searchImagesArray" options:0 context:NULL];
    
    // Do any additional setup after loading the view.
    
    if (self.isInUserView)
    {
       // self.isInUserView = NO;
        imagesArray = self.mediaSegue;
        [self.collectionView reloadData];
        NSLog(@"MediaSegue from VKVC: %@", self.mediaSegue);
    }
    else
    {
        
    
        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = self.view.center;
        [activityView startAnimating];
        [self.collectionView addSubview:activityView];
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        dispatch_queue_t backGroundQue = dispatch_queue_create("instaqueue", NULL);
        
        dispatch_sync(backGroundQue, ^{
            
            testArray = [[NSMutableArray alloc]initWithArray:[client startConnectionPopulairFeed]];
            //     NSLog(@"[VKViewController]TestArray: %@", testArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if (self.isInUserView)
    {
        self.isInUserView = NO;
        imagesArray = self.mediaSegue;
        [self.collectionView reloadData];
        NSLog(@"MediaSegue from VKVC: %@", self.mediaSegue);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}



- (void)downloadFinished:(NSNotification *)notification
{
    [activityView stopAnimating];
    if ([notification.name isEqualToString:@"searchDownload"])
    {
        imagesArray = client.searchImagesArray;
        [self.collectionView reloadData];
    }
    else if ([notification.name isEqualToString:@"populairFeedDownload"])
    {
        imagesArray = client.imagesArray;
        [self.collectionView reloadData];
    }
    else
    {
        imagesArray = client.personalImagesArray;
        [self.collectionView reloadData];
    }

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *keyword = self.searchBar.text;
     [activityView startAnimating];
    [client searchForKeyWords:keyword];
  //  NSLog(@"Werkt!");
}
/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [activityView stopAnimating];
    //KVO checken per property & juiste actie nemen
    if ([keyPath isEqual:@"searchImagesArray"])
    {
        NSLog(@"Keypath is: %@", keyPath);
        NSLog(@"[VKViewController]searchImagesArray called");
        NSLog(@"SearchImagesArray : %@", client.searchImagesArray);
        imagesArray = client.searchImagesArray;
        [self.collectionView reloadData];
    }
    else
    {
        NSLog(@"Keypath is: %@", keyPath);
        NSLog(@"[VKViewController]imagesArray called");
        imagesArray = client.imagesArray;
        
        [self.collectionView reloadData];
    }
    
    
   
    

 
}
*/
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (imagesArray)
    {
        return [imagesArray count];
    }
    else
    {
        return 40;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *cellImageView = (UIImageView *) [cell viewWithTag:100];
    if (imagesArray)
    {
           media = [imagesArray objectAtIndex:indexPath.row];
    }
    NSDictionary *tiet = [media.images objectForKey:@"thumbnail"];
    
    NSURL *url = [NSURL URLWithString:[tiet objectForKey:@"url"]];
    [cellImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"graybox.jpg"]];

    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tiet"])
    { 
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems]objectAtIndex:0];
        ResuableTableViewController *vc = (ResuableTableViewController *)segue.destinationViewController;
        InstaMedia *segueMedia = [[InstaMedia alloc]init];
        segueMedia = [imagesArray objectAtIndex:indexPath.row];
        NSString *username = segueMedia.caption[@"from"][@"username"];
        vc.isImageDetailView = YES;
        vc.mediaSegue = @[segueMedia];
        vc.feedArray = @[segueMedia];
        
    }
}



/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
