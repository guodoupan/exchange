//
//  ExchangeViewController.m
//  exchange
//
//  Created by Nadav Golbandi on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ItemCellTableViewCell.h"

@interface ExchangeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* items;
@property (strong, nonatomic) NSString* userName;
@property (nonatomic, strong) ItemCellTableViewCell * prototypeCell;
@property (nonatomic, strong) ItemCellTableViewCell* selected;
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation ExchangeViewController

-(id) initForUser:(NSInteger) userId{
    if(self = [super init]){
        PFQuery *query = [PFQuery queryWithClassName:@"ExchangeItem"];
        [query orderByDescending:@"updatedAt"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu items.", (unsigned long)objects.count);
                // Do something with the found objects
                self.items = [ExchangeItem exchangeItemsWithArray:objects];
                [self.tableView reloadData];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];    }
    self.selected = nil;
    return self;
}

- (ItemCellTableViewCell *)protoTypeCell {
    if (!_protoTypeCell) {
        _protoTypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCellTableViewCell"];
    }
    return _protoTypeCell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //update the view controller about the castom cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"ItemCellTableViewCell"];
    
    self.title = @"Choose one";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDoneButton)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) onDoneButton {
    NSLog(@"requesting: %@, requested:%@", self.requestedItem.name, self.selected.item.name);
    
    Transaction *transaction = [[Transaction alloc] init];
    transaction.requestingItemId = self.selected.item.objectId;
    transaction.requestedItemId = self.requestedItem.objectId;
    transaction.status = TransactionRequesting;
    [[transaction pfObject] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"transaction success");
            PFQuery *itemQuery = [PFQuery queryWithClassName:@"ExchangeItem"];
            [itemQuery getObjectInBackgroundWithId:self.requestedItem.objectId block:^(PFObject *object, NSError *error) {
                if (!error) {
                    NSInteger wanted = [object[@"wanted"] integerValue];
                    object[@"wanted"] = @(wanted <= 0 ? 1 : wanted + 1);
                    object[@"status"] = @(ItemExchangeRequesting);
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            [self.navigationController popViewControllerAnimated:TRUE];
                        } else {
                            NSLog(@"save item error:%@", error);
                        }
                    }];
                } else {
                    NSLog(@"get item error: %@", error);
                }
            }];
            
        } else {
            NSLog(@"transaction failed: %@", error);
        }
    }];
    self.selected = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCellTableViewCell"];
    cell.item = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCellTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selected = cell;
    self.selectedRow = indexPath.row;
    //The actual query that set the transaction entry should be implemented.
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.protoTypeCell.item = self.items[indexPath.row];
    [self.protoTypeCell layoutIfNeeded];
    
    CGSize size = [self.protoTypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
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
