//
//  ViewController.m
//  HomeScreenShortCutExample
//
//  Created by Park on 2016. 11. 16..
//  Copyright © 2016년 fantagram Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
//    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"search" localizedTitle:@"Search" localizedSubtitle:nil icon:icon1 userInfo:nil];
//    [[UIApplication sharedApplication].shortcutItems arrayByAddingObject:item1];
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
        NSLog(@"available");
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    else{
        NSLog(@"gesture");
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] init];
        [self.longPressGesture addTarget:self action:@selector(presentingDetailViewWithLongPressGesture:)];
        [self.imageView addGestureRecognizer:self.longPressGesture];
    }
    if(self.originalImage){
        self.imageView.image = self.originalImage;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load a Image
- (IBAction)loadImageBtnTapped:(id)sender {
    [self openImagePicker];
}

- (void) openImagePicker{
    FTImagePickerOptions *options = [[FTImagePickerOptions alloc] init];
    [FTImagePickerManager presentFTImagePicker:self withOptions:options];
}

#pragma mark - Image Picker delegate
- (void)getSelectedImageAssetsFromImagePicker:(NSMutableArray *)selectedAssetsArray{
    self.asset = selectedAssetsArray[0];
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:self.imageView.frame.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.imageView.image = result;
    }];
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        self.originalImage = [UIImage imageWithData:imageData];
    }];
}

- (void)imagePickerCanceledWithOutSelection{
    
}

#pragma mark - Branch For the device 3d touch is not available
- (void) presentingDetailViewWithLongPressGesture:(UILongPressGestureRecognizer *) gesture{
    if(gesture.state == UIGestureRecognizerStateBegan) {
        if(self.imageView.image != nil){
            NSLog(@"longPressGesture");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
            detailViewController.imageToShow = self.originalImage;
            detailViewController.delegate = (id)self;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
}

#pragma mark - 3d touch Preview Peek
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    if(CGRectContainsPoint(self.imageView.frame, location)){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
        detailViewController.imageToShow = self.originalImage;
        detailViewController.preferredContentSize = CGSizeMake(0.0, 300);
        detailViewController.delegate = (id)self;
        
        [previewingContext setSourceRect:self.imageView.frame];
        
        return detailViewController;
    }
    else{
        return nil;
    }
}

#pragma mark - 3d touch Pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

#pragma mark - Check 3d touch availibility
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    NSLog(@"changed");
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
        self.longPressGesture.enabled = NO;
    }
    else{
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] init];
        [self.longPressGesture addTarget:self action:@selector(presentingDetailViewWithLongPressGesture:)];
        [self.imageView addGestureRecognizer:self.longPressGesture];
    }
}

#pragma mark - DetailViewController delegate
- (void) shareImage:(UIImage *) imageToShare{
    UIActivityViewController *shareImage = [[UIActivityViewController alloc] initWithActivityItems:@[imageToShare] applicationActivities:nil];
    [self presentViewController:shareImage animated:YES completion:nil];
}

@end
