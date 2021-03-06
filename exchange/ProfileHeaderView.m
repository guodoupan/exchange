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
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (nonatomic, strong) PFUser *currentUser;

@end

@implementation ProfileHeaderView

+ (id)profileHeader {
    ProfileHeaderView *profileHeader = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil] lastObject];
    if ([profileHeader isKindOfClass:[ProfileHeaderView class]]) {
        profileHeader.avatarImage.layer.cornerRadius = profileHeader.avatarImage.frame.size.height /2;
        profileHeader.avatarImage.layer.masksToBounds = YES;
        profileHeader.avatarImage.layer.borderWidth = 0;
        return profileHeader;
    }
    return nil;
}

- (void)setUser:(PFUser *)user {
    self.currentUser = user;
    self.nameLabel.text = user.username;
    self.emailLabel.text = user.email;
}

- (void)setAvatar:(UIImage *)image {
    self.avatarImage.image = image;
}

- (IBAction)onSetting:(id)sender {
    [self.delegate onSetting];
}

- (IBAction)onMyItemChange:(id)sender {
    [self.delegate onShowMyItems];
}



@end
