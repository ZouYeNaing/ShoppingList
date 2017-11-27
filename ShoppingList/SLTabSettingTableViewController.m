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
    
    if([[NSUserDefaults standardUserDefaults] objectForKey: @"Tab"]){
        tabSettingArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"Tab"]];
    } else {
        
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
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(onLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0f;
    [self.tableView addGestureRecognizer: longPressRecognizer];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    
    //UISwitchColor
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"myColor"];
    switchColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
}

- (void) hideKeyboard {
    
    [myTextField resignFirstResponder];
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
    
    myTextField = [[self.tableView cellForRowAtIndexPath: self.indexpath] viewWithTag: self.indexpath.row];
    
    NSLog(@"selected txtField.tag : %ld", myTextField.tag);
    NSLog(@"selected txtField.text: %@", myTextField.text);
    
    myTextField.userInteractionEnabled = YES;
    myTextField.returnKeyType = UIReturnKeyDone;
    [myTextField becomeFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"textFieldDidBeginEditing : %@", textField.text);
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"indexpath : %ld", self.indexpath.row);
    
    
    NSMutableDictionary *changeTitle = [NSMutableDictionary dictionary];
    [changeTitle setValue: [tabSettingArray objectAtIndex: self.indexpath.row][@"status"] forKey: @"status"];
    [changeTitle setValue: textField.text  forKey: @"data"];
    
    [tabSettingArray replaceObjectAtIndex: self.indexpath.row withObject: changeTitle];
    
    [[NSUserDefaults standardUserDefaults] setObject: tabSettingArray forKey: @"Tab"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.tabBarController.tabBar.items[self.indexpath.row].title = textField.text;
    [self.tableView reloadData];
    
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    // Remove OldTextField.
    myTextField = [cell viewWithTag: indexPath.row];
    [myTextField removeFromSuperview];
    
    
    // UITextField.
    myTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, 200, 30)];
    myTextField.delegate = self;
    myTextField.userInteractionEnabled = NO;
    myTextField.tag  = indexPath.row;
    myTextField.text = [tabSettingArray objectAtIndex: indexPath.row][@"data"];
    
    // UISwitch.
    UISwitch *switchView = [[UISwitch alloc] initWithFrame: CGRectMake(120, 13, 375, 30)];
    cell.accessoryView = switchView;
    switchView.tag = indexPath.row;
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
    
    [cell.contentView addSubview: myTextField];
    
    return cell;
}

-(void)switchChanged: (id)sender {
    
    UISwitch *switchControl = sender;
    int rowIndex = (int)[switchControl tag];
    
    NSMutableDictionary *changeStatus = [NSMutableDictionary dictionary];
    [changeStatus setValue: [NSNumber numberWithBool:switchControl.on] forKey: @"status"];
    [changeStatus setValue: [tabSettingArray objectAtIndex: rowIndex][@"data"] forKey: @"data"];
    
    [tabSettingArray replaceObjectAtIndex: rowIndex withObject: changeStatus];
    [[NSUserDefaults standardUserDefaults] setObject: tabSettingArray forKey: @"Tab"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[SLTabMManager sharedInstance] hideTabBarItem: tabSettingArray];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Change List Title"
 message: @""
 preferredStyle: UIAlertControllerStyleAlert];
 
 UIAlertAction *saveAction = [UIAlertAction actionWithTitle: @"Save" style:UIAlertActionStyleDefault
 handler: ^(UIAlertAction * action) {
 
 NSLog(@"Save Text : %@", alert.textFields[0].text);
 
 // [tabTitleMArray replaceObjectAtIndex: self.indexpath.row withObject: alert.textFields[0].text];
 
 NSMutableDictionary *changeTitle = [NSMutableDictionary dictionary];
 [changeTitle setValue: [tabSettingArray objectAtIndex: self.indexpath.row][@"status"] forKey: @"status"];
 [changeTitle setValue: alert.textFields[0].text  forKey: @"data"];
 
 [tabSettingArray replaceObjectAtIndex: self.indexpath.row withObject: changeTitle];
 
 [[NSUserDefaults standardUserDefaults] setObject: tabSettingArray forKey: @"Tab"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 
 self.tabBarController.tabBar.items[self.indexpath.row].title = alert.textFields[0].text;
 
 [self.tableView reloadData];
 }];
 UIAlertAction* cancelAction = [UIAlertAction actionWithTitle: @"Cancel" style:UIAlertActionStyleDefault
 handler: ^(UIAlertAction * action) {
 //cancel action
 }];
 [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
 // A block for configuring the text field prior to displaying the alert
 // textField.placeholder = [tabTitleMArray objectAtIndex: self.indexpath.row];
 textField.placeholder = [tabSettingArray objectAtIndex: self.indexpath.row][@"data"];
 
 }];
 [alert addAction: saveAction];
 [alert addAction: cancelAction];
 [self presentViewController: alert animated: YES completion: nil];
 */


@end
