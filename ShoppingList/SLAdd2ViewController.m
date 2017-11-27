//
//  SLAdd2ViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/08/19.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLAdd2ViewController.h"
#import "SLShoppingListData.h"

@interface SLAdd2ViewController ()
{
    NSMutableArray *AddVCArray;
}

@end

@implementation SLAdd2ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AddVCArray = [SLShoppingListData sharedInstance].SLData2Array;
    
}

-(void)viewWillAppear: (BOOL)animated {
    
    [super viewWillAppear: animated];
    
    [_addTextView becomeFirstResponder];
    
    NSLog(@"viewWillAppear (Add), address  : %p", [SLShoppingListData sharedInstance].SLData2Array);
    
 
    
}

-(void)appendDataDictToPlist: (NSString *) addText {
    
    if ([addText length] == 0) {
        
        NSLog(@"length zero");
        
    } else {
        
        NSLog(@"appendDataDictToPlist : %@", addText);
        
        NSMutableDictionary *addList = [NSMutableDictionary dictionary];
        [addList setValue: [NSNumber numberWithBool: NO] forKey: @"status"];
        [addList setValue: addText forKey: @"data"];
        
        [AddVCArray insertObject: addList atIndex: 0];
        
        [SLShoppingListData sharedInstance].SLData2Array = AddVCArray;
        [[SLShoppingListData sharedInstance] save2Data];
    }
}
- (IBAction)AddList:(id)sender {
    
    NSString *addText = _addTextView.text;
    NSLog(@"addText : %@", addText);
    
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *rows = [addText componentsSeparatedByCharactersInSet:separator];
    
    NSLog(@"NSCharacterSet : %@", rows);
    if (rows) {
        
        for (int i=0; i<[rows count]; i++) {
            
            [self appendDataDictToPlist: rows[i]];
            
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
