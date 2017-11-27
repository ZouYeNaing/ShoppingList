//
//  SLEdit2ViewController.h
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/08/19.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLEdit2ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *editTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightTxtView;

@property (strong, nonatomic) NSIndexPath *indexpath;

@end
