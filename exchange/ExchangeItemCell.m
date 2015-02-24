//
//  ExchangeItemCell.m
//  exchange
//
//  Created by Doupan Guo on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ExchangeItemCell.h"

@interface ExchangeItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *wantLabel;
@end

@implementation ExchangeItemCell

- (void)awakeFromNib {
     self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel layoutIfNeeded];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(ExchangeItem *)item {
    if (item != nil) {
        self.nameLabel.text = item.name;
//        if (item.imageFile) {
//            NSLog(@"get image:%@", item.name);
//            [self.item.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                NSLog(@"get image error: %@", error);
//                if (!error) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    [self.iconImage setImage:image];
//                }
//            }];
//        }
    }
}

- (void)setItemImage:(UIImage *)image {
    self.iconImage.image = image;
}
@end