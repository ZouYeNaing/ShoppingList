//
//  SLTabSettingTableViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/09/10.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLTabSettingTableViewController.h"
#import "SLMainTableViewController.h"
#import "SLShoppingListData.h"
#import "SLTabMManager.h"

@interface SLTabSettingTableViewController ()
{
    NSMutableArray *tabTitleMArray, *switchMArray, *tabBarArray, *tabSettingArray;
    UILongPressGestureRecognizer *longPressRecognizer;
    UITextField *myTextField;
    UIColor *switchColor;
}

@end

@implementation SLTabSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switchMArray =  [@[@YES, @YES, @YES, @YES, @YES] mutableCopy];
    
    tabSettingArray = [NSMutableArray array];
    
    tabTitleMArray = [NSMutableArray array];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]){
        tabSettingArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"SavedTab"]];
    } else {
        /*
        NSDictionary *newDic1 = @{@"status": @YES, @"data": @"リスト 1"};
        NSDictionary *newDic2 = @{@"status": @YES, @"data": @"リスト 2"};
        NSDictionary *newDic3 = @{@"status": @YES, @"data": @"リスト 3"};
        NSDictionary *newDic4 = @{@"status": @YES, @"data": @"リスト 4"};
        NSDictionary *newDic5 = @{@"status": @YES, @"data": @"設定"};
        [tabSettingArray addObject: newDic1];
        [tabSettingArray addObject: newDic2];
        [tabSettingArray addObject: newDic3];
        [tabSettingArray addObject: newDic4];
        [tabSettingArray addObject: newDic5];
         */
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
    longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(onLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0f;
    [self.tableView addGestureRecognizer: longPressRecognizer];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //UISwitchColor
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    switchColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
}

- (void) hideKeyboard {

    [myTextField resignFirstResponder];
    [self.tableView reloadData];
}

-(void)onLongPress: (UILongPressGestureRecognizer*)longPress {
    
    NSLog(@"UILongPressGestureRecognizer");
    
    if (longPress.state != UIGestureRecognizerStateBegan) {
        
        return;
        
    }
    
    CGPoint p = [longPress locationInView: self.tableView];
    self.indexpath = [self.tableView indexPathForRowAtPoint: p];
    
    if (self.indexpath == nil) {
        
        return;
        
    }
    NSLog(@"indexpath : %ld", self.indexpath.row);
    
    UITextField *textField = (UITextField *)[[self.tableView cellForRowAtIndexPath: self.indexpath] viewWithTag: 999];
    
    textField.userInteractionEnabled = YES;
    textField.returnKeyType = UIReturnKeyDone;
    [textField becomeFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"textFieldDidBeginEditing : %@", textField.text);
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSMutableDictionary *changeTitle = [NSMutableDictionary dictionary];
    [changeTitle setValue: [tabSettingArray objectAtIndex: self.indexpath.row][@"status"] forKey: @"status"];
    [changeTitle setValue: textField.text  forKey: @"data"];
    
    [tabSettingArray replaceObjectAtIndex: self.indexpath.row withObject: changeTitle];
    
    [[NSUserDefaults standardUserDefaults] setObject: tabSettingArray forKey: @"SavedTab"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.tabBarController.tabBar.items[self.indexpath.row].title = textField.text;
    
    [self.tableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tabSettingArray count]-1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"TabSettingCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *textField = (UITextField *)[cell viewWithTag: 999];
    if (nil == textField) {
        // UITextField.
        textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, 200, 30)];
        textField.delegate = self;
        textField.tag  = 999;
        [cell.contentView addSubview: textField];
    }
    textField.userInteractionEnabled = NO;
    textField.text = [tabSettingArray objectAtIndex: indexPath.row][@"data"];
    
    // UISwitch.
    UISwitch *switchView = [[UISwitch alloc] initWithFrame: CGRectMake(120, 13, 375, 30)];
    cell.accessoryView = switchView;
    switchView.tag = (int)indexPath.row;
    switchView.tintColor = switchColor;
    switchView.onTintColor = switchColor;
    [switchView addTarget: self
                   action: @selector(switchChanged:)
         forControlEvents: UIControlEventValueChanged];
    
    NSLog(@"myTextField.text : %@", myTextField.text);
    
    if([[tabSettingArray objectAtIndex: indexPath.row][@"status"] boolValue] == YES) {
        
        [switchView setOn: YES animated: NO];
        
    }
    else {
        
        [switchView setOn: NO animated: NO];
        
    }
    return cell;
    
}

-(void)switchChanged: (id)sender {
    
    UISwitch *switchControl = sender;
    int rowIndex = (int)[switchControl tag];
    
    NSMutableDictionary *changeStatus = [NSMutableDictionary dictionary];
    [changeStatus setValue: [NSNumber numberWithBool:switchControl.on] forKey: @"status"];
    [changeStatus setValue: [tabSettingArray objectAtIndex: rowIndex][@"data"] forKey: @"data"];
    
    [tabSettingArray replaceObjectAtIndex: rowIndex withObject: changeStatus];
    [[NSUserDefaults standardUserDefaults] setObject: tabSettingArray forKey: @"SavedTab"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[SLTabMManager sharedInstance] hideTabBarItem: tabSettingArray];
}

@end
