//
//  SLAddViewController.h
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/07/29.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLMainTableViewController.h"

@class SLMainTableViewController;

@class SLAddViewController;             //define class, so protocol can see MyClass
@protocol SLAddViewControllerDelegate <NSObject>   //define delegate protocol

@optional
// - (void) addedList:(NSArray *)list;  //define delegate method to be implemented within another class

@end //end protocol

@interface SLAddViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightTxtView;
@property (weak, nonatomic) IBOutlet UITextView *addTextView;
@property (weak, nonatomic) SLMainTableViewController *sLMainTableViewController;

@property (nonatomic, weak) id <SLAddViewControllerDelegate> delegate; //define MyClassDelegate

@end
