//
//  FeedViewController.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 26/09/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *feedCollectionView;

@end