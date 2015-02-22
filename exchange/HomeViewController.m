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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadDefaultData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDefaultData) name:DidUploadItemNotificationKey object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
    ExchangeItem *item = self.dataArray[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.desc;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    UIImage *image = [UIImage imageNamed:@"search"];
    UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:image tag:0];
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
