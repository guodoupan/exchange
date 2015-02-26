//
//  PostViewController.m
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "PostViewController.h"

NSString * const PlaceHolder = @"Write your item's description ...";

@interface PostViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (strong, nonatomic) UIImage *itemImage;
- (void)onImageTap: (UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation PostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"add"];
        UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:@"Post" image:image tag:0];
        
        self.tabBarItem = tabItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Added tap gesture
    [self.itemImageView setUserInteractionEnabled:YES];
    self.itemImageView.layer.cornerRadius = 10;
    self.itemImageView.clipsToBounds = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.itemImageView addGestureRecognizer:tapGestureRecognizer];
    
    // Settings for text view
    self.descTextView.delegate = self;
    self.descTextView.text = PlaceHolder;
    self.descTextView.textColor = [UIColor lightGrayColor];
}

- (void)onImageTap: (UITapGestureRecognizer *)tapGestureRecognizer {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Give a Picture to Your Item!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Pick a Picture from Library", @"Take a new Picture", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self onTakePicture:buttonIndex];
}

#pragma - text view settings
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = PlaceHolder;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
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
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizeImage = [self resizeImage:chosenImage toSize:CGSizeMake(800, 800)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.itemImageView.image = resizeImage;
    [self setItemImage:resizeImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTakePicture: (NSInteger)index {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (index == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (index == 1 && [self checkCameraAvailability]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPost:(id)sender {
    ExchangeItem *item = [[ExchangeItem alloc] init];
    item.name = self.nameTextField.text;
    item.type = 0;
    item.desc = self.descTextView.text;
    item.status = ItemUploaded;
    item.wanted = 0;
    item.user = [PFUser currentUser];
    
    // Save image file
    PFFile *imageFile = [PFFile fileWithData:UIImagePNGRepresentation(self.itemImage)];
    item.imageFile = imageFile;
    
    [[item pfObject] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"post success");
            [[NSNotificationCenter defaultCenter] postNotificationName:DidUploadItemNotificationKey object:nil];
            // Should clear existing content
            [self tearDown];
            [self.tabBarController setSelectedIndex:0];
        } else {
            NSLog(@"post failed");
        }
    }];
}

- (void)tearDown {
    self.nameTextField.text = @"";
    self.descTextView.text = @"";
    [self.itemImageView setImage:[UIImage imageNamed:@"itemPostImage"]];
}

@end
