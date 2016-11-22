//
//  DetailViewController.m
//  HomeScreenShortCutExample
//
//  Created by Park on 2016. 11. 17..
//  Copyright © 2016년 fantagram Inc. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailImageView.image = self.imageToShow;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Preview Action
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    UIPreviewAction *shareAction = [UIPreviewAction actionWithTitle:@"Share" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"preview action");
        [self.delegate shareImage:self.imageToShow];
    }];
    
    return @[shareAction];
}


@end
