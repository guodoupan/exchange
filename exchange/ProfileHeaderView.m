//
//  ProfileHeaderView.m
//  exchange
//
//  Created by Doupan Guo on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ProfileHeaderView.h"

@interface ProfileHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (nonatomic, strong) PFUser *currentUser;

@end

@implementation ProfileHeaderView

+ (id)profileHeader {
    ProfileHeaderView *profileHeader = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil] lastObject];
    if ([profileHeader isKindOfClass:[ProfileHeaderView class]]) {
        return profileHeader;
    }
    return nil;
}

- (void)setUser:(PFUser *)user {
    self.currentUser = user;
    self.nameLabel.text = user.username;
}
- (IBAction)onSetting:(id)sender {
    [self.delegate onSetting];
}

@end
