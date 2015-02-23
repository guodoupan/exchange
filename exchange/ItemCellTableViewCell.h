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


@protocol SwitchCellDelegate <NSObject>

- (void) ItemCellTableViewCell: (ItemCellTableViewCell*) cell didUpdateValue:(BOOL)value;

@end

@interface ItemCellTableViewCell : UITableViewCell
@property(nonatomic, strong) ExchangeItem* item;

@property (nonatomic, assign) BOOL on;
@property (weak, nonatomic) id<SwitchCellDelegate> delegate;

-(void) setOn:(BOOL)on animated:(BOOL) animated;

@end
