//
//  ExchangeViewController.m
//  exchange
//
//  Created by Nadav Golbandi on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ItemCellTableViewCell.h"

@interface ExchangeViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* items;
@property (strong, nonatomic) NSString* userName;
@property (nonatomic, strong) ItemCellTableViewCell * prototypeCell;
@property (nonatomic, assign) NSInteger selected;
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
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //update the view controller about the castom cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"ItemCellTableViewCell"];
    
    //dynamic raw cell high dimension
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Exchange";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCellTableViewCell"];
    cell.item = self.items[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (ItemCellTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCellTableViewCell"];
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

-(void) ItemCellTableViewCell:(ItemCellTableViewCell *)cell didUpdateValue:(BOOL)value{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    //if the categoy selected I would like to add it to the set
    self.selected = indexPath.row;
}



@end
