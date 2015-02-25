//
//  TransactionCell.m
//  exchange
//
//  Created by Doupan Guo on 2/25/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "TransactionCell.h"

@interface TransactionCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation TransactionCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(ExchangeItem *)requestedItem {
    _item = requestedItem;
    self.nameLabel.text = requestedItem.name;
}

- (void)setIcon:(UIImage *)image {
    self.iconImage.image = image;
}

- (IBAction)onAccept:(id)sender {
    [self.delegate transactionCell:self accepted:YES];
}
- (IBAction)onReject:(id)sender {
    [self.delegate transactionCell:self accepted:NO];
}

@end
