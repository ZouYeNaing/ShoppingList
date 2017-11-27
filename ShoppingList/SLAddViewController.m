//
//  SLAddViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/07/29.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLMainTableViewController.h"
#import "SLAddViewController.h"
#import "SLShoppingListData.h"

@interface SLAddViewController ()
{
    NSMutableArray *addVCArray;
}

@end

@implementation SLAddViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    addVCArray = [SLShoppingListData sharedInstance].getSLDataArray;
    
    NSLog(@"addVCArray : %@", addVCArray);
    
}

-(void)viewWillAppear: (BOOL)animated {
    
    [super viewWillAppear: animated];
    
    [_addTextView becomeFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear: animated];
    
    [_addTextView resignFirstResponder];
    
}

- (IBAction)saveList: (id)sender {
    
    NSString *addText = _addTextView.text;
    NSLog(@"addText : %@", addText);
    
    
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *rows = [addText componentsSeparatedByCharactersInSet:separator];
    
    NSLog(@"NSCharacterSet : %@", rows);
    
    if([self.delegate respondsToSelector:@selector(addedList:)]) {
        [self.delegate addedList:rows];
    }
    
    [self dismissViewControllerAnimated: YES completion: nil];
    
}

- (IBAction)cancelList: (id)sender {
    
    [self dismissViewControllerAnimated: YES completion: nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
