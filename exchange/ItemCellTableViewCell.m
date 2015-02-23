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
@property (weak, nonatomic) IBOutlet UILabel *userAndTimeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *exchangeSelector;

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
    
    NSTimeInterval elapsedTimeInterval = [self.item.createdAt timeIntervalSinceNow];
    int elapsedSeconds = (int)(elapsedTimeInterval * -1);
    
    NSLog(@"%d", elapsedSeconds);
    NSString* formattedDateString;
    if (elapsedSeconds < 60) {
        formattedDateString = @"just now";
    }
    else if (elapsedSeconds < 3600) {
        int minutes = elapsedSeconds / 60;
        formattedDateString = [NSString stringWithFormat:@"in %dm", minutes];
    }
    else if (elapsedSeconds < 86400) {
        int hours = elapsedSeconds / 3600;
        formattedDateString = [NSString stringWithFormat:@"in %dh", hours];
    }
    else if (elapsedSeconds < 31536000) {
        int days = elapsedSeconds / 86400;
        formattedDateString = [NSString stringWithFormat:@"in %dd", days];
    }
    else {
        int years = elapsedSeconds / 31536000;
        formattedDateString = [NSString stringWithFormat:@"in %dyr", years];
    }
    
    self.userAndTimeLabel.text = [NSString stringWithFormat:@"Published by %@ %@",self.item.userId, formattedDateString];

}

-(void) setOn:(BOOL)on{
    [self setOn:on animated:NO];
}

-(void) setOn:(BOOL)on animated:(BOOL) animated{
    _on = on;
    [self.exchangeSelector setOn:on animated:animated];
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate ItemCellTableViewCell:self didUpdateValue:self.exchangeSelector.on];
}


@end
