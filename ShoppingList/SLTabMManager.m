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
        
       
        
        
        // _defaultTabBarMArray = [NSMutableArray arrayWithArray: [tabbar.viewControllers mutableCopy]];
        
        for (int i=0; i < _defaultTabBarMArray.count; i++) {
            UIViewController *vc = [_defaultTabBarMArray objectAtIndex: i];
            NSLog(@"Title(...) : %@", vc.tabBarItem.title);
        }

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

- (void)moveTabBarItem : (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath{
    
    if (fromIndexPath != toIndexPath ) {
        
        NSMutableArray *tabSettingArray = [self.tabBarController.viewControllers mutableCopy];
        
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
        
        
        UITabBarController *tab = self.tabBarController;
        
        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject: tab];
        [[NSUserDefaults standardUserDefaults] setObject: data1 forKey: @"changedTabbar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

-(void)setTabBarTitle:(NSMutableArray *)tabSettingArray tabBarVCArray:(NSMutableArray *)tabBarVCArray {
    
    
    NSMutableArray *tabArray         = [tabBarVCArray mutableCopy];
    // NSMutableArray *tabArray = [self.tabBarController.viewControllers mutableCopy];
//    NSMutableArray *tabArray = [[NSMutableArray arrayWithArray: [SLShoppingListData sharedInstance].tabBarController.viewControllers] mutableCopy];
    NSLog(@"setTabBarTitle : %@", tabSettingArray);
    
    /*
    if(tabSettingArray.count > 0)
    {
        for (int i=0; i < tabArray.count; i++) {
            [[tabArray objectAtIndex: i]setTitle: [tabSettingArray objectAtIndex: i][@"data"]];
        }
    }
    */
    
    [self.tabBarController setViewControllers: tabArray animated:YES];
    
    // [SLShoppingListData sharedInstance].tabBarController = self.tabBarController;
    
}


- (NSString *)getTabBarTitle : (NSInteger)selectedTabIndex {
    
    NSLog(@"selectedTab(getTabBarTitle) %ld", selectedTabIndex);
    NSString *title;
    NSMutableArray *tabSetting = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
    
    for (int i=0; i < [tabSetting count]-1; i++) {
        if (selectedTabIndex == [[tabSetting objectAtIndex:i][@"tab"] integerValue]) {
            title = [tabSetting objectAtIndex: i][@"data"];
        }
    }
    
    // NSString *title = [tabSetting objectAtIndex: selectedTabIndex][@"data"];
    
    return title;

}


@end
