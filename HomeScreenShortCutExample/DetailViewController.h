//
//  DetailViewController.h
//  HomeScreenShortCutExample
//
//  Created by Park on 2016. 11. 17..
//  Copyright © 2016년 fantagram Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate <NSObject>

- (void) shareImage:(UIImage *) imageToShare;

@end

@interface DetailViewController : UIViewController
@property (strong, nonatomic) UIImage *imageToShow;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) id<DetailViewControllerDelegate> delegate;

@end
