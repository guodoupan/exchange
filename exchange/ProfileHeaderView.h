//
//  ProfileHeaderView.h
//  exchange
//
//  Created by Doupan Guo on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class ProfileHeaderView;

@protocol ProfileHeaderViewDelegate <NSObject>

- (void)onSetting;

@end

@interface ProfileHeaderView : UIView

@property (nonatomic, weak) id<ProfileHeaderViewDelegate> delegate;

+ (id)profileHeader;

- (void)setUser: (PFUser *)user;
@end
