//
//  TodayViewController.h
//  HomeScreenShortCutExampleWidget
//
//  Created by Park on 2016. 11. 17..
//  Copyright © 2016년 fantagram Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface TodayViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *assetsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *widgetCollectionView;
@property (strong, nonatomic) NSURL *groupDirectoryURL;

@end
