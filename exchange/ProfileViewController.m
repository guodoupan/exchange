//
//  ProfileViewController.m
//  exchange
//
//  Created by Doupan Guo on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ProfileViewController.h"
#import "ItemCellTableViewCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *myItemsDataArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) ProfileHeaderView *headerView;
@property (nonatomic, strong) ItemCellTableViewCell * prototypeCell;
@property (nonatomic, assign) BOOL showMyItem;

@end

@implementation ProfileViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"profile"];
        UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:image tag:0];
        
        self.tabBarItem = tabItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.headerView = [ProfileHeaderView profileHeader];
    self.headerView.delegate = self;
    [self.headerView setUser: self.user];
    self.tableView.tableHeaderView = self.headerView;
    
    // Register nib
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"ItemCellTableViewCell"];
    
    self.showMyItem = YES;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - table view actions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCellTableViewCell"];
    cell.item = self.myItemsDataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myItemsDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TransactionViewController *vc = [[TransactionViewController alloc] init];
    vc.requestedItem = self.myItemsDataArray[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.protoTypeCell.item = self.myItemsDataArray[indexPath.row];
    [self.protoTypeCell layoutIfNeeded];
    CGSize size = [self.protoTypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}


- (void)loadData {
    if(self.showMyItem == YES){
        PFQuery *query = [PFQuery queryWithClassName:@"ExchangeItem"];
        [query orderByDescending:@"updatedAt"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                // Do something with the found objects
                self.myItemsDataArray = [ExchangeItem exchangeItemsWithArray:objects];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
    
    [self loadAvatar];
    
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self loadAvatar];
    }];
}

- (void)loadTransaction {
    PFQuery *query = [PFQuery queryWithClassName:@"ExchangeItem"];
    PFQuery *transactionQuery = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"userid" equalTo:[self.user objectId]];
    [query whereKey:@"objectId" matchesKey:@"requestingItemId" inQuery:transactionQuery];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            self.myItemsDataArray = [ExchangeItem exchangeItemsWithArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.refreshControl endRefreshing];
    }];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [PFUser logOut];
        [[NSNotificationCenter defaultCenter] postNotificationName:DidLogoutNotificationKey object:nil];
    } else if (buttonIndex == 1) {
        NSLog(@"Change icon");
        [self changeIcon:@"Library"];
    } else if (buttonIndex == 2) {
        [self changeIcon:@"Camera"];
    }
}

- (void)onSetting {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:@"Change Icon from Library", @"Take a New Profile Picture", nil];
    [actionSheet showInView:self.view];
}

-(void) onShowMyItems{
    if(self.showMyItem == NO){
        self.showMyItem = YES;
    }else{
        self.showMyItem = NO;
    }
    [self loadData];
}

- (void)changeIcon: (NSString *)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if ([sourceType isEqualToString:@"Camera"] && [self checkCameraAvailability]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:picker animated:YES completion:NULL];
    } else if([sourceType isEqualToString:@"Library"]){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)saveAvatar: (UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    
    PFUser *user = [PFUser currentUser];
    [user setObject:imageFile forKey:@"profilePic"];
    [user saveInBackground];
}

- (void)loadAvatar {
    // Actually we can save image inside the PFUser, no need for a new Class
    PFUser *user = [PFUser currentUser];
    [self.headerView setUser:user];
    PFFile *imageFile = user[@"profilePic"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            [self.headerView setAvatar:image];
        }
    }];
}

-(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}

#pragma - image picker actions
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Let's use the edited image which is square
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizeImage = [self resizeImage:chosenImage toSize:CGSizeMake(300, 300)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (resizeImage != nil) {
        [self.headerView setAvatar: resizeImage];
        [self saveAvatar:resizeImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)checkCameraAvailability {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        return false;
    }
    return true;
}

- (ItemCellTableViewCell *)protoTypeCell {
    if (!_protoTypeCell) {
        _protoTypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCellTableViewCell"];
    }
    return _protoTypeCell;
}

@end
