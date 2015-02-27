//
//  TransactionViewController.h
//  exchange
//
//  Created by Doupan Guo on 2/25/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeItem.h"
#import "TransactionCell.h"
#import "Transaction.h"
#import "Constants.h"

@interface TransactionViewController : UIViewController

@property (nonatomic, strong) ExchangeItem *requestedItem;
@property (nonatomic, strong) TransactionCell *prototypeCell;

@end
