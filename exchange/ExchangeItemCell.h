//
//  ExchangeItemCell.h
//  exchange
//
//  Created by Doupan Guo on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeItem.h"
@interface ExchangeItemCell : UITableViewCell

@property (nonatomic, strong) ExchangeItem *item;
@property (nonatomic, strong) NSArray *transactionsArray;

- (void)setItemImage: (UIImage *)image;
@end
