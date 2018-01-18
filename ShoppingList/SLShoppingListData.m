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

/*
- (void)changeTrashButtom: (NSArray *)mainVCArray {
    for (int i=0; i < [mainVCArray count]; i++) {
        
        if ([[mainVCArray objectAtIndex: i][@"status"] boolValue] == YES) {
            _trashButtonItem.enabled = YES;
        } else
        {
            _trashButtonItem.enabled = NO;
        }
    }
}
*/

/*
- (NSMutableArray *)getSLDataArray {
    
    NSString *key = [NSString stringWithFormat:@"List%ld", _tabBarController.selectedIndex];
    NSLog(@"selectedIndex(getSLDataArray) : %ld", _tabBarController.selectedIndex);
    // [self changeTrashButtom: [_SLDict objectForKey: key]];
    return [_SLDict objectForKey: key];
    
    /*
    case 0:
    NSLog(@"tab* 0");
    [self changeTrashButtom: [_SLDict objectForKey: @"List0"]];
    return [_SLDict objectForKey: @"List0"];
     * /
    
}
*/

- (NSMutableArray *)getSLDataArray : (NSInteger)selectedTabIndex {
    
    NSString *key;
    // NSString *key = [NSString stringWithFormat:@"List%ld", selectedTabIndex];
    NSLog(@"selectedIndex(getSLDataArray) : %ld", selectedTabIndex);
    NSLog(@"key(getSLDataArray)           : %@", key);
    NSLog(@"index           : %ld", _tabBarController.selectedIndex);
    NSLog(@"savedtab         : %@", [[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]);
    NSLog(@"_SLDict(getSLDataArray)       : %@", _SLDict);
    
    NSMutableArray *savedTab = [[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"] mutableCopy];
    if(savedTab)
    {
        key = [NSString stringWithFormat:@"List%ld", [[savedTab objectAtIndex: _tabBarController.selectedIndex][@"tab"] integerValue]];
    } else {
        key = [NSString stringWithFormat:@"List%ld", selectedTabIndex];
    }
   
    return [_SLDict objectForKey: key];
    // [self changeTrashButtom: [_SLDict objectForKey: key]];
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

- (void)setSLDataArray:(NSMutableArray *)SLDataArray {
    
     NSLog(@"selectedIndex(setSLDataArray) : %ld", _tabBarController.selectedIndex);
    
    NSString *key = [NSString stringWithFormat:@"List%ld", _tabBarController.selectedIndex];
    
    [_SLDict setValue: SLDataArray forKey: key];
    // [self changeTrashButtom: SLDataArray];
    
    /*
     case 0:
     [_SLDict setValue: SLDataArray forKey: @"List0"];
     */
}

- (void)saveData {
    
    NSString *key       = [NSString stringWithFormat: @"List%ld", _tabBarController.selectedIndex];
    NSString *plistName = [NSString stringWithFormat: @"FinalList%ld", _tabBarController.selectedIndex];
    
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

@end
