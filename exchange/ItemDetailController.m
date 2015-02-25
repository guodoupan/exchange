//
//  ItemDetailController.m
//  exchange
//
//  Created by Nadav Golbandi on 2/21/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ItemDetailController.h"
#import "UIImageView+AFNetworking.h"
#import "ExchangeViewController.h"

@interface ItemDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageAndOwnerLabel;
@property (weak, nonatomic) IBOutlet UITextView *descText;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UITextView *itemDescTextView;
@property (strong, nonatomic) ExchangeItem* item;
@end

@implementation ItemDetailController

-(id) initWithItem:(ExchangeItem*) item{
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameLabel.text = self.item.name;
    self.itemDescTextView.text = self.item.desc;
     UIColor *customColor = [UIColor colorWithRed:199.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1];
    [self.exchangeButton setBackgroundColor:customColor];
    
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
    
    self.ageAndOwnerLabel.text = [NSString stringWithFormat:@"Published by %@ %@",self.item.userId, formattedDateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onExchange:(id)sender {
    NSLog(@"On Exchange");
    // getting the user active items
    ExchangeViewController *evc = [[ExchangeViewController alloc] initForUser:[self.item.userId integerValue]];
    evc.requestingItem = self.item;
    [self.navigationController pushViewController:evc animated:YES];
}

- (NSArray*) fetchUserItems:(NSInteger) userId{
    return [NSArray array];
}

@end
