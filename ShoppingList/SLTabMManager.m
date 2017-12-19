//
//  SLTabMManager.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/11/14.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLTabMManager.h"
#import "SLShoppingListData.h"

@implementation SLTabMManager

+ (instancetype)sharedInstance
{
    static SLTabMManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SLTabMManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)saveDefaultTabBarMArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultTabBarMArray = [[NSMutableArray arrayWithArray: [SLShoppingListData sharedInstance].tabBarController.viewControllers] mutableCopy];
    });
}

- (void)hideTabBarItem : (NSMutableArray *)tabSettingArray {
    
    NSMutableArray *tabStatus = [tabSettingArray valueForKey: @"status"];
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    NSMutableArray *tabBarArray = _defaultTabBarMArray.mutableCopy;
    // NSLog(@"org : %@", tabBarArray);
    tabBarArray =[SLTabMManager sharedInstance].defaultTabBarMArray.mutableCopy;
    for (int i=0; i < tabStatus.count; i++) {
        if (NO == [tabStatus[i] boolValue]) {
            [indexes addIndex : i];
        }
    }
    [tabBarArray removeObjectsAtIndexes: indexes];
    // NSLog(@"aft : %@", tabBarArray);
    [self.tabBarController setViewControllers: tabBarArray];
    
}

- (void)setTabBarTitle : (NSMutableArray *)tabSettingArray {
    
    NSMutableArray *tabArray = [self.tabBarController.viewControllers mutableCopy];
    NSLog(@"setTabBarTitle : %@", tabSettingArray);
    
    if(tabSettingArray.count > 0)
    {
        for (int i=0; i < tabArray.count-1; i++) {
            [[tabArray objectAtIndex: i]setTitle: [tabSettingArray objectAtIndex: i][@"data"]];
        }
    }
    
    self.tabBarController.viewControllers = tabArray;
    [self.tabBarController setViewControllers: tabArray animated:YES];
    
}


- (NSString *)getTabBarTitle : (NSInteger)selectedTabIndex {

    NSLog(@"selectedTabIndex %ld", selectedTabIndex);
    NSMutableArray *tabSetting = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
    NSString *title = [tabSetting objectAtIndex: selectedTabIndex][@"data"];
    
    return title;

}


@end
