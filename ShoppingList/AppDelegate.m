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
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    NSMutableArray *tabArray = [tabBarController.viewControllers mutableCopy];
    
    for (int i=0; i < tabArray.count; i++) {
        UIViewController *vc = [tabArray objectAtIndex: i];
        vc.tabBarItem.tag = i;
    }
    
    [tabBarController setTabBarItem: tabArray.mutableCopy];
    
    [SLShoppingListData sharedInstance].tabBarController = tabBarController;
    [SLTabMManager sharedInstance].tabBarController = tabBarController;
    
    [[SLTabMManager sharedInstance] saveDefaultTabBarMArray];
    
    
    NSMutableArray *tabSetting = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"Tab"]];
    [[SLTabMManager sharedInstance] setTabBarTitle: tabSetting];
    [[SLTabMManager sharedInstance] hideTabBarItem: tabSetting];

    [[SLShoppingListData sharedInstance] updateColor];
    
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
