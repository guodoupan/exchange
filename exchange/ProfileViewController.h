//
//  ProfileViewController.h
//  exchange
//
//  Created by Doupan Guo on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProfileHeaderView.h"
#import "Constants.h"
#import "ExchangeItem.h"
#import "ItemCellTableViewCell.h"

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) ItemCellTableViewCell *protoTypeCell;

@end
