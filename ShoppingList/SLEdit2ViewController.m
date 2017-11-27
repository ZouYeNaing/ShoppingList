//
//  SLEdit2ViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/08/19.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLEdit2ViewController.h"
#import "SLShoppingListData.h"

@interface SLEdit2ViewController ()
{
    NSMutableArray *EditVCArray;
}

@end

@implementation SLEdit2ViewController

@synthesize indexpath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EditVCArray = [SLShoppingListData sharedInstance].SLData2Array;
    
    _editTextView.text = [EditVCArray objectAtIndex: indexpath.row][@"data"];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillChange:)
                                                 name: UIKeyboardDidShowNotification
                                               object: nil];
    
}

- (void)viewWillAppear: (BOOL)animated {
    
    [super viewWillAppear: animated];
    
    [_editTextView becomeFirstResponder];
    
    NSLog(@"viewWillAppear (Edit), address  : %p", [SLShoppingListData sharedInstance].SLData2Array);
    
}

-(void)viewDidAppear: (BOOL)animated {
    
    [super viewDidAppear: animated];
    
}

- (void)keyboardWillChange: (NSNotification *)notification {
    
    NSLog(@"KeyBoard Height : %f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    _bottomHeightTxtView.constant = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
}

-(void)appendDataDictToPlist: (NSString *) editText {
    
    if ([editText length] == 0) {
        
        NSLog(@"length zero");
        
    } else {
        
        NSLog(@"appendDataDictToPlist : %@", editText);
        
        NSMutableDictionary *editList = [NSMutableDictionary dictionary];
        [editList setValue: [NSNumber numberWithBool: NO] forKey: @"status"];
        [editList setValue: editText forKey: @"data"];
        
        // [[SLShoppingListData sharedInstance].SLDataArray insertObject: editList atIndex: 0];
        [EditVCArray insertObject: editList atIndex: 0];
        
        [SLShoppingListData sharedInstance].SLData2Array = EditVCArray;
        [[SLShoppingListData sharedInstance] save2Data];
        
    }
}
- (IBAction)EditList:(id)sender {
    
    NSString *edited = _editTextView.text;
    NSLog(@"edited : %@", edited);
    
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *rows = [edited componentsSeparatedByCharactersInSet:separator];
    
    if (rows) {
        for (int i = 0; i < [rows count]; i++) {
            if (i == 0) {
                
                NSMutableDictionary *editTest = [NSMutableDictionary dictionary];
                [editTest setValue: [EditVCArray objectAtIndex: self.indexpath.row][@"status"] forKey: @"status"];
                [editTest setValue: rows[i] forKey: @"data"];
                
                // [[SLShoppingListData sharedInstance].SLDataArray replaceObjectAtIndex: indexpath.row withObject: editTest];
                [EditVCArray replaceObjectAtIndex: indexpath.row withObject: editTest];
                
                [SLShoppingListData sharedInstance].SLData2Array = EditVCArray;
                [[SLShoppingListData sharedInstance] save2Data];
                
            } else {
                
                [self appendDataDictToPlist: rows[i]];
                
            }
        }
    }
    
    [self dismissViewControllerAnimated: YES completion: nil];
    
}
- (IBAction)CancelList:(id)sender {
    
    [self dismissViewControllerAnimated: YES completion: nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
