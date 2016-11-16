//
//  AppDelegate.h
//  HomeScreenShortCutExample
//
//  Created by Park on 2016. 11. 16..
//  Copyright © 2016년 fantagram Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

