//
//  ItemCellTableViewCell.h
//  exchange
//
//  Created by Nadav Golbandi on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeItem.h"

@class ItemCellTableViewCell;

@interface ItemCellTableViewCell : UITableViewCell
@property(nonatomic, strong) ExchangeItem* item;
- (void) selectionImageHiddenSwitch;
- (void) selectionImageHidden:(BOOL)hidden;
@end
