//
//  LoginViewController.m
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = @"Exchange";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextfield.delegate = self;
    self.passwordTextfield.secureTextEntry = YES;
    [self.nameTextField becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSignIn:(id)sender {
    NSString *username = self.nameTextField.text;
    NSString *password = self.passwordTextfield.text;
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            NSLog(@"sign in success %@", user.username);
                                            [self openHome];
                                            // Do stuff after successful login.
                                        } else {
                                            NSLog(@"sign in failed: %@", error);
                                            // The login failed. Check error to see why.
                                        }
                                    }];
}

- (IBAction)onSignUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.nameTextField.text;
    user.password = self.passwordTextfield.text;
    user.email = self.emailTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"Sign up success:%@", [PFUser currentUser].username);
            [self openHome];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"sign up error: %@", errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

- (void)openHome {
    [[NSNotificationCenter defaultCenter] postNotificationName:DidLoginNotificationKey object:nil];
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
