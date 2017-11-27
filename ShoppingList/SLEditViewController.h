//
//  SLEditViewController.h
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/07/29.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLMainTableViewController.h"

@class SLMainTableViewController;

@class SLEditViewController;
@protocol SLEditViewControllerDelegate <NSObject>

@optional
// - (void)     editedList:(NSArray *)list;  //define delegate method to be implemented within another class
- (void)     editedList: (NSString * )editedText
               newAdded: (NSArray *)list;
- (void)  addedList:(NSArray *)list;

@end

@interface SLEditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *editTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightTxtView;

@property (strong, nonatomic) NSIndexPath *indexpath;
@property (nonatomic) BOOL isEditing;

@property (nonatomic, weak) id <SLEditViewControllerDelegate> delegate;

@end
