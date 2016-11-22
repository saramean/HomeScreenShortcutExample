//
//  TodayViewController.m
//  HomeScreenShortCutExampleWidget
//
//  Created by Park on 2016. 11. 17..
//  Copyright © 2016년 fantagram Inc. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.assetsArray = [[NSMutableArray alloc] init];

    self.groupDirectoryURL= [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.fantagram.HomeScreenShortCutExample"];
    NSLog(@"%@", self.groupDirectoryURL);

    [self fetchRecentlyTakenPictures];
    self.widgetCollectionView.backgroundColor = [UIColor clearColor];
    NSLog(@"%d", (int)self.assetsArray.count);
    //From IOS 10, widget height need to be configured by following line and widgetActiveDisplayModeDidChange delegate
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
}

//set widget height
- (void)viewWillAppear:(BOOL)animated{
    //From IOS 10, widget size is limited. Following code won't affect to the size of widget
    self.preferredContentSize = CGSizeMake(0.0, self.widgetCollectionView.frame.size.height + 60);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Widget Delegate
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
//widget margin
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    defaultMarginInsets.left = 0.0;
    defaultMarginInsets.bottom = 5.0;
    return defaultMarginInsets;
}


//for ios 10
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    if(activeDisplayMode == NCWidgetDisplayModeCompact){
        self.preferredContentSize = CGSizeMake(0.0, 0.0);
    }
    else{
        self.preferredContentSize = CGSizeMake(0.0, self.widgetCollectionView.frame.size.height + 60);
    }
}

#pragma mark - Fetching Recently Taken Picture
//fetch 3 images from cameraroll and save to the app group directory
- (void) fetchRecentlyTakenPictures {
    PHFetchResult *camerarollCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [camerarollCollection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *collection = obj;
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", 1];
        PHFetchResult *assetFetch = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        [assetFetch enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] options:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.assetsArray addObject:obj];
            if(self.assetsArray.count == 3){
                [self saveImageFileToAppGroupDirectory:self.assetsArray];
            }
        }];
    }];
}

#pragma mark - Saving pictures to App group directory
- (void) saveImageFileToAppGroupDirectory:(NSArray *) assetsArray{
    for(int i = 0; i< self.assetsArray.count ; i++){
        NSString *savingPath = [NSString stringWithFormat:@"%@/%d.jpg", [self.groupDirectoryURL absoluteString], i];
        NSURL *savingURL = [NSURL URLWithString:savingPath];
        [[PHImageManager defaultManager] requestImageDataForAsset:self.assetsArray[i] options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if([imageData writeToURL:savingURL atomically:YES]){
                NSLog(@"saving success at path %@", savingURL);
            }
            else{
                NSLog(@"saving faill at path %@", savingURL);
            }
        }];
    }
}


#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"widgetPicturesCell" forIndexPath:indexPath];
    PHAsset *asset = self.assetsArray[indexPath.row];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:cell.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:cell.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = result;
        [cell.contentView addSubview:imageView];
    }];
    cell.layer.cornerRadius = 5.0;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *urlString = [NSString stringWithFormat:@"HomeScreenShortCutExample://%d.jpg", (int)indexPath.row];
    [self.extensionContext openURL:[NSURL URLWithString:urlString] completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"success");
        }
        else{
            NSLog(@"failed");
        }
    }];
}

#pragma mark - CollectionView Layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float cellHeight = self.widgetCollectionView.frame.size.height;
    return CGSizeMake(cellHeight, cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat distance = floorf(([UIScreen mainScreen].bounds.size.width - (3 * self.widgetCollectionView.frame.size.height)) / 4);
    return distance;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat distance = floorf(([UIScreen mainScreen].bounds.size.width - (3 * self.widgetCollectionView.frame.size.height)) / 4);
    CGSize size = CGSizeMake(distance - 10, self.widgetCollectionView.frame.size.height);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGFloat distance = floorf(([UIScreen mainScreen].bounds.size.width - (3 * self.widgetCollectionView.frame.size.height)) / 4);
    CGSize size = CGSizeMake(distance - 10, self.widgetCollectionView.frame.size.height);
    return size;
}

@end
