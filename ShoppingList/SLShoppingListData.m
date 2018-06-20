//
//  SLShoppingListData.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/08/01.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLShoppingListData.h"

@implementation SLShoppingListData

+ (instancetype)sharedInstance
{
    static SLShoppingListData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SLShoppingListData alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)createNSDictionary
{
    if(_SLDict) {
        NSLog(@"Already Exists");
    }
    else {
        _SLDict = [NSMutableDictionary dictionary];
    }
    
}

- (NSMutableArray *)getSLDataArray : (NSInteger)selectedTabIndex {
    
    NSString *key;
    NSMutableArray *savedTab = [[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"] mutableCopy];
    NSMutableArray *tabStatus = [NSMutableArray array];
    for (int i=0; i < savedTab.count; i++) {
        if (YES == [[savedTab objectAtIndex: i][@"status"] boolValue]) {
            [tabStatus addObject: [savedTab objectAtIndex: i]];
        }
    }
    if(savedTab)
    {
        key = [NSString stringWithFormat:@"List%ld", [[tabStatus objectAtIndex: _tabBarController.selectedIndex][@"tab"] integerValue]];
    }
    
    return [_SLDict objectForKey: key];
    // [self changeTrashButtom: [_SLDict objectForKey: key]];
}

- (void)setSLDataArray:(NSMutableArray *)SLDataArray {
    
    NSString *key;
    NSMutableArray *savedTab = [[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"] mutableCopy];
    if(savedTab) {
        key = [savedTab objectAtIndex: _tabBarController.selectedIndex][@"key"];

    } else {
        key = [NSString stringWithFormat:@"List%ld", _tabBarController.selectedIndex];
    }
    NSLog(@"SetSlDataArray Key : %@", key);
    [_SLDict setValue: SLDataArray forKey: key];
}

- (void)saveData {
    
    NSString *key, *plistName;
    NSMutableArray *savedTab = [[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"] mutableCopy];
    if(savedTab) {
        key       = [[self checkTabStatus: savedTab] objectAtIndex: _tabBarController.selectedIndex][@"key"];
        plistName = [[self checkTabStatus: savedTab] objectAtIndex: _tabBarController.selectedIndex][@"path"];
    }/* else {
        key       = [NSString stringWithFormat: @"List%ld", _tabBarController.selectedIndex];
        plistName = [NSString stringWithFormat: @"FinalList%ld", _tabBarController.selectedIndex];
    }*/
    [[self.SLDict objectForKey: key] writeToFile: [self dataFilePath: plistName] atomically: YES];
 
}

- (NSString *)dataFilePath: (NSString *)saveFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex: 0];
    return [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.plist", saveFileName]];
}

- (void)updateColor {
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    UIColor *selectedColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    if (selectedColor) {
        
        [[UINavigationBar appearance] setTintColor: selectedColor];
        [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: selectedColor}];
        [[UITextView appearance]      setTintColor: selectedColor];
        [[UITabBar appearance]        setTintColor: selectedColor];
        self.tabBarController.tabBar.tintColor = selectedColor;
    }
}

// Check tab switch status when reload and set tab bar item title.
-(NSMutableArray *)checkTabStatus: (NSMutableArray *)saved {
    
    NSMutableArray *checkTabStatus = [NSMutableArray array];
    for (int i=0; i < saved.count; i++) {
        if (YES == [[saved objectAtIndex: i][@"status"] boolValue]) {
            // [indexes addIndex : i];
            [checkTabStatus addObject: [saved objectAtIndex: i]];
        }
    }
    return checkTabStatus;
}

@end
