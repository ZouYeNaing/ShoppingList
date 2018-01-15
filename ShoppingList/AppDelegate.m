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
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"changeTabbar"]){
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"changeTabbar"];
        NSMutableArray *tab = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        
        NSMutableArray *tabArray = [tabBarController.viewControllers mutableCopy];
        
        for (int i=0; i < tabArray.count; i++) {
            UIViewController *vc = [tab objectAtIndex: i];
            [tabArray replaceObjectAtIndex:i withObject: [tab objectAtIndex: i]];
            
            NSLog(@"Title(AppDelegateSave) : %@", vc.tabBarItem.title);
            NSLog(@"VC : %@", vc);
            
        }
        
        // [tabBarController setViewControllers: tabArray.mutableCopy];
        [tabBarController setTabBarItem: tabArray.mutableCopy];
        
        [[SLTabMManager sharedInstance] saveDefaultTabBarMArray: tabBarController];
        
        for (int i=0; i < tabBarController.viewControllers.count; i++) {
            UIViewController *vc = [tabBarController.viewControllers objectAtIndex: i];
            NSLog(@"Title(AppDelegateSave) : %@", vc.tabBarItem.title);
        }
        
        [SLShoppingListData sharedInstance].tabBarController = tabBarController;
        [SLTabMManager sharedInstance].tabBarControllertest = tabBarController;

        
    } else {
        
        NSMutableArray *tabArray = [tabBarController.viewControllers mutableCopy];
        
        for (int i=0; i < tabArray.count; i++) {
            UIViewController *vc = [tabArray objectAtIndex: i];
            vc.tabBarItem.tag = i;
            NSLog(@"Title(AppDelegate) : %@", vc.tabBarItem.title);
            
        }
        
        [tabBarController setTabBarItem: tabArray.mutableCopy];
        [SLShoppingListData sharedInstance].tabBarController = tabBarController;
        [SLTabMManager sharedInstance].tabBarController = tabBarController;
         [[SLTabMManager sharedInstance] saveDefaultTabBarMArray: tabBarController];
    }
    
    
    /*
    [SLShoppingListData sharedInstance].tabBarController = tabBarController;
    [SLTabMManager sharedInstance].tabBarController = tabBarController;
    */
    
    NSDictionary *newDic1 = @{@"status": @YES, @"data": @"リスト 1", @"path":@"FinalList0", @"key":@"List0", @"tab":@"0"};
    NSDictionary *newDic2 = @{@"status": @YES, @"data": @"リスト 2", @"path":@"FinalList1", @"key":@"List1", @"tab":@"1"};
    NSDictionary *newDic3 = @{@"status": @YES, @"data": @"リスト 3", @"path":@"FinalList2", @"key":@"List2", @"tab":@"2"};
    NSDictionary *newDic4 = @{@"status": @YES, @"data": @"リスト 4", @"path":@"FinalList3", @"key":@"List3", @"tab":@"3"};
    NSDictionary *newDic5 = @{@"status": @YES, @"data": @"設定"};
    
    NSMutableArray *tabSettingArray = [@[newDic1, newDic2, newDic3, newDic4, newDic5] mutableCopy];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"SavedTab": tabSettingArray}];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject: [UIColor redColor]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedColor": colorData}];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedIndex": @(46)}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedFont": @"Helvetica"}];
    
    NSMutableArray *tabSetting = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
    
    
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
