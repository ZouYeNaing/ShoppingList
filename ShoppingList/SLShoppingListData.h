//
//  SLShoppingListData.h
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/08/01.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SLShoppingListData : NSObject

@property (strong, nonatomic) NSMutableDictionary *SLDataDict;

@property (strong, nonatomic) NSDictionary *test;

@property (nonatomic) NSInteger *hiddenTab;

@property (strong, nonatomic) NSMutableDictionary *SLDict;

@property (weak, nonatomic) UITabBarController *tabBarController;

@property (weak, nonatomic) UIBarButtonItem *trashButtonItem;

+ (instancetype)sharedInstance;

- (NSMutableArray *)getSLDataArray;

- (NSMutableArray *)getSLDataArray : (NSInteger)selectedTabIndex;

- (void)setSLDataArray:(NSMutableArray *)SLDataArray;

- (void)saveData;

- (void)createNSDictionary;

- (void)updateColor;

- (NSString *)dataFilePath: (NSString *)saveFileName;

@end
