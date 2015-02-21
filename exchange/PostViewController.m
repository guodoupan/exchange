//
//  PostViewController.m
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPost:(id)sender {
    ExchangeItem *item = [[ExchangeItem alloc] init];
    item.name = self.nameTextField.text;
    item.desc = self.descTextField.text;
    //TODO use the proper values
    item.imageUrl = @"image url";
    item.type = 1;
    item.status = ItemUploaded;
    item.userId = [[PFUser currentUser] objectId];
    
    [[item pfObject] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"post success");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"post failed");
        }
    }];
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
