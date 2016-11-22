//
//  AppDelegate.m
//  HomeScreenShortCutExample
//
//  Created by Park on 2016. 11. 16..
//  Copyright © 2016년 fantagram Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Check 3d touch is available
    //3d touch is available
    self.forceTouchCapability = self.window.rootViewController.traitCollection.forceTouchCapability;
    if(self.forceTouchCapability == UIForceTouchCapabilityAvailable){
        //when 3d touch is available
        NSLog(@"3d touch is available");
        //check app is launched from shortcut or not
        BOOL performShortcutDelegate = YES;
        if([launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey]){
            
            NSLog(@"application launched via shortcut");
            self.shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
            
            performShortcutDelegate = NO;
        }
        return performShortcutDelegate;
    }
    //3d touch is not available
    else{
        //when 3d touch is not available
        NSLog(@"3d touch is not available %d", (int)self.forceTouchCapability);
        return YES;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Application did become Active");
    if(self.shortcutItem){
        NSLog(@"shortcut property has been set");
        [self handlingShortcutItems:self.shortcutItem];
        
        self.shortcutItem = nil;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Shortcut item handling helper function
//helper function for handling shortcut item
- (BOOL) handlingShortcutItems: (UIApplicationShortcutItem *) shortcutItem{
    NSLog(@"handling shortcut");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"defaultNavigationController"];
    ViewController *defaultViewController = [storyboard instantiateViewControllerWithIdentifier:@"defaultViewController"];
    BOOL succeed = NO;
    if([shortcutItem.type isEqualToString:@"goToMain"]){
        succeed = YES;
        
        self.window.rootViewController = navigationController;
        [navigationController setViewControllers:@[defaultViewController]];
        [self.window makeKeyAndVisible];
    }
    else if([shortcutItem.type isEqualToString:@"goToImagePicker"]){
        succeed = YES;
        
        self.window.rootViewController = navigationController;
        [navigationController setViewControllers:@[defaultViewController]];
        [defaultViewController openImagePicker];
    }
    return succeed;
}
#pragma mark - Shortcut item Delegate
//Shortcut item delegate
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"Application performActionForShortcutItem");
    completionHandler([self handlingShortcutItems:shortcutItem]);
}

#pragma mark - When app is launched from other app
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    //load image from app group directory
    NSString *fileName = [url.resourceSpecifier substringFromIndex:2];
    self.groupDirectoryURL= [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.fantagram.HomeScreenShortCutExample"];
    NSString *imagePath = [NSString stringWithFormat:@"%@%@", self.groupDirectoryURL.resourceSpecifier, fileName];
    NSLog(@"%@", imagePath);
    UIImage *imageToSet = [UIImage imageWithContentsOfFile:imagePath];
    NSLog(@"file exist? %d", [[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
    //set image to viewcontroller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"defaultNavigationController"];
    ViewController *defaultViewController = [storyboard instantiateViewControllerWithIdentifier:@"defaultViewController"];
    defaultViewController.originalImage = imageToSet;
    
    self.window.rootViewController = navigationController;
    [navigationController setViewControllers:@[defaultViewController]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"HomeScreenShortCutExample"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
