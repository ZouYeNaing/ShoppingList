//
//  AppDelegate.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/07/28.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "AppDelegate.h"
#import "SLShoppingListData.h"
#import "SLTabMManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary *newDic1 = @{@"status": @YES, @"title": @"リスト 1", @"path":@"FinalList0", @"key":@"List0", @"tab":@"0"};
    NSDictionary *newDic2 = @{@"status": @YES, @"title": @"リスト 2", @"path":@"FinalList1", @"key":@"List1", @"tab":@"1"};
    NSDictionary *newDic3 = @{@"status": @YES, @"title": @"リスト 3", @"path":@"FinalList2", @"key":@"List2", @"tab":@"2"};
    NSDictionary *newDic4 = @{@"status": @YES, @"title": @"リスト 4", @"path":@"FinalList3", @"key":@"List3", @"tab":@"3"};
    NSDictionary *newDic5 = @{@"status": @YES, @"title": @"設定"};
    
    NSMutableArray *tabBarItemSettingArray = [@[newDic1, newDic2, newDic3, newDic4, newDic5] mutableCopy];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"SavedTab": tabBarItemSettingArray}];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject: [UIColor redColor]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedColor": colorData}];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedIndex": @(46)}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedFont": @"Helvetica"}];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey: @"changedTabbar"]) {
        
        NSMutableArray *tabBarItemSettingArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
        
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"changedTabbar"];
        UITabBarController *savedtabBarController = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        
        NSMutableArray *savedTabBarVCArray = [savedtabBarController.viewControllers mutableCopy];
        NSMutableArray *tabBarVCArray      = [tabBarController.viewControllers mutableCopy];
        
        for (int i=0; i < tabBarVCArray.count; i++) {
            [tabBarVCArray replaceObjectAtIndex: i withObject: [savedTabBarVCArray objectAtIndex: i]];
        }
        
//        for (int i=0; i < tabBarVCArray.count; i++) {
//            UIViewController *vc = [tabBarVCArray objectAtIndex: i];
//            vc.tabBarItem.tag = i;
//            NSLog(@"Title(AppDelegateChanged) VC : %@, %ld", vc.tabBarItem.title, vc.tabBarItem.tag);
//        }
        
//        [tabBarController setTabBarItem: tabBarVCArray.mutableCopy];
//        [tabBarController setViewControllers: tabBarVCArray.mutableCopy];
        
        // self.window.rootViewController = tabBarController;
        
//        [SLShoppingListData sharedInstance].tabBarController   = (UITabBarController *)self.window.rootViewController;
//        [SLTabMManager sharedInstance].tabBarController        = (UITabBarController *)self.window.rootViewController;
//        [[SLTabMManager sharedInstance] saveDefaultTabBarMArray: (UITabBarController *)self.window.rootViewController];
        [SLShoppingListData sharedInstance].tabBarController   = tabBarController;
        [SLTabMManager sharedInstance].tabBarController        = tabBarController;
        [[SLTabMManager sharedInstance] saveDefaultTabBarMArray: tabBarController];
        
        [[SLTabMManager sharedInstance] hideTabBarItem: tabBarItemSettingArray];
        [[SLTabMManager sharedInstance] setTabBarTitle: tabBarItemSettingArray tabBarVCArray: tabBarVCArray];
        
        [[SLShoppingListData sharedInstance] updateColor];
        
    } else {
        
        NSMutableArray *tabBarItemSettingArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
        
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        NSMutableArray *tabBarVCArray = [tabBarController.viewControllers mutableCopy];
        
        for (int i=0; i < tabBarVCArray.count; i++) {
            UIViewController *vc = [tabBarVCArray objectAtIndex: i];
//            vc.tabBarItem.tag = i;
            NSLog(@"Title(AppDelegate) : %@", vc.tabBarItem.title);
            
        }
        
        [tabBarController setTabBarItem: tabBarVCArray.mutableCopy];
        
        [SLShoppingListData sharedInstance].tabBarController = tabBarController;
        [SLTabMManager sharedInstance].tabBarController = tabBarController;
        [[SLTabMManager sharedInstance] saveDefaultTabBarMArray: tabBarController];
        
        [[SLTabMManager sharedInstance] setTabBarTitle: tabBarItemSettingArray tabBarVCArray: tabBarVCArray];
        [[SLTabMManager sharedInstance] hideTabBarItem: tabBarItemSettingArray];
        
        [[SLShoppingListData sharedInstance] updateColor];
    }
    
    return YES;
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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
