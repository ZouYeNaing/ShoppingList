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

- (void)saveDefaultTabBarMArray: (UITabBarController*)tabbar {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _defaultTabBarMArray = [[NSMutableArray arrayWithArray: [SLShoppingListData sharedInstance].tabBarController.viewControllers] mutableCopy];

    });
}

- (void)hideTabBarItem : (NSMutableArray *)tabSettingArray {
    
    NSMutableArray *tabStatus = [tabSettingArray valueForKey: @"status"];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    NSMutableArray *tabBarArray = _defaultTabBarMArray.mutableCopy;
    // tabBarArray =[SLTabMManager sharedInstance].defaultTabBarMArray.mutableCopy;
    for (int i=0; i < tabStatus.count; i++) {
        if (NO == [tabStatus[i] boolValue]) {
            [indexes addIndex : i];
        }
    }
    [tabBarArray removeObjectsAtIndexes: indexes];
    
    [self.tabBarController setViewControllers: tabBarArray];
    
}

- (void)moveTabBarItem : (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath{
    
    if (fromIndexPath != toIndexPath ) {
        NSMutableArray *tabBarItemSettingArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
        NSMutableArray *tabSettingArray = _defaultTabBarMArray.mutableCopy;
        NSMutableDictionary *toMoveDict = tabSettingArray[fromIndexPath.row];
        
        [tabSettingArray removeObjectAtIndex: fromIndexPath.row];
        [tabSettingArray insertObject: toMoveDict atIndex: toIndexPath.row];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject: tabSettingArray];
        [[NSUserDefaults standardUserDefaults] setObject: data forKey: @"DefaultTabBarMArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tabBarController setViewControllers: tabSettingArray animated:YES];
        _defaultTabBarMArray = [self.tabBarController.viewControllers mutableCopy];
        [self hideTabBarItem: tabBarItemSettingArray];
        
        // Test
        /*
        NSMutableArray *tabStatus = [tabBarItemSettingArray valueForKey: @"status"];
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
        
        _defaultTabBarMArray = [self.tabBarController.viewControllers mutableCopy];
        NSMutableArray *tabBarArray = _defaultTabBarMArray.mutableCopy;
        NSLog(@"org : %@", tabBarArray);
        for (int i=0; i < tabBarArray.count; i++) {
            if (NO == [tabStatus[i] boolValue]) {
                [indexes addIndex : i];
            }
        }
        [tabBarArray removeObjectsAtIndexes: indexes];
        
        for (int i=0; i < tabBarArray.count; i++) {
            UIViewController *vc = [tabBarArray objectAtIndex: i];
            NSLog(@"Title(after hide) : %@", vc.tabBarItem.title);
        }
        
        [self.tabBarController setViewControllers: tabBarArray];
         */
        //Test
        
        UITabBarController *tab = self.tabBarController;
        
        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject: tab];
        [[NSUserDefaults standardUserDefaults] setObject: data1 forKey: @"changedTabbar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

-(void)setTabBarTitle:(NSMutableArray *)tabSettingArray {
    
    NSMutableArray *tabArray = [_defaultTabBarMArray mutableCopy];
    
    for (int i=0; i < tabArray.count; i++) {
        UIViewController *vc = [tabArray objectAtIndex: i];
        NSLog(@"Title(setTabBarTitle) : %@", vc.tabBarItem.title);
    }
    
    NSLog(@"setTabBarTitle : %@", tabSettingArray);
    
    if(tabSettingArray.count > 0)
    {
        for (int i=0; i < tabArray.count; i++) {
            [[tabArray objectAtIndex: i]setTitle: [tabSettingArray objectAtIndex: i][@"title"]];
        }
    }
    
    for (int i=0; i < tabArray.count; i++) {
        UIViewController *vc = [tabArray objectAtIndex: i];
        NSLog(@"Title(setTabBarTitle) : %@", vc.tabBarItem.title);
    }
    
    [self.tabBarController setViewControllers: tabArray animated:YES];
    
}


- (NSString *)getTabBarTitle : (NSInteger)selectedTabIndex {
    
    NSLog(@"selectedTab(getTabBarTitle) %ld", selectedTabIndex);
    NSString *title;
    NSMutableArray *tabSetting = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
    
    for (int i=0; i < [tabSetting count]-1; i++) {
        if (selectedTabIndex == [[tabSetting objectAtIndex:i][@"tab"] integerValue]) {
            title = [tabSetting objectAtIndex: i][@"title"];
        }
    }
    // NSString *title = [tabSetting objectAtIndex: selectedTabIndex][@"title"];
    
    return title;

}


@end
