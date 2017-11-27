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

+ (instancetype)sharedInstance;
- (void)saveDefaultTabBarMArray;
- (void)hideTabBarItem : (NSMutableArray *)indexes;
- (void)setTabBarTitle : (NSMutableArray *)tabSettingArray;
- (NSString *)getTabBarTitle : (int)selectedTabIndex;
@end
