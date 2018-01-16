//
//  SLTabMManager.h
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/11/14.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLTabMManager : NSObject

@property(nonatomic, strong)NSMutableArray *defaultTabBarMArray;

@property (weak, nonatomic) UITabBarController *tabBarController;

@property (weak, nonatomic) UITabBarController *tabBarControllertest;

+ (instancetype)sharedInstance;
- (void)saveDefaultTabBarMArray: (UITabBarController*)tabbar;
- (void)hideTabBarItem : (NSMutableArray *)indexes;
- (void)setTabBarTitle : (NSMutableArray *)tabSettingArray tabBarVCArray: (NSMutableArray *)tabBarVCArray;
- (NSString *)getTabBarTitle : (NSInteger)selectedTabIndex;
- (void)moveTabBarItem : (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath;
@end
