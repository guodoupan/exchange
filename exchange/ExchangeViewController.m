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
        [query whereKey:@"userid" containsString: [[PFUser currentUser] objectId]];
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
    
    self.title = @"Select an Item 4 Exchange";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancleButton)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) onCancleButton {
    [self.navigationController popViewControllerAnimated:TRUE];
    self.selected = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCellTableViewCell"];
    cell.item = self.items[indexPath.row];
    [cell selectionImageHidden:YES];
    if(indexPath.row == self.selectedRow){
        [self.selected selectionImageHiddenSwitch];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ItemCellTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(self.selected && self.selected!=cell){
        [self.selected selectionImageHiddenSwitch];
    }
    self.selected = cell;
    self.selectedRow = indexPath.row;
    [self.selected selectionImageHiddenSwitch];
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
