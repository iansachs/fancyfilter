//
//  ViewController.m
//  fancyfilter-app
//
//  Created by sachs on 11/3/16.
//
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)processImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectImagePressed:(id)sender {
    // Launch the picker here
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationPopover;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Implement this processImage function

- (void)processImage {
    //
    // HERE is where you should call out to your fancy filter class
    // to actually process the image held in the UIImageView.
    //
    NSLog(@"processImage - Implement this");
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"image picker selected image");
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Start processing the image as soon as the picker has
        // been dismissed
        [self processImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"image picker cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
