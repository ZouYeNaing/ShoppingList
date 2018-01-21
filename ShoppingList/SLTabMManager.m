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
        
        /*
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"changeTabbar"];
        _defaultTabBarMArray = [NSKeyedUnarchiver unarchiveObjectWithData: data];
         */
        
        
        _defaultTabBarMArray = [[NSMutableArray arrayWithArray: [SLShoppingListData sharedInstance].tabBarController.viewControllers] mutableCopy];

    });
}

- (void)hideTabBarItem : (NSMutableArray *)tabSettingArray {
    
    NSMutableArray *savedTab = [[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"] mutableCopy];
    
    NSMutableArray *tabStatus = [tabSettingArray valueForKey: @"status"];
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    // _defaultTabBarMArray = [self.tabBarController.viewControllers mutableCopy];
    NSMutableArray *tabBarArray = _defaultTabBarMArray.mutableCopy;
    NSLog(@"org : %@", tabBarArray);
    
    for (int i=0; i < tabBarArray.count; i++) {
        UIViewController *vc = [tabBarArray objectAtIndex: i];
        //            vc.tabBarItem.tag = i;
        NSLog(@"Title(before hide) : %@", vc.tabBarItem.title);
        
    }
    
    tabBarArray =[SLTabMManager sharedInstance].defaultTabBarMArray.mutableCopy;
    for (int i=0; i < tabStatus.count; i++) {
        if (NO == [tabStatus[i] boolValue]) {
            [indexes addIndex : i];
        }
    }
    [tabBarArray removeObjectsAtIndexes: indexes];
    
    for (int i=0; i < tabBarArray.count; i++) {
        UIViewController *vc = [tabBarArray objectAtIndex: i];
        //            vc.tabBarItem.tag = i;
        NSLog(@"Title(after hide) : %@", vc.tabBarItem.title);
    }
    
    // NSLog(@"aft : %@", tabBarArray);
    [self.tabBarController setViewControllers: tabBarArray];
    
}

- (void)moveTabBarItem : (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath{
    
    if (fromIndexPath != toIndexPath ) {
        NSMutableArray *tabBarItemSettingArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
        // NSMutableArray *tabSettingArray = [self.tabBarController.viewControllers mutableCopy];
        // NSMutableArray *saveData = [[NSUserDefaults standardUserDefaults] objectForKey: @""];
        NSMutableArray *tabSettingArray = [SLTabMManager sharedInstance].defaultTabBarMArray.mutableCopy;
        for (int i=0; i < tabSettingArray.count; i++) {
            UIViewController *vc = [tabSettingArray objectAtIndex: i];
            //            vc.tabBarItem.tag = i;
            NSLog(@"move(self.tabbar) : %@", vc.tabBarItem.title);
        }
        
        NSMutableArray *tabSetting = _defaultTabBarMArray.mutableCopy;
        for (int i=0; i < tabSetting.count; i++) {
            UIViewController *vc = [tabSetting objectAtIndex: i];
            //            vc.tabBarItem.tag = i;
            NSLog(@"move(defaulttabbar) : %@", vc.tabBarItem.title);
        }
        
        // NSMutableArray *tabSettingArray = [_defaultTabBarMArray mutableCopy];
        
        NSMutableDictionary *toMoveDict = tabSettingArray[fromIndexPath.row];
        
        [tabSettingArray removeObjectAtIndex: fromIndexPath.row];
        [tabSettingArray insertObject: toMoveDict atIndex: toIndexPath.row];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject: tabSettingArray];
        [[NSUserDefaults standardUserDefaults] setObject: data forKey: @"DefaultTabBarMArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        UIViewController *vc = [[SLShoppingListData sharedInstance].tabBarController.viewControllers objectAtIndex: [SLShoppingListData sharedInstance].tabBarController.selectedIndex];
        
        
        
        //self.tabBarController.viewControllers = tabSettingArray;
        // [SLShoppingListData sharedInstance].tabBarController.viewControllers = tabSettingArray;
        [self.tabBarController setViewControllers: tabSettingArray animated:YES];
        
        [self hideTabBarItem: tabBarItemSettingArray];
        
        
        
        
        UITabBarController *tab = self.tabBarController;
        
        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject: tab];
        [[NSUserDefaults standardUserDefaults] setObject: data1 forKey: @"changedTabbar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

-(void)setTabBarTitle:(NSMutableArray *)tabSettingArray tabBarVCArray:(NSMutableArray *)tabBarVCArray {
    
    
    
    NSMutableArray *tabArray         = [_defaultTabBarMArray mutableCopy];
    
    for (int i=0; i < tabArray.count; i++) {
        UIViewController *vc = [tabArray objectAtIndex: i];
        NSLog(@"Title(setTabBarTitle) : %@", vc.tabBarItem.title);
    }
    
    // NSMutableArray *tabArray = [self.tabBarController.viewControllers mutableCopy];
    // NSMutableArray *tabArray = [[NSMutableArray arrayWithArray: [SLShoppingListData sharedInstance].tabBarController.viewControllers] mutableCopy];
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
    
    // [SLShoppingListData sharedInstance].tabBarController = self.tabBarController;
    
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
