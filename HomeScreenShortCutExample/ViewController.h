//
//  ViewController.h
//  HomeScreenShortCutExample
//
//  Created by Park on 2016. 11. 16..
//  Copyright © 2016년 fantagram Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTImagePicker.h"
#import "DetailViewController.h"

@interface ViewController : UIViewController<FTImagePickerViewControllerDelegate, UIViewControllerPreviewingDelegate, DetailViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;


- (void) openImagePicker;
- (IBAction)loadImageBtnTapped:(id)sender;
@end
