//
//  CustomHeaderViewCell.m
//  
//
//  Created by Matthias Vermeulen on 4/10/14.
//
//

#import "CustomHeaderViewCell.h"
@implementation CustomHeaderViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.usernameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)taptap:(UIButton *)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    UserProfileViewController *storyboardView =
    [storyboard instantiateViewControllerWithIdentifier:@"userView"];
    NSLog(@"SectionTAPPED: %ld", (long)sender.tag);
    [self.delegate loadNewScreen:storyboardView fromSection:sender.tag] ;
    
}

@end
