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

- (IBAction)moveRow:(id)sender {

    if(self.editing == NO) {
        self.editing = YES;
    } else {
        self.editing = NO;
    }
    [self.tableView reloadData];
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
    [changeTitle setValue: [tabSettingArray objectAtIndex: self.indexpath.row][@"key"] forKey: @"key"];
    [changeTitle setValue: [tabSettingArray objectAtIndex: self.indexpath.row][@"path"] forKey: @"path"];
    [changeTitle setValue: [tabSettingArray objectAtIndex: self.indexpath.row][@"status"] forKey: @"status"];
    [changeTitle setValue: [tabSettingArray objectAtIndex: self.indexpath.row][@"tab"] forKey: @"tab"];
    [changeTitle setValue: textField.text  forKey: @"title"];
    
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
    textField.text = [tabSettingArray objectAtIndex: indexPath.row][@"title"];
    
    // UISwitch.
    UISwitch *switchView = [[UISwitch alloc] initWithFrame: CGRectMake(800, 13, 175, 30)];
    if (self.editing == YES) {
        cell.editingAccessoryView = switchView;
    } else {
        cell.accessoryView = switchView;
    }
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
    [changeStatus setValue: [tabSettingArray objectAtIndex: rowIndex][@"key"] forKey: @"key"];
    [changeStatus setValue: [tabSettingArray objectAtIndex: rowIndex][@"path"] forKey: @"path"];
    [changeStatus setValue: [NSNumber numberWithBool:switchControl.on] forKey: @"status"];
    [changeStatus setValue: [tabSettingArray objectAtIndex: rowIndex][@"tab"] forKey: @"tab"];
    [changeStatus setValue: [tabSettingArray objectAtIndex: rowIndex][@"title"] forKey: @"title"];
    
    [tabSettingArray replaceObjectAtIndex: rowIndex withObject: changeStatus];
    [[NSUserDefaults standardUserDefaults] setObject: tabSettingArray forKey: @"SavedTab"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[SLTabMManager sharedInstance] hideTabBarItem: tabSettingArray];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 0, self.view.frame.size.width - 20, 40)];
    detailLabel.textColor = [UIColor darkGrayColor];
    detailLabel.numberOfLines = 0;
    detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    detailLabel.text = @"Long Pressed On Each List Can Edit List Name.";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [detailLabel setFont: [UIFont systemFontOfSize: 14]];
    [footerView addSubview: detailLabel];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if (self.editing == YES) {
        
        return UITableViewCellEditingStyleNone;
        
    } else {
        
        return UITableViewCellEditingStyleDelete;
        
    }
    
}

- (BOOL)tableView: (UITableView *)tableView canMoveRowAtIndexPath: (NSIndexPath *)indexPath {
    
    return YES;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView: (UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath: (NSIndexPath *)indexPath {
    
    return NO;
    
}

- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath {
    self.tableView.delegate = self;
    
    if (fromIndexPath != toIndexPath ) {
        
        NSMutableDictionary *toMoveDict = tabSettingArray[fromIndexPath.row];
        
        [tabSettingArray removeObjectAtIndex: fromIndexPath.row];
        [tabSettingArray insertObject: toMoveDict atIndex: toIndexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setObject: tabSettingArray forKey: @"SavedTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[SLTabMManager sharedInstance] moveTabBarItem: fromIndexPath toIndexPath: toIndexPath];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }
    
    
    for (NSInteger i=0; i < [SLShoppingListData sharedInstance].tabBarController.viewControllers.count
         ; i++) {
        UIViewController *vc = [[SLShoppingListData sharedInstance].tabBarController.viewControllers objectAtIndex: i];
         NSLog(@"tag item : %ld", vc.tabBarItem.tag);
    }
    
}

@end
