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
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import Firebase;

@interface AppDelegate ()

@end

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary *tabItemDic1 = @{@"status": @YES, @"title": @"リスト 1", @"path":@"FinalList0", @"key":@"List0", @"tab":@"0"};
    NSDictionary *tabItemDic2 = @{@"status": @YES, @"title": @"リスト 2", @"path":@"FinalList1", @"key":@"List1", @"tab":@"1"};
    NSDictionary *tabItemDic3 = @{@"status": @YES, @"title": @"リスト 3", @"path":@"FinalList2", @"key":@"List2", @"tab":@"2"};
    NSDictionary *tabItemDic4 = @{@"status": @YES, @"title": @"リスト 4", @"path":@"FinalList3", @"key":@"List3", @"tab":@"3"};
    NSDictionary *tabItemDic5 = @{@"status": @YES, @"title": NSLocalizedString(@"Setting", "")};
    
    NSMutableArray *tabBarItemSettingArray = [@[tabItemDic1, tabItemDic2, tabItemDic3, tabItemDic4, tabItemDic5] mutableCopy];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"SavedTab": tabBarItemSettingArray}];
    
    NSDictionary *initListDic1 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Apple"};
    NSDictionary *initListDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Banana"};
    NSDictionary *initListDic3 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Corn"};
    NSDictionary *initListDic4 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Durian"};
    NSDictionary *initListDic5 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Onion"};
    NSDictionary *initListDic6 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Tomato"};
    NSDictionary *initListDic7 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Potato"};
    
    NSMutableArray *initListArray = [@[initListDic1, initListDic2, initListDic3, initListDic4, initListDic5, initListDic6, initListDic7] mutableCopy];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"initList": initListArray}];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject: [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedColor": colorData}];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedIndex": @(46)}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"selectedFont": @"Helvetica"}];
    
    NSDictionary *reminderStatusDict = @{@"title": NSLocalizedString(@"Enable", ""), @"status": @NO, @"detail":@""};
    NSDictionary *reminderDetailDict = @{@"title": NSLocalizedString(@"Reminder me at", ""), @"status": @YES, @"detail":@""};
    NSMutableArray *initReminderArray = [@[reminderStatusDict, reminderDetailDict] mutableCopy];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"reminderInfo": initReminderArray}];

    if([[NSUserDefaults standardUserDefaults] objectForKey: @"changedTabbar"]) {
        
        NSMutableArray *tabBarItemSettingArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
        
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        
        [SLShoppingListData sharedInstance].tabBarController   = tabBarController;
        [SLTabMManager sharedInstance].tabBarController        = tabBarController;
        [[SLTabMManager sharedInstance] saveDefaultTabBarMArray: tabBarController];
        
        [[SLTabMManager sharedInstance] setTabBarTitle: tabBarItemSettingArray];
        [[SLTabMManager sharedInstance] hideTabBarItem: tabBarItemSettingArray];
        
        [[SLShoppingListData sharedInstance] updateColor];
    } else {
        NSMutableArray *tabBarItemSettingArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
        
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        
        // [tabBarController setTabBarItem: tabBarVCArray.mutableCopy];
        [SLShoppingListData sharedInstance].tabBarController = tabBarController;
        [SLTabMManager sharedInstance].tabBarController = tabBarController;
        [[SLTabMManager sharedInstance] saveDefaultTabBarMArray: tabBarController];
        
        [[SLTabMManager sharedInstance] setTabBarTitle: tabBarItemSettingArray];
        [[SLTabMManager sharedInstance] hideTabBarItem: tabBarItemSettingArray];
        
        [[SLShoppingListData sharedInstance] updateColor];
    }
    [self addEventsFor3DTouchEvents];
    [FIRApp configure];
    [Fabric with:@[[Answers class], [Crashlytics class]]];
    [self registerForRemoteNotifications];
    return YES;
}

- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
            }
        }];
    }
    else {
        // Code for old versions
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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) addEventsFor3DTouchEvents {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        NSArray *savedTabBarItems = [[[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]] mutableCopy];
        NSMutableArray *quickActionItems = [NSMutableArray array];
        for (NSDictionary *itemDic in savedTabBarItems) {
            if([itemDic[@"status"] isEqualToNumber:[NSNumber numberWithBool:YES]] && ![itemDic[@"title"] isEqualToString:@"Setting"]) {
                [quickActionItems addObject:itemDic];
            }
        }
        NSMutableArray *shortcutItems = [NSMutableArray array];
        for (NSDictionary *tabDic in quickActionItems) {
            UIApplicationShortcutItem *shortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"" localizedTitle:tabDic[@"title"] localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"icon"] userInfo:tabDic];
            [shortcutItems addObject:shortcutItem];
        }
        if (shortcutItems.count > 0) {
            [[UIApplication sharedApplication] setShortcutItems: shortcutItems];
        }
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    NSMutableArray *reminderInfoArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reminderInfo"] mutableCopy];
    
    NSMutableDictionary *reminderStatusDict = [[reminderInfoArray objectAtIndex:0] mutableCopy];
    NSMutableDictionary *reminderDetailDict = [[reminderInfoArray objectAtIndex:1] mutableCopy];
    
    [reminderStatusDict setValue:@NO forKey:@"status"];
    [reminderDetailDict setValue:@"" forKey:@"detail"];
    
    [reminderInfoArray replaceObjectAtIndex:0 withObject:reminderStatusDict];
    [reminderInfoArray replaceObjectAtIndex:1 withObject:reminderDetailDict];
    
    [[NSUserDefaults standardUserDefaults] setObject:reminderInfoArray forKey:@"reminderInfo"];
    NSLog(@"didReceiveNotificationResponse : %@", reminderInfoArray);
    completionHandler();
}

#pragma mark - 3DTouch Delegate Methods
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [self moveThrough3DTouch:shortcutItem];
}

#pragma MARK for Handling Action for Three D Touch Events
- (void)moveThrough3DTouch:(UIApplicationShortcutItem *)shortcutItem {
    
    NSArray *currentTabBarItems = [[(UITabBarController *)self.window.rootViewController tabBar].items mutableCopy];
    for (int i=0; i < currentTabBarItems.count; i++) {
        if([[currentTabBarItems[i] title] isEqualToString:shortcutItem.localizedTitle]) {
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            [tabBarController setSelectedIndex:i];
            break;
        }
    }
}

@end
