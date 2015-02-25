//
//  TransactionCell.h
//  exchange
//
//  Created by Doupan Guo on 2/25/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"
#import "ExchangeItem.h"

@class TransactionCell;

@protocol TransactionCellDelegate <NSObject>

- (void)transactionCell: (TransactionCell *)cell accepted: (BOOL)didAccecpted;

@end

@interface TransactionCell : UITableViewCell

@property (nonatomic, strong) ExchangeItem *item;
@property (nonatomic, weak) id<TransactionCellDelegate> delegate;

- (void)setIcon: (UIImage *)image;
@end
