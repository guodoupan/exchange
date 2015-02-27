//
//  TransactionViewController.m
//  exchange
//
//  Created by Doupan Guo on 2/25/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "TransactionViewController.h"

@interface TransactionViewController () <UITableViewDataSource, UITableViewDelegate, TransactionCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    
    [self loadTransaction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"requestedItemId" equalTo:self.requestedItem.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"transaction item:%lu", (unsigned long)objects.count);
        } else {
            NSLog(@"transaction error: %@", error);
        }
    }];
}


- (void)loadTransaction {
    PFQuery *query = [PFQuery queryWithClassName:@"ExchangeItem"];
    PFQuery *transactionQuery = [PFQuery queryWithClassName:@"Transaction"];
    [transactionQuery whereKey:@"requestedItemId" equalTo:self.requestedItem.objectId];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"objectId" matchesKey:@"requestingItemId" inQuery:transactionQuery];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            NSLog(@"load transaction:%ld", objects.count);
            self.dataArray = [ExchangeItem exchangeItemsWithArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.item = self.dataArray[indexPath.row];
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell"];
    ExchangeItem *item = self.dataArray[indexPath.row];
    cell.item = item;
    
    if (item.imageFile != nil) {
        [item.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            NSLog(@"get data success %ld", indexPath.row);
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                [cell setIcon:image];
            }
        }];
    }
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)transactionCell:(TransactionCell *)cell accepted:(BOOL)didAccecpted {
     PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"requestedItemId" equalTo:self.requestedItem.objectId];
    [query whereKey:@"requestingItemId" equalTo:cell.item.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            object[@"status"] = @(didAccecpted ? TransactionAccepted : TransactionRejected);
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"save success:%d", succeeded);
                PFQuery *itemQuery = [PFQuery queryWithClassName:@"ExchangeItem"];
                [itemQuery getObjectInBackgroundWithId:self.requestedItem.objectId block:^(PFObject *object, NSError *error) {
                    if (!error) {
                        object[@"status"] = @(didAccecpted ? ItemExchangeAccepted : ItemExchangeRejected);
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                            } else {
                                NSLog(@"save item error:%@", error);
                            }
                        }];
                    } else {
                        NSLog(@"get item error: %@", error);
                    }
                }];
            }];
            
        }
    }];
    
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - setter for prototype cell
- (TransactionCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TransactionCell"];
    }
    return _prototypeCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
