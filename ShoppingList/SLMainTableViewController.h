//
//  SLMainTableViewController.h
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/07/29.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAddViewController.h"
#import "SLEditViewController.h"

@interface SLMainTableViewController : UITableViewController<SLAddViewControllerDelegate, SLEditViewControllerDelegate>

@property (strong, nonatomic) NSIndexPath *indexpath;

@property (weak, nonatomic) UITabBarController *tabBarController;

@property (nonatomic) NSUInteger newCounter;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBox;

@property (nonatomic) NSMutableArray *listAdded;

@property (nonatomic) NSMutableArray *listEdited;

@property (nonatomic) NSString *EditedText;


@end
