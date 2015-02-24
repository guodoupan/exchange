//
//  ProfileViewController.m
//  exchange
//
//  Created by Doupan Guo on 2/22/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) ProfileHeaderView *headerView;

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
    
    [self loadData];
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
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)loadData {
    PFQuery *query = [PFQuery queryWithClassName:@"ExchangeItem"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"userid" equalTo:[self.user objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            self.dataArray = [ExchangeItem exchangeItemsWithArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.refreshControl endRefreshing];
    }];
    
    [self loadAvatar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [PFUser logOut];
        [[NSNotificationCenter defaultCenter] postNotificationName:DidLogoutNotificationKey object:nil];
    } else if (buttonIndex == 1) {
        NSLog(@"Change icon");
        [self changeIcon];
    }
}

- (void)onSetting {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:@"Change icon", nil];
    [actionSheet showInView:self.view];
}

- (void)changeIcon {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if ([self checkCameraAvailability]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)saveAvatar: (UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithData:imageData];

    PFQuery *query = [PFQuery queryWithClassName:@"UserAvatar"];
    [query whereKey:@"userid" equalTo:[self.user objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            object[@"imageFile"] = imageFile;
            [object saveInBackground];
        }
    }];
}

- (void)loadAvatar {
     PFQuery *query = [PFQuery queryWithClassName:@"UserAvatar"];
    [query whereKey:@"userid" equalTo:[self.user objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFFile *imageFile = objects[0][@"imageFile"];
            if (imageFile) {
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        [self.headerView setAvatar:image];
                    }
                }];
            }
        }
    }];
}


#pragma - image picker actions
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    UIImage *flippedImage = [UIImage imageWithCGImage:chosenImage.CGImage scale:chosenImage.scale orientation:UIImageOrientationLeftMirrored];

    [picker dismissViewControllerAnimated:YES completion:nil];
    if (flippedImage != nil) {
        [self.headerView setAvatar: flippedImage];
        [self saveAvatar:flippedImage];
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

@end
