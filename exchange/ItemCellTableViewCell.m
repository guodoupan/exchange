//
//  ItemCellTableViewCell.m
//  exchange
//
//  Created by Nadav Golbandi on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ItemCellTableViewCell.h"

@interface ItemCellTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wantedLabel;

@end

@implementation ItemCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setItem:(ExchangeItem *)item{
    _item = item;
    self.nameLabel.text = self.item.name;
    self.wantedLabel.text = [NSString stringWithFormat:@"Wanted:%ldd",(long) self.item.wanted];
    
    if (self.item.imageFile) {
        [self.item.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                [self.itemImageView setImage:image];
            }
        }];
    } else {
        // Image placeholder for non-image case
        [self.itemImageView setImage:[UIImage imageNamed:@"picColored"]];
    }
}
@end
