//
//  CustomHeaderViewCell.h
//  
//
//  Created by Matthias Vermeulen on 4/10/14.
//
//

#import <UIKit/UIKit.h>

@interface CustomHeaderViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
