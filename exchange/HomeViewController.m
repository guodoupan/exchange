//
//  HomeViewController.m
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "HomeViewController.h"
#import "ItemDetailController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *titleView;

@end

@implementation HomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self showDefaultTitle];
    }
    return self;
}

- (ExchangeItemCell *)protoTypeCell {
    if (!_protoTypeCell) {
        _protoTypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"ExchangeItemCell"];
    }
    return _protoTypeCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadDefaultData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

     [self.tableView registerNib:[UINib nibWithNibName:@"ExchangeItemCell" bundle:nil] forCellReuseIdentifier:@"ExchangeItemCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDefaultData) name:DidUploadItemNotificationKey object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.protoTypeCell.item = self.dataArray[indexPath.row];
    [self.protoTypeCell layoutIfNeeded];
    
    CGSize size = [self.protoTypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeItemCell"];
    ExchangeItem *item = self.dataArray[indexPath.row];
    //[cell setItemImage:[UIImage imageNamed:@"sunglass"]];
    NSLog(@"get view:%d", indexPath.row);
    if (item.imageFile != nil) {
        [item.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            NSLog(@"get data success %d", indexPath.row);
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                [cell setItemImage:image];
            }
        }];
    } else {
        [cell setItemImage:[UIImage imageNamed:@"sunglass"]];
    }

    cell.item = item;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ItemDetailController *dvc = [[ItemDetailController alloc] initWithItem:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = searchBar.text;
    [self loadData:searchTerm];
}

- (void)onRightButton {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(self.navigationItem.titleView.frame))];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    [searchBar becomeFirstResponder];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(showDefaultTitle)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)showDefaultTitle {
    self.title = @"Exchange";
    UIImage *image = [UIImage imageNamed:@"explore"];
    UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:image tag:0];
    tabItem.selectedImage = [UIImage imageNamed:@"explore_selected"];
    self.tabBarItem = tabItem;
    
    UIImage *searchImage = [UIImage imageNamed:@"search"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStyleDone target:self action:@selector(onRightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.titleView = self.titleView;
    
    [self loadDefaultData];
}

- (void)loadDefaultData {
    [self loadData:nil];
}

- (void)loadData: (NSString *)keyword{
    PFQuery *query = [PFQuery queryWithClassName:@"ExchangeItem"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"userid" notEqualTo:[PFUser currentUser].objectId];
    if (keyword != nil) {
        [query whereKey:@"name" containsString:keyword];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d items.", objects.count);
            // Do something with the found objects
            self.dataArray = [ExchangeItem exchangeItemsWithArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)onLogout:(id)sender {
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:DidLogoutNotificationKey object:nil];
}

- (void)onPost:(id)sender {
    PostViewController *vc = [[PostViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
