//
//  ExchangeViewController.h
//  exchange
//
//  Created by Nadav Golbandi on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCellTableViewCell.h"
#import "Transaction.h"
#import "Constants.h"

@interface ExchangeViewController : UIViewController

-(id) initForUser:(PFUser *) user;
@property (nonatomic, strong) PFUser *requestedUser;
@property (nonatomic, strong) ExchangeItem *requestedItem;
@property (nonatomic, strong) ItemCellTableViewCell *protoTypeCell;

@end
